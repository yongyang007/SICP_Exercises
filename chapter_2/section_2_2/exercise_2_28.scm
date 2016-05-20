(define x (list 1 2 3 4))

(define (fringe tree)
  (cond ((null? tree) '())
        ((not (pair? tree)) (list tree))
        (else (append (fringe (car tree))
                      (fringe (cdr tree))))))

(fringe (list x x))

(fringe (list 1 2 (list 3 (list 4 5 6) 7 8 (list 9 10)) 11 12))
