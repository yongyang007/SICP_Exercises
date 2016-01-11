(load "./exercise_1_17.scm")
                                        ;迭代方式
(define (fast-*-iter a b n)
  (cond ((= b 0) n)
        ((even? b) (fast-*-iter (double a) (halve b) n))
        (else (fast-*-iter a (- b 1) (+ n a)))))
(define (fast-* a b)
  (fast-*-iter a b 0))

(fast-* 7 8)
