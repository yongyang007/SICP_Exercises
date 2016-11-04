(add-load-path "./")
(load "exercise_3_66.scm")

(define (pairs s t)
  (cons-stream
   (list (stream-car s) (stream-car t))
   (interleave
    (interleave
     (stream-map (lambda (x) (list (stream-car s) x))
                 (stream-cdr t))
     (stream-map (lambda (x) (list x (stream-car t)))
                 (stream-cdr s)))
    (pairs (stream-cdr s) (stream-cdr t)))))

(sub-list (pairs integers integers) 30)
