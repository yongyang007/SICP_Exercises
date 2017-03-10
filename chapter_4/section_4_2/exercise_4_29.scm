(use gauche.time)

(add-load-path "./")
(load "lazy_evaluator.scm")

;; 启用记忆功能：
(define (force-it obj)
  (cond ((trunk? obj)
         (let ((result (actual-value
                        (trunk-exp obj)
                        (trunk-env obj))))
           (set-car! obj 'evaluated-trunk)
           (set-car! (cdr obj) result)     ;; replace exp with value
           (set-cdr! (cdr obj) '())        ;; forget uneeded env
           result))
        ((evaluated-trunk? obj)
         (trunk-value obj))
        (else obj)))

(eval '(define (self x) (+ 1 (- (+ 2 (- (+ 3 (- (+ 4 (- (+ 5 (- x 1)) 2)) 3)) 4)) 5))) the-global-environment)
(eval '(define (factorial n) (if (= n 1) 1 (* n (factorial (- n 1))))) the-global-environment)
(time-this '(cpu 1) (lambda () (eval '(factorial (self 100)) the-global-environment)))
;; => #<time-result 752 times/  1.240 real/  1.280 user/  0.000 sys>

;; 没有启用记忆功能：
(define (force-it obj)
  (if (trunk? obj)
      (actual-value (trunk-exp obj) (trunk-env obj))
      obj))
(time-this '(cpu 1) (lambda () (eval '(factorial (self 100)) the-global-environment)))


;; 采用记忆功能：
(driver-loop)

(define count 0)
(define (id x)
  (set! count (+ count 1))
  x)
(define (square x)
  (* x x))

;;; L-Eval imput:
(square (id 10))
;;; L-Eval value:
;; => 100

;;; L-Eval imput:
count
;;; L-Eval value:
;; => 1

(exit)

;; 没有记忆功能：
(driver-loop)

(define count 0)

;;; L-Eval imput:
(square (id 10))
;;; L-Eval value:
;; => 100

;;; L-Eval imput:
count
;;; L-Eval value:
;; => 2

;; (id 10)会执行两次
