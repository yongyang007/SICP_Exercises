(define zero (lambda (f) (lambda (x) x)))
(define (add-1 n)
  (lambda (f) (lambda (x) (f ((n f) x)))))

                                        ;(add-1 zero)
                                        ;(lambda (f) (lambda (x) (f ((zero f) x))))
                                        ;(lambda (f) (lambda (x) (f ((lambda (x) x) x))))
                                        ;(lambda (f) (lambda (x) (f x)))
(define one (lambda (f) (lambda (x) (f x))))
(define two (lambda (f) (lambda (x) (f (f x)))))

(define (add m n)
  (lambda (f) (lambda (x) ((m f) ((n f) x)))))

                                        ;为了表示定义的方法
(define (inc n) (+ n 1))
(define (to-i c) ((c inc) 0))
(to-i zero)
(to-i (add-1 zero))
(to-i one)
(to-i two)
(to-i (add one two))
