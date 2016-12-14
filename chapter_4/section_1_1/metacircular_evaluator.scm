(define true #t)
(define false #f)
(define apply-in-underly-scheme apply) ;; alias

;; define put and get
(define (make-table)
  (let ((local-table (list "*table*")))
    (define (assoc key records)
      (cond ((null? records) #f)
            ((eq? key (caar records))
             (car records))
            (else (assoc key (cdr records)))))
    (define (look-up key-1 key-2)
      (let ((sub-table (assoc key-1 (cdr local-table))))
        (if sub-table
            (let ((record (assoc key-2 (cdr sub-table))))
              (if record
                  (cdr record)
                  #f))
            #f)))
    (define (insert! key-1 key-2 value)
      (let ((sub-table (assoc key-1 (cdr local-table))))
        (if sub-table
            (let ((record (assoc key-2 (cdr sub-table))))
              (if record
                  (set-cdr! record value)
                  (set-cdr! sub-table
                            (cons (cons key-2 value)
                                  (cdr sub-table)))))
            (set-cdr! local-table
                      (cons (list key-1 (cons key-2 value))
                            (cdr local-table))))
        'ok))
    (define (dispatch m)
      (cond ((eq? m 'look-up-proc) look-up)
            ((eq? m 'insert!-proc) insert!)
            (else (error "Unknown operation -- TABLE" m))))
    dispatch))

(define operation-table (make-table))
(define put (operation-table 'insert!-proc))
(define get (operation-table 'look-up-proc))

;; the core of the evaluator
(define (apply procedure arguments)
  (cond ((primitive-procedure? procedure)
         (apply-primitive-procedure procedure arguments))
        ((compound-procedure? procedure)
         (eval-sequence
          (procedure-body procedure)
          (extend-environment
           (procedure-parameters procedure)
           arguments
           (procedure-environment procedure))))
        (else
         (error
          "Unknown procedure type -- APPLY" procedure))))

(define (list-of-values exps env)
  (if (no-operand? exps)
      '()
      (cons (eval (first-operand exps) env)
            (list-of-values (rest-operands exps) env))))

(define (eval-if exp env)
  (if (true? (eval (if-predicate exp) env))
      (eval (if-consequent exp) env)
      (eval (if-alternative exp) env)))

(define (eval-sequence exps env)
  (cond ((last-exp? exps) (eval (first-exp exps) env))
        (else (eval (first-exp exps) env)
              (eval-sequence (rest-exps exps) env))))

(define (eval-assignment exp env)
  (set-variable-value! (assignment-variable exp)
                       (eval (assignment-value exp) evn)
                       evn)
  'ok)

(define (eval-definition exp env)
  (define-variable! (definition-variable exp)
                    (eval (definition-value exp) env)
                    env)
  'ok)

;; representing expressions
(define (self-evaluating? exp)
  (cond ((number? exp) true)
        ((string? exp) true)
        (else false)))

(define (variable? exp) (symbol? exp))

(define (quoted? exp)
  (tagged-list? exp 'quote))

(define (text-of-quotation exp) (cadr exp))

(define (tagged-list? exp tag)
  (if (pair? exp)
      (eq? (car exp) tag)
      false))

(define (assignment? exp)
  (tagged-list? exp 'set!))
(define (assignment-variable exp) (cadr exp))
(define (assignment-value exp) (caddr exp))

(define (definition? exp)
  (tagged-list? exp 'define))
(define (definition-variable exp)
  (if (symbol? (cadr exp))
      (cadr exp)
      (caadr exp)))
(define (definition-value exp)
  (if (symbol? (cadr exp))
      (caddr exp)
      (make-lambda (cdadr exp)   ; formal parameters
                   (cddr exp)))) ; body

(define (lambda? exp) (tagged-list? exp 'lambda))
(define (lambda-parameters exp) (cadr exp))
(define (lambda-body exp) (cddr exp))

(define (make-lambda parameters body)
  (cons 'lambda (cons parameters body)))

(define (if? exp) (tagged-list? exp 'if))
(define (if-predicate exp) (cadr exp))
(define (if-consequent exp) (caddr exp))
(define (if-alternative exp)
  (if (not (null? (cdddr exp)))
      (cadddr exp)
      'false))

(define (make-if predicate consequent alternative)
  (list 'if predicate consequent alternative))

(define (begin? exp) (tagged-list? exp 'begin))
(define (begin-actions exp) (cdr exp))
(define (last-exp? seq) (null? (cdr seq)))
(define (first-exp seq) (car seq))
(define (rest-exps seq) (cdr seq))

(define (sequence->exp seq)
  (cond ((null? seq) seq)
        ((last-exp? seq) (first-exp seq))
        (else (make-begin seq))))
(define (make-begin seq) (cons 'begin seq))

(define (application? exp) (pair? exp))
(define (operator exp) (car exp))
(define (operands exp) (cdr exp))
(define (no-operand? ops) (null? ops))
(define (first-operand ops) (car ops))
(define (rest-operands ops) (cdr ops))

(define (cond? exp) (tagged-list? exp 'cond))
(define (cond-clauses exp) (cdr exp))
(define (cond-else-clause? clause)
  (eq? (cond-predicate clause) 'else))
(define (cond-predicate clause) (car clause))
(define (cond-actions clause) (cdr clause))
(define (cond->if exp)
  (expand-clauses (cond-clauses exp)))

;; modify the expand-clauses to allow the syntax (<test> => <recipient>) for cond clauses
(define (expand-clauses clauses)
  (if (null? clauses)
      'false                           ; no else clause
      (let ((first (car clauses))
            (rest (cdr clauses)))
        (if (cond-else-clause? first)
            (if (null? rest)
                (sequence->exp (cond-actions first))
                (error "ELSE clause isn't last -- COND->IF"
                       clause))
            (let ((predicate (cond-predicate first))
                  (actions (cond-actions first)))
              (make-if predicate
                       (if (and (tagged-list? actions '=>)
                                (null? (cddr actions)))
                           (list (cadr actions) predicate)
                           (sequence->exp actions))
                       (expand-clauses rest)))))))

;; make-unbound!
(define (unbound? exp)
  (tagged-list? exp 'make-unbound!))
(define (unbound-variable exp) (cadr exp))
(define (eval-unbound exp env)
  (remove-variable! (unbound-variable exp)
                    env)
  'ok)

;; evaluator data structures
(define (true? x)
  (not (eq? x false)))
(define (false? x)
  (eq? x false))

(define (make-procedure parameters body env)
  (list 'procedure parameters body env))
(define (compound-procedure? p)
  (tagged-list? p 'procedure))
(define (procedure-parameters p) (cadr p))
(define (procedure-body p) (caddr p))
(define (procedure-environment p) (cadddr p))

(define (enclosing-environment env) (cdr env))
(define (first-frame env) (car env))
(define the-empty-environment '())

(define (make-frame variables values)
  (cons variables values))
(define (frame-variables frame) (car frame))
(define (frame-values frame) (cdr frame))
(define (add-binding-to-frame! var val frame)
  (set-car! frame (cons var (car frame)))
  (set-cdr! frame (cons val (cdr frame))))

(define (extend-environment vars vals base-env)
  (if (= (length vars) (length vals))
      (cons (make-frame vars vals) base-env)
      (if (< (length vars) (length vals))
          (error "Too many arguments supplied" vars vals)
          (error "Too few arguments supplied" vars vals))))

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

;; make-unbound!
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

;; running the evaluator as a program
(define primitive-procedures
  (list (list 'car car)
        (list 'cdr cdr)
        (list 'cons cons)
        (list 'null? null?)
        (list 'eq? eq?)
        (list 'equal? equal?)
        (list '= =)
        (list '+ +)
        (list '- -)
        (list '* *)
        (list '/ /)
        ;; <more primitives>
        ))
(define (primitive-procedure-names)
  (map car
       primitive-procedures))
(define (primitive-procedure-objects)
  (map (lambda (proc) (list 'primitive (cadr proc)))
       primitive-procedures))

(define (setup-environment)
  (let ((initial-env
         (extend-environment (primitive-procedure-names)
                             (primitive-procedure-objects)
                             the-empty-environment)))
    (define-variable! 'true true initial-env)
    (define-variable! 'false false initial-env)
    initial-env))
(define the-global-environment (setup-environment))

(define (primitive-procedure? proc)
  (tagged-list? proc 'primitive))

(define (primitive-implementation proc) (cadr proc))

(define (apply-primitive-procedure proc args)
  (apply-in-underly-scheme
   (primitive-implementation proc) args))

(define input-prompt ";;; M-Eval imput:")
(define output-prompt ";;; M-Eval value:")
(define (driver-loop)
  (prompt-for-input input-prompt)
  (let ((input (read)))
    (let ((output (eval input the-global-environment)))
      (announce-output output-prompt)
      (user-print output)))
  (driver-loop))
(define (prompt-for-input string)
  (newline) (newline) (display string) (newline))
(define (announce-output string)
  (newline) (display string) (newline))

(define (user-print object)
  (if (compound-procedure? object)
      (display (list 'compound-procedure
                     (procedure-parameters object)
                     (procedure-body object)
                     '<procedure-env>))
      (display object)))

;; `and and or
(define (and? exp) (tagged-list? exp 'and))
(define (or? exp) (tagged-list? exp 'or))

(define (and-clauses exp) (cdr exp))
(define (or-clauses exp) (cdr exp))

(define (and->if exp)
  (expand-and-clauses (and-clauses exp)))

(define (expand-and-clauses clauses)
  (if (null? clauses)
      (make-if 'true 'true 'false)
      (let ((first (car clauses))
            (rest (cdr clauses)))
        (make-if first
                 (if (null? rest)
                     first
                     (expand-and-clauses rest))
                 'false))))

(define (or->if exp)
  (expand-or-clauses (or-clauses exp)))

(define (expand-or-clauses clauses)
  (if (null? clauses)
      (make-if 'true 'false 'true)
      (make-if (car clauses)
               'true
               (expand-or-clauses (cdr clauses)))))

;; modify the part of let to support the named letB
(define (let? exp) (tagged-list? exp 'let))

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

;; let*
(define (make-let bindings body)
  (cons 'let (cons bindings body)))

(define (let*? exp) (tagged-list? exp 'let*))

(define (let*-bindings exp) (cadr exp))
(define (let*-body exp) (cddr exp))

(define (let*->nested-lets exp)
  (expand-body (let*-bindings exp) (let*-body exp)))

(define (expand-body bindings body)
  (if (null? bindings)
      (make-let '() body)
      (make-let (list (car bindings))
                (if (null? (cdr bindings))
                    body
                    (list (expand-body (cdr bindings) body))))))

;; change the load order of eval
(put 'eval 'quote (lambda (exp env) (text-of-quotation exp)))
(put 'eval 'set! eval-assignment)
(put 'eval 'define eval-definition)
(put 'eval 'if eval-if)
(put 'eval
     'lambda
     (lambda (exp env)
       (make-procedure (lambda-parameters exp)
                       (lambda-body exp)
                       env)))
(put 'eval
     'begin
     (lambda (exp env)
       (eval-sequence (begin-actions exp) env)))
(put 'eval 'cond (lambda (exp env) (eval (cond->if exp) env)))

;; `and and or
(put 'eval 'and (lambda (exp env) (eval (and->if exp) env)))
(put 'eval 'or (lambda (exp env) (eval (or->if exp) env)))

;; let
(put 'eval 'let (lambda (exp env) (eval (let->combination exp) env)))

;; let*
(put 'eval 'let* (lambda (exp env) (eval (let*->nested-lets exp) env)))

(put 'eval 'make-unbound! eval-unbound)

(define (eval exp env)
  (cond ((self-evaluating? exp) exp)
        ((variable? exp) (lookup-variable-value exp env))
        ((get 'eval (operator exp))
         ((get 'eval (operator exp)) exp env))
        ((application? exp)
         (apply (eval (operator exp) env)
                (list-of-values (operands exp) env)))
        (else
         (error "Unknown expression type -- EVAL" exp))))
