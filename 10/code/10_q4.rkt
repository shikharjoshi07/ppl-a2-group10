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

;; (make-inserter x len-ok?) -> procedure
;; Recursive reading: Process each element, recursively transforming
;; sublists; then insert x if the original list's length satisfies len-ok?.
(define (make-inserter x len-ok?)
  (letrec ((insert
            (lambda (lst)
              (let ((mapped
                     (my-map
                      (lambda (e)
                        (if (or (null? e) (pair? e))
                            (insert e)
                            e))
                      lst)))
                (if (len-ok? (my-length lst))
                    (cons x mapped)
                    mapped)))))
    insert))

;; (insert-if-short x lst n) -> list
;; Recursive reading: Delegate to make-inserter with a predicate
;; that accepts lists whose original length is less than n.
(define (insert-if-short x lst n)
  ((make-inserter x (lambda (len) (< len n))) lst))
