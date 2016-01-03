(load "./smallest_divisor.scm")

(define (prime? n)
  (= (smallest-divisor n) n))
