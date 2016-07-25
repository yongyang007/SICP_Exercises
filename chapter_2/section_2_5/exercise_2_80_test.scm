(add-load-path "./")
(load "exercise_2_78.scm")

(=zero? 0)
(=zero? 1)

(define r1 (make-rational 0 1))
(define r2 (make-rational 3 3))
(=zero? r1)
(=zero? r2)

(define c1 (make-complex-from-real-imag 0 0))
(define c2 (make-complex-from-real-imag 4 5))
(define c3 (make-complex-from-mag-ang 0 10))
(define c4 (make-complex-from-mag-ang 10 0))
(=zero? c1)
(=zero? c2)
(=zero? c3)
(=zero? c4)
