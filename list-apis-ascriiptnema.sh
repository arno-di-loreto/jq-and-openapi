# TITLE: API Toolbox - JQ and OpenAPI - Using JQ to extract data from OpenAPI files
# ROOT: apihandyman.io
# SECTION: list apis
# We have a bunch (well 3 actually) of OpenAPI JSON files, let's have a quick view of them
jq -f list-apis.jq *.json | jq -s
# Thank to the list-apis.jq script, we have for each API info about the file like its name, type and version in specification, the API's name, version and summary and its number of operations. We will focus only the the filename and the summary
# SECTION: filename
# Here's how to get the filename
jq 'input_filename' *.json
# The "input_filename" filter works as long as jq is fed with some filenames
ls *.json | xargs jq 'input_filename'
find . -type f -name "*.json" -exec jq 'input_filename' {} \;
# But when fed with file content, it tells "<stdin>"
ls *.json | xargs cat | jq 'input_filename'
# Here's the part of the script dealing with the file information
bat -r 2:10 list-apis.jq
# SECTION: summary
# In the info section we have a summary which is the first 100 characters of info.description or the first characters before <!--more--> in info.description. Let's start by selecting the first 100 characters of each description
jq '.info.description[0:100]' *.json
# As you can see this is quite simple. Now let's add "[...]" when the description is longer then 100 characters
jq 'if (.info.description | length) <= 100 then .info.description else .info.description[0:100] + "[...]" end' *.json
# In some file here, the description may contain the "<!--more-->" tag that indicates the end of the summary. Lets find it
jq '{ filename: input_filename, more: .info.description | indices("<!--more-->")}' *.json
# The "indices" filter returns all the indices where the provided string is found. Now let's work only on the concerned file to get the adequate substring for the summary. We need the more tag index
jq '.info.description | indices("<!--more-->")[0]' demo-api-openapi.json
# And now we cut the string
jq '.info.description[0:(.info.description | indices("<!--more-->")[0])]' demo-api-openapi.json
# Here's the full script for the API info including the summary
bat -r 11:27 list-apis.jq
# Not how the $more variable is used and the if elif else to deal with different cases
