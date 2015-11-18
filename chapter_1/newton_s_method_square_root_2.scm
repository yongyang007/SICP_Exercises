(load "./newton_s_method_square_root_1.scm")

(define (sqrt-iter old-guess new-guess x)
  (if (good-enough? old-guess new-guess)
      new-guess
      (sqrt-iter new-guess
                 (improve new-guess x)
                 x)))
(define (good-enough? old-guess new-guess)
  (< (abs (- 1.0 (/ old-guess new-guess))) 0.001))
(define (sqrt x)
  (sqrt-iter 1.0 (* 1.0 x) x))
