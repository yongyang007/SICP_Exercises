(add-load-path "../../tool/")
(load "accumulate.scm")

(define (count-leaves t)
  (accumulate +
              0
              (map (lambda (x)
                     (cond ((null? x) 0)
                           ((not (pair? x)) 1)
                           (else (count-leaves x))))
                   t)))

(count-leaves (list 1 (list 2 3 4) 5 (list 6 (list 7 8 (list 9)) 10) 11))
