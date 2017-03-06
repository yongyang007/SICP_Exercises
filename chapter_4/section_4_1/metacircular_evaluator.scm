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
(define (analyze-application exp)
  (let ((fproc (analyze (operator exp)))
        (aprocs (map analyze (operands exp))))
    (lambda (env)
      (execute-application (fproc env)
                           (map (lambda (aproc) (aproc env))
                                aprocs)))))

(define (execute-application proc args)
  (cond ((primitive-procedure? proc)
         (apply-primitive-procedure proc args))
        ((compound-procedure? proc)
         ((procedure-body proc)
          (extend-environment
           (procedure-parameters proc)
           args
           (procedure-environment proc))))
        (else
         (error
          "Unknown procedure type -- EXECUTE-APPLICATION" proc))))

(define (list-of-values exps env)
  (if (no-operand? exps)
      '()
      (cons (eval (first-operand exps) env)
            (list-of-values (rest-operands exps) env))))

(define (analyze-self-evaluating exp)
  (lambda (env) exp))

(define (analyze-quote exp)
  (let ((qval (text-of-quotation exp)))
    (lambda (env) qval)))

(define (analyze-variable exp)
  (lambda (env) (lookup-variable-value exp env)))

(define (analyze-if exp)
  (let ((pproc (analyze (if-predicate exp)))
        (cproc (analyze (if-consequent exp)))
        (aproc (analyze (if-alternative exp))))
    (lambda (env)
      (if (true? (pproc env))
          (cproc env)
          (aproc env)))))

(define (analyze-lambda exp)
  (let ((vars (lambda-parameters exp))
        (bproc (analyze-sequence (scan-out-defines (lambda-body exp)))))
    (lambda (env) (make-procedure vars bproc env))))

(define (analyze-sequence exps)
  (define (sequentially proc1 proc2)
    (lambda (env) (proc1 env) (proc2 env)))
  (define (loop first-proc rest-procs)
    (if (null? rest-procs)
        first-proc
        (loop (sequentially first-proc (car rest-procs))
              (cdr rest-procs))))
  (let ((procs (map analyze exps)))
    (if (null? procs)
        (error "Empty sequence -- ANALYZE"))
    (loop (car procs) (cdr procs))))

(define (analyze-assignment exp)
  (let ((var (assignment-variable exp))
        (vproc (analyze (assignment-value exp))))
    (lambda (env)
      (set-variable-value! var (vproc env) env)
      'ok)))

(define (analyze-definition exp)
  (let ((var (definition-variable exp))
        (vproc (analyze (definition-value exp))))
    (lambda (env)
      (define-variable! var (vproc env) env)
      'ok)))

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
(define (analyze-unbound exp)
  (let ((var (unbound-variable exp)))
    (lambda (env)
      (remove-binding-in-frame! var env)
      'ok)))

;; evaluator data structures
(define (true? x)
  (not (eq? x false)))
(define (false? x)
  (eq? x false))

;; add scan-out-defines to trans internal definitions
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

(define (binding-variable binding) (car binding))
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

;; modify the lookup-variable-value
;; signal an error when it found unassigned variable
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

;; modify the part of let to support the named let
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

;; letrec
;; exercise 4.20 a)
(define (letrec? exp) (tagged-list? exp 'letrec))

(define (letrec-bingings exp) (cadr exp))
(define (letrec-body exp) (cddr exp))

(define (letrec->let exp)
  (let ((bindings (letrec-bingings exp))
        (body (letrec-body exp)))
    (make-let (map
               (lambda (var) (list var ''*unassigned*))
               (map binding-variable bindings))
              (append
               (map
                (lambda (binding) (cons 'set! binding))
                bindings)
               body))))

;; change the load order of eval and analyze
(put 'analyze 'quote analyze-quote)
(put 'analyze 'set! analyze-assignment)
(put 'analyze 'define analyze-definition)
(put 'analyze 'if analyze-if)
(put 'analyze 'lambda analyze-lambda)
(put 'analyze
     'begin
     (lambda (exp)
       (analyze-sequence (begin-actions exp))))
(put 'analyze 'cond (lambda (exp) (analyze (cond->if exp))))

;; `and and or
(put 'analyze 'and (lambda (exp) (analyze (and->if exp))))
(put 'analyze 'or (lambda (exp) (analyze (or->if exp))))

;; let
(put 'analyze 'let (lambda (exp) (analyze (let->combination exp))))

;; let*
(put 'analyze 'let* (lambda (exp) (analyze (let*->nested-lets exp))))

;; letrec
;; exercise 4.20 a)
(put 'analyze 'letrec (lambda (exp) (analyze (letrec->let exp))))

(put 'analyze 'make-unbound! analyze-unbound)

(define (analyze exp)
  (cond ((self-evaluating? exp)
         (analyze-self-evaluating exp))
        ((variable? exp) (analyze-variable exp))
        ((get 'analyze (operator exp))
         ((get 'analyze (operator exp)) exp))
        ((application? exp) (analyze-application exp))
        (else
         (error "Unknown expression type -- ANALYZE" exp))))

(define (eval exp env)
  ((analyze exp) env))
