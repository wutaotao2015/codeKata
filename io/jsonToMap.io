
OperatorTable addAssignOperator(":", "putKV")

curlyBrackets := method(
   map := Map clone
   call message arguments foreach(arg,
     # below is same with -> map putKV(key, value), so map is the target
     map doMessage(arg)
   )
   map
)

Map putKV := method(
    
    # for the operator a : b, a is string type, b is value
    call message arguments println
    self atPut(
        call evalArgAt(0) asMutable removePrefix("\"") removeSuffix("\""),
        call evalArgAt(1)
    )
)

s := File with("phonebook.json") openForReading contents
s println
map := doString(s)

map keys println
map values println
