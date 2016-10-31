(add-load-path "./")
(load "exercise_3_60.scm")

(define (mul-inverse s)
  (cons-stream 1
               (mul-series (stream-map - (stream-cdr s))
                           (mul-inverse s))))

(define S cosine-series)
(define X (mul-inverse S))

(sub-list (mul-series S X) 10)
