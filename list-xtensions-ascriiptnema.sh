# INVISIBLE: git checkout tags/final list-xtensions.jq &>/dev/null
# TITLE: API Toolbox - JQ and OpenAPI - Using JQ to extract data from OpenAPI files
# ROOT: apihandyman.io
# SECTION: list extensions
# What are the extensions (x- properties)  used in the demo API? Where are they located and what are their values?
jq -r -f list-xtensions.jq demo-api-openapi.json
# The OpenAPI specification is extensible, you can add custom structure data almost anywhere. All that is needed is that the name of the properties containing them starts by "x-". Here's the full jq script
bat list-xtensions.jq
# This jq script is composed of 5 steps
grep "# [0-9]" list-xtensions.jq
# For each extension occurence found we have its name, its location 2 different format (path and ref) and its value. We will focus on step 2, 3.1 and 3.2
# SECTION: list extensions 1
git checkout tags/list-xtensions-1 list-xtensions.jq
bat list-xtensions.jq
# Step 1 does nothing interesting for no, it only store the whole document in a variable for later use
jq -r -f list-xtensions.jq demo-api-openapi.json
# Note that only declaring a variable without outputing anything leads to an error.
# SECTION: list extensions 2
# The objective of step 2 is to return the paths of all extensions. To do so we will use the "paths" function, here's an example
jq '.info | paths' demo-api-openapi.json
# The "paths" function lists recursively all properties and returns their paths (as an array). This result says that, inside info, the path of url is contact -> url. Let's use it on the whole document
jq 'paths' demo-api-openapi.json
# In order to get the paths of all extensions, we need to filter this list to keep the paths having a leaf which name starts by "x-". Let's get these leafs
jq 'paths | .[-1]' demo-api-openapi.json
# Now we will check if some start by "x-"
jq 'paths | .[-1] | test("^x-")' demo-api-openapi.json
# Not all leaf are string, so we must convert them
jq 'paths | .[-1] | tostring | test("^x-")' demo-api-openapi.json
# Now we know how to work on leafs, let's select the paths to leaf which start by "x-"
jq 'paths | select(.[-1] | tostring | test("^x-"))' demo-api-openapi.json
# And put them in an array
jq '[paths | select(.[-1] | tostring | test("^x-"))]' demo-api-openapi.json
# Here's the whole script for step 2
git checkout tags/list-xtensions-2 list-xtensions.jq
bat -r 5: list-xtensions.jq
# SECTION: list extensions 3.1
# The result of the final script is an array of name, paths, ref and value. With step 3.1, we start by working on ref which is a JSON pointer to the extension. The JSOIN pointer to the api name is #/info/title. Let's start by joining the path arrays values with "/"
jq -r -f list-xtensions.jq demo-api-openapi.json | jq 'map(join("/"))'
# The join function concatenates values with an optional separator. Now let's add "#/" at the beginning
jq -r -f list-xtensions.jq demo-api-openapi.json | jq 'map("#/" + join("/"))'
# We're almost done. In a JSON pointer, "/" must be replace by "~1" and this must be done before joining values with "/"
jq -r -f list-xtensions.jq demo-api-openapi.json | jq 'map(map_values(gsub("/";"~1")) | "#/" + join("/"))'
# This replacement is donne by using map_value which allows to modify each value of an array and gsub to search/replace a string. Here's the whole script for step 3.1
git checkout tags/list-xtensions-3.1 list-xtensions.jq
bat -r 18: list-xtensions.jq
# SECTION: list extensions 3.2
# Let's revert jq file to step 2 to work on the extension value
git checkout tags/list-xtensions-2 list-xtensions.jq
# To get the value identified by a path we just need to use the getpath function
jq -r -f list-xtensions.jq demo-api-openapi.json | jq 'map(getpath(.))'
# 🤔 It's not working... 
# 🤦🏻‍♂️ Of course, we need to provide the whole original document to getpath(some path)
git checkout tags/list-xtensions-3.2 list-xtensions.jq
bat -r 18: list-xtensions.jq
# That's why the document variable was defined on step 1 
jq -r -f list-xtensions.jq demo-api-openapi.json
# SECTION: list extensions 3
# And to finish the full step 3 including the name (path's leaf) and path
git checkout tags/list-xtensions-3 list-xtensions.jq
bat -r 18: list-xtensions.jq
jq -r -f list-xtensions.jq demo-api-openapi.json
# INVISIBLE: git checkout tags/final list-xtensions.jq &>/dev/null
