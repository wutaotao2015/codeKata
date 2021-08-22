food(apple).
food(bread).

eat(X, Y, Z) :- X = apple, Y = bread, Z = cheese.
both_food(X, Y) :- food(X), food(Y).

