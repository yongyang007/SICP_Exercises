(define (rand-update x)
  (remainder (+ x 1812433253) 4294967296))

(define random-init 1)

(define rand
  (let ((x random-init))
    (lambda (m)
      (cond ((eq? m 'generate)
             (set! x (rand-update x))
             x)
            ((eq? m 'reset)
             (lambda (new-value)
               (set! x new-value)
               x))
            (else (error "Unknow request -- RAND"
                         m))))))

(rand 'generate)
((rand 'reset) 99999999)
