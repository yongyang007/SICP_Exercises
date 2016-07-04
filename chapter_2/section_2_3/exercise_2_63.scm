(add-load-path "./")
(load "sets_as_binary_trees.scm")

(define (tree->list-1 tree)
  (if (null? tree)
      '()
      (append (tree->list-1 (left-branch tree))
              (cons (entry tree)
                    (tree->list-1 (right-branch tree))))))

(define (tree->list-2 tree)
  (define (copy-to-list tree result-list)
    (if (null? tree)
        result-list
        (copy-to-list (left-branch tree)
                      (cons (entry tree)
                            (copy-to-list (right-branch tree)
                                          result-list)))))
  (copy-to-list tree '()))

(define set-1 (make-tree 7
                         (make-tree 3
                                    (make-tree 1 '() '())
                                    (make-tree 5 '() '()))
                         (make-tree 9
                                    '()
                                    (make-tree 11 '() '()))))
(define set-2 (make-tree 3
                         (make-tree 1 '() '())
                         (make-tree 7
                                    (make-tree 5 '() '())
                                    (make-tree 9
                                               '()
                                               (make-tree 11 '() '())))))
(define set-3 (make-tree 5
                         (make-tree 3
                                    (make-tree 1 '() '())
                                    '())
                         (make-tree 9
                                    (make-tree 7 '() '())
                                    (make-tree 11 '() '()))))

(tree->list-1 set-1)
(tree->list-1 set-2)
(tree->list-1 set-3)
(tree->list-2 set-1)
(tree->list-2 set-2)
(tree->list-2 set-3)

                                        ;a)
                                        ;两个过程对所有产生的结果相同
                                        ;他们对图2-16中的那些树产生生序排列的表

                                        ;b)
                                        ;由于第一个过程利用了append，应该是第二个方法步数增长的慢
                                        ;过程一为Θ(n*log n)，过程二为Θ(n)
