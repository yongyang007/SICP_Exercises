(define (f a b c)
  (cond ((and (> a c) (> b c)) (+ a b))
        ((and (> a b) (> c b)) (+ a c))
        (else (+ b c))))

(f 2 7 3) ;10
