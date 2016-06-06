(add-load-path "./")
(load "exercise_1_22.scm")

(define (next n)
  (if (= n 2) 3 (+ n 2)))

(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divisor? test-divisor n) test-divisor)
        (else (find-divisor n (next test-divisor)))))

(load "./search_for_primes_test.scm")

                                        ;修改前后两个算法速度的比值并不是2
                                        ;原因应该和执行next的时间有关
