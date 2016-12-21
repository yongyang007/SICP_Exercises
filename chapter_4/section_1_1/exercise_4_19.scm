(add-load-path "./")
(load "metacircular_evaluator.scm")

(driver-loop)

(let ((a 1))
  (define (f x)
    (define b (+ a x))
    (define a 5)
    (+ a b))
  (f 10))

;; 正如书中脚标所说：Eva的观点从原则上说是正确的；
;; 但所实现的解释器执行的结果是Alyssa所说的返回一个错误；
;; 而Ben的想法最不正确，它有违了内部定义的定义，即a和b应该是同时被定义的。

;; 要实现Eve的行为，我觉得在实现内部定义时要用到delay和force这中延时求值的操作

(put 'eval 'delay
     (lambda (exp env)
       (eval (make-lambda '() (cdr exp)) env)))
(put 'eval 'force
     (lambda (exp env)
       (eval (list (cadr exp)) env)))

(define (delay-value value) (list 'delay value))
(define (force-values-in-body body delayed-variables)
  (cond ((null? body) '())
        ((self-evaluating? body) body)
        ((variable? body)
         (if (memq body delayed-variables)
             (list 'force body)
             body))
        ((pair? body)
         (cons (force-values-in-body (car body) delayed-variables)
               (force-values-in-body (cdr body) delayed-variables)))))

(define (scan-out-defines proc-body)
  (let ((definitions (filter definition? proc-body)))
    (if (null? definitions)
        proc-body
        (let ((body (filter (lambda (b) (not (definition? b)))
                            proc-body))
              (variables (map definition-variable definitions))
              (values (map definition-value definitions)))
          (list
           (make-let (map (lambda (variable)
                            (list variable ''*unassigned*))
                          variables)
                     (append
                      (map (lambda (variable value)
                             (list 'set!
                                   variable
                                   (delay-value (force-values-in-body
                                                 value
                                                 variables))))
                           variables
                           values)
                      (force-values-in-body body variables))))))))

(driver-loop)

(let ((a 1))
  (define (f x)
    (define b (+ a x))
    (define a 5)
    (+ a b))
  (f 10))
