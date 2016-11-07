(add-load-path "./")
(load "stream.scm")
(load "integral_delay.scm")

(define (solve-2nd f y0 dy0 dt)
  (define y (integral (delay dy) y0 dt))
  (define dy (integral (delay ddy) dy0 dt))
  (define ddy (stream-map f dy y))
  y)

(stream-ref (solve-2nd (lambda (y dy) y) 1 1 0.001) 1000)
(stream-ref (solve-2nd (lambda (y dy) dy) 1 1 0.001) 1000)
