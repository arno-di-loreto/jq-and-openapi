# INVISIBLE: git checkout tags/final list-operations.jq &>/dev/null
# TITLE: API Toolbox - JQ and OpenAPI - Using JQ to extract data from OpenAPI files
# ROOT: apihandyman.io
# SECTION: list operations
# What are the available operations in the demo API, what are they supposed to do and which are deprecated?
jq -r -f list-operations.jq demo-api-openapi.json
# We already have seen that operations data can be accessed on the paths -> path (/whatever) -> operation (http method) path.
jq '.' demo-api-openapi.json | grep -A 8 "paths"
# The summary and possible deprecated flag (not shown above) we are also looking for are properties of the operation object 
# Here's the full jq script
bat list-operations.jq
# This (quite long) jq script is composed of 3 steps
grep "# [0-9]" list-operations.jq
# SECTION: list operations 1
# In this first step, we will create an array of {key, value} object where key is a path and value its value. We start by getting the paths object
jq '.paths' demo-api-openapi.json | head
# Then we use the "to_entries" function
jq '.paths | to_entries' demo-api-openapi.json | head
# The "to_entries" function transforms an object into an array of {key: property name, value: property value}. Each key property will so contain a path
jq '.paths | to_entries | map(.key)' demo-api-openapi.json
# Here's the complete script for this first step
git checkout tags/list-operations-1 list-operations.jq
bat list-operations.jq
# Note the last line which filters possible x-tension in paths, it uses concepts we already have seen before
# SECTION: list operations 2
# Step 2 objective's is to create an array of { method, path, summary, deprecated}, we'll start by working on {method, path}
jq -f list-operations.jq demo-api-openapi.json | head
# Each object in the array has a key (value path) and a value (containing operations identified by HTTP methods). Let's keep only the path and the HTTP methods
jq -f list-operations.jq demo-api-openapi.json | jq 'map({path: .key, methods: (.value | keys)})'
# Cool, but that's not exactly what we want, we want an array of {path, method}. Let's try to flatten the keys of value
jq -f list-operations.jq demo-api-openapi.json | jq 'map({path: .key, method: (.value | keys[])})'
# 🤯 It's working. The magic of jq is totally amazing, we now have  an array of {path, method}. Well, we have some x-tension that needs to be cleaned, let's select only the keys that are actual HTTP method as we already have done before
jq -f list-operations.jq demo-api-openapi.json | jq 'map({path: .key, method: (.value |keys[] | select(IN("get")))})'
# Note that I only filtered on "get" but I think you get how it works. That's great but how do we get the summary or deprecated flag? Let's try something else
jq -f list-operations.jq demo-api-openapi.json | jq 'map( .value | to_entries | map({method: .key, summary: .value.summary?}))'
# Now we have an array of {method, summary} ... but no path, we need to keep it somehow, let's define a variable
jq -f list-operations.jq demo-api-openapi.json | jq 'map( .key as $path | .value | to_entries | map({method: .key, path: $path, summary: .value.summary?}))'
# Great! Using "filter as $name" we can create variables and use them later in the filters chain. As you can see there are some unwanted xtension value, you should remember how to clean that
jq -f list-operations.jq demo-api-openapi.json | jq 'map( .key as $path | .value | to_entries | map(select(.key | IN("get")) | {method: .key, path: $path, summary: .value.summary?}))'
# Here's step 2 scripts which filters on all HTTP methods and adds the deprecated flag
git checkout tags/list-operations-2 list-operations.jq
bat list-operations.jq
# SECTION: list operations 3
# Let's output tab separated values (spoiler you'll learn something new!). We start with method, path and summary
jq -f list-operations.jq demo-api-openapi.json | jq -r 'map(.method + "\t" + .path + "\t" + .summary)[]'
# You should remember what will happen if we add deprecated which is a boolean
jq -f list-operations.jq demo-api-openapi.json | jq -r 'map(.method + "\t" + .path + "\t" + .summary + "\t" + .deprecated)[]'
# An error, deprecated has to be turned into a string with "tostring"
jq -f list-operations.jq demo-api-openapi.json | jq -r 'map(.method + "\t" + .path + "\t" + .summary + "\t" + (.deprecated | tostring))[]'
# Unfortunately, the deprecated flag is only set for actually deprecated operations and just having "true" or "null" after the summary does not give reader a clue about what is this value. Let's change that. Here are the deprecated values
jq -f list-operations.jq demo-api-openapi.json | jq -r 'map(.deprecated)[]'
# Let's replace them by "(deprecated)" when deprecated is true and "" in other cases
jq -f list-operations.jq demo-api-openapi.json | jq -r 'map(if .deprecated then "(deprecated)" else "" end)[]'
# 🤯 Yes, you can use if condition then filter A else filter B in jq! Here's the full step 3 script
git checkout tags/list-operations-3 list-operations.jq
bat -r 42: list-operations.jq
# INVISIBLE: git checkout tags/final list-operations.jq &>/dev/null
