# TITLE: API Toolbox - JQ and OpenAPI - Using JQ to extract data from OpenAPI files
# ROOT: apihandyman.io
# SECTION: invoke jq
# This session will show you how to invoke jq which is a lightweight and flexible command-line JSON processor
# SECTION: beautify & color JSON
# The demo-api-openapi.json file is an OpenAPI JSON file describing an API. Let's see its content
cat demo-api-openapi.json  # SLEEP: 1
# BLANK
# 😱 Uglified JSON is totally unreadable. Let's pipe it into jq
cat demo-api-openapi.json | jq '.' # SLEEP: 1 
# 😍 That's better! The jq '.' command beautified and colored JSON. Note that jq can be used without cat, just provide the filename as second parameter
jq '.' demo-api-openapi.json # SLEEP: 1
# But even colored and beautified, the JSON is ...
cat demo-api-openapi.json | jq '.' | wc -l
# ... lines long. That's not easy to read
# SECTION: extract data with jq filters
# The '.' parameter is a jq filter that outputs the whole JSON. What about just getting the info section?
jq '.info' demo-api-openapi.json
# Or the API's name?
jq '.info.title' demo-api-openapi.json
# 🤯 that's dead simple!
# SECTION: generate json
# jq allows to do much more than that, it allows to generate tailor made JSON
jq '{name: .info.title, version: .info.version, contact: .info.contact.name}' demo-api-openapi.json
# SECTION: generate text
# It can also outputs text, like the title
jq '.info.title' demo-api-openapi.json
# Let's try to output tab separated values
jq '.info.title + "\t" + .info.version + "\t" + .info.contact.name' demo-api-openapi.json
# It's not working, 🤔 how to output raw text?
jq --help | grep "output raw"
# OK, just need to add -r (raw) flag
jq -r '.info.title + "\t" + .info.version + "\t" + .info.contact.name' demo-api-openapi.json
# 🎉 Tab separated raw text!
# SECTION: pipe filters
# Now let's talk about piping. Our first jq command was like this
cat demo-api-openapi.json | jq '.'  # SLEEP: 1
# The result of cat is piped with | to jq. But the result of jq can also be piped to any other command 
cat demo-api-openapi.json | jq '.' | head
# And you can obviously chain jq commands
cat demo-api-openapi.json | jq '{name: .info.title, version: .info.version, contact: .info.contact.name}' | jq -r '.name + "\t" + .version'
# More interesting, jq filters can be chained with | too
jq -r '{name: .info.title, version: .info.version, contact: .info.contact.name} | .name + "\t" + .version' demo-api-openapi.json
# This allows to create very complex filters as we'll see in the post's next section
# SECTION: use jq files
# But that makes complex command lines. Hopefully, you can put jq filters in a file
bat basics.jq
# This file contains the same filters as in previous command, but now it's easier to read and it can be commented. Use the -f parameter to load filters from a file 
jq -r -f basics.jq demo-api-openapi.json
# SECTION: invoke jq
# Now that we know the basics of jq, let’s try more complex stuff on OpenAPI JSON files. You can proceeed to post's next section
