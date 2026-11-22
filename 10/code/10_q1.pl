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
