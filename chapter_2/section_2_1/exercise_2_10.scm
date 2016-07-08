(define (div-interval x y)
  (if (< (* (upper-bound y) (lower-bound y)) 0)
      (error "error to divide by an interval that spans zero -- DIV_INTERVAL" y)
      (mul-interval x
                    (make-interval (/ 1.0 (upper-bound y))
                                   (/ 1.0 (lower-bound y))))))
