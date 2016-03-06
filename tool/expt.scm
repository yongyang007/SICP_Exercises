(define (expt base n)
  ((repeated (lambda (x) (* base x)) n) 1))
