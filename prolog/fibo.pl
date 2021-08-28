
fib(0, 0).
fib(1, 1).
/**
fib(N, Res) :- fibo(N, 0, 1, Res).
% N is the accumulation count
fibo(0, Prev, _, Prev).
fibo(N, Prev, Next, Res) :- 
N > 0,
TmpN is N - 1,
Tmp is Prev + Next,
fibo(TmpN, Next, Tmp, Res).
**/

% just list simple true goals to make the rule become true
fib(N, Res) :- 
  succ(N1, N), 
  succ(N2, N1),
  fib(N1, F1),
  fib(N2, F2),
  plus(F1, F2, Res).


fac(0,1).
fac(N, Res) :-
  N1 is N - 1,
  fac(N1, R1),
  Res is N * R1, !.


/*** use middle accumulation variable to store the middle temp result
 the head of the original list is added to the temp, just like 
 stack pop and push operation **/
rev(Old, R) :- rev(Old, [], R).
rev([], X, X).
rev([Head|Rest], Accu, R) :- rev(Rest, [Head|Accu], R).

