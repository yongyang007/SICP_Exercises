(add-load-path "./")
(load "stream.scm")
(load "integral_delay.scm")

(define (RLC R L C dt)
  (lambda (vC0 iL0)
    (define vC (integral (delay (scale-stream iL (/ -1 C))) vC0 dt))
    (define iL (integral (delay diL) iL0 dt))
    (define diL (add-streams
                 (scale-stream vC (/ 1 L))
                 (scale-stream iL (/ (- R) L))))
    (cons vC iL)))

(define RLC1 (RLC 1 1 0.2 0.1))

(define vC-iL (RLC1 10 0))

(sub-list (car vC-iL) 10)
(sub-list (cdr vC-iL) 10)
