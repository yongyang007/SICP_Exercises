(add-load-path "./")
(load "stream.scm")

(define fibs (cons-stream 0
                          (cons-stream 1
                                       (add-streams fibs
                                                    (stream-cdr fibs)))))
(sub-list fibs 10)

;; 用这种方法计算第n个斐波那契数时，只需要做(n - 1)次加法（0 <= n）
;; 而如果在实现delay时，不将结果存储在延迟对象中，
;; 根据练习1.13的证明，计算次数是指数级别增长的
