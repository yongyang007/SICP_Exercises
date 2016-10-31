(add-load-path "./")
(load "stream.scm")

(define (partial-sums stream)
  (cons-stream (stream-car stream)
               (add-streams (partial-sums stream)
                            (stream-cdr stream))))

(sub-list (partial-sums integers)
          10)
