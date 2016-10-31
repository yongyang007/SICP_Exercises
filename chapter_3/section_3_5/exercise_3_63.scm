(add-load-path "./")
(load "stream.scm")
(add-load-path "../../tool/")
(load "accumulate.scm")

(define (average . args)
  (/ (accumulate + 0 args)
     (length args)))
(define (sqrt-improve guess x)
  (average guess (/ x guess)))

;; 对比两种定义
(define (sqrt-stream x)
  (define guesses
    (cons-stream 1.0
                 (stream-map (lambda (guess)
                               (sqrt-improve guess x))
                             guesses)))
  guesses)

;; (define (sqrt-stream x)
;;   (cons-stream 1.0
;;                (stream-map (lambda (guess)
;;                              (sqrt-improve guess x))
;;                            (sqrt-stream x))))

;; 可以看出第一个定义用一个guesses将stream保存了起来，这样在计算第n个元素时，
;; 由于用了memo-proc的优化，并不用再去重复计算多次前n-1个元素，计算次数为Θ(n)；
;; 而第二个定义中，没有保存生成的流，只是递归调用来重新再生成出一个流，
;; 这样便不能利用以前的结果了，计算次数为Θ(n^2)

;; 但如果我们实现delay时没用memo-proc进行优化，那么两种定义的效率就将相同了
