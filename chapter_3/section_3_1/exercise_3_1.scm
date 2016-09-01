(define (make-accumulator sum)
  (lambda (input)
    (set! sum (+ sum input))
    sum))

(define A (make-accumulator 5))
(A 10)
(A 10)
