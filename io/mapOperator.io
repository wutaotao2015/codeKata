
OperatorTable addAssignOperator(":", "putKV")
Map putKV := method(
   "inside map putKV" println
   self atPut("1", "2")
)
curlyBrackets := method(
  map := Map clone
  call message arguments println
  call message arguments foreach(arg,
    map doMessage(arg)
  )
  map
)


#{"name":"wtt", "age" : "31"} println
#{"name":"wtt", "age":"31"} println

#########################################################
must use doString to make the new : operator take effect
#########################################################

s := "{\"name\":\"wtt\", \"age\" : \"31\"}"
doString(s)

