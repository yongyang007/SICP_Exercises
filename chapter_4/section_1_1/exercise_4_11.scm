(define (enclosing-environment env) (cdr env))
(define (first-frame env) (car env))
(define the-empty-environment '())

;; the part of rewriting
(define (make-frame variables values)
  (cons 'bindings (map cons variables values)))
(define (frame-bindings frame) (cdr frame))
(define (add-binding-to-frame! var val frame)
  (set-cdr! frame (cons (cons var val) (cdr frame))))

(define (extend-environment vars vals base-env)
  (if (= (length vars) (length vals))
      (cons (make-frame vars vals) base-env)
      (if (< (length vars) (length vals))
          (error "Too many arguments supplied" vars vals)
          (error "Too few arguments supplied" vars vals))))

;; the part of rewriting
(define (lookup-variable-value var env)
  (define (env-loop env)
    (define (scan bindings)
      (cond ((null? bindings)
             (env-loop (enclosing-environment env)))
            ((eq? var (caar bindings))
             (cdar bindings))
            (else (scan (cdr bindings)))))
    (if (eq? env the-empty-environment)
        (error "Unbound variable" var)
        (let ((frame (first-frame env)))
          (scan (frame-bindings frame)))))
  (env-loop env))

(define (set-variable-value! var val env)
  (define (env-loop env)
    (define (scan bindings)
      (cond ((null? bindings)
             (env-loop (enclosing-environment env)))
            ((eq? var (caar bindings))
             (set-cdr! (car bindings) val))
            (else (scan (cdr bindings)))))
    (if (eq? env the-empty-environment)
        (error "Unbound variable -- SET!" var)
        (let ((frame (first-frame env)))
          (scan (frame-bindings frame)))))
  (env-loop env))

(define (define-variable! var val env)
  (let ((frame (first-frame env)))
    (define (scan bindings)
      (cond ((null? bindings)
             (add-binding-to-frame! var val frame))
            ((eq? var (caar bindings))
             (set-cdr! (car bindings) val))
            (else (scan (cdr bindings)))))
    (scan (frame-bindings frame))))

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
