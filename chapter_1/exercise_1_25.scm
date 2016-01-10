(load "./fast_expt.scm")

(define (expmod base exp m)
  (remainder (fast-expt base exp) m))

                                        ;这个方法从理论上没有错，
                                        ;但是每次计算时要先算出(fast-expt base exp)
                                        ;如果指数和底数都很大的话，会造成运算缓慢甚至溢出。
                                        ;而原来的算法在每一步都先做求模运算，从而不用计算比较大的数。
