(add-load-path "./")
(load "exercise_4_6.scm")

(define (named-let? exp) (and (let? exp) (symbol? (cadr exp))))

(define (let-var exp) (if (named-let? exp) (cadr exp) #f))
(define (let-parameters exp) (map car ((if (named-let? exp) caddr cadr) exp)))
(define (let-arguments exp) (map cadr ((if (named-let? exp) caddr cadr) exp)))
(define (let-body exp) ((if (named-let? exp) cdddr cddr) exp))

(define (make-definition variable value)
  (list 'define variable value))

(define (let->combination exp)
  (let ((l (make-lambda
            (let-parameters exp)
            (let-body exp)))
        (v (let-var exp))
        (a (let-arguments exp)))
    (if v
        (make-begin (list (make-definition v l) (cons v a)))
        (cons l a))))

(let->combination test-exp)
(define test-exp1 '(let <var> ((<var1> <exp1>) (<var2> <exp2>)) <body>))
(let->combination test-exp1)
;; => (begin (define <var> (lambda (<var1> <var2>) <body>)) (<var> <exp1> <exp2>))
