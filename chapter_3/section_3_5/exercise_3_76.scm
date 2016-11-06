(add-load-path "./")
(load "exercise_3_74.scm")

(define (smooth stream)
  (stream-map (lambda (a b)
                (/ (+ a b) 2))
              stream
              (cons-stream 0 stream)))

(define smoothed-data (smooth sense-data))
(sub-list smoothed-data 13)

(define zero-crossings
  (stream-map sign-change-detector smoothed-data (cons-stream 0 smoothed-data)))

(sub-list zero-crossings 13)
