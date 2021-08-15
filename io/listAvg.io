List avg := method(r,
     r = 0
     for(i, 0, (self size) - 1,
        e := self at(i)
        if(e asNumber isNan,   
             Exception raise("not a number, at index " .. i .. ", elment is " .. e)
             break,
             r = r + self at(i)
        )
     )
     r = r / (self size)
)

l := list(1, 5, 6)
l avg println

s := list(6,4)
s avg println

y := list(1, 2, 6, 7, 14)
y avg println

#z := list(2,3,"oe", 0, 6)
#z avg println

"brief way using reduce to sum up " println
List avg2 := method(
     hasNoNumbers := select(e, e asNumber isNan) size > 0
     if (hasNoNumbers, Exception raise("has no number elements"))

     sum := self flatten reduce(+)
     sum / self size
)

l := list(1, 5, 6)
l avg2 println

s := list(6,4)
s avg2 println

y := list(1, 2, 6, 7, 14)
y avg2 println

z := list(2,3,"oe", 0, 6)
z avg2 println
