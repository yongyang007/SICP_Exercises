(add-load-path "./")
(load "metacircular_evaluator.scm")

(driver-loop)

(define (map proc list)
  (if (null? list)
      '()
      (cons (proc (car list))
            (map proc (cdr list)))))

(map car '((1 2) (2 3) (3 4) (4 5)))

(exit)
(add-load-path "./")
(load "metacircular_evaluator.scm")

(define primitive-procedures
  (list (list 'car car)
        (list 'cdr cdr)
        (list 'cons cons)
        (list 'null? null?)
        (list 'map map)
        ;; <more primitives>
        ))
(define the-global-environment (setup-environment))

(driver-loop)

(map car '((1 2) (2 3) (3 4) (4 5)))

;; 通过上面的例子可以看出，如果将系统的map方法作为基本方法加入到求值器中，
;; 这时将其它基本方法（比如上面的car）作为map的参数调用map的话，
;; 会将用'primitive封装过的对象导入map的执行过程，从而出现错误。
