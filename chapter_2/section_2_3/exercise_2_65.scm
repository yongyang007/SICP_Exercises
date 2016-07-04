(add-load-path "./")
(load "exercise_2_63.scm")
(load "exercise_2_64.scm")

(define (union-set set1 set2)
  (define (union-ordered-list list1 list2)
    (if (or (null? list1) (null? list2))
        (if (null? list2) list1 list2)
        (let ((x1 (car list1)) (x2 (car list2)))
          (cond ((= x1 x2) (cons x1
                                 (union-ordered-list (cdr list1) (cdr list2))))
                ((< x1 x2) (cons x1
                                 (union-ordered-list (cdr list1) list2)))
                ((< x2 x1) (cons x2
                                 (union-ordered-list list1 (cdr list2))))))))
  (list->tree (union-ordered-list (tree->list-2 set1)
                                  (tree->list-2 set2))))

(define (intersection-set set1 set2)
  (define (intersection-ordered-list list1 list2)
    (if (or (null? list1) (null? list2))
        '()
        (let ((x1 (car list1)) (x2 (car list2)))
          (cond ((= x1 x2) (cons x1
                                 (intersection-ordered-list (cdr list1) (cdr list2))))
                ((< x1 x2) (intersection-ordered-list (cdr list1) list2))
                ((< x2 x1) (intersection-ordered-list list1 (cdr list2)))))))
  (list->tree (intersection-ordered-list (tree->list-2 set1)
                                         (tree->list-2 set2))))

(define set-1 (make-tree 5
                         (make-tree 3
                                    (make-tree 1 '() '())
                                    '())
                         (make-tree 7
                                    '()
                                    (make-tree 9 '() '()))))
(define set-2 (make-tree 6
                         (make-tree 4
                                    (make-tree 2 '() '())
                                    '())
                         (make-tree 8
                                    '()
                                    (make-tree 10 '() '()))))
(define set-3 (make-tree 5
                         (make-tree 2
                                    (make-tree 1 '() '())
                                    (make-tree 3
                                               '()
                                               (make-tree 4 '() '())))
                         (make-tree 8
                                    (make-tree 7
                                               (make-tree 6 '() '())
                                               '())
                                    (make-tree 9
                                               '()
                                               (make-tree 10 '() '())))))

(union-set set-1 set-2)
(union-set set-1 set-3)
(union-set set-2 set-3)
(intersection-set set-1 set-2)
(intersection-set set-1 set-3)
(intersection-set set-2 set-3)
