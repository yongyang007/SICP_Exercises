(add-load-path "./")
(load "stream.scm")

(define (expand num den radix)
  (cons-stream
   (quotient (* num radix) den)
   (expand (remainder (* num radix) den) den radix)))

;; 根据定义可知expand过程返回的流，其第一个元素是(num * radix)除以den的商
;; 而后再将num变化为(num * radix)除以den的余数，继续递归定义
;; 说明白些流内的元素就是就是以radix为基数，(num / den)的小数形式的小数部分（其中num < den）

(sub-list (expand 3 8 10) 10)
;; => (3 7 5 0 0 0 0 0 0 0)
(sub-list (expand 1 3 10) 10)
;; => (3 3 3 3 3 3 3 3 3 3)
