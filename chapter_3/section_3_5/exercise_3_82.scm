(add-load-path "./")
(load "stream.scm")
(add-load-path "../../tool/")
(load "random.scm")

(define (monte-carlo experiment-stream passed failed)
  (define (next passed failed)
    (cons-stream
     (/ passed (+ passed failed))
     (monte-carlo (stream-cdr experiment-stream) passed failed)))
  (if (stream-car experiment-stream)
      (next (+ passed 1) failed)
      (next passed (+ failed 1))))

(define (random-numbers-in-range low high)
  (cons-stream
     (let ((range (- high low)))
       (+ low (random range)))
     (random-numbers-in-range low high)))

(define (estimate-integral-stream P x1 x2 y1 y2)
  (stream-map (lambda (ratio)
                (* (- x2 x1)
                   (- y2 y1)
                   ratio))
              (monte-carlo (stream-map P
                                       (random-numbers-in-range x1 x2)
                                       (random-numbers-in-range y1 y2))
                           0
                           0)))

(define estimate-pi-stream
  (estimate-integral-stream (lambda (x y)
                              (<= (+ (square x) (square y)) 1))
                            -1.0
                            1.0
                            -1.0
                            1.0))

(stream-ref estimate-pi-stream 5000000)
