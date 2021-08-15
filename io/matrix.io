
Matrix := Object clone
Matrix val := List clone
Matrix dim := method(x, y,
       #x println
       #y println
       if (x == nil, x = 0)
       if (y == nil, y = 0)
       inner := List clone
       oldX := x
       while(y > 0,
               while(x > 0,
          inner push(nil)
          x = x - 1)
          self val push(inner)
          inner = List clone
          x = oldX
          y = y - 1
       )
       self
)
Matrix prettyPrint := method(
  str := "\n-----------\n"
  x := self val at(0) size
  y := self val size
  x repeat(row, 
    y repeat(col, str = str .. (self val at(col) at(row) .. " "))
    str = str .. "\n"
  )
 str =  str .. "-----------"
 str =  str .. "\n"
  str println
  str
)

Matrix print := method(
  str := ""
  x := self val at(0) size
  y := self val size
  x repeat(row, 
    y repeat(col, str = str .. (self val at(col) at(row) .. ","))
    str = str .. "\n"
  )
  str =  str .. "\n"
  str println
  str
)

"begin" println
matrix := Matrix clone
matrix dim(2,3)
matrix prettyPrint

Matrix set := method(x, y, value,

       col := self val at(y)
       #col println
       col atPut(x, value)
       #col println
       self
)
matrix set(1,1,666) print
matrix set(1,2,778) print

Matrix get := method(x, y,

     self val at(y) at(x)
)

writeln("-----begin get matrix-------")
matrix get(1, 1) println
matrix get(1,2) println
"------end get matrix--------------" println

matrix val = list(list(1,2,3), list(4,5,6), list(7,8,9))
writeln("------initial matrix----")
matrix prettyPrint

Matrix trans := method(
     self val foreach(y, v, 
        #"begin outer" println
        x := 0
        while(x < y, 
          #"begin" println
           #self print
           tmp := self val at(y) at(x)
           self val at(y) atPut(x,self val at(x) at(y))
           self val at(x) atPut(y,tmp)
           #self print
           x = x + 1
        )
     )
     self
)    
matrix trans
writeln("------after transending------")
matrix prettyPrint

writeln("------begin to write to file---")
file := File with("matrix.txt")
file remove
file openForUpdating
file write(
  matrix print   
)
file close
writeln("-------end to write file-----")

writeln("----begin to read file----")
lines := file readLines
lines println
writeln("----end to read file----")


