# 1 - Stores document for later use
#----------------------------------
. as $document # Variable used on line 23 to get 
               # extension value from its path
# 2 - Lists extensions paths
#---------------------------
| [
  paths # Lists ALL possible paths in documents 
        # (each path is represented as an array)
  | select( # Keeps only the values for which 
            # what follows return true
    .[-1] # Gets the path leaf (last item in array)
          # Equivalent to .[.|length-1]
    | tostring # Converts to string for next step 
    | test("^x-") # Checks if leaf name starts with x-
  )
]
# 3 - Sets all data for each extension occurence
#-----------------------------------------------
| map( # Applies a filter to each element
    # 3.1 - Creates a JSON pointer to extension
    #------------------------------------------
      "#/" + # adds numbers, strings, arrays or objects
      (
        map_values( # Applies a filter on each value
                    # (in place modification)
          gsub("/";"~1" ) # replaces a value in a string
                          # / must be replace by ~1
                          # in a JSON pointer
        )
        | join("/") # concatenates string with 
                  # a separator
      )
)