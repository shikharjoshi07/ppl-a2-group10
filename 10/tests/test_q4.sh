#!/usr/bin/env bash

set -uo pipefail

cd "$(dirname "$0")/.." || exit 1

tmp=$(mktemp)
out=$(mktemp)
expected=$(mktemp)

trap 'rm -f "$tmp" "$out" "$expected"' EXIT

cp code/10_q4.rkt "$tmp" || exit 1
printf '\n(print-insert-result)\n' >> "$tmp"

failed=0

run_case() {
    local name="$1"
    local input="$2"
    local want="$3"

    printf '%s\n' "$want" > "$expected"

    if printf '%s\n' "$input" | racket "$tmp" > "$out" 2>&1 &&
       diff -q "$expected" "$out" >/dev/null; then
        echo "PASS: $name"
    else
        echo "FAIL: $name"
        diff -u "$expected" "$out" || true
        failed=1
    fi
}

run_prefix_case() {
    local name="$1"
    local input="$2"
    local prefix="$3"

    if printf '%s\n' "$input" | racket "$tmp" > "$out" 2>&1; then
        local actual
        actual=$(cat "$out")

        if [[ "$actual" == "$prefix"* ]]; then
            echo "PASS: $name"
        else
            echo "FAIL: $name"
            echo "Expected prefix: $prefix"
            echo "Actual: ${actual:0:100}"
            failed=1
        fi
    else
        echo "FAIL: $name (racket error)"
        failed=1
    fi
}

# Four examples from the specification.

run_case "Example 1" \
    '42 ((1 2) (3 4 5) (6) ()) 3' \
    '((42 1 2) (3 4 5) (42 6) (42))'

run_case "Example 2" \
    '0 (((1) 2) (3) ((4 5 6) ())) 3' \
    '((0 (0 1) 2) (0 3) (0 (4 5 6) (0)))'

run_case "Example 3: empty list, n=3" \
    '7 () 3' \
    '(7)'

run_case "Example 4: empty list, n=0" \
    '7 () 0' \
    '()'

# Additional edge cases.

run_case "Atoms and empty sublists" \
    'z ((a) () (b c)) 1' \
    '((a) (z) (b c))'

run_case "Length exactly n" \
    'z (1 2) 2' \
    '(1 2)'

run_case "Nested empty list" \
    'q (()) 2' \
    '(q (q))'

# Nesting depth 100.

deep="1"
for ((i = 0; i < 100; i++)); do
    deep="($deep)"
done

prefix=""
for ((i = 0; i < 100; i++)); do
    prefix+="(x "
done

run_prefix_case "Nesting depth 100" \
    "x $deep 2" \
    "$prefix"

# Flat list of 10,000 elements.

nums=$(seq -s ' ' 1 10000)
flat="($nums)"

run_prefix_case "10,000 elements, n=10001" \
    "x $flat 10001" \
    '(x 1 2 3'

run_case "10,000 elements, n=5" \
    "x $flat 5" \
    "$flat"

# Loading the original file with empty stdin must print nothing.

if racket code/10_q4.rkt </dev/null > "$out" 2>&1 &&
   [[ ! -s "$out" ]]; then
    echo "PASS: No output when loaded"
else
    echo "FAIL: No output when loaded"
    cat "$out"
    failed=1
fi

echo

if [[ "$failed" -eq 0 ]]; then
    echo "All tests passed."
    exit 0
else
    echo "Some tests failed."
    exit 1
fi
