# TITLE: API Toolbox - JQ and OpenAPI - Modifying OpenAPI files with JQ
# ROOT: apihandyman.io
# SECTION: delete elements
# This session will show you how to delete elements from a JSON document with jq
# SECTION: using = or |=
# Here's the info section
jq '.info' demo-api-openapi.json
# Let's delete contact with =
jq '.info = { info: .info.title, version: .info.version, description: .info.description }' demo-api-openapi.json | jq '.info'
# Now with |=
jq '.info |= { title, version, description }' demo-api-openapi.json | jq '.info'
# SECTION: using del
# But we did not actually delete contact, we just keep all other properties
# There's a way to actually delete contact with del and |=
jq '.info |= del(.contact)' demo-api-openapi.json | jq '.info'
# And an even much clever one with del alone
jq 'del(.info.contact)' demo-api-openapi.json | jq '.info'
# del deletes the property corresponding to provided path
# SECTION: using walk and del
# Now let's use del with walk
# walk(filters) basically go through all nodes and apply the provided filters
# Here's the list of deprecated operations 
jq -r --arg deprecated true -f search-operations.jq demo-api-openapi.json
# Now let's remove them
jq -f delete-deprecated.jq demo-api-openapi.json | jq -r -f search-operations.jq --arg deprecated true
# Here's how it works
bat -r 3:11 delete-deprecated.jq
# First we walk though the document and delete objects having a deprecated property set to true  
bat -r 12:22 delete-deprecated.jq
# Then we clean the null property due to the first step
bat -r 23: delete-deprecated.jq
# Then we clean the {} property due to second step
# SECTION: using paths and delpaths
# Instead of walking through the document we can also select alls paths we want to get rid of with the paths function and delete them with delpaths
# Here's how to list x-tensions paths
jq 'paths | select(.[-1] | tostring | test("^x-"))' demo-api-openapi.json # SLEEP: 2
# We keep only the paths having a leaf ( hence -1) prefixed by x-
# Now let's delete all these x-tensions
jq -f delete-xtensions.jq demo-api-openapi.json | jq -r -f list-xtension-paths.jq
#  We just put the list of paths in an $xtension variable and pass it to delpaths
bat -r 11: delete-xtensions.jq
# SECTION: using delpaths alone
# It's not mandatory to use paths, we can build a paths list outselves
# We will now delete unused schemas, we need to list them firts
# We need all defined schemas refs
jq '.components.schemas | keys | map("#/compoments/schemas" + .)' demo-api-openapi.json
# Minus actually used schemas which are listed by finding all $ref values
jq '[.. | select(type=="object") | select(has("$ref")) | .["$ref"]] | unique' demo-api-openapi.json
# And then we transform each JSON ref in a path array like this
echo '["#/components/schemas/SomeSchema"]' | jq 'map(split("/") - ["#"])' 
# Once we have a paths list, we can delete them
jq -f delete-unused-schemas.jq demo-api-openapi.json | jq -r -f list-unused-schemas.jq
# This is done just like before, put the paths list into a variable and pass it to delpaths
bat -r 19: delete-unused-schemas.jq
# And we're done with part 3 of this JQ and OpenAPI Series
