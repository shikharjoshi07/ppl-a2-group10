%! candidate(-S) is nondet.
% Declarative reading: S is a list assigning each friend a unique department,
% language, and project, using every value of each attribute exactly once.

candidate([
    p('Alex', D1, L1, P1),
    p('Ben', D2, L2, P2),
    p('Carla', D3, L3, P3),
    p('Dana', D4, L4, P4)
]) :-
    permutation([research, development, design, testing],
                [D1, D2, D3, D4]),
    permutation([python, java, 'c++', javascript],
                [L1, L2, L3, L4]),
    permutation(['AI', web, embedded, data],
                [P1, P2, P3, P4]).

% The friend who prefers the AI project does not work in research and is not Dana.
%! clue(1, +S) is semidet.
% Declarative reading: The friend preferring AI is not Dana and does not work in research.
clue(1, S) :-
    member(p(Name, Dept, _, 'AI'), S),
    Name \= 'Dana',
    Dept \= research.

% Alex does not work in development and does not prefer C++.
%! clue(2, +S) is semidet.
% Declarative reading: Alex works outside development and does not prefer c++.
clue(2, S) :-
    member(p('Alex', Dept, Lang, _), S),
    Dept \= development,
    Lang \= 'c++'.

% The friend working in the testing department likes Python.
%! clue(3, +S) is semidet.
% Declarative reading: The friend working in testing has python as their favorite language.
clue(3, S) :-
    member(p(_, testing, python, _), S).

% Ben prefers web projects and does not work in testing.
%! clue(4, +S) is semidet.
% Declarative reading: Ben prefers web projects and works outside testing.
clue(4, S) :-
    member(p('Ben', Dept, _, web), S),
    Dept \= testing.

% The friend whose favorite language is Java works in the design department.
%! clue(5, +S) is semidet.
% Declarative reading: The friend whose favorite language is java works in design.
clue(5, S) :-
    member(p(_, design, java, _), S).

% Carla's project preference is not embedded, and her department is not development.
%! clue(6, +S) is semidet.
% Declarative reading: Carla does not prefer embedded projects and does not work in development.
clue(6, S) :-
    member(p('Carla', Dept, _, Project), S),
    Dept \= development,
    Project \= embedded.

% Dana's favorite language is not Java, and she works in research or testing.
%! clue(7, +S) is semidet.
% Declarative reading: Dana does not prefer java and works in either research or testing.
clue(7, S) :-
    member(p('Dana', Dept, Lang, _), S),
    Lang \= java,
    (Dept = research ; Dept = testing).

% The friend who prefers data projects works in research and does not use JavaScript.
%! clue(8, +S) is semidet.
% Declarative reading: The friend preferring data projects works in research and does not prefer javascript.
clue(8, S) :-
    member(p(_, research, Lang, data), S),
    Lang \= javascript.

%! clue(9, +S) is semidet.
% Declarative reading: The friend working in design prefers embedded projects.
% CLUE 9: The friend working in the design department prefers the embedded project.
clue(9, S) :-
    member(p(_, design, _, embedded), S).

%! holds_all(+Active, +S) is semidet.
% Declarative reading: Every clue number in Active holds for solution S.
holds_all(Active, S) :-
    forall(
        member(N, Active),
        clue(N, S)
    ).

%! main is det.
% Declarative reading: The first candidate satisfying all eight clues is printed
% as four lines, one for each friend in the required order.
main :-
    once((
        candidate(S),
        holds_all([1,2,3,4,5,6,7,8], S)
    )),
    member(p('Alex', D1, L1, P1), S),
    member(p('Ben', D2, L2, P2), S),
    member(p('Carla', D3, L3, P3), S),
    member(p('Dana', D4, L4, P4), S),
    format("Alex = [~w, ~w, ~w]~n", [D1, L1, P1]),
    format("Ben = [~w, ~w, ~w]~n", [D2, L2, P2]),
    format("Carla = [~w, ~w, ~w]~n", [D3, L3, P3]),
    format("Dana = [~w, ~w, ~w]~n", [D4, L4, P4]).

%! count_solutions(+Active, -N) is det.
% Declarative reading: N is the number of candidates satisfying every active clue.
count_solutions(Active, N) :-
    aggregate_all(
        count,
        (
            candidate(S),
            holds_all(Active, S)
        ),
        N
    ).

%! list_solutions(+Active, -Sols) is det.
% Declarative reading: Sols is the list of all candidates satisfying every active clue.
list_solutions(Active, Sols) :-
    findall(
        S,
        (
            candidate(S),
            holds_all(Active, S)
        ),
        Sols
    ).
