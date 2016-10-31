(add-load-path "./")
(load "stream.scm")

;; a)
(define (div-streams s1 s2)
  (stream-map / s1 s2))

(define (integrate-series power-series)
  (div-streams power-series integers))

(sub-list (integrate-series ones) 10)

;; b)
(define exp-series
  (cons-stream 1 (integrate-series exp-series)))
(sub-list exp-series 10)

(define cosine-series
  (cons-stream 1 (integrate-series (stream-map - sine-series))))

(define sine-series
  (cons-stream 0 (integrate-series cosine-series)))

(sub-list cosine-series 10)
(sub-list sine-series 10)
