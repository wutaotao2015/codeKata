
diff(red, blue). diff(red, green).
diff(blue, red). diff(blue, green).
diff(green, red). diff(green, blue).

color(A, B, C, D, E) :- 
diff(B, A),
diff(B, C),
diff(B, E),
diff(C, A),
diff(C, D),
diff(C, E),
diff(D, A),
diff(D, E).
