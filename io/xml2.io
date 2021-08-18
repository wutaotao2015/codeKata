
Xml := Object clone
Xml count := 0

curlyBrackets := method(
    call message arguments foreach(arg, 
        pairs := arg asSimpleString split(":")
        #writeln(" 0 is ", pairs at(0) asMutable exSlice(1, -2))
       # writeln(" 1 is ", pairs at(1))
       # writeln(" 0 is '", pairs at(0), "'")
       # writeln(" 1 is '", pairs at(1), "'")
        write(" ", pairs at(0) asMutable exSlice(1, -2), "=", pairs at(1) exSlice(1))
    )
)
doMsg := method(arg, 
      # self is the message target, the inner forward callings 
      # are all for this one Xml object target
      content := self doMessage(arg)
      if (content type == "Sequence",
        (self count + 1) repeat(" " print)
        writeln(content)
      )
)
Xml forward := method(
    self count = self count + 1
    self count repeat(" " print)
    write("<", call message name)
    argList := call message arguments
    if (argList size > 0 and (argList at(0) asString containsSeq("(")), 
       self doMsg(argList at(0))
    )
    writeln(">")
    if(argList at(0) asString containsSeq("(") == false, 
        self doMsg(argList at(0))
      )
    if (argList size > 1, 
       argList rest foreach(arg,
          self doMsg(arg)
      )
    )
    self count repeat(" " print)
    writeln("</", call message name, ">")
    self count = self count - 1
)

# Xml ul(li(sa("I am the first node")), li(sa("I am the second node")), 
#       li(sa("I am the third node")))

  Xml bookList({"title":"listTitle"}, book("first book"), 
     book({"price":"100"}, "second book"), book({"name": "thirdBook","author": "wtt"}, chapters("7 chapters")))

