# TITLE: API Toolbox - JQ and OpenAPI - Using JQ command line arguments, functions and modules
# ROOT: apihandyman.io
# SECTION: Solving argument problem
# This session will show you how to deal with optional command line arguments (--arg name value)
# SECTION: The problem
# Thanks to -n flag we can tell JQ to not expect any JSON input
jq -n '{foo: "hello", bar: "world"}'
# That's useful to test some features 😁
# So, let's replace foo and bar values by command line arguments values
jq -n --arg foo hello --arg bar world '{foo: $foo, bar: $bar}'
# When using --arg name value, you can get the value with $name
# But, unfortunately...
jq -n --arg foo hello '{foo: $foo, bar: $bar}'
# You'll get an error if the --arg name is not provided
# SECTION: $ARGS.named
# Hopefully, we can use $ARGS.named
jq -n --arg foo hello '$ARGS.named'
# It contains all --arg 
jq -n --arg foo hello '$ARGS.named["foo"]'
# And does not complain when you get a non provided arg by its name
jq -n --arg foo hello '$ARGS.named["bar"]'
# Let's fix the foo bar JSON example
jq -n --arg foo hello '{foo: $ARGS.named["foo"], bar: $ARGS.named["bar"]}'
# 🎉 No more errors when bar is not provided!
# What if we need default values when an --arg is not provided?
# SECTION: default values
bat -r 8: module-args.jq
# This filters takes an object with the default values and replace them by provided parameters
jq -n --arg bar "bar from command line" 'include "module-args"; init_parameters({foo: "default foo", bar: null}) as $parameters| {message: ($parameters.foo + " and " + $parameters.bar)}'
# 🎉 Any non provided --arg name can now have a default value!
