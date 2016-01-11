(load "./exercise_1_22.scm")
(load "./fast_prime_test.scm")

(define (prime? n) (fast-prime? n 10))

(load "./search_for_primes_test.scm")

                                        ;可以看到，在处理比较小的数的时候，改进后的算法还比较慢
                                        ;这是因为算法执行的速度还受到了计算步骤之外因素的影响
                                        ;但因为改进后的算法增长的阶是Θ(log n)的，输入的数字越大，优势就越明显
                                        ;书中做例子的数字都比较小，现在计算机速度更快了，还可以用一些更大的数做测试
