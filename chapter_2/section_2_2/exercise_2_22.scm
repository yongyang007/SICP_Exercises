(load "./exercise_2_21.scm")

(define (square-list items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things)
              (cons (square (car things))
                    answer))))
  (iter items '()))

(square-list (list 1 2 3 4))
                                        ;这种迭代的计算过程，先从源list中首端出来的元素经过计算后会先进入目标list的底端,
                                        ;所以得到结果的顺序是反的

(define (square-list items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things)
              (cons answer
                    (square (car things))))))
  (iter items '()))

(square-list (list 1 2 3 4))
                                        ;而这种修改方法，每次都是把一个list放在序对的前面，
                                        ;得到的是(...((((), 1), 2), 3)...n)这种形式的结果，并不是list
