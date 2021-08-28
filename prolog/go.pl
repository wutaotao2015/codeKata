
% single direction map
border(a, b).
border(a, c).
border(a, d).
border(b, c).
border(b, e).
border(c, d).
border(c, e).
border(d, e).


route(X, Y, [go(X, Y)]) :-
  border(X, Y).

route(X, Y, [go(X, Z) | ZtoY]) :-
  border(X, Z),
  route(Z, Y, ZtoY).

