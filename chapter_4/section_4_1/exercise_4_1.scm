(define x 10)
(define expressions '((set! x (+ x 2)) (set! x (* x 2))))

(define (list-of-values exps env)
  (if (no-operands? exps)
      '()
      (cons (eval (first-operand exps) env)
            (list-of-values (rest-operands exps) env))))
(define no-operands? null?)
(define first-operand car)
(define rest-operands cdr)

(list-of-values expressions (interaction-environment))
;; => (12 24)

(define (list-of-values-left-to-right exps env)
  (if (no-operands? exps)
      '()
      (let ((first-value (eval (first-operand exps) env)))
        (cons first-value
              (list-of-values-left-to-right (rest-operands exps) env)))))

(set! x 10)
(list-of-values-left-to-right expressions (interaction-environment))
;; => (12 24)

(define (list-of-values-right-to-left exps env)
  (if (no-operands? exps)
      '()
      (let ((rest-values (list-of-values-right-to-left (rest-operands exps) env)))
        (cons (eval (first-operand exps) env)
              rest-values))))

(set! x 10)
(list-of-values-right-to-left expressions (interaction-environment))
;; => (22 20)
