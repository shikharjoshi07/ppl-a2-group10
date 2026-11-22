%! split(+List, -Left, -Right) is nondet.
% Declarative reading: Left and Right are non-empty contiguous parts of List,
% and appending Left followed by Right reconstructs List.

split(List, Left, Right) :-
    append(Left, Right, List),
    Left = [_|_],
    Right = [_|_].
