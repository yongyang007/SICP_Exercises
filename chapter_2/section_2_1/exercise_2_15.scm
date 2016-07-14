(add-load-path "./")
(load "exercise_2_14.scm")

(define (par1 r1 r2)
  (div-interval (mul-interval r1 r2)
                (add-interval r1 r2)))
(define (par2 r1 r2)
  (let ((one (make-interval 1 1)))
    (div-interval one
                  (add-interval (div-interval one r1)
                                (div-interval one r2)))))

(define ApA1 (par1 A A))
ApA1 ;=> (9.415686274509806 . 10.616326530612245)
(center ApA1) ;=> 10.016006402561025
(percent ApA1) ;=> 5.9936076707950345
(define ApA2 (par2 A A))
ApA2 ;=> (9.8 . 10.2)
(center ApA2) ;=> 10.0
(percent ApA2) ;=> 1.999999999999993
                                        ;由结果可知，par2的计算结果的确比par1的误差值更小
                                        ;原因也正如题目所说的那样，而且通过上一题也可以看到误差值的累加
                                        ;但是否这样就证明par2比par1“更好”，我想就不能确定了，因为还要考虑实际应用的场景
                                        ;比如这个计算并联电阻值的应用，是否误差值越小就越接近真实的电阻值呢？我想答案是不确定的。
