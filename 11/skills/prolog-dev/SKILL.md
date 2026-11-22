---
name: prolog-dev
description: Conventions, run/test commands, self-review checklist and known AI failure modes for writing SWI-Prolog 9.x code for CS F301 Assignment 2 (P1 logic puzzle, P2 arithmetic equations).
---

# Prolog development (SWI-Prolog 9.x)

## Scope of every answer
- Write exactly one unit of work per answer: one predicate (all its clauses), one test file, or one review. Never write a whole problem at once.
- Give the code, then a 2–4 line explanation that includes the declarative reading. No filler.
- If the request is ambiguous, state your assumption in one line and proceed.

## Environment
- SWI-Prolog 9.x. Code is run as `swipl -q -f id_qN.pl -g main -t halt`, or `swipl -q -f id_qN.pl -g "<goal>" -t halt`.
- Allowed libraries: `lists`, `apply`, `yall`, `aggregate` only.
- Forbidden: `assert*`/`retract*`, `b_setval`/`nb_setval` and any global variables, `:- initialization(...)`, calling `halt/0`, printing anything that wasn't asked for, and building a string and then parsing it back into a term (`term_string`, `term_to_atom`, `read_term_from_atom`, `number_codes` on an equation string).

## Coding conventions
- Predicate names are `snake_case`; variable names are descriptive (`Dept`, `Lang`, `Proj`, `LeftTree`), never `X1`, `X2`.
- Put this above every predicate:
  - `%! name(+In, -Out) is det|semidet|nondet.` (the mode line)
  - `% Declarative reading: <one sentence on what is true when it succeeds>.`
- Keep all clauses of a predicate together. Don't use `discontiguous`.
- P1: each clue is its own clause, `clue(N, Solution)`, with the English clue in a comment above it.
- Arithmetic: evaluate with `is`, compare with `=:=` and `=\=`, use integer division `//`, and check exactness with `mod`. Never use `=` for arithmetic.
- Strings: double quotes are SWI strings. Build them with `format(string(S), Fmt, Args)` or `string_concat/3`.
- Recurse on structurally smaller inputs (split a list into non-empty parts before recursing) so termination is obvious.

## How to run and test
- Interactive: `swipl code/id_q1.pl`, then `?- main.`
- One goal: `swipl -q -f code/id_q1.pl -g "count_solutions([1,2,3,4,5,6,7,8],N), print(N), nl" -t halt`
- Tests: plunit files in `tests/`, run with `swipl -q -g run_tests -t halt tests/test_q1.pl`
- Loading the file must print nothing and give zero warnings.

## Self-review checklist (apply before every answer)
1. Does the file load with zero warnings (singletons, discontiguous clauses)?
2. Is there any forbidden predicate or directive (assert, retract, nb_setval, initialization, halt, a library outside the allowed four)?
3. Does it terminate on every input, including `[]` and one-element lists? Does it fail rather than raise an error?
4. Are atoms like `'AI'`, `'Alex'` and `'c++'` quoted in the source, and printed with `~w` so the quotes don't show?
5. Is arithmetic done with `is` and `=:=`? Is every division guarded (divisor `=\= 0`, `X mod Y =:= 0`)?
6. Does the printed output match the required format exactly, with nothing extra?
7. Are there duplicate solutions or leftover choice points where the predicate should be deterministic?
8. Does the declarative-reading comment match what the code actually does?

## Known AI failure modes in Prolog
- Printing lists with `write`/`print`, which gives `[a,b]` with no spaces and `'AI'` with quotes.
- Running a clue check or arithmetic before the generator has bound the values ("Arguments are not sufficiently instantiated").
- Writing `X = A + B` when it means `X is A + B`.
- Using `/` and getting rationals or floats. Integer division is `//`, plus a `mod` exactness check.
- Left recursion (`expr :- expr, ...`) that loops forever. Always shrink the input before recursing.
- Forgetting that `sort/2` removes duplicates and `msort/2` does not.
- Expecting `\+` to bind variables.
- Inventing predicates that SWI-Prolog doesn't have, or using libraries outside the allowed set.
- Adding `:- initialization(main).` out of habit.
- Confusing strings, atoms and code lists (`"abc"` vs `'abc'` vs `` `abc` ``).
