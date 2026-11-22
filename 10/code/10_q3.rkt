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

;; (preorder-acc tree acc) -> list
;; Recursive reading: If tree is empty, return acc; otherwise process the
;; right subtree, then the left subtree, then cons the node value.
(define (preorder-acc tree acc)
  (if (null? tree)
      acc
      (cons (car tree)
            (preorder-acc
             (cadr tree)
             (preorder-acc (caddr tree) acc)))))

;; (postorder-acc tree acc) -> list
;; Recursive reading: If tree is empty, return acc; otherwise cons the
;; node value, then process the right subtree, then the left subtree.
(define (postorder-acc tree acc)
  (if (null? tree)
      acc
      (postorder-acc
       (cadr tree)
       (postorder-acc
        (caddr tree)
        (cons (car tree) acc)))))

;; (print-all-traversals tree) -> void
;; Recursive reading: Obtain each traversal using its accumulator helper,
;; display each resulting list, and terminate each line with a newline.
(define (print-all-traversals tree)
  (display (inorder-acc tree '()))
  (newline)
  (display (preorder-acc tree '()))
  (newline)
  (display (postorder-acc tree '()))
  (newline))
