(add-load-path "./")
(load "stream.scm")

(define (interleave s1 s2)
  (if (stream-null? s1)
      s2
      (cons-stream (stream-car s1)
                   (interleave s2 (stream-cdr s1)))))

(define (pairs s t)
  (cons-stream
   (list (stream-car s) (stream-car t))
   (interleave
    (stream-map (lambda (x) (list (stream-car s) x))
                (stream-cdr t))
    (pairs (stream-cdr s) (stream-cdr t)))))

(define pairs-stream (pairs integers integers))

;; (1, 1) (1, 2) (1, 3) (1, 4) ...
;;        (2, 2) (2, 3) (2, 4) ...
;;               (3, 3) (3, 4) ...
;;                      (4, 4) ...
;; ...    ...    ...    ...    ...

;; 我们把上面这个流分为三个部分：(1, 1)，第一行中的其它序对，剩余的序对
;; 而流的cdr部分又是由后两个部分交替组合而成的，
;; (1, 100)属于第二部分，因此在它之前还应有(98 * 2 + 1) = 197个序对
(stream-ref pairs-stream 197)
;; (1, x)之前会有(2x - 3)个序对
;; (100, 100)属于第三部分，而第三部分又可以分三个部分，
;; (100, 100)就是整个流在分了第99次之后的第三部分的第一个元素
;; 它的位置应该是（从0开始计数）：
(define (test n)
  (define (f p i n)
    (if (= n 0)
        (- i 1)
        (f p (p i) (- n 1))))
  (if (= n 1)
      0
      (f (lambda (x) (+ (* x 2) 1)) 3 (- n 2))))
(test 100)
;; => 1267650600228229401496703205374
;; 也就是说(100, 100)前应该有1267650600228229401496703205374个序对
;; 数字太大，只能用其它的验证：
(stream-ref pairs-stream (test 10))
;; (stream-ref pairs-stream (test 20)) ; 这个算起来就已经很慢了
