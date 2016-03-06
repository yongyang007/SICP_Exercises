(define (compose f g)
  (lambda (x) (f (g x))))

(load "../../tool/square.scm")
(load "./exercise_1_41.scm")

((compose square inc) 6)
