(define (make-segment start end)
  (cons start end))

(define (start-segment segment)
  (car segment))

(define (end-segemnt segment)
  (cdr segment))
