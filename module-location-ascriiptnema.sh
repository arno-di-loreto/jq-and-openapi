# TITLE: API Toolbox - JQ and OpenAPI - Using JQ command line arguments, functions and modules
# ROOT: apihandyman.io
# SECTION: Modules location
# This session will show you how to manage modules location
# SECTION: -L argument
# Let's output the first operation's summary of demo-api-openapi.json using the module-openapi.jq module
jq -r 'include "module-openapi"; oas_operations[0].summary' demo-api-openapi.json
# Let's go into the parent folder and do the same
cd ..
# Obviously, to do the same we have to use JQ on jq-and-openapi/demo-api-openapi.json now
jq -r 'include "module-openapi"; oas_operations[0].summary' jq-and-openapi/demo-api-openapi.json
# That's not working because JQ looks for a module-openapi.jq file in the current folder
ls module-openapi.jq
# But it's not there, it's in jq-and-openapi folder. Let's tell JQ to look there with -L
jq -r -L jq-and-openapi 'include "module-openapi"; oas_operations[0].summary' jq-and-openapi/demo-api-openapi.json
# Now it works 🎉
mv ~/.jq ~/.jq_bak 2>/dev/null # INVISIBLE
# SECTION: ~/.jq folder
# If there are modules that you use extensively, you should use the ~/.jq folder
mkdir ~/.jq
# Just put some jq module files in it
cp jq-and-openapi/module-openapi.jq ~/.jq
# And run JQ without -L
jq -r 'include "module-openapi"; oas_operations[0].summary' jq-and-openapi/demo-api-openapi.json
# It works 🎉
# SECTION: ~/.jq file
# ~/.jq can also be a file
rm -rf ~/.jq
cp jq-and-openapi/module-openapi.jq ~/.jq
jq -r 'oas_operations[0].summary' jq-and-openapi/demo-api-openapi.json
# Now I don't even need to include anything to use my custom oas_operations function
# That's cool, but I do not recommend to use it because that makes dependencies invisible
rm ~/.jq 2>/dev/null # INVISIBLE
mv ~/.jq ~/.jq_bak 2>/dev/null # INVISIBLE
