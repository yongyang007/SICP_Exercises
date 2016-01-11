(load "./newton_s_method_square_root_1.scm")

(define (sqrt-iter guess x)
  (if (good-enough? guess (improve guess x))
      (improve guess x)
      (sqrt-iter (improve guess x)
                 x)))
(define (good-enough? old-guess new-guess)
  (< (abs (- 1.0 (/ old-guess new-guess))) 0.001))
