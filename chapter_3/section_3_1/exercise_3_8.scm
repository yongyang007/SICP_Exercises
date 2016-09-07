(define f
  (let ((n 1))
    (lambda (x)
      (if (= x 0)
          (begin (set! n 0)
                 n)
          n))))
(+ (f 0) (f 1))

(define f
  (let ((n 1))
    (lambda (x)
      (if (= x 0)
          (begin (set! n 0)
                 n)
          n))))
(+ (f 1) (f 0))
