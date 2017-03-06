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

;; test
(define test-exp '(let* ((x 3) (y (+ x 2)) (z (+ x y 5))) (* x z)))
(let*->nested-lets test-exp)
;; => (let ((x 3)) (let ((y (+ x 2))) (let ((z (+ x y 5))) (* x z))))
(let*->nested-lets '(let* () (+ 1 1)))
;; => (let () (+ 1 1))

;; 这样只要在eval方法的条件中加入下面的语句
;; ((let*? exp) (eval (let*->nested-lets exp) evn))
;; 就足够了，不必显式地以非派生的方法处理
