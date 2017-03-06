(use gauche.time)

(add-load-path "./")
(load "metacircular_evaluator.scm")

(eval '(define (factorial n) (if (= n 1) 1 (* (- n 1) (factorial (- n 1))))) the-global-environment)

(time-this '(cpu 1.0) (lambda () (eval '(factorial 4) the-global-environment)))
;; #<time-result 37500 times/  1.116 real/  1.240 user/  0.010 sys>

(time-this '(cpu 1.0) (lambda () (analyze '(factorial 4))))
;; #<time-result 600000 times/  0.971 real/  1.140 user/  0.010 sys>

(load "original_metacircular_evaluator.scm")

(eval '(define (factorial n) (if (= n 1) 1 (* (- n 1) (factorial (- n 1))))) the-global-environment)

(time-this '(cpu 1.0) (lambda () (eval '(factorial 4) the-global-environment)))
;; #<time-result 23080 times/  1.209 real/  1.240 user/  0.000 sys>


;; 可以看出，在同样的时间内（1秒），未优化的解释器计算4的阶乘时要比优化后的少执行14000次左右
;; 对于各中过程分析和执行所用时间的比例，也可以用类似做法算出
