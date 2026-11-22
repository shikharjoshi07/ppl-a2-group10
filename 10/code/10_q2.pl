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

%! tree_string(+Tree, -S) is det.
% Declarative reading: S is the canonical string representation of Tree,
% with parentheses determined by operator precedence and associativity.

tree_string(N, S) :-
    integer(N),
    format(string(S), '~w', [N]).

tree_string(+(A, B), S) :-
    tree_string_node(+, A, B, 1, S).

tree_string(-(A, B), S) :-
    tree_string_node(-, A, B, 1, S).

tree_string(*(A, B), S) :-
    tree_string_node(*, A, B, 2, S).

tree_string('/'(A, B), S) :-
    tree_string_node('/', A, B, 2, S).


%! tree_string_node(+Op, +A, +B, +Prec, -S) is det.
% Declarative reading: S represents Op(A,B), formatting both children
% according to their precedence relative to the parent operator.

tree_string_node(Op, A, B, Prec, S) :-
    tree_string_child(A, Prec, left, LeftString),
    tree_string_child(B, Prec, right, RightString),
    format(string(S), '~s~w~s', [LeftString, Op, RightString]).


%! tree_string_child(+Tree, +ParentPrec, +Side, -S) is det.
% Declarative reading: S represents Tree, adding parentheses exactly when
% its operator precedence requires them on the specified side of its parent.

tree_string_child(Tree, ParentPrec, Side, S) :-
    tree_string(Tree, InnerString),
    (   tree_precedence(Tree, ChildPrec),
        (   (Side = left, ChildPrec < ParentPrec)
        ;   (Side = right, ChildPrec =< ParentPrec)
        )
    ->  format(string(S), '(~s)', [InnerString])
    ;   S = InnerString
    ).

%! tree_precedence(+Tree, -Prec) is semidet.
% Declarative reading: Prec is the precedence of an operator at the root
% of Tree; numbers have no operator precedence.

tree_precedence(+( _, _), 1).
tree_precedence(-( _, _), 1).
tree_precedence(*( _, _), 2).
tree_precedence('/'( _, _), 2).

%! generate_equation(+List, -Equation) is nondet.
% Declarative reading: Equation is a valid equation formed by splitting List
% into two non-empty consecutive parts whose expression trees have equal values.

generate_equation(List, Equation) :-
    split(List, LeftNums, RightNums),
    expr(LeftNums, LeftTree, LeftValue),
    expr(RightNums, RightTree, RightValue),
    LeftValue =:= RightValue,
    tree_string(LeftTree, LeftString),
    tree_string(RightTree, RightString),
    format(string(Equation), '~s=~s', [LeftString, RightString]).

%! all_equations(+List, -Equations) is det.
% Declarative reading: Equations is the sorted list of all distinct valid
% equations that can be formed from List.

all_equations(List, Equations) :-
    findall(Equation, generate_equation(List, Equation), Generated),
    sort(Generated, Equations).


%! count_equations(+List, -N) is det.
% Declarative reading: N is the number of distinct valid equations
% that can be formed from List.

count_equations(List, N) :-
    all_equations(List, Equations),
    length(Equations, N).
