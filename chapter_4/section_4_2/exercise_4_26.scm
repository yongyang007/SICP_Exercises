(add-load-path "../section_4_1/")
(load "metacircular_evaluator.scm")

(define (unless? exp) (tagged-list? exp 'unless))
(define (unless-predicate exp) (cadr exp))
(define (unless-alternative exp) (caddr exp))
(define (unless-consequent exp)
  (if (not (null? (cdddr exp)))
      (cadddr exp)
      'false))

(define (unless->if exp)
  (make-if (unless-predicate exp)
           (unless-consequent exp)
           (unless-alternative exp)))

(define (analyze-unless exp) (analyze (unless->if exp)))

(put 'analyze 'unless analyze-unless)

(driver-loop)

(define (factorial n)
  (unless (= n 1)
          (* n (factorial (- n 1)))
          1))
(factorial 5)

;; 上面的过程就是将unless实现为一种派生表达式

;; 但如果需要利用高阶过程，
;; 例如现在有一个条件序列，两个选项序列，
;; 如果unless是一个过程而不是语法形式，
;; 我们就能用map算出结果的序列；

(define (unless condition usual-value exceptional-value)
    (if condition exceptional-value usual-value))

(map unless
     '(#t #f #f #t)
     '(1 3 5 7)
     '(2 4 6 8))
