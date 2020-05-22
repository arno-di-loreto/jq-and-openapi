# TITLE: API Toolbox - JQ and OpenAPI - Modifying OpenAPI files with JQ
# ROOT: apihandyman.io
# SECTION: replace elements
# This session will show you how to add elements into a JSON document with jq
# SECTION: using +=
# Let's concatenate "is awesome" to contact name
jq '.info.contact.name' demo-api-openapi.json 
# This can be done with = and +
jq '.info.contact.name = .info.contact.name + " is awesome"' demo-api-openapi.json | jq '.info.contact.name'
# It can also be done with |= and +
jq '.info.contact.name |= . + " is awesome"' demo-api-openapi.json | jq '.info.contact.name'
# The most simple way is to use the += operator
jq '.info.contact.name += " is awesome"' demo-api-openapi.json | jq '.info.contact.name'
# += can be used on object too
# Let's add a x-tension property to contact
jq '.info.contact' demo-api-openapi.json
jq '.info.contact += {"x-slack": "apiteam" }' demo-api-openapi.json | jq '.info.contact'
# It can also be used to update and add properties at the same time
jq '.info.contact += { name: "The Awesome Banking API team", "x-slack": "apiteam" }' demo-api-openapi.json | jq '.info.contact'
# name has been update and x-slack added
# SECTION: Filters on the left
#  We can put complex filters on the left side of +=
# Let's add missing 500 responses when needed
# First let's find the operations without 500
jq '.paths[][] | select(type=="object") | select(has("responses")) | .responses | select(has("500") | not) ' demo-api-openapi.json
# Now let's add a 500 response
jq '(.paths[][] | select(type=="object") | select(has("responses")) | .responses | select(has("500") | not)) += {"500": { description: "Unexpected error"}} ' demo-api-openapi.json | jq '.paths["/accounts"].get.responses'
# You'll find a fully working module in add-missing-500.jq file
# SECTION: Filters on the right
# Note that you can also put complex filters on the right side of operators
# See how post /beneficiaries lacks content definition in its 40x responses
jq '.paths["/beneficiaries"].post.responses' demo-api-openapi.json 
# Let's fix that
jq --arg coderegex 40. --arg schema ConsumerError -f add-missing-response-content.jq demo-api-openapi.json | jq '.paths["/beneficiaries"].post.responses'
# This is done by selecting all responses
bat -r 2:7 add-missing-response-content.jq
# And then update them when needed for HTTP status matching provided regex using the provided schema name
bat -r 8:23 add-missing-response-content.jq
# SECTION: replace elements
# And we're done. In next session we'll learn to delete elements from a JSON file 
