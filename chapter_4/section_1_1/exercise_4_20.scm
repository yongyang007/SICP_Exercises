;; a) test
(add-load-path "./")
(load "metacircular_evaluator.scm")

(driver-loop)

(letrec ((fact
          (lambda (n)
            (if (= n 1)
                1
                (* n (fact (- n 1)))))))
  (fact 10))

(define (f x)
  (letrec ((even?
            (lambda (n)
              (if (= n 0)
                  true
                  (odd? (- n 1)))))
           (odd?
            (lambda (n)
              (if (= n 0)
                  false
                  (even? (- n 1))))))
    (cond ((even? x) 'even)
          ((odd? x) 'odd))))

(f 5)

(exit)

;; b)
;; 如果将letrec替换成let，是不能进行递归定义的
;; 如环境图所示，那是因为作为参数的函数体的环境上下文不同
