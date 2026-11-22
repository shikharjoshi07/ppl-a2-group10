#!/usr/bin/env bash

set -u

cd "$(dirname "$0")/.." || exit 1

SOURCE="code/10_q3.rkt"
TMP=$(mktemp)
EXPECTED=$(mktemp)
ACTUAL=$(mktemp)

trap 'rm -f "$TMP" "$EXPECTED" "$ACTUAL"' EXIT

passed=0
failed=0

run_case() {
    name="$1"
    tree_definition="$2"
    calls="$3"
    expected="$4"

    cp "$SOURCE" "$TMP" || exit 1

    {
        echo "$tree_definition"
        echo "$calls"
    } >> "$TMP"

    printf '%s\n' "$expected" > "$EXPECTED"

    if racket "$TMP" > "$ACTUAL" 2>&1; then
        if diff -u "$EXPECTED" "$ACTUAL"; then
            echo "PASS: $name"
            passed=$((passed + 1))
        else
            echo "FAIL: $name"
            failed=$((failed + 1))
        fi
    else
        echo "FAIL: $name"
        cat "$ACTUAL"
        failed=$((failed + 1))
    fi
}

# t1: balanced tree
run_case "t1 all traversals and height" \
'(define t1 (quote (4 (2 (1 () ()) (3 () ())) (6 (5 () ()) (7 () ())))))' \
'(print-inorder t1)
(print-all-traversals t1)
(print-height-and-leaves t1)' \
'(1 2 3 4 5 6 7)
(1 2 3 4 5 6 7)
(4 2 1 3 6 5 7)
(1 3 2 5 7 6 4)
(3 4)'

# t2: right-only chain
run_case "t2 all traversals and height" \
'(define t2 (quote (1 () (2 () (3 () ())))))' \
'(print-inorder t2)
(print-all-traversals t2)
(print-height-and-leaves t2)' \
'(1 2 3)
(1 2 3)
(1 2 3)
(3 2 1)
(3 1)'

# t3: symbolic values
run_case "t3 all traversals and height" \
'(define t3 (quote (a (b () ()) (c () ()))))' \
'(print-inorder t3)
(print-all-traversals t3)
(print-height-and-leaves t3)' \
'(b a c)
(b a c)
(a b c)
(b c a)
(2 2)'

# Empty tree
run_case "empty tree" \
'(define t (quote ()))' \
'(print-inorder t)
(print-all-traversals t)
(print-height-and-leaves t)' \
'()
()
()
()
(0 0)'

# Single node
run_case "single node" \
'(define t (quote (5 () ())))' \
'(print-inorder t)
(print-all-traversals t)
(print-height-and-leaves t)' \
'(5)
(5)
(5)
(5)
(1 1)'

# Left-only chain
run_case "left-only chain" \
'(define t (quote (3 (2 (1 () ()) ()) ())))' \
'(print-inorder t)
(print-all-traversals t)
(print-height-and-leaves t)' \
'(1 2 3)
(1 2 3)
(3 2 1)
(1 2 3)
(3 1)'

# Source file must produce no output independently
if racket "$SOURCE" > "$ACTUAL" 2>&1; then
    if [ ! -s "$ACTUAL" ]; then
        echo "PASS: no top-level output"
        passed=$((passed + 1))
    else
        echo "FAIL: no top-level output"
        cat "$ACTUAL"
        failed=$((failed + 1))
    fi
else
    echo "FAIL: standalone source execution"
    cat "$ACTUAL"
    failed=$((failed + 1))
fi

echo
echo "Results: $passed passed, $failed failed"

if [ "$failed" -ne 0 ]; then
    exit 1
fi

exit 0
