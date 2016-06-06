(add-load-path "../../tool/")
(load "square.scm")
(load "random.scm")

(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((nontrivial-square-root? base m) 0)
        ((even? exp)
         (remainder (square (expmod base (/ exp 2) m)) m))
        (else
         (remainder (* base (expmod base (- exp 1) m)) m))))

(define (nontrivial-square-root? a n)
  (and (or (not (= a 1))
           (not (= a (- n 1))))
       (= (remainder (square a) n) 1)))

(define (miller-rabin-test n)
  (define (try-it a)
    (= (expmod a (- n 1) n) 1))
  (try-it (+ 1 (random (- n 1)))))

(define (fast-prime? n times)
  (cond ((= times 0) #t)
        ((miller-rabin-test n) (fast-prime? n (- times 1)))
        (else #f)))

                                        ;Carmichael数
(fast-prime? 561 10)
(fast-prime? 1105 10)
(fast-prime? 1729 10)
(fast-prime? 2465 10)
(fast-prime? 2821 10)
(fast-prime? 6601 10)
                                        ;素数
(fast-prime? 1997 10)
(fast-prime? 1999 10)
(fast-prime? 2143 10)
(fast-prime? 2693 10)
                                        ;非素数
(fast-prime? 222 10)
(fast-prime? 1111 10)
