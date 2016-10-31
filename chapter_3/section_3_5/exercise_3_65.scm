(add-load-path "./")
(load "stream.scm")

(define ln2-summands (stream-map
                      (lambda (n)
                        (/ ((if (odd? n) + -) 1.0) n))
                      integers))
(sub-list ln2-summands 10)

(define ln2-stream (partial-sums ln2-summands))

(sub-list ln2-stream 10)
(sub-list (euler-transfrom ln2-stream) 10)
(sub-list (accelerated-sequence euler-transfrom
                                ln2-stream)
          10)
