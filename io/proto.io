Object ances := method(
       proType := self proto
       if (proType != Object,
          writeln("current type is ", self type)
          writeln("its prototype is ", proType type, ", its slots are\n------")
          proType slotNames foreach(s, writeln(s))
          writeln
          proType ances
       )
)

Shape := Object clone
Shape area := "shape area"

Rectangle := Shape clone
Rectangle lines := "rectangle lines four"

Square := Rectangle clone
Square area := "square area"

Square ances
