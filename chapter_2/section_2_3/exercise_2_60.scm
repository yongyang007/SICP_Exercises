(define (element-of-set? x set)
  (cond ((null? set) #f)
        ((equal? x (car set)) #t)
        (else (element-of-set? x (cdr set)))))

(define (adjoin-set x set) (cons x set))

(define (intersection-set set1 set2)
  (cond ((or (null? set1) (null? set2)) '())
        ((element-of-set? (car set1) set2)
         (cons (car set1) (intersection-set (cdr set1) set2)))
        (else (intersection-set (cdr set1) set2))))

(define (union-set set1 set2) (append set1 set2))

(element-of-set? 2 '(7 6 2 3 6 2 7))
(adjoin-set 2 '(2 3 2))
(intersection-set '(2 3 4) '(3 1 2 2 3))
(intersection-set '(3 1 2 2 3) '(2 3 4))
(union-set '(1 2 2 3) '(2 2 3))


                                        ;可以看到element-of-set?和intersection-set和无重复时定义时一样的
                                        ;adjoin-set步数的增长的阶由Θ(n)降到了Θ(1)
                                        ;而union-set的则由Θ(n^2)降到了Θ(n)
                                        ;但是由此损失了一些空间
                                        ;这种允许重复的表示方法比较适合于大量使用adjoin-set和union-set这两个方法的应用
