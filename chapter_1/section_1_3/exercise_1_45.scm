(load "./fixed_point.scm")
(load "./average_damp.scm")
(load "./exercise_1_43.scm")
(load "../../tool/expt.scm")

(define (damp-nth-root n damp-times)
  (lambda (x) (fixed-point
               ((repeated average-damp damp-times)
                (lambda (y) (/ x (expt y (- n 1)))))
               1.0)))
                                        ;平方根
((damp-nth-root 2 1) 4)
                                        ;立方根
((damp-nth-root 3 1) 8)
                                        ;四次方根
((damp-nth-root 4 2) 16)
                                        ;八次方跟
((damp-nth-root 8 3) 256)
                                        ;十六次方根
((damp-nth-root 16 4) 66536)
                                        ;可以看出需要平均阻尼的次数至少为(/ (log n) (log 2))向下取整
(define (nth-root n)
  (damp-nth-root n
                 (floor (/ (log n)
                           (log 2)))))

((nth-root 10) 1024)
((nth-root 15) (expt 3 15))
