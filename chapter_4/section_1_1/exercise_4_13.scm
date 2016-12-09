;; make-unbound!的规范应该和set!的情况类似：
;; 在当前环境中寻找需要消除的约束，
;; 如果找到了就消除，如果没找到就继续在其它外围环境寻找，
;; 当遇到空环境时发出一个“未约束变量”的错误信号

(add-load-path "./")
(load "exercise_4_13.scm")

(define (remove-binding-in-frame! var frame)
  (define (scan vars vals)
    (cond ((null? (cdr vars))
           #f)
          ((eq? var (cadr vars))
           (set-cdr! vars (cddr vars))
           (set-cdr! vals (cddr vals)))
          (else (scan (cdr vars) (cdr vals)))))
  (let ((variables (frame-variables frame))
        (values (frame-values frame)))
    (if (eq? var (car variables))
        (begin
          (set-car! frame (cdr variables))
          (set-cdr! frame (cdr values)))
        (scan variables
              values))))

(define (remove-variable! var env)
  (define (env-loop env)
    (if (eq? env the-empty-environment)
        (error "Unbound variable -- MAKE-UNBOUND!" var)
        (let ((frame (first-frame env)))
          (if (frame-binding var frame)
              (remove-binding-in-frame! var frame)
              (env-loop (enclosing-environment env))))))
  (env-loop env))

;; test
(lookup-variable-value 'a env2) ;; => 9
(remove-variable! 'a env2)
(lookup-variable-value 'a env2) ;; => 10
(remove-variable! 'a env2)
(lookup-variable-value 'a env2) ;; => 1
(remove-variable! 'a env2)
(lookup-variable-value 'a env2) ;; => error

(lookup-variable-value 'e env2) ;; => 4
(remove-variable! 'e env2)
(lookup-variable-value 'e env2) ;; => error
(remove-variable! 'e env2) ;; => error

;; 再把这个remove方法实装到eval中
(define (unbound? exp)
  (tagged-list? exp 'make-unbound!))
(define (unbound-variable exp) (cadr exp))
(define (eval-unbound exp env)
  (remove-variable! (unbound-variable exp)
                    env)
  'ok)
;; 最后在eval中加入
;; ((unbound? exp) (eval-unbound exp env))
