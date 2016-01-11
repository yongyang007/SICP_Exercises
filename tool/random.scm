(use math.mt-random)

(define mt (make <mersenne-twister> :seed (sys-time)))

(define (random n)
  (mt-random-integer mt n))
