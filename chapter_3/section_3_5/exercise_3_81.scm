(add-load-path "./")
(load "stream.scm")

(define (rand-update x)
  (remainder (+ x 1812433253) 4294967296))

(define random-init 1)

(define (random-numbers request-stream)
  (define (rand number request)
    (cond ((eq? request 'generate)
           (rand-update number))
          ((number? request)
           request)
          (else (error "Unknow request -- RAND" request))))
  (define random-stream
    (cons-stream (rand random-init (stream-car request-stream))
                 (stream-map rand
                             random-stream
                             (stream-cdr request-stream))))
  random-stream)

(define generate-stream (cons-stream 'generate generate-stream))

(define requests
  (cons-stream 99999
               (cons-stream 'generate
                            (cons-stream 'generate
                                         (cons-stream 'generate
                                                      (cons-stream 99
                                                                   generate-stream))))))

(define randoms (random-numbers requests))

(sub-list randoms 10)
