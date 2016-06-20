(define (equal? a b)
  (cond ((not (or (pair? a) (pair? b)))
         (eq? a b))
        ((and (pair? a) (pair? b))
         (and (equal? (car a) (car b))
              (equal? (cdr a) (cdr b))))
        (else #f)))

(equal? '(this is a list) '(this is a list))

(equal? '(this is a list) '(this (is a) list))

(equal? '(1 2 3) '(1 2 3 4))

(equal? '(1 2 3) '(1 2 3))
