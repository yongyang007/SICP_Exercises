(add-load-path "./")
(load "exercise_3_66.scm")

(define (triples s t u)
  (cons-stream (list (stream-car s) (stream-car t) (stream-car u))
               (interleave
                (stream-map (lambda (x) (cons (stream-car s) x))
                            (pairs (stream-cdr t) (stream-cdr u)))
                (triples (stream-cdr s) (stream-cdr t) (stream-cdr u)))))

(sub-list (triples integers integers integers) 30)

(define pythagorean-triples
  (stream-filter (lambda (t)
                   (let ((i (car t))
                         (j (cadr t))
                         (k (caddr t)))
                     (= (+ (square i) (square j))
                        (square k))))
                 (triples integers integers integers)))

(sub-list pythagorean-triples 5)
