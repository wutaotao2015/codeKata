
norepeat([], []).
norepeat([Head|Tail], Result) :-
member(Head, Tail),!,
norepeat(Tail, Result).

% if the head is not a member of the Tail, the procedure will
% use the rule below, however, this will create a checkpoint,
% when backtracking, there is no more step-by-step execution, the system
% will try all kinds of possibilities, so the repeated head will be kept 
% as a solution or  alternative for the rule below.
norepeat([Head|Tail], [Head|Result]) :-
norepeat(Tail, Result).

% prolog use cut to delete the no-longer-needed backtracking status data, 
% like regular expression using atomic group to fail matching up fast.
% we use cut to stop matching the second rule after failing the first with
% the head is a member of the tail
/**
Whenever a cut is
encountered in a rule’s body, all choices made between the time that rule’s head has
been matched with the parent goal and the time the cut is passed are final, i.e., any
choicepoints are being discarded.
**/
 
% bug problem with cut
%add(E, L, L) :-
%member(E, L), !.

% I believe below rule can work because the L and R different char with cut
% make the unification permanent, and R = L make false permanent.
add(E, L, R) :-
member(E, L), !,
R = L.

add(E, L, [E|L]).
% add(a, [a,b], [a,a,b]). will be true

pretty(cll).
pretty(wsl).
smart(wsl).
smart(wll).

% cut make the qualified answer be ignored, choice permanent!
bride(Girl) :-
pretty(Girl), !,
smart(Girl).

% negation, the reverse side of the goal, like the single judgement example below
couple(wtt, cll).
couple(wsl, fengc).
couple(wll, zw).

% if the original goal can not be proven, then the negation goal is true
single(P) :-
 \+ couple(P, _),
 \+ couple(_, P).
% according the closed world assumption of prolog, single(X) is No.
% it knows nothing other than the facts provided, -_-!
% fail to prove equals negation, we can not explicitly declare a predicate as being false.
