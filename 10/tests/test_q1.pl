% Tests for P1. The source path is resolved relative to this test file.
:- prolog_load_context(directory, TestDir),
   atom_concat(TestDir, '/../code/10_q1.pl', Source),
   ensure_loaded(Source).

:- begin_tests(q1).

test(no_clues_count_all_candidates) :-
    count_solutions([], N),
    assertion(N =:= 13824).

test(clues_1_to_8_have_three_solutions) :-
    count_solutions([1,2,3,4,5,6,7,8], N),
    assertion(N =:= 3).

test(clues_1_to_9_have_one_solution) :-
    count_solutions([1,2,3,4,5,6,7,8,9], N),
    assertion(N =:= 1).

test(clues_1_to_9_return_kept_solution) :-
    list_solutions(
        [1,2,3,4,5,6,7,8,9],
        [ [p('Alex', design, java, embedded),
           p('Ben', development, javascript, web),
           p('Carla', testing, python, 'AI'),
           p('Dana', research, 'c++', data)] ]
    ).

test(clue_9_fails_on_solution_1, [fail]) :-
    clue(9, [
        p('Alex', design, java, 'AI'),
        p('Ben', development, javascript, web),
        p('Carla', research, 'c++', data),
        p('Dana', testing, python, embedded)
    ]).

test(clue_9_fails_on_solution_3, [fail]) :-
    clue(9, [
        p('Alex', testing, python, embedded),
        p('Ben', development, javascript, web),
        p('Carla', design, java, 'AI'),
        p('Dana', research, 'c++', data)
    ]).

test(main_prints_exactly_solution_1) :-
    with_output_to(
        string(Out),
        main
    ),
    Expected = "Alex = [design, java, AI]\nBen = [development, javascript, web]\nCarla = [research, c++, data]\nDana = [testing, python, embedded]\n",
    assertion(Out == Expected).

:- end_tests(q1).
