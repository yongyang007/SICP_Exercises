(define (install-integer-package)
  (define (tag x)
    (attach-tag 'integer (floor->exact (+ x 0.5))))
  (put 'add
       '(integer integer)
       (lambda (x y) (tag (+ x y))))
  (put 'sub
       '(integer integer)
       (lambda (x y) (tag (- x y))))
  (put 'mul
       '(integer integer)
       (lambda (x y) (tag (* x y))))
  (put 'div
       '(integer integer)
       (lambda (x y) (tag (/ x y))))
  (put 'make
       'integer
       (lambda (x) (tag x)))
  (put 'equ?
       '(integer integer)
       =)
  (put '=zero?
       '(integer)
       (lambda (x) (= x 0)))
  ;; exercise 2.83
  (put 'raise
       '(integer)
       (lambda (x) (make-rational x 1)))
  'done)

(define (make-integer n)
  ((get 'make 'integer) n))
