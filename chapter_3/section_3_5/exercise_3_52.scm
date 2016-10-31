(add-load-path "./")
(load "stream.scm")

(define sum 0)
(define (accum x)
  (set! sum (+ x sum))
  sum)

(add-load-path "../../tool/")
(load "enumerate-interval.scm")
(define sum-debug 0)
(define (accum-debug x)
  (set! sum-debug (+ x sum-debug))
  sum-debug)
(define seq-debug (map accum-debug (enumerate-interval 1 20)))
seq-debug
;; => (1 3 6 10 15 21 28 36 45 55 66 78 91 105 120 136 153 171 190 210)
(filter even? seq-debug)
;; => (6 10 28 36 66 78 120 136 190 210)
(filter (lambda (x) (= (remainder x 5) 0))
        seq-debug)
;; => (10 15 45 55 105 120 190 210)

(define seq (stream-map accum (stream-enumerate-interval 1 20)))
sum ; => 1

(define y (stream-filter even? seq))
sum ; => 6

(define z (stream-filter (lambda (x) (= (remainder x 5) 0))
                         seq))
sum ; => 10

(stream-ref y 7) ; => 136
sum ; => 136

(display-stream z)
;; 控制台打印出的响应：
;; 10
;; 15
;; 45
;; 55
;; 105
;; 120
;; 190
;; 210done
sum ; => 210


;; 如果不对同一延迟对象的结果进行保存：
(load "stream_without_memo.scm")

(define sum 0)

(define seq (stream-map accum (stream-enumerate-interval 1 20)))
sum ; => 1

(define sum-debug 1)
(define seq-debug (map accum-debug (enumerate-interval 2 20)))
seq-debug
;; => (3 6 10 15 21 28 36 45 55 66 78 91 105 120 136 153 171 190 210)

(define y (stream-filter even? seq))
sum ; => 6

(define sum-debug 6)
(define seq-debug (map accum-debug (enumerate-interval 2 20)))
seq-debug
;; => (8 11 15 20 26 33 41 50 60 71 83 96 110 125 141 158 176 195 215)

(define z (stream-filter (lambda (x) (= (remainder x 5) 0))
                         seq))
sum ; => 15

(define sum-debug 15)
(define seq-debug (map accum-debug (enumerate-interval 4 20)))
(filter even? seq-debug)
;; => (24 30 54 64 100 114 162 180)

(stream-ref y 7) ; => 162
sum ; => 162

(define sum-debug 162)
(define seq-debug (map accum-debug (enumerate-interval 5 20)))
seq-debug
;; => (167 173 180 188 197 207 218 230 243 257 272 288 305 323 342 362)
(filter (lambda (x) (= (remainder x 5) 0))
        seq-debug)
;; => (180 230 305)

(display-stream z)
;; 控制台打印出的响应：
;; 15
;; 180
;; 230
;; 305done
sum ; => 362

;; 可以看到由于没有进行优化，sum因为执行一个延迟对象多次而在不停的累加
;; 这里需要注意的是，在处理y和z时，执行accum的“起点”是不同的
