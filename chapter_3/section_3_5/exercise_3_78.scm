(add-load-path "./")
(load "stream.scm")
(load "integral_delay.scm")

(define (solve-2nd y0 dy0 a b dt)
  (define y (integral (delay dy) y0 dt))
  (define dy (integral (delay ddy) dy0 dt))
  (define ddy
    (add-streams (scale-stream dy a)
                 (scale-stream y b)))
  y)

(stream-ref (solve-2nd 1 1 0 1 0.001) 1000)
(stream-ref (solve-2nd 1 1 2 -1 0.001) 1000)
(stream-ref (solve-2nd 1 1 1 0 0.001) 1000)
