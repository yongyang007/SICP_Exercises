(define (* a b)
  (if (= b 0)
      0
      (+ a (* a (- b 1)))))

(define (double n)
  (+ n n))
(define (halve n)
  (/ n 2))

                                        ;递归方式
(define (fast-* a b)
  (cond ((= b 0) 0)
        ((even? b) (double (fast-* a (halve b))))
        (else (+ a (fast-* a (- b 1))))))

(fast-* 7 8)
