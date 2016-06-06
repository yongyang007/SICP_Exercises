(define (filtered-accumulate valid? combiner null-value term a next b)
  (if (> a b)
      null-value
      (if (valid? a)
          (combiner (term a)
                    (filtered-accumulate valid? combiner null-value term (next a) next b))
          (filtered-accumulate valid? combiner null-value term (next a) next b))))

(add-load-path "./")
(add-load-path "../section_1_2/")
(load "fast_prime_test.scm")
(load "exercise_1_31.scm")
                                        ;a)给定范围内的素数之和
(define (prime-sum a b)
  (define (prime? x) (fast-prime? x 100))
  (filtered-accumulate prime? + 0 phototype a add-one b))
                                        ;test
(prime-sum 2 20)                        ;2 + 3 + 5 + 7 + 11 + 13 + 17 + 19 = 77

                                        ;b)小于n的所有与n互素的正整数的乘积
(define (co-prime? a b) (= (gcd a b) 1))
(define (co-prime-product n)
  (filtered-accumulate co-prime? * 1 phototype 1 add-one n))
                                        ;test
(co-prime-product 10)                   ;1 * 3 * 7 * 9 = 189
