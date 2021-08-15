# from the example, we can see that
# function is like variable, they are first-class members

#fib := method(n,
# if(n == 1 or n == 2,
#  1,
#  fib(n-1) + fib(n -2)))

i := 3
first := 1
second := 1
sum := 0
fib := method(n,
if (n == 1 or n == 2, 1,
(while(i <= n,
      sum = first + second
      first = second
      second = sum
      i = i + 1
      sum
))))


fib(1) println
fib(2) println
fib(3) println
fib(4) println
fib(5) println
fib(6) println
fib(7) println
