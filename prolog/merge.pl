/**
merge([], List, List).
merge([Head|Tail1], List, [Head|Tail2]) :- merge(Tail1, List, Tail2).

rev([], []).
%watch each step of the recursive progress, use a series of true statements to 
%express the algorithm, bad is use built-in reverse to implement rev
rev(Res, [Head|Tail]) :- reverse(Tmp, Tail), merge(Tmp, [Head], Res).

min(Min, A, B) :- A < B, Min is A.
min(Min, A, B) :- A = B, Min is A.
min(Min, A, B) :- A > B, Min is B.

minList(M, [A]) :- minList(A, [A]).

% need to use tail recursion optimization here
minList(M, [Head|Tail]) :- 
Tmp is min(M, Head),
minList(Tmp, Tail).
**/


% this step is reduce the numbers of parameters, remove the middle param
rev(Old, R) :- rev(Old, [], R).
rev([H|T], Tmp, R) :- rev(T, [H|Tmp], R).
rev([], Tmp, Tmp).


min(A, A, A).
min(A, B, A) :- A < B.
min(A, B, B) :- B < A.

minInL([H|T], M) :- minInL(T, MT), min(H, MT, M).
minInL([M], M).

% if the min element is the head, just remove it
% else remove the head of the original and result, and use recursion the repeat 
% the process, never think about how to remove the min one, use the true goal 
% and recursion to do the job.
takeout(H, [H|T], T).
takeout(Min, [H|T], [H|RestT]) :-
takeout(Min, T, RestT).

% the orginal list is unsorted, the result is sorted
% in order to use recursion, we need to remove the head of both the original
% list and sorted list(the min one of the sorted list)
sortL(L, [SH|ST]) :- 
  minInL(L, SH),
  takeout(SH, L, RestL),
  sortL(RestL, ST).

sortL([X], [X]).

