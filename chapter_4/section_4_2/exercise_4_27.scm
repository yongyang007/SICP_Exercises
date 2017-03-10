(add-load-path "./")
(load "lazy_evaluator.scm")

(driver-loop)

(define count 0)
(define (id x)
  (set! count (+ count 1))
  x)
(define w (id (id 10)))

;;; L-Eval imput:
count
;;; L-Eval value:
;; => 1

;;; L-Eval imput:
w
;;; L-Eval value:
;; => 10

;;; L-Eval imput:
count
;;; L-Eval value:
;; => 2

;; w的值是10这点毫无疑问，
;; 而由于要计算w需要调用id两次，因此count最后也由0增长到了2,
;; 在执行(define w (id (id 10)))的时候，
;; (id 10)作为一个thunk被当成参数传进id方法中，
;; 因此此时w的值实际上是一个(id 10)形成的thunk，
;; 而由于这时最外层的id执行了一次，因此count增长到1
;; 在输出w时，(id 10)的thunk被force求值返回10,
;; id方法再次执行count的值增加1
