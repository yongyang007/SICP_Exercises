(load "../square.scm")
(define (fast-expt-iter a b n)
  (if (= n 0)
      a
      (if (even? n)
          (fast-expt-iter a (square b) (/ n 2))
          (fast-expt-iter (* a b) b (- n 1)))))
(define (even? n)
  (= (remainder n 2) 0))
(define (fast-expt b n)
  (fast-expt-iter 1 b n))

(fast-expt 3 3)
