#lang racket/base

;; (my-length lst) -> integer
;; Recursive reading: Empty list returns the accumulator; otherwise,
;; count the first element and recurse on the rest with accumulator + 1.
(define (my-length lst)
  (let loop ((remaining lst) (count 0))
    (if (null? remaining)
        count
        (loop (cdr remaining) (+ count 1)))))

;; (my-map f lst) -> list
;; Recursive reading: Empty list returns (); otherwise, apply f to the
;; first element and cons it onto the recursively mapped rest.
(define (my-map f lst)
  (if (null? lst)
      '()
      (cons (f (car lst))
            (my-map f (cdr lst)))))
