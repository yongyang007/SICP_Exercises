(add-load-path "./")
(load "huffman_encoding_trees.scm")

(define (generate-huffman-tree pairs)
  (successive-merge (make-leaf-set pairs)))

(define (successive-merge set)
  (if (null? set)
      '()
      (let ((smallest-1 (car set))
            (others-1 (cdr set)))
        (if (null? others-1)
            smallest-1
            (let ((smallest-2 (car others-1))
                  (others-2 (cdr others-1)))
              (successive-merge (adjoin-set
                                 (make-code-tree smallest-1
                                                 smallest-2)
                                 others-2)))))))
