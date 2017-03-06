(add-load-path "./")
(load "metacircular_evaluator.scm")

(define true #t)
(define false #f)

(eval '(define x 3) (interaction-environment))
;; *** ERROR: unbound variable: define-variable!

(define (eval exp env)
  (cond ((self-evaluating? exp) exp)
        ((variable? exp) (lookup-variable-value exp env))
        ((quoted? exp) (text-of-quotation exp))
        ((application? exp)
         (apply (eval (operator exp) env)
                (list-of-values (operands exp) env)))
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
        (else
         (error "Unknown expression type -- EVAL" exp))))

(eval '(define x 3) (interaction-environment))
;; *** ERROR: unbound variable: lookup-variable-value

;; a)
;; 虽然现阶段求值器的核心还没有完成，但通过修改eval内cond子句位置前后所报的错误我们就应该已经能看出问题所在了：
;; 修改之前因为还没有定义define-varibale!而报错，证明define已经执行了；
;; 修改之后因为没有定义lookup-variable-value而报错，说明求值器已经开始寻找x的值了，
;; 这样就算是完整的求值器，也会在之后因为在环境中找不到x（x还未定义）或者找到x后（x已被定义）找不到define而出错。
;; 这是因为对于原来的求值器来说，处理基本表达式和特殊形式外，所有的应用都是过程应用，
;; 而把有关过程应用的子句放到有关赋值的子句之前，就相当于把define和set!也降级到过程应用中去了，而环境中有没有这些过程的定义，所以出错。

;; b)
(define (application? exp) (tagged-list? exp 'call))
(define (operator exp) (cadr exp))
(define (operands exp) (cddr exp))

(eval '(define x 3) (interaction-environment))
(eval '(call + 1 2) (interaction-environment))
