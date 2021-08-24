
merge([], List, List).
merge([Head|Tail1], List, [Head|Tail2]) :- merge(Tail1, List, Tail2).

rev([], []).
/** watch each step of the recursive progress, use a series of true statements to 
express the algorithm **/
rev(Res, [Head|Tail]) :- reverse(Tmp, Tail), merge(Tmp, [Head], Res).

min(Min, A, B) :- A < B, Min is A.
min(Min, A, B) :- A = B, Min is A.
min(Min, A, B) :- A > B, Min is B.

minList(M, [A]) :- minList(A, [A]).
% need to use tail recursion optimization here
% minList(M, [Head|Tail]) :- minList(Tmp, Tail), min(M, Tmp, Head).
% minList(M, [Head|Tail]) :- M < Head, minList(M, Tail).

