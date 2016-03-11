(load "./exercise_2_2.scm")
                                        ;用三个顶点定义
                                        ;  p1---o
                                        ;   |   |
                                        ;  p2---p3
(define (make-rect p1 p2 p3)
  (cons (cons p1 p2)
        p3))
(define (height-rect r)
  (let ((p1 (caar r))
        (p2 (cdar r)))
    (abs (- (y-point p1)
            (y-point p2)))))
(define (width-rect r)
  (let ((p2 (cdar r))
        (p3 (cdr r)))
    (abs (- (x-point p2)
            (x-point p3)))))
