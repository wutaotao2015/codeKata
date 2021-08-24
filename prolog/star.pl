
w(0, _).
w(I, Str) :-
 Tmp is I - 1,
 write(Str),
 w(Tmp, Str).

square(0, _).
square(I, Str) :-
 Row is I - 1,
 w(I, Str), nl,
 square(Row, Str).
