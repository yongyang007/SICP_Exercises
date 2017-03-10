;; 如果eval在把运算符传给apply之前没有force求出运算符的值，
;; 那么传给apply的将有可能是一个thunk，
;; 这时apply将不能识别它，来看下面的例子：
(add-load-path "./")
(load "lazy_evaluator.scm")

(driver-loop)

(define (foo x) (+ x 1))
(foo 2)
;; => 3
(define (hoge proc) (proc 10))
(hoge foo)
;; => 11

(exit)

;; 如果在调用apply之前不force出运算符的值：
(define (eval exp env)
  (cond ((self-evaluating? exp) exp)
        ((variable? exp) (lookup-variable-value exp env))
        ((get 'eval (operator exp))
         ((get 'eval (operator exp)) exp env))
        ((application? exp)
         (apply (eval (operator exp) env)  ;; changed
                (operands exp)
                env))
        (else
         (error "Unknown expression type -- EVAL" exp))))
(driver-loop)

(define (foo x) (+ x 1))
(foo 2)
;; => 3
(define (hoge proc) (proc 10))
(hoge foo)
;; => *** ERROR: Unknown procedure type -- APPLY (trunk foo ...

;; 这里的foo因为是被作为参数传入的，
;; 如果没有force出它的值就直接传到apply中,
;; apply将不能处理
