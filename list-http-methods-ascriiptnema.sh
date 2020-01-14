# INVISIBLE: git checkout tags/final list-http-methods.jq &>/dev/null
# TITLE: API Toolbox - JQ and OpenAPI - Using JQ to extract data from OpenAPI files
# ROOT: apihandyman.io
# SECTION: HTTP methods
# What are the HTTP methods used in the demo API?
jq -r -f list-http-methods.jq demo-api-openapi.json
# In an OpenAPI file, HTTP methods are keys inside each path object which are inside the paths attributes
jq '.' demo-api-openapi.json |grep -A 2 "paths\":"
bat list-http-methods.jq
# It's a bit long because of comments, it is composed of 4 steps:
grep "# [0-9]" list-http-methods.jq
# Let's see them in action one by one
# SECTION: HTTP methods 1
git checkout tags/list-http-methods-1 list-http-methods.jq
# The first step aims to get an array with all keys from all operation objects from all paths
jq -r -f list-http-methods.jq demo-api-openapi.json
# Here's the script
bat list-http-methods.jq
# It reuses the  filters we have seen in list-paths.jq but now it gets a level deeper and creates an array of all of the paths properties by putting the filters chain inside brackets. Let's decompose it
jq -r '.paths' demo-api-openapi.json | head
# This last command returns all of the paths attribute properties values, hence path objects
jq -r '.paths[]' demo-api-openapi.json | head
# And this one returns the properties of all the path objects
jq -r '.paths[] | keys' demo-api-openapi.json
# Now we have the keys, which are the HTTP methods, but as the file contains different path we have them as an array of array. Indeed we get an array of operation for each path
jq -r '.paths[] | keys[]' demo-api-openapi.json
# Flattening the array output by keys put all values at the same level, but there's no array at all anymore
jq -r '[.paths[] | keys[]]' demo-api-openapi.json
# Adding brackets arround the filter chain put its result in an array 🎉
# SECTION: HTTP methods 2
# But there are values which are not HTTP methods. Let's clean them with step 2
git checkout tags/list-http-methods-2 list-http-methods.jq
jq -r -f list-http-methods.jq demo-api-openapi.json
# Only HTTP methods remain. Here's how it is done:
bat -r 11: list-http-methods.jq
# Let's revert jq file to step 1 to decompose step 2's actions
git checkout tags/list-http-methods-1 list-http-methods.jq
jq -r -f list-http-methods.jq demo-api-openapi.json
# This was the result of step one, let's pipe it into the map filter with another jq command
jq -r -f list-http-methods.jq demo-api-openapi.json | jq 'map(.)'
# It seems map did nothing, let's try to concatenate some string to what is provided as input inside map
jq -r -f list-http-methods.jq demo-api-openapi.json | jq 'map(. + " HTTP method")'
# As you can see, the map filter applied a filter to each element of the array. Let's use the select filter inside it
jq -r -f list-http-methods.jq demo-api-openapi.json | jq 'map(select(true))'
# The select filter did not change anything with a parameter set to true 
jq -r -f list-http-methods.jq demo-api-openapi.json | jq 'map(select(false))'
# With false no value is returned. The select filter let pass value when the result of the filter inside it is true
jq -r -f list-http-methods.jq demo-api-openapi.json | jq 'map(select(. == "get"))'
# Here, it only let pass get values. We shouldn't forget our objective which is to get all HTTP method values
jq -r -f list-http-methods.jq demo-api-openapi.json | jq 'map(select(IN("get","post")))'
# Thanks to IN which returns true when the value belongs to its list, it is easy to do. The step 2 in jq script lists all possible HTTP methods in the IN filter
git checkout tags/list-http-methods-2 list-http-methods.jq
bat -r 11: list-http-methods.jq
# Now you know how step 2 cleans the list to keep only the HTTP methods, but there's a problem
jq -r -f list-http-methods.jq demo-api-openapi.json
# BLANK
# SECTION: HTTP methods 3
# There are multiple occurences of some HTTP methods. We want to keep only one of each and hopefully that's dead simple
jq -r -f list-http-methods.jq demo-api-openapi.json | jq 'unique'
# The unique filter keeps only one occurence of each element inside an array
git checkout tags/list-http-methods-3 list-http-methods.jq
bat -r 23: list-http-methods.jq
# BLANK
# SECTION: HTTP methods 4
# And for the final step the script only flattens the result for the raw output
git checkout tags/list-http-methods-4 list-http-methods.jq
bat -r 27: list-http-methods.jq
# INVISIBLE: git checkout tags/final list-http-methods.jq &>/dev/null
