;; 另一种使解释器能实现内部定义的“同时性”的变换，
;; 就是把所有的内部定义都放在非内部定义的前面，
;; 这种变换又不额外添加额外框架。

(add-load-path "./")
(load "metacircular_evaluator.scm")

(define (scan-out-defines proc-body)
  (let ((definitions (filter definition? proc-body)))
    (if (null? definitions)
        proc-body
        (let ((body (filter (lambda (b) (not (definition? b)))
                            proc-body)))
          (append definitions body)))))

(driver-loop)

(define (f x)
  (define (u n) (+ (g n) 1))
  (set! x (g x))
  (define (g n) (+ n 1))
  (+ x (g x) (u x)))

(f 0)
