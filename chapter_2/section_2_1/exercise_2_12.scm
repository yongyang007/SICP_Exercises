(add-load-path "./")
(load "interval_arithmetic.scm")
(load "exercise_2_7.scm")

(define (make-center-percent c p)
  (let ((w (/ (* (abs c) p) 100)))
    (make-center-with c w)))

(define (percent i)
  (/ (* (width i) 100)
     (abs (center i))))

(define i (make-center-percent 73 4.5))
(center i)
(percent i)
