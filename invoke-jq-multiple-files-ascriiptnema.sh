# TITLE: API Toolbox - JQ and OpenAPI - Using JQ to extract data from OpenAPI files
# ROOT: apihandyman.io
# SECTION: invoke jq on multiple files
# Like many command line tools, jq can work on multiple files.
ls *.json
# There are 3 API description JSON file available, let's get the APIs names
jq -r '.info.title' *.json
# Now their names, versions and summary
jq '{name: .info.title, file: .info.version}' *.json
# That's cool, but the result is not an array. Fortunately we can pipe it to another jq command
jq '{name: .info.title, file: .info.version}' *.json | jq '[.]'
# That's not what we want 
jq --help | grep "into an array"
# Let's use the -s flag
jq '{name: .info.title, file: .info.version}' *.json | jq -s
# Magic! No filter was provided, the -s flag puts the entire stream into an array. Then you can work on it
jq '{name: .info.title, file: .info.version}' *.json | jq -s 'map(.name)'
# And jq can also be used with xargs or find
ls *.json | xargs jq -r '.info.title'
find . -type f -name "*.json" -exec jq -r '.info.title' {} \;
find . -type f -name "*.json" | xargs jq -r '.info.title'
