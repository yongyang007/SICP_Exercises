(load "../../tool/runtime.scm")
(load "./prime_test.scm")

(define (timed-prime-test n)
  (newline)
  (display n)
  (start-prime-test n (runtime)))

(define (start-prime-test n start-time)
  (if (prime? n)
      (report-prime (- (runtime) start-time))))

(define (report-prime elapsed-time)
  (display " *** ")
  (display elapsed-time))

(define (search-for-primes n)
  (continue-primes n 3))
(define (continue-primes n count)
  (cond
   ((= 0 count) (newline))
   ((prime? n)
    (timed-prime-test n)
    (continue-primes (next-odd n) (- count 1)))
   (else (continue-primes (next-odd n) count))))
(define (next-odd n)
  (if (odd? n) (+ n 2) (+ n 1)))

(load "./search_for_primes_test.scm")

                                        ;结果表明，随着n以10为倍数的增长，时间基本是按10^(1/2)增长的
