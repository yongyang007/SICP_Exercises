(add-load-path "./")
(load "lazy_evaluator.scm")

;; a)
(driver-loop)

(define (for-each proc items)
  (if (null? items)
      'done
      (begin (proc (car items))
             (for-each proc (cdr items)))))

(for-each (lambda (x) (newline) (display x))
          '(57 321 88))

;; 在解释(begin (proc (car items)) (for-each proc (cdr items)))的第一条语句时，
;; (proc (car items))，方法proc会被force求出，能保证每次递归都正常执行

;; b)
(define (p1 x)
  (set! x '(2))
  x)

(define (p2 x)
  (define (p e)
    e
    x)
  (p (set! x (cons x '(2)))))

;; 原来的eval-sequence:
(exit)
(define (eval-sequence exps env)
  (cond ((last-exp? exps) (eval (first-exp exps) env))
        (else (eval (first-exp exps) env)
              (eval-sequence (rest-exps exps) env))))
(driver-loop)

(p1 1)
;; => (2)

(p2 1)
;; => 1
;; (set! x (cons x '(2)))被作为参数传入方法p中，不会被force执行的

;; 修改后的eval-sequence：
(exit)
(define (eval-sequence exps env)
  (cond ((last-exp? exps) (eval (first-exp exps) env))
        (else (actual-value (first-exp exps) env)
              (eval-sequence (rest-exps exps) env))))
(driver-loop)

(p1 1)
;; => (2)

(p2 1)
;; => (1 2)

;; c)
;; b中的修改只是将sequence中的每条语句都force执行而已，
;; 不会对最后的结果造成影响，也就并不会a中那种实例的行为了

;; d)
;; 有待探讨，个人觉得应该想办法把两种做法结合一下
