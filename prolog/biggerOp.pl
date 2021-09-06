
:- op(300, xfx, bigger).

is_bigger(bear, dog).
is_bigger(dog, ant).

bigger(X, Y) :- is_bigger(X, Y).
bigger(X, Y) :- is_bigger(X, Z), is_bigger(Z, Y).
