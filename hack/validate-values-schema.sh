#!/bin/bash
# Copyright 2025 The argocd-agent Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -euo pipefail

# Script directory
SCRIPT_DIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Charts to validate. Add more chart directory names here to extend coverage.
CHARTS=(
	"argocd-agent-agent"
	"argocd-agent-principal"
)

# Check required binaries
required_binaries="yq jq"
for bin in $required_binaries; do
	if ! command -v "$bin" >/dev/null 2>&1; then
		echo "Error: Required binary '$bin' not found in \$PATH" >&2
		echo "Please install it:" >&2
		if [ "$bin" = "yq" ]; then
			echo "  yq: https://github.com/mikefarah/yq#install" >&2
		elif [ "$bin" = "jq" ]; then
			echo "  jq: https://stedolan.github.io/jq/download/" >&2
		fi
		exit 1
	fi
done

# Function to extract all paths from YAML (recursive)
extract_yaml_paths() {
	local data="$1"
	local prefix="${2:-}"
	
	# Convert YAML to JSON for easier processing
	local json_data
	json_data=$(echo "$data" | yq eval -o=json -)
	
	# Extract all keys recursively
	echo "$json_data" | jq -r '
		def paths_to_strings:
			paths(scalars) as $p | 
			$p | map(tostring) | join(".");
		paths_to_strings
	'
}

# Function to extract all property paths from JSON schema (recursive)
extract_schema_paths() {
	local schema_file="$1"
	
	jq -r '
		def extract_properties($prefix):
			if type == "object" then
				# Handle both schema objects (with .properties) and property objects directly
				(if .properties then .properties else . end) | 
				to_entries[] | 
				($prefix + (if $prefix == "" then "" else "." end) + .key) as $path |
				$path,
				(.value | extract_properties($path))
			else
				empty
			end;
		
		.properties | extract_properties("")
	' "$schema_file"
}

# Function to check if a schema path allows additionalProperties
has_additional_properties() {
	local schema_file="$1"
	local path="$2"
	
	# Check all parent levels of the path
	# Convert path to parts, handling both . and / separators
	local path_parts
	path_parts=$(echo "$path" | sed 's|/|.|g' | tr '.' '\n')
	
	# Check each parent level
	local current_path=""
	for part in $path_parts; do
		if [ -n "$current_path" ]; then
			current_path="${current_path}.${part}"
		else
			current_path="$part"
		fi
		
		# Get the schema for this path level
		local level_schema
		level_schema=$(jq -r --arg path "$current_path" '
			def get_schema($path_parts):
				. as $root |
				reduce $path_parts[] as $part (
					$root.properties // {};
					if type == "object" then
						(if .properties then .properties[$part] else .[$part] end) // {}
					else
						{}
					end
				);
			
			($path | split(".")) as $parts |
			get_schema($parts)
		' "$schema_file")
		
		# Check if this level has additionalProperties
		local additional_props
		additional_props=$(echo "$level_schema" | jq -r '.additionalProperties // false')
		
		if [ "$additional_props" = "true" ]; then
			return 0
		fi
		
		# Check if additionalProperties is an object (which also allows additional props)
		if echo "$additional_props" | jq -e 'type == "object"' >/dev/null 2>&1; then
			return 0
		fi
	done
	
	return 1
}

# Validate a single chart: compare values.yaml paths against values.schema.json.
# Prints a per-chart status line and returns 0 on success, 1 on mismatch/missing files.
validate_chart() {
	local chart_name="$1"
	local chart_dir="${REPO_ROOT}/install/helm-repo/${chart_name}"
	local values_yaml="${chart_dir}/values.yaml"
	local schema_json="${chart_dir}/values.schema.json"

	if [ ! -f "$values_yaml" ]; then
		echo "Error [${chart_name}]: values.yaml not found at $values_yaml" >&2
		return 1
	fi

	if [ ! -f "$schema_json" ]; then
		echo "Error [${chart_name}]: values.schema.json not found at $schema_json" >&2
		return 1
	fi

	local yaml_content
	yaml_content=$(cat "$values_yaml")

	local yaml_paths schema_paths yaml_paths_array schema_paths_array
	yaml_paths=$(extract_yaml_paths "$yaml_content")
	schema_paths=$(extract_schema_paths "$schema_json")
	yaml_paths_array=$(echo "$yaml_paths" | sort -u)
	schema_paths_array=$(echo "$schema_paths" | sort -u)

	local missing_paths=""
	local missing_count=0

	while IFS= read -r path; do
		[ -z "$path" ] && continue

		if echo "$schema_paths_array" | grep -Fxq "$path"; then
			continue
		fi

		if has_additional_properties "$schema_json" "$path"; then
			continue
		fi

		if [ -z "$missing_paths" ]; then
			missing_paths="$path"
		else
			missing_paths="$missing_paths"$'\n'"$path"
		fi
		missing_count=$((missing_count + 1))
	done <<< "$yaml_paths_array"

	if [ "$missing_count" -gt 0 ]; then
		echo "Error [${chart_name}]: The following fields from values.yaml are missing in values.schema.json:" >&2
		echo "$missing_paths" | while IFS= read -r path; do
			[ -n "$path" ] && echo "  - $path" >&2
		done
		return 1
	fi

	echo "✓ [${chart_name}] All fields from values.yaml are present in values.schema.json"
	return 0
}

# Validate every chart; report all failures before exiting non-zero.
exit_code=0
for chart in "${CHARTS[@]}"; do
	if ! validate_chart "$chart"; then
		exit_code=1
	fi
done

exit "$exit_code"

