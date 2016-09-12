(define (has-cycle? x)
  (define (iter checked uncheck)
    (cond ((null? uncheck) #f)
          ((memq (car uncheck) checked) #t)
          (else (iter (cons (car uncheck) checked) (cdr uncheck)))))
  (iter '() x))

(add-load-path "./")
(load "exercise_3_13.scm")

(define l1 (list 1 2 3))
(define l2 (make-cycle (list 1 2 3)))

(has-cycle? l1)
(has-cycle? l2)
