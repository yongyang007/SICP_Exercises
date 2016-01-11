(load "./exercise_1_24.scm")

(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
         (remainder (* (expmod base (/ exp 2) m)
                       (expmod base (/ exp 2) m))
                    m))
        (else
         (remainder (* base (expmod base (- exp 1) m))
                    m))))

(load "./search_for_primes_test.scm")

                                        ;在expmod中如果改用显式的乘法的话，
                                        ;原本线状的计算过程就变为树状展开了。
                                        ;原来计算过程的增长阶为以2为底的Θ(log n)，
                                        ;而修改后的版本则为n/2层的二叉树，节点个数为2^0+2^1+...+2^(n/2-1)=2^(n/2)-1
                                        ;所以其增长的阶为Θ(n)，自然比prime?的Θ(n^(1/2))还要慢
