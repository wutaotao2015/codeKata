
OperatorTable addAssignOperator(":", "setPair")
Map setPair := method(
   "inside setPair" println
   call message arguments println
   #self atPut(call message arguments at(0), call message arguments at(1))
   # self atPut(call evalArgAt(0), call evalArgAt(1))
  self atPut(call evalArgAt(0) asMutable removePrefix("\"") removeSuffix("\""), call evalArgAt(1))
) 

doMsg := method(
  map := Map clone
  "doMsg method here" println
  map doMessage(call message arguments at(0))
  map)

#direct call do not have the message target: the map
#doMsg("name": "wtt")
# must use doString to assign the map as target, as 
#  map doMsg("name": "wtt")

s := "doMsg(\"name\": \"wtt\")"
resultMap := doString(s)
resultMap keys println
resultMap values println

"-----------" println

List do := method(
   num,
   self append(num)
   self
)
str := "do(1)"
l := list()
#l doString(str) println
l do(1) println


"--------" println
operatorMethod := method(
   "begin.........." println
   call message arguments at(0) println
   call message arguments at(0) type println
   call evalArgAt(0) println
   call evalArgAt(0) type println
  "second++++" println
   call message arguments at(1) println
   call message arguments at(1) type println
   call evalArgAt(1) println
   call evalArgAt(1) type println
   "end.........." println

)
# method parameter types are all Message type, use call evalArgAt(number) to get
# the real value
#operatorMethod("a", list(1,2))
ss := "operatorMethod(\"a\", list(1,2))"
doString(ss)




