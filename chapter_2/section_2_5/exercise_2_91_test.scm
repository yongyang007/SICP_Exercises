(add-load-path "./")
(load "generic_arithmetic_system.scm")

(define p1 (make-sparse-polynomial 'x '((5 1) (0 -1))))
(define p2 (make-sparse-polynomial 'x '((2 1) (0 -1))))

(div p1 p2)
