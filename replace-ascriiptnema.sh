# TITLE: API Toolbox - JQ and OpenAPI - Modifying OpenAPI files with JQ
# ROOT: apihandyman.io
# SECTION: replace elements
# This session will show you how to replace elements inside a JSON document with jq
# SECTION: using =
# Let's see how the description looks like
jq '.info.description' demo-api-openapi.json
# Now let's replace it using the = operator
jq '.info.description="New description"' demo-api-openapi.json # SLEEP: 2
# That outputs the whole modified documents, let's focus only in the modified part
jq '.info.description="New description"' demo-api-openapi.json | jq '.info.description'
# Quite simple isn't it?
# Now let's try to modify the contact object, here's its current value
jq '.info.contact' demo-api-openapi.json
# And now we modify it with =
jq '.info.contact = { name: "The Awesome Banking API Team", url: "www.bankingcompany.com" }' demo-api-openapi.json | jq '.info.contact'
# SECTION: saving file
# We did not actually saved the modified file
# Unfortunately jq do not do inline editing like sed but you can use a good old > to save the result
jq '.info.description="New description"' demo-api-openapi.json > demo-api-openapi-mod.json
# Let's check the new file's content
jq '.info.description' demo-api-openapi-mod.json
# SECTION: using filters
# You can put anything on the right side even the most complicated filters chains.
# Let's do something simple and remove the -snapshot from version number
jq '.info.version' demo-api-openapi.json 
jq '.info.version = (.info.version | sub("-snapshot";""))' demo-api-openapi.json | jq '.info.version' 
# SECTION: do not forget ()
# If you do not put () around right hand filters here's what happens
jq '.info.version = .info.version | sub("-snapshot";"")'  demo-api-openapi.json
# SECTION: from anywhere
# The new value can come from anywhere in the document
# Let's replace description by version number without snapshot
jq '.info.description = (.info.version | sub("-snapshot";""))' demo-api-openapi.json | jq '.info.description'
# SECTION: using |=
# Removing -snapshot can be done in a more elegant way with |= operator
jq '.info.version' demo-api-openapi.json 
jq '.info.version |= sub("-snapshot";"")' demo-api-openapi.json | jq '.info.version' 
# It works also on object
jq '.info.contact' demo-api-openapi.json 
jq '.info.contact |= { name, url: .email, email: .url }' demo-api-openapi.json | jq '.info.contact'
# Note how name value was kept unmodified by typing just "name", this is pretty handy
# SECTION: chaining modifications
# jq obviously allows to do more than one modifications
# All that is needed is to chain them with |
# The fully modified document is passed to next filters
jq '.info' demo-api-openapi.json
jq '(.info.description = "New description.") | (.info.version |= sub("-snapshot";""))' demo-api-openapi.json | jq '.info'
# SECTION: replace elements
# And we're done. In the next session, we'll see how to add elements to a JSON document
