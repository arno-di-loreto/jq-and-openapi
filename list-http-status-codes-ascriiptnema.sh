# INVISIBLE: git checkout tags/final list-http-status-codes.jq &>/dev/null
# TITLE: API Toolbox - JQ and OpenAPI - Using JQ to extract data from OpenAPI files
# ROOT: apihandyman.io
# SECTION: HTTP status codes
# How many times each HTTP status code is used in the API?
jq -r -f list-http-status-codes.jq demo-api-openapi.json
# Where are located the HTTP status codes inside an OpenAPI file?
jq '.' demo-api-openapi.json | grep -A 8 "paths"
# In an OpenAPI files, HTTP status codes are located in the responses properties of all operations (identified by an HTTP method) which are located inside all paths (identified by a path like /whatever) in the paths property.
# Here's the full jq script
bat list-http-status-codes.jq
# This (quite long) jq script is composed of 5 steps
grep "# [0-9]" list-http-status-codes.jq
# SECTION: HTTP status codes 1
# For the first step which aims to list all properties of all reponses objects (hence HTTP status codes), we will do almost the same thing as in list-http-methods.jq but 2 level deeper. We start by getting the paths content
jq '.paths' demo-api-openapi.json | head
# Then we go a level deeper to get paths -> path (/whatever) properties content
jq '.paths[]' demo-api-openapi.json | head
# And a level deeper to get paths -> path (/whatever) -> operation (get) properties content
jq '.paths[][]' demo-api-openapi.json | head
# Now let's get paths -> path (/whatever) -> operation (get) -> reponses properties content
jq '.paths[][].responses' demo-api-openapi.json
# 😅 Oops there's an error. Indeed, not all objects inside a path are actual operations (identified by an HTTP method)
jq '.paths[] | keys[]' demo-api-openapi.json 
# As you can see, we have some path level parameters and some x-tensions which don't have a responses property. Hopefully we can solve this problem with the "?" operator
jq '.paths[][].responses?' demo-api-openapi.json
# Using the "?" operator on a value disable errors if the property does not exist. Let's go on to get all propertie names inside responses
jq '.paths[][].responses? | keys' demo-api-openapi.json
# 😅 An error again. That's a consequence of ".responses?". Indeed, when responses property does no exist, null is returned and "keys" does not work on null value. Maybe we can use "?" again
jq '.paths[][].responses? | keys?' demo-api-openapi.json
# 🎉 it works. Now we have all properties inside paths -> path (/whatever) -> operation (get) -> reponses. Now let's clean this mess of arrays 
jq '.paths[][].responses? | keys?[]' demo-api-openapi.json
# 😅 Yet another error. The "?" operator can't be used right after "[]", let's add a pipe
jq '.paths[][].responses? | keys? | .[]' demo-api-openapi.json
# Now it works. We have the list of all responses properties, we just need to enclose it inside an array
jq '[ .paths[][].responses? | keys? | .[] ]' demo-api-openapi.json
# 🎉 We're done for first step. We have an array containing all properties names of all responses objects. Here's the full script
git checkout tags/list-http-status-codes-1 list-http-status-codes.jq
bat list-http-status-codes.jq
# SECTION: HTTP status codes 2
# As you may have noticed, the list returned by step 1 does not contains only HTTP status codes
jq -f list-http-status-codes.jq demo-api-openapi.json
# Indeed one of the responses object contains some x-tension. According to the OpenAPI specification, responses object may contain some "x-something" properties besides HTTP status codes. To get rid of them we could use the same filters as when we filtered path objects to keep only HTTP methods
jq -f list-http-status-codes.jq demo-api-openapi.json | jq 'map(select(IN("200","404")))'
# But there are so many HTTP status codes (63 defined by various RFCs to be precise). Let's reverse the problem and get rid of x-something properties 
jq -f list-http-status-codes.jq demo-api-openapi.json | jq 'map(select(test("^x-")))'
# The "test(regex)" function returns true if the value matches the regex. Here the regex tells "starts by x-". But we need the opposite of that
jq -f list-http-status-codes.jq demo-api-openapi.json | jq 'map(select(test("^x-") | not))'
# By forwarding the result of "test" to "not" we have what we want, values "not starting by x-". That's all for step 2, here's its final script
git checkout tags/list-http-status-codes-2 list-http-status-codes.jq
bat  -r 12: list-http-status-codes.jq
# SECTION: HTTP status codes 3
# Now that we have all HTTP status codes, we can count how many times each one is used. We start by grouping values together
jq -f list-http-status-codes.jq demo-api-openapi.json | jq 'group_by(.)'
# The group_by function returns an array of array. Each sub array containing elements which are equals. Now let's counts how many time each HTTP status is used
jq -f list-http-status-codes.jq demo-api-openapi.json | jq 'group_by(.) | map(. | length)'
# Using length, you get the length of an array (or a string or an object). Note that using ". |" is not necessary 
jq -f list-http-status-codes.jq demo-api-openapi.json | jq 'group_by(.) | map(length)'
# We have counts but we need to know to which HTTP status codes they refer to. Let's see how to extract the HTTP status code from each element returned by group by
jq -f list-http-status-codes.jq demo-api-openapi.json | jq 'group_by(.) | map(.[0])'
# Dead simple, we get the first (0) element of each array. Now let's put all that together in a {code, count} object
jq -f list-http-status-codes.jq demo-api-openapi.json | jq 'group_by(.) | map({ code: .[0], count: length })'
# We're done for step 3, here's its script
git checkout tags/list-http-status-codes-3 list-http-status-codes.jq
jq -f list-http-status-codes.jq demo-api-openapi.json
bat -r 21: list-http-status-codes.jq
# SECTION: HTTP status codes 4
# Now we have a list of objects containing an HTTP status code and how many times it used, but they are not sorted by this count.
jq -f list-http-status-codes.jq demo-api-openapi.json | jq 'sort_by(.count)'
# As you can see sorting is not that difficult with "sort_by", just provide the value you want to use. That's good but I want to get this list sorted by descending count
jq -f list-http-status-codes.jq demo-api-openapi.json | jq 'sort_by(-.count)'
# Dead simple again, sort_by takes any filter combination and sort the values based on its result for each value. That's all for step 4, here's the script
git checkout tags/list-http-status-codes-4 list-http-status-codes.jq
bat -r 32: list-http-status-codes.jq
# SECTION: HTTP status codes 5
# Final step, printing tab separated values. Based on what we have learned so far, "map", string concatenation with "+" and" some flattening with "[]" should do the trick
jq -f list-http-status-codes.jq demo-api-openapi.json | jq -r 'map(.code + "\t" + .count)[]'
# 😅 An error, the last one I promise. You cannot concat non-string value to string value, they have to be converted with "tostring"
jq -f list-http-status-codes.jq demo-api-openapi.json | jq -r 'map(.code + "\t" + .count | tostring)[]'
# 🤔 Still not working with the exact same error as before? That's totally normal, what has been passed to "tostring" is the result of ALL what's on it's left side. We need to add some ()
jq -f list-http-status-codes.jq demo-api-openapi.json | jq -r 'map(.code + "\t" + (.count | tostring))[]'
# That's better! We're done, here's this final step scripts
git checkout tags/list-http-status-codes-5 list-http-status-codes.jq
bat -r 37: list-http-status-codes.jq
# Do not forget the -r flag to run the full script
jq -r -f list-http-status-codes.jq demo-api-openapi.json
# INVISIBLE: git checkout tags/final list-http-status-codes.jq &>/dev/null
