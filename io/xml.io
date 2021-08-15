
Xml := Object clone

Xml forward := method(
    writeln("<", call message name, ">")
    call message arguments foreach(arg,
        content := self doMessage(arg)
        if (content type == "Sequence",
            writeln(content)
          )
    )
    writeln("</", call message name, ">")
)

#Xml ul(li("first"), li("two"), li("three"))
Xml ul(li(sa("first")), li(sa("two")), li(sa("three")))

