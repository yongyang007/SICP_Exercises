(load "./exercise_2_2.scm")
                                        ;用两条线段定义
                                        ;     s1
                                        ;   o----o
                                        ; s2|    |
                                        ;   o----o
(define (make-rect s1 s2)
  (cons s1 s2))
(define (height-rect r)
  (let ((s2 (cdr r)))
    (abs (- (y-point (start-segment s2))
            (y-point (end-segment s2))))))
(define (width-rect r)
  (let ((s1 (car r)))
    (abs (- (x-point (start-segment s1))
            (x-point (end-segment s1))))))
