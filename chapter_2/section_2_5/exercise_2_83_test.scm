(add-load-path "./")
(load "generic_arithmetic_system.scm")

;; integer and real package test
(define int-1 (make-integer 1))
(define int-2 (make-integer 2.2))
(define int-3 (make-integer 2.5))
(add int-1 int-2)
(sub int-3 int-1)
(mul int-2 int-3)
(div int-3 int-2)

(define real-1 (make-real 1))
(define real-2 (make-real 2.2))
(define real-3 (make-real 3.6))
(add real-1 real-2)
(sub real-3 real-2)
(mul real-2 real-3)
(div real-3 real-2)

(define rational-1 (make-rational 3 6))
(define complex-1 (make-complex-from-real-imag 2 3))

;; raise test
(raise int-1)
(raise rational-1)
(raise real-1)
(raise complex-1)

(raise (raise (raise int-3)))
