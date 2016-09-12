(define (has-cycle? x)
  (define (inner l)
    (cond ((null? l) #f)
          ((memq (car l) x) #t)
          (else (inner (cdr l)))))
  (inner x))

(add-load-path "./")
(load "exercise_3_13.scm")

(define l1 (list 1 2 3))
(define l2 (make-cycle (list 1 2 3)))

(has-cycle? l1)
(has-cycle? l2)
