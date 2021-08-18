OperatorTable addAssignOperator(":", "atPutNumber")

Map atPutNumber := method(
  self atPut(
      call evalArgAt(0) asMutable removePrefix("\"") removeSuffix("\""),
      call evalArgAt(1)
  )
)
      
curlyBrackets := method(
  r := Map clone
  call message arguments foreach(arg,
      r doMessage(arg)
  )
  r
)

Map printAsAttributes := method(
  self foreach(k, v,
      write(" " .. k .. "=\"" .. v .. "\"")
  )
)

Builder := Object clone
Builder indentLevel := 0

Builder makeIndent := method(
  spaces := ""
  indentLevel repeat(spaces = spaces .. "  ")
  return spaces
)
Builder forward = method(
  write(makeIndent() .. "<", call message name)
  indentLevel = indentLevel + 1
  isFirst := true
  call message arguments foreach(
      arg,
      if(isFirst,
          if(arg name == "curlyBrackets", 
              (self doMessage(arg)) printAsAttributes
          )

          write(">\n")
          isFirst = false
      )

      content := self doMessage(arg)
      if(content type == "Sequence", writeln(makeIndent() .. content))
  )
  indentLevel = indentLevel - 1
  writeln(makeIndent() .. "</", call message name, ">")
)

#s := File with("builderSyntax.txt") openForReading contents
#doString(s)

# must use doString to make the : operator work
s :="
Builder bookList({\"title\":\"listTitle\"}, book(\"first book\"),
       book({\"price\":\"100\"}, \"second book\"), book({\"name\": \"thirdBook\",\"author\": \"wtt\"}, chapters(\"7 chapters\")))
"
doString(s)

