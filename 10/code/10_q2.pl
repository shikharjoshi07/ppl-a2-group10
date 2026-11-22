%! split(+List, -Left, -Right) is nondet.
% Declarative reading: Left and Right are non-empty contiguous parts of List,
% and appending Left followed by Right reconstructs List.

split(List, Left, Right) :-
    append(Left, Right, List),
    Left = [_|_],
    Right = [_|_].

%! expr(+Nums, -Tree, -Value) is nondet.
% Declarative reading: Tree represents an expression using every number in
% Nums exactly once, in order, and Value is its valid integer evaluation.

expr([N], N, N).

expr(Nums, Tree, Value) :-
    split(Nums, Left, Right),
    expr(Left, LeftTree, LeftValue),
    expr(Right, RightTree, RightValue),
    combine(LeftTree, RightTree, LeftValue, RightValue, Tree, Value).

%! combine(+LeftTree, +RightTree, +LeftValue, +RightValue, -Tree, -Value) is nondet.
% Declarative reading: Tree combines the two operand trees using a valid
% arithmetic operation and Value is the resulting integer.

combine(LeftTree, RightTree, LeftValue, RightValue,
        +(LeftTree, RightTree), Value) :-
    Value is LeftValue + RightValue.

combine(LeftTree, RightTree, LeftValue, RightValue,
        -(LeftTree, RightTree), Value) :-
    Value is LeftValue - RightValue.

combine(LeftTree, RightTree, LeftValue, RightValue,
        *(LeftTree, RightTree), Value) :-
    Value is LeftValue * RightValue.

combine(LeftTree, RightTree, LeftValue, RightValue,
        '/'(LeftTree, RightTree), Value) :-
    RightValue =\= 0,
    LeftValue mod RightValue =:= 0,
    Value is LeftValue // RightValue.
