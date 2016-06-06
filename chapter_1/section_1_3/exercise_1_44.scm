(define (smooth f)
  (define (average a b c) (/ (+ a b c) 3))
  (define dx 0.00001)
  (lambda (x) (average (f (- x dx))
                      (f x)
                      (f (+ x dx)))))

(add-load-path "./")
(load "exercise_1_43.scm")

(define (smooth-n-times f n)
  ((repeated smooth n) f))
