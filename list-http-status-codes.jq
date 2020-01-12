# 1 - Selects all properties of all responses
#--------------------------------------------
# It returns ["404", "200", "200", "x-example"]
[
  .paths[][].responses? # ? avoid getting an error if
                        # responses does not exist
  | keys? # ? avoid getting an error if . is not an
          # object and has no keys
  | .[] # [ ["404", "200"], ["200", "x-example"] ] ⤵️
      #                     ["404", "200", "200", "x-example"]
]
