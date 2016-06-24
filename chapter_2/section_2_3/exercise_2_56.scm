(add-load-path "./")
(load "symbolic_differentiation.scm")

(define (make-exponentiation b e)
  (cond ((=number? e 0) 1)
        ((=number? e 1) b)
        ((and (number? b) (number? e)) (expt b e))
        (else (list '** b e))))

(define (base e) (cadr e))

(define (exponent e) (caddr e))

(define (exponentiation? e)
  (and (pair? e) (eq? '** (car e))))

(define (deriv exp var)
  (cond ((number? exp) 0)
        ((variable? exp)
         (if (same-variable? exp var) 1 0))
        ((sum? exp)
         (make-sum (deriv (addend exp) var)
                   (deriv (augend exp) var)))
        ((product? exp)
         (make-sum
          (make-product (multiplier exp)
                        (deriv (multiplicand exp) var))
          (make-product (deriv (multiplier exp) var)
                        (multiplicand exp))))
        ((exponentiation? exp)
         (let ((b (base exp))
               (e (exponent exp)))
           (make-product
            (make-product e
                          (make-exponentiation b
                                               (make-sum e -1)))
            (deriv b var))))
        (else
         (error "unknown expression type -- DERIV" exp))))

(deriv '(** (* x y) 2) 'x)
(deriv '(+ (* a (** x 2)) (* b x)) 'x)
(deriv '(+ (+ (* a (** x 2)) (* b x)) c) 'x)
