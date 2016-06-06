(add-load-path "./")
(load "fixed_point.scm")
                                        ;重新定义打印序列版的fixed-point
(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) toterance))
  (define (try guess n)
    (define (print x count)
      (display count)
      (display " -> ")
      (display x)
      (newline))
    (print guess n)
    (let ((next (f guess)))
      (if (close-enough? guess next)
          next
          (try next (+ n 1)))))
  (try first-guess 1))

(fixed-point (lambda (x) (/ (log 1000) (log x))) 1.1)

(load "average_damp.scm")
(fixed-point (average-damp (lambda (x) (/ (log 1000) (log x)))) 1.1)
