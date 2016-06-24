(add-load-path "./")
(load "symbolic_differentiation.scm")

                                        ;a
(define (make-sum a1 a2)
  (cond ((=number? a1 0) a2)
        ((=number? a2 0) a1)
        ((and (number? a1) (number? a2)) (+ a1 a2))
        (else (list a1 '+ a2))))

(define (addend s) (car s))

(define (sum? x)
  (and (pair? x) (eq? '+ (cadr x))))

(define (make-product m1 m2)
  (cond ((or (=number? m1 0) (=number? m2 0)) 0)
        ((=number? m1 1) m2)
        ((=number? m2 1) m1)
        ((and (number? m1) (number? m2)) (* m1 m2))
        (else (list m1 '* m2))))

(define (multiplier p) (car p))

(define (product? x)
  (and (pair? x) (eq? '* (cadr x))))

(deriv '(x + (3 * (x + (y + 2)))) 'x)

                                        ;b
(define (sum? x)
  (if (eq? #f (memq '+ x))
      #f
      #t))

(define (simplify-item i)
  (if (null? (cdr i))
      (car i)
      i))

(define (addend s)
  (define (iter result e)
    (if (same-variable? '+ (car e))
        result
        (iter (append result (list (car e))) (cdr e))))
  (simplify-item (iter '() s)))

(define (augend s)
  (define (iter e)
    (if (same-variable? '+ (car e))
        (cdr e)
        (iter (cdr e))))
  (simplify-item (iter s)))

(define (multiplicand p)
  (simplify-item (cddr p)))

(deriv '(x + 3 * (x + y + 2)) 'x)
(deriv '(3 * (x + y + 2) + x) 'x)
