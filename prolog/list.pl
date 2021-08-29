
count(0, []).
count(Count, [Head|Tail]) :- count(TailCount, Tail), Count is TailCount + 1.

sum(0, []).
sum(Total, [Head|Tail]) :- sum(TailTotal, Tail), Total is Head + TailTotal.

avg(Result, List) :- count(Count, List), sum(Total, List), Result is Total / Count.


% using call to implement higher order function
map(F, [], []).
map(F, [H|T], [RH|RT]) :-
  call(F, H, RH),
  map(F, T, RT).
% map(plus(1), [1,2,3], R).

