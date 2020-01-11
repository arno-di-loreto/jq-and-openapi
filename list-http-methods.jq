# 1 - Creates an array of all HTTP methods
#     inside paths["/whatever"]
#-----------------------------------------
# It returns ["get", "post","summary","x-example", "post"]
[
  .paths[] # Selects the paths["/whatever"] properties content
           # to keeps only the operations
  | keys[] # Keeps only the keys (HTTP methods and few other things)
           # and flattens array
]