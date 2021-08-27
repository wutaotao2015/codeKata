
fib(0, 0).
fib(1, 1).
fib(N, Res) :- fibo(N, 0, 1, Res).

% N is the accumulation count
fibo(0, Prev, _, Prev).
fibo(N, Prev, Next, Res) :- 
N > 0,
TmpN is N - 1,
Tmp is Prev + Next,
fibo(TmpN, Next, Tmp, Res).


