;; 为了支持(<test> => <recipient>)，需要修改expand-clauses的实现
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
