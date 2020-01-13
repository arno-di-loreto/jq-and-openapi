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