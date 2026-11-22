---
name: scheme-dev
description: Conventions, allowed built-ins, run/test commands, self-review checklist and known AI failure modes for writing restricted Racket 8.x (#lang racket/base) code for CS F301 Assignment 2 (S1 tree traversals, S2 nested insert).
---

# Scheme development (Racket 8.x, `#lang racket/base`)

## Scope of every answer
- Write exactly one unit of work per answer: one function (plus any tiny helper it needs), one test file, or one review. Never write a whole problem at once.
- Give the code, then a 2–4 line explanation that includes the recursive reading. No filler.

## Environment
- Racket 8.x. Every code file starts with `#lang racket/base`.
- Files contain only definitions: no top-level calls and no output at load time. The grader appends its own calls and runs `racket id_qN.rkt`.

## Allowed built-ins (nothing else)
`define`, `lambda`, `let`, `let*`, `letrec`, named `let`, `if`, `cond` (with `else`), `and`, `or`, `not`, `begin`, `quote` / `'`, `cons`, `car`, `cdr`, `list`, the `c[ad]{2,4}r` compositions (`cadr`, `cddr`, `caddr`, `cadddr`, …), `null?`, `pair?`, `eq?`, `assq`, `assoc`, `+ - * < > <= >= =`, `max`, `display`, `newline`. `read` is allowed in S2 only.

Explicitly forbidden: `set!` and its relatives, vectors, hash tables, strings, `do`, `for` and other loops, `length`, `append`, `reverse`, `map`, `filter`, `member`, `memq`, `list-ref`, `list-tail`. Also not on the list, so don't use them either: `list?`, `equal?`, `zero?`, `add1`, `sub1`, `first`, `rest`, `empty?`, `null` (write `'()`), `when`, `unless`, `case`, `foldl`, `foldr`, `apply`, `printf`, `write`, `define-values`, `provide`, `require`.

## Coding conventions
- Names are kebab-case. Helpers you write yourself are prefixed `my-` (`my-length`, `my-map`, `my-reverse`).
- Put this above every function:
  - `;; (name arg ...) -> return type`
  - `;; Recursive reading: <base case>; <recursive case in one sentence>.`
- Pass all state through arguments, and use accumulators where they make tail recursion natural.
- To test whether something is a list (including `()`), use `(or (null? e) (pair? e))`.
- Use only parentheses, no square brackets.

## How to run and test
- Run: `racket code/id_q3.rkt` (it should print nothing).
- Tests are bash scripts in `tests/` that do what the grader does: copy the code file to a temp file, append calls, run `racket`, and `diff` the output against the expected text. Run with `bash tests/test_q3.sh`.
- For S2, feed stdin: `printf '42 ((1 2) (3 4 5) (6) ()) 3' | racket tmp.rkt`

## Self-review checklist (apply before every answer)
1. Is every identifier used either defined in this file or on the allowed list above? Scan for `length`, `append`, `map`, `reverse`, `list?`, `equal?`, `else` inside `if`, `when`, `set!`.
2. Does the file start with `#lang racket/base`, with no top-level calls or output?
3. Is the empty case `()` handled first in every recursion?
4. Does every printing function end its output with `(newline)`?
5. Does it work on the examples from the problem statement, including the `()` edge cases?
6. Will it handle a 10,000-element list and nesting depth 100 without blowing up?
7. Is state threaded through arguments only (no mutation)?
8. Does the recursive-reading comment match the code?

## Known AI failure modes in this restricted Scheme
- Reaching for `length`, `append`, `map`, `reverse` or `list?` out of habit.
- Using `#lang racket` instead of `#lang racket/base`, or adding `(provide ...)` or `(require ...)`.
- Calling functions at the top level "to demo" them, which breaks the grader's output.
- Using `printf`/`write` instead of `display`, or forgetting the trailing `newline`.
- Treating `()` as an atom. It is an empty list and must be processed like any other list.
- Computing a length after modifying the list instead of on the original.
- Building traversals with repeated `append`, which is both forbidden and quadratic. Use a cons accumulator instead.
- Using `null` or `empty` instead of `'()`.
