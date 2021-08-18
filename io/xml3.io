Xml := Object clone
Xml spaceNum := 0

OperatorTable addAssignOperator(":", "putPair")
Map putPair := method(
  #"inside putPair" println
  self atPut(
     call evalArgAt(0) asMutable removePrefix("\"") removeSuffix("\""),
     call evalArgAt(1)
  ) 
)
curlyBrackets := method(
   #"inside curlyBrackets" println
   map := Map clone
   # call message arguments println
   call message arguments foreach(arg,
      map doMessage(arg)
   )
   map
)


Map printAttr := method(
    self foreach (k,v,
      write(" " .. k .. "=\"" .. v .. "\"")
    )
)

#map := Map clone
#map atPut("name", "wtt")
#map atPut("age", "30")
#map printAttr

Xml indent := method(
    space := ""
    spaceNum repeat(space = space .. "  ")
    space
)

#xml := Xml clone
#xml spaceNum := 3
#write("/" .. xml indent() .. "/")

Xml forward := method(
  
  write(indent() .. "<" .. call message name)
  spaceNum = spaceNum + 1
  isFirst := true
  call message arguments foreach(arg, 

      # here we can not use and to combine two judgements, because the non-curlyBrackets
      # --as the Sequence--also need to write end > tag, and make isFirst false

      if(isFirst, 
        if(arg name == "curlyBrackets", 
           # "inside first and curlyBrackets" println
            Map doMessage(arg) printAttr)
          writeln(">")
          isFirst = false
      )
      content := self doMessage(arg)
      if(content type == "Sequence", writeln(indent() .. content))
  )
  spaceNum = spaceNum - 1
  writeln(indent() .. "</" .. call message name .. ">")
)

s := "Xml bookList({\"title\":\"listTitle\"}, book(\"first book\"),
    book({\"price\":\"100\"}, \"second book\"), book({\"name\": \"thirdBook\",\"author\": \"wtt\"}, chapters(\"7 chapters\")))"
doString(s)

