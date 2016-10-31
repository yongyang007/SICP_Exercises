(add-load-path "./")
(load "stream.scm")

(define (show x)
  (display-line x)
  x)

(define x (stream-map show (stream-enumerate-interval 0 10)))
;; 控制台打印出的响应：
;; 0x
;; 只有第一个元素0会被传进show中执行并被换行打印出，
;; 后面的操作还在流中，最后打印出被定义的x
(stream-ref x 5)
;; 控制台打印出的响应：
;; 1
;; 2
;; 3
;; 4
;; 55
;; 为遍历到index为5的数据，流中的后面的数据会依次传入show执行并被换行打出，
;; 直到index到5为止，最后打印出(show 5)的返回值5
(stream-ref x 7)
;; 控制台打印出的响应：
;; 6
;; 77
;; 为遍历到index为7的数据，流中的后面的数据会依次传入show执行,
;; 但是直到index为5的数据对show的执行结果在上一执行中已经存入延迟对象中了，
;; 所以只会换行打印出6和7，最后打印出(show 7)的返回值7
