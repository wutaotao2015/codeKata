
add := method(dd,
  writeln("add begin----")
  sum := 0
  for(i, 0, (dd size) - 1,

  writeln("the ",i,"th element arr begin---")

   for(j, 0, (dd at(i)) size - 1,
       sum = sum + ((dd at(i)) at(j))
   )
  writeln("the ",i,"th element arr end, the sum is ", sum, " -----")
)
   writeln("add end----")
   sum
)


arr := list(list(1, 3), list(6, 9))
add(arr) println


arr2 := list(list(5, 2), list(6, 1, 4))
add(arr2) println

# one line code
"one line code using flatten and reduce" println
sum := method(arr, arr flatten reduce(+))
arr := list(list(1, 3), list(6, 9))
sum(arr) println

arr2 := list(list(5, 2), list(6, 1, 4))
sum(arr2) println
