(define (a-pythagorean-triple-between low high)
  (let ((i (an-integer-between low high))
        (hsq (* high high)))
    (let ((j (an-integer-between i high)))
      (let ((ksq (+ (* i i) (* j j))))
        (require (>= hsq ksq))
        (let ((k (sqrt ksq)))
          (require (integer? k))
          (list i j k))))))

;; 让我们来看一下求解(a-pythagorean-triple-between 1 5)时的所有可能
;; (i j)
;; (1 1) (1 2) (1 3) (1 4) (1 5)
;; (2 2) (2 3) (2 4) (2 5)
;; (3 3) (3 4) => 结果(3 4 5)

;; 然后是练习4.35的情况
(define (a-pythagorean-triple-between low high)
  (let ((i (an-integer-between low high)))
    (let ((j (an-integer-between i high)))
      (let ((k (an-integer-between j high)))
        (require (= (+ (* i i) (* j j)) (* k k)))
        (list i j k)))))

;; (i j k)
;; (1 1 1) (1 1 2) (1 1 3) (1 1 4) (1 1 5)
;; (1 2 2) (1 2 3) (1 2 4) (1 2 5)
;; (1 3 3) (1 3 4) (1 3 5)
;; (1 4 4) (1 4 5)
;; (1 5 5)
;; (2 2 2) (2 2 3) (2 2 4) (2 2 5)
;; (2 3 3) (2 3 4) (2 3 5)
;; (2 4 4) (2 4 5)
;; (2 5 5)
;; (3 3 3) (3 3 4) (3 3 5)
;; (3 4 4) (3 4 5) => 结果

;; 可以看出Ben的方法确实效率比较高
