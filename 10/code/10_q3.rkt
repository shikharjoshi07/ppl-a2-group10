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

;; (tree-height tree) -> number
;; Recursive reading: If tree is empty, return 0; otherwise return 1 plus
;; the maximum height of the left and right subtrees.
(define (tree-height tree)
  (if (null? tree)
      0
      (+ 1
         (max (tree-height (cadr tree))
              (tree-height (caddr tree))))))

;; (count-leaves tree acc) -> number
;; Recursive reading: If tree is empty, return acc; if both subtrees are
;; empty, increment acc; otherwise count the left subtree, then the right.
(define (count-leaves tree acc)
  (if (null? tree)
      acc
      (if (and (null? (cadr tree))
               (null? (caddr tree)))
          (+ acc 1)
          (count-leaves
           (cadr tree)
           (count-leaves (caddr tree) acc)))))

;; (print-height-and-leaves tree) -> void
;; Recursive reading: Calculate the height and leaf count, display them
;; together as a two-element list, and terminate with a newline.
(define (print-height-and-leaves tree)
  (display (list (tree-height tree) (count-leaves tree 0)))
  (newline))
