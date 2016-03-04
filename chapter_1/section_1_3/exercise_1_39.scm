load "../../tool/square.scm")
(load "./exercise_1_37.scm")

(define (tan-cf x k)
  (/ (cont-frac (lambda (i) (- (square x)))
                (lambda (i) (- (* 2 i) 1))
                k)
     (* x -1.0)))

(tan 10)
(tan-cf 10 100)

(tan 25)
(tan-cf 25 100)
