(add-load-path "./")
(load "stream.scm")

(define sense-data (cons-stream
                    1
                    (cons-stream
                     2
                     (cons-stream
                      1.5
                      (cons-stream
                       1
                       (cons-stream
                        0.5
                        (cons-stream
                         -0.1
                         (cons-stream
                          -2
                          (cons-stream
                           -3
                           (cons-stream
                            -2
                            (cons-stream
                             -0.5
                             (cons-stream
                              0.2
                              (cons-stream
                               3
                               (cons-stream
                                4
                                sense-data))))))))))))))

(define (sign-change-detector value last-value)
  (if (= value 0) (set! value 1))
  (if (= last-value 0) (set! last-value 1))
  (if (>= (* value last-value) 0)
      0
      (if (< value 0) -1 1)))
(define (make-zero-crossings input-stream last-value)
  (cons-stream
   (sign-change-detector (stream-car input-stream) last-value)
   (make-zero-crossings (stream-cdr input-stream)
                        (stream-car input-stream))))
(define zero-crossings
  (make-zero-crossings sense-data 0))

(sub-list zero-crossings 13)

(define zero-crossings
  (stream-map sign-change-detector sense-data (cons-stream 0 sense-data)))

(sub-list zero-crossings 13)
