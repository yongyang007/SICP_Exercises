(define (print-point p)
  (newline)
  (display "(")
  (display (x-point p))
  (display ",")
  (display (y-point p))
  (display ")"))

(define (make-segment start end)
  (cons start end))
(define (start-segment s)
  (car s))
(define (end-segment s)
  (cdr s))

(define (make-point x y)
  (cons x y))
(define (x-point p)
  (car p))
(define (y-point p)
  (cdr p))

(define (midpoint-segment s)
  (define (average a b) (/ (+ a b) 2))
  (let ((mid-x (average (x-point (start-segment s)) (x-point (end-segment s))))
        (mid-y (average (y-point (start-segment s)) (y-point (end-segment s)))))
    (make-point mid-x mid-y)))

(define a-point (make-point 1 2))
(define b-point (make-point 2 3))
(define a-segment (make-segment a-point b-point))
(print-point (midpoint-segment a-segment))