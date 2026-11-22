# P1 Report

## 1. Solutions using clues 1-8

`count_solutions([1,2,3,4,5,6,7,8], N)` gives **N = 3**.

| Friend | Solution 1 | Solution 2 (kept) | Solution 3 |
|---|---|---|---|
| Alex | `[design, java, AI]` | `[design, java, embedded]` | `[testing, python, embedded]` |
| Ben | `[development, javascript, web]` | `[development, javascript, web]` | `[development, javascript, web]` |
| Carla | `[research, c++, data]` | `[testing, python, AI]` | `[design, java, AI]` |
| Dana | `[testing, python, embedded]` | `[research, c++, data]` | `[research, c++, data]` |

## 2. What the results tell us

The eight clues under-determine the puzzle: they admit three valid solutions, so the puzzle has no unique answer as stated.

Ben's attributes are identical in all three solutions. Alex, Carla, and Dana have different assignments across the solutions. In particular, the department, language, and project assignments vary for those friends. Solutions 1 and 3 contain the same four department-language-project combinations, but assign those combinations to different friends.

`main/0` prints solution 1, which is a valid answer to clues 1-8, while clue 9 keeps solution 2.

## 3. Additional clue 9

**Clue 9:** The friend working in the design department prefers the embedded project.

This clue is true in the kept solution (solution 2), because the friend in design prefers embedded. It is false in solutions 1 and 3, where the friend in design prefers AI.

With clue 9 added, `count_solutions([1,2,3,4,5,6,7,8,9], N)` gives **N = 1**, so the kept solution is uniquely selected.
