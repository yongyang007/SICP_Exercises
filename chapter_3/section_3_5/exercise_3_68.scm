(add-load-path "./")
(load "exercise_3_66.scm")

(define (pairs s t)
  (interleave
   (stream-map (lambda (x) (list (stream-car s) x))
               t)
   (pairs (stream-cdr s) (stream-cdr t))))

;; 如果用这种定义去求值(pairs integers integers)，
;; 是不会返回结果的，这是因为interleave的第二个参数又调用了pairs本身，
;; 为了求出pairs的结果，就必须一致调用pairs，从而陷入死循环。
;; 而原来的定义，以为pairs等于是包在在delay中，并不会立即执行，这也就是为什么stream可以用来处理无限的数据了。
