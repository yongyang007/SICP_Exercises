;; a)
(define (lookup-variable-value var env)
  (define (env-loop env)
    (if (eq? env the-empty-environment)
        (error "Unbound variable" var)
        (let ((binding (frame-binding var (first-frame env))))
          (if binding
              (let ((value (binding-value binding)))
                (if (eq? value '*unassigned*)
                    (error "Unassigned variable" var)
                    value))
              (env-loop (enclosing-environment env))))))
  (env-loop env))

;; b)
(define (scan-out-defines proc-body)
  (let ((definitions (filter definition? proc-body)))
    (if (null? definitions)
        proc-body
        (let ((body (filter (lambda (b) (not (definition? b)))
                            proc-body)))
          (list
           (make-let (map (lambda (definition)
                            (list (definition-variable definition)
                                  ''*unassigned*))
                          definitions)
                     (append
                      (map (lambda (definition)
                             (list 'set!
                                   (definition-variable definition)
                                   (definition-value definition)))
                           definitions)
                      body)))))))

;; c)
;; 实装进make-procedure中更好，这样只需要在创建procedure时转换一次
;; 当然理论上在procedure-body中调用也是可以的，
;; 就像前面提到的那个有理数化简的问题
