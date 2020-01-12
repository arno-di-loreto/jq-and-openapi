# 1 - Selects paths objects
#--------------------------
# returns [{key: path, value: path value}]
.paths # Selects the paths property content
| to_entries # Transforms
             # { "/resources": { "get": {operation data}}} 
             # to 
             # [ { "key": "/resources", 
             #     "value": { "get": {operation data}} ]
| map(select(.key | test("^x-") | not)) # Gets rid of x-tensions