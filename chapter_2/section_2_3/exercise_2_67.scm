(add-load-path "./")
(load "huffman_encoding_trees.scm")

(define sample-tree
  (make-code-tree (make-leaf 'A 4)
                  (make-code-tree
                   (make-leaf 'B 2)
                   (make-code-tree (make-leaf 'D 1)
                                   (make-leaf 'C 1)))))
(define sample-message '(0 1 1 0 0 1 0 1 0 1 1 1 0))

                                        ; tree:
                                        ;    (A B C D)
                                        ;      /   \
                                        ;     A   (B C D)
                                        ;          /   \
                                        ;         B   (C D)
                                        ;              / \
                                        ;             D   C

(decode sample-message sample-tree) ; => (A D A B B C A)
