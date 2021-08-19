
likes(wtt, apple).
likes(cll, apple).
likes(xxx, banana).

friend(X, Y) :- \+(X = Y), likes(X, Z), likes(Y, Z).
