(define (compose f g)
  (lambda (x) (f (g x))))

(add-load-path "./")
(add-load-path "../../tool/")
(load "square.scm")
(load "exercise_1_41.scm")

((compose square inc) 6)
