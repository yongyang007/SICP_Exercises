(add-load-path "./")
(load "constraint_system.scm")

(define (averager a b c)
  (let ((sum (make-connector))
        (coef (make-connector)))
    (adder a b sum)
    (multiplier coef c sum)
    (constant 2 coef)
    'ok))

(define a (make-connector))
(define b (make-connector))
(define c (make-connector))

(averager a b c)

(probe "a" a)
(probe "b" b)
(probe "c" c)

(set-value! a 1 'user)
(set-value! b 2 'user)
(set-value! c 4 'user)
(forget-value! a 'user)
(set-value! c 4 'user)
