(define (an-integer-starting-from n)
  (amb n (an-integer-starting-from (+ n 1))))

;; 如果将上一题的an-integer-between用an-integer-starting-from作简单的替换
(define (a-pythagorean-triple-starting-from n)
  (let ((i (an-integer-starting-from n)))
    (let ((j (an-integer-starting-from n)))
      (let ((k (an-integer-starting-from n)))
        (require (= (+ (* i i) (* j j)) (* k k)))
        (list i j k)))))
;; 这种写法在取(i j k)的值时都不会产生失败，
;; 因此程序会一直去取k的值，不会在i或者j那里回溯

(define (a-pythagorean-triple-from n)
  (let ((k (an-integer-starting-from n)))
    (let ((i (an-integer-between n k))
          (j (an-integer-between n k)))
      (require (= (+ (* i i) (* j j)) (* k k)))
      (list i j k))))

(define pythagorean-triples
  (a-pythagorean-triple-from 3))
