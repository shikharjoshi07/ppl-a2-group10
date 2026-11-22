:- prolog_load_context(directory, TestDir),
   absolute_file_name('../code/10_q2.pl', Source,
                      [relative_to(TestDir)]),
   consult(Source).

:- begin_tests(q2).

test(all_equations_example) :-
    all_equations([4,2,5,3], Es),
    assertion(Es == [
        "4*2-5=3",
        "4*2=5+3",
        "4-2=5-3",
        "4/2=5-3",
        "4=2*(5-3)",
        "4=2+(5-3)",
        "4=2+5-3"
    ]).

test(generate_one_equation) :-
    once(generate_equation([4,2,5,3], E)),
    Expected = [
        "4*2-5=3",
        "4*2=5+3",
        "4-2=5-3",
        "4/2=5-3",
        "4=2*(5-3)",
        "4=2+(5-3)",
        "4=2+5-3"
    ],
    assertion(member(E, Expected)).

test(no_equation) :-
    assertion(\+ generate_equation([2,3,4], _)),
    all_equations([2,3,4], Es),
    assertion(Es == []).

test(two_four_eight) :-
    all_equations([2,4,8], Es),
    assertion(Es == ["2*4=8"]).

test(empty_and_singleton) :-
    assertion(\+ generate_equation([], _)),
    assertion(\+ generate_equation([5], _)),
    all_equations([], Empty),
    all_equations([5], Single),
    assertion(Empty == []),
    assertion(Single == []).

test(six_zero) :-
    all_equations([6,0], Es),
    assertion(Es == []).

test(zero_zero) :-
    all_equations([0,0], Es),
    assertion(Es == ["0=0"]).

test(no_division_by_zero) :-
    all_equations([1,0,1], Es),
    forall(
        member(E, Es),
        assertion(\+ sub_string(E, _, _, _, "/0"))
    ).

test(parenthesisation) :-
    tree_string('*'('+'(4,2),3), S1),
    tree_string('+'(4,'*'(2,3)), S2),
    tree_string('*'('/'(8,4),2), S3),
    tree_string('/'(8,'*'(4,2)), S4),
    tree_string('-'('-'(1,2),3), S5),
    tree_string('-'(1,'-'(2,3)), S6),
    tree_string('+'(1,'+'(2,3)), S7),
    tree_string('+'('+'(1,2),3), S8),

    assertion(S1 == "(4+2)*3"),
    assertion(S2 == "4+2*3"),
    assertion(S3 == "8/4*2"),
    assertion(S4 == "8/(4*2)"),
    assertion(S5 == "1-2-3"),
    assertion(S6 == "1-(2-3)"),
    assertion(S7 == "1+(2+3)"),
    assertion(S8 == "1+2+3").

test(results_are_strings) :-
    all_equations([4,2,5,3], Es),
    forall(
        member(E, Es),
        assertion(string(E))
    ).

test(count_equations) :-
    count_equations([4,2,5,3], N),
    assertion(N =:= 7).

:- end_tests(q2).
