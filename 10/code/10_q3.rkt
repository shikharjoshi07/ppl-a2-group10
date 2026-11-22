#lang racket/base

;; (inorder-acc tree acc) -> list
;; Recursive reading: If tree is empty, return acc; otherwise process the
;; right subtree, cons the node value, then process the left subtree.
(define (inorder-acc tree acc)
  (if (null? tree)
      acc
      (inorder-acc
       (cadr tree)
       (cons (car tree)
             (inorder-acc (caddr tree) acc)))))

;; (print-inorder tree) -> void
;; Recursive reading: Obtain the inorder list using inorder-acc, display it,
;; and terminate the output with a newline.
(define (print-inorder tree)
  (display (inorder-acc tree '()))
  (newline))
