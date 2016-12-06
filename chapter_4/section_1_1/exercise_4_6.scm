(define (let? exp) (tagged-list? exp 'let))

(define (let-parameters exp) (map car (cadr exp)))
(define (let-arguments exp) (map cadr (cadr exp)))
(define (let-body exp) (caddr exp))

(define (let->combination exp)
  (cons (make-lambda
         (let-parameters exp)
         (let-body exp))
        (let-arguments exp)))

(define (eval exp env)
  (cond ((self-evaluating? exp) exp)
        ((variable? exp) (lookup-variable-value exp env))
        ((quoted? exp) (text-of-quotation exp))
        ((assignment? exp) (eval-assignment exp env))
        ((definition? exp) (eval-definition exp env))
        ((if? exp) (eval-if exp env))
        ((lambda? exp)
         (make-procedure (lambda-parameters exp)
                         (lambda-body exp)
                         env))
        ((begin? exp)
         (eval-sequence (begin-actions exp) env))
        ((cond? exp) (eval (cond->if exp) env))
        ((let? exp) (eval (let->combination exp) env))
        ((application? exp)
         (apply (eval (operator exp) env)
                (list-of-values (operands exp) env)))
        (else
         (error "Unknown expression type -- EVAL" exp))))

;; test
(add-load-path "./")
(load "metacircular_evaluator.scm")

(define test-exp '(let ((<var1> <exp1>) (<var2> <exp2>)) <body>))
(let->combination test-exp)
;; => ((lambda (<var1> <var2>) . <body>) <exp1> <exp2>)
