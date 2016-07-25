(add-load-path "./")
(load "exercise_2_78.scm")

(equ? 6 6)
(equ? 6 9)

(define r1 (make-rational 2 3))
(define r2 (make-rational 3 2))
(define r3 (make-rational 9 6))
(equ? r1 r1)
(equ? r1 r2)
(equ? r2 r3)

(define c1 (make-complex-from-real-imag 1 2))
(define c2 (make-complex-from-real-imag 2 1))
(define c3 (make-complex-from-mag-ang 3 4))
(define c4 (make-complex-from-mag-ang 4 3))
(define c5 (make-complex-from-mag-ang (sqrt (+ (square 1) (square 2)))
                                      (atan 2 1)))
(equ? c2 c2)
(equ? c1 c2)
(equ? c3 c3)
(equ? c3 c4)

(equ? c1 c5)
(real-part c5)
(imag-part c5)
;; 因为两种定义方式的复数间有误差，所以这个判断有可能不为真
