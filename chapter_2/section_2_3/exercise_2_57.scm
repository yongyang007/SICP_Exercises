(add-load-path "./")
(load "symbolic_differentiation.scm")

(define (augend s)
  (let ((a2 (cddr s)))
    (if (null? (cdr a2))
        (car a2)
        (cons '+ a2))))

(define (multiplicand p)
  (let ((m2 (cddr p)))
    (if (null? (cdr m2))
        (car m2)
        (cons '* m2))))

(deriv '(* x y (+ x 3)) 'x)
(deriv '(* (* x y) (+ x 3)) 'x)
(deriv '(* x (* y (+ x 3))) 'x)
