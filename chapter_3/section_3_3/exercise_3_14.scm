(define (mystery x)
  (define (loop x y)
    (if (null? x)
        y
        (let ((temp (cdr x)))
          (set-cdr! x y)
          (loop temp x))))
  (loop x '()))

(define v (list 'a 'b 'c))
(define w (mystery v))

;; mystery方法就将返回参数list的倒序，并将参数list改变为只含它原来第一个元素的list
;; 执行后的盒子图如下
;;                            ---
;;                         |->|a|
;;                         |  --- 
;;      -----    -----    -----
;; w--->|.|.|--->|.|.|--->|.|/|
;;      -----    -----    -----
;;       |  ---   |  ---   ^
;;       |->|c|   |->|b|   |---v
;;          ---      ---   
