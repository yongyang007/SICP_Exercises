                                        ;递归计算过程：
(define (f n)
  (if (< n 3)
      n
      (+ (f (- n 1))
         (* 2 (f (- n 2)))
         (* 3 (f (- n 3))))))
                                        ;迭代计算过程：
(define (f n)
  (if (< n 3)
      n
      (f-iter 2 1 0 n)))
(define (f-iter a b c count)
  (if (= count 3)
      (+ a (* 2 b) (* 3 c))
      (f-iter (+ a (* 2 b) (* 3 c))
              a
              b
              (- count 1))))

                                        ;test:
(f 2)
(f -7)
(f 6)
(f 13)
