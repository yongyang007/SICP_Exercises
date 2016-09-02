(use math.mt-random)

(define mt (make <mersenne-twister> :seed (sys-time)))

(define (random n)
  (if (inexact? n)
      (* n (mt-random-real0 mt))
      (mt-random-integer mt n)))
