
N := Object clone
N div := method(x, y, x / y)

changeDiv := method(slotName, 
   # self is this method caller
   self getSlot(slotName) setArgumentNames (
       list(
         self getSlot(slotName) argumentNames at(1),
         self getSlot(slotName) argumentNames at(0)
       )
   )
)

n := N clone
writeln(" n div (10,2) = ", n div(10, 2))
n changeDiv("div")
writeln(" ------- changing-------\n n div (10,2) = ", n div(10, 2))
