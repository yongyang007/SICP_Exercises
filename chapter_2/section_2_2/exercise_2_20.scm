(load "./exercise_2_18.scm")

(define (same-parity x . items)
  (define (same-parity-iter origin target)
    (if (null? origin)
        target
        (let ((first-item (car origin))
              (others (cdr origin)))
          (if (same-parity? first-item x)
              (same-parity-iter others (cons first-item target))
              (same-parity-iter others target)))))
  (cons x (reverse (same-parity-iter items '()))))
(define (same-parity? a b)
  (even? (+ a b)))

(same-parity 1 2 3 4 5 6)
(same-parity 2 3 4 5 6 7)
