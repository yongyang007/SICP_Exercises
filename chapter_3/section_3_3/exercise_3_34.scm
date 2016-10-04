(add-load-path "./")
(load "constraint_system.scm")

(define (squarer a b)
  (multiplier a a b))

(define A (make-connector))
(define B (make-connector))

(squarer A B)

(probe "A" A)
(probe "B" B)

(set-value! A 2 'user)
(forget-value! A 'user)
(set-value! B 9 'user)
(get-value B) ; => 9
(get-value A) ; => #f
;; 可以看到为B赋值后并没有约束到A
;; 这个建议的缺陷就是，只赋值给b并不能启动约束
;; 因为乘法约束只有知道其中两个量的值时才能为第三个量赋值
