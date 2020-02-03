# TITLE: API Toolbox - JQ and OpenAPI - Using JQ command line arguments, functions and modules
# ROOT: apihandyman.io
# SECTION: Search demo
# Find anything in OpenAPI files with JQ!
jq -r -f search-operations.jq *.json
jq --arg path_contains sources --arg method get -r -f search-operations.jq *.json
jq --arg deprecated true --arg format text_without_source -r -f search-operations.jq demo-api-openapi.json
# JQ modules and functions are definitely 🤯
