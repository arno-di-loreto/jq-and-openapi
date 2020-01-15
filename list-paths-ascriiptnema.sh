git checkout tags/final list-paths.jq &>/dev/null # INVISIBLE
# TITLE: API Toolbox - JQ and OpenAPI - Using JQ to extract data from OpenAPI files
# ROOT: apihandyman.io
# SECTION: list paths
# What are the available paths in the demo API?
jq -r -f list-paths.jq demo-api-openapi.json
# In an OpenAPI file, the API's paths are the keys of the paths root object property
jq '.' demo-api-openapi.json |grep -A 1 "paths\":"
# Here's the jq file used to extract them
bat list-paths.jq
# It is composed of 3 steps that we will now see in action
# SECTION: list paths 1
# Let's revert list-path.jq file to an ealier state in order to only execute step 1
git checkout tags/list-paths-1 list-paths.jq
bat list-paths.jq
jq -r -f list-paths.jq demo-api-openapi.json
# That's actually only the content of the paths attribute, but that's a bit too long. Let's just print the beginning
jq -r -f list-paths.jq demo-api-openapi.json | head
# As you can see, we only get the paths attribute content.
# SECTION: list paths 2
# Now let's add step 2 to keep this object keys
git checkout tags/list-paths-2 list-paths.jq
bat list-paths.jq
jq -r -f list-paths.jq demo-api-openapi.json
# We get an array of "/path".
# SECTION: list paths 3
# Let's add the final step to flatten this array
git checkout tags/list-paths-3 list-paths.jq
bat list-paths.jq
jq -r -f list-paths.jq demo-api-openapi.json
# We now have the raw paths list
git checkout tags/final list-paths.jq &>/dev/null # INVISIBLE