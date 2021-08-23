
merge([], List, List).
merge([Head|Tail1], List, [Head|Tail2]) :- merge(Tail1, List, Tail2).
