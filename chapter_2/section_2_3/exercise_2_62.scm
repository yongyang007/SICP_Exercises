(define (union-set set1 set2)
  (if (or (null? set1) (null? set2))
      (if (null? set2) set1 set2)
      (let ((x1 (car set1)) (x2 (car set2)))
        (cond ((= x1 x2)
               (cons x1
                     (union-set (cdr set1) (cdr set2))))
              ((< x1 x2)
               (cons x1
                     (union-set (cdr set1) set2)))
              ((< x2 x1)
               (cons x2
                     (union-set set1 (cdr set2))))))))

(union-set '() '())
(union-set '() '(1 2 3))
(union-set '(1 2 3) '())
(union-set '(1 3 5) '(2 3 6))
(union-set '(1 3 5) '(2 4 6))
(union-set '(1 3 6 7) '(2 4 5 8))
