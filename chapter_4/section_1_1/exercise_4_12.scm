(add-load-path "./")
(load "metacircular_evaluator.scm")

(define (frame-binding var frame)
  (define (scan vars vals)
    (cond ((null? vars)
           #f)
          ((eq? var (car vars))
           (cons var (car vals)))
          (else (scan (cdr vars) (cdr vals)))))
  (scan (frame-variables frame)
        (frame-values frame)))

(define (binding-value binding) (cdr binding))

(define (set-binding-in-frame! var val frame)
  (define (scan vars vals)
    (cond ((null? vars)
           #f)
          ((eq? var (car vars))
           (set-car! vals val))
          (else (scan (cdr vars) (cdr vals)))))
  (scan (frame-variables frame)
        (frame-values frame)))

(define (lookup-variable-value var env)
  (define (env-loop env)
    (if (eq? env the-empty-environment)
        (error "Unbound variable" var)
        (let ((binding (frame-binding var (first-frame env))))
          (if binding
              (binding-value binding)
              (env-loop (enclosing-environment env))))))
  (env-loop env))

(define (set-variable-value! var val env)
  (define (env-loop env)
    (if (eq? env the-empty-environment)
        (error "Unbound variable -- SET!" var)
        (let ((frame (first-frame env)))
          (if (frame-binding var frame)
              (set-binding-in-frame! var val frame)
              (env-loop (enclosing-environment env))))))
  (env-loop env))

(define (define-variable! var val env)
  (let ((frame (first-frame env)))
    (if (frame-binding var frame)
        (set-binding-in-frame! var val frame)
        (add-binding-to-frame! var val frame))))

;; test
(define env0 (extend-environment '(a b c) '(1 2 3) the-empty-environment))
(define env1 (extend-environment '(e f) '(4 5) env0))
(define env2 (extend-environment '(a g) '(6 7) env1))
(define env3 (extend-environment '(a g) '(6 7 8) env1)) ;; => error

(lookup-variable-value 'f env2)
(lookup-variable-value 'a env2)
(lookup-variable-value 'a env1)
(lookup-variable-value 'h env2) ;; => error

(set-variable-value! 'a 9 env2)
(lookup-variable-value 'a env2)
(set-variable-value! 'h 9 env2) ;; => error

(define-variable! 'a 10 env1)
(lookup-variable-value 'a env1)
(define-variable! 'h 10 env1)
(lookup-variable-value 'h env2)
