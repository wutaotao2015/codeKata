
merge([], List, List).
merge([Head|Tail1], List, [Head|Tail2]) :- merge(Tail1, List, Tail2).

reverse([A], [A]).
/** watch the results, use a series of true statements to express the algorithm**/
reverse(Res, [Head|Tail]) :- reverse(Tmp, Tail), merge(Tmp, Head, Res).

