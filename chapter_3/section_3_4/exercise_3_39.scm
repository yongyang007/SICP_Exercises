(define x 10)

(define s (make-serializer))

(parallel-execute (lambda () (set! ((s (lambda () (* x x))))))
                  (s (lambda () (set! x (+ x 1)))))

;; 如果这样执行，则出了121和101两个值，还可能出现100
