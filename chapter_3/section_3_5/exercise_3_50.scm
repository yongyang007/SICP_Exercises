(add-load-path "./")
(load "stream.scm")

(define (stream-map proc . argstreams)
  (if (stream-null? (car argstreams))
      the-empty-stream
      (cons-stream
       (apply proc (map stream-car argstreams))
       (apply stream-map
              (cons proc (map stream-cdr argstreams))))))

(define stream1 (cons-stream 1 (cons-stream (+ 1 1) (cons-stream (+ 1 1 1) '()))))
(define stream2 (cons-stream 2 (cons-stream (+ 2 2) (cons-stream (+ 2 2 2) '()))))
(define stream3 (cons-stream 3 (cons-stream (+ 3 3) (cons-stream (+ 3 3 3) '()))))

(define stream-add (stream-map + stream1 stream2 stream3))
(display-stream stream-add)
