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

;; rewrite eval
(add-load-path "./")
(load "metacircular_evaluator.scm")

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
