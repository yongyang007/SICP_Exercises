(add-load-path "./")
(load "generic_arithmetic_system.scm")

(define p1 (make-polynomial 'x '((2 10) (1 5))))
(define p2 (make-polynomial 'x '((3 2) (2 2))))
(define p3 (make-polynomial 'x '()))
(define p4 (make-polynomial 'x '((100 0) (0 0))))
(define p5 (make-polynomial 'y
                            (list (list 3 p2) (list 2 p1))))
(define p6 (make-polynomial 'y
                            (list (list 2 p2) (list 1 p1))))
(define p7 (make-polynomial 'y
                            (list (list 4 p3) (list 1 p1))))

(=zero? p1)
(=zero? p3)
(=zero? p4)

(add p1 p2)
(mul p4 p1)
(add p5 p6)
(mul p6 p7)
(add p1 p7)
