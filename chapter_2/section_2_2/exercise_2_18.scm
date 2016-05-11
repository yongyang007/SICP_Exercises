(define (reverse items)
  (define (reverse-iter origin target)
    (if (null? origin)
        target
        (reverse-iter (cdr origin)
                      (cons (car origin)
                            target))))
  (reverse-iter items '()))

(reverse (list 5 4 3 2 1))
