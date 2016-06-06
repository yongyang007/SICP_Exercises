(add-load-path "./")
(load "rect_1.scm")

(define (perimeter-rect r)
  (* (+ (height-rect r)
        (width-rect r))
     2))
(define (area-rect r)
  (* (height-rect r)
     (width-rect r)))

(define p1 (make-point 3 1))
(define p2 (make-point 3 -1))
(define p3 (make-point 5 -1))

(define rect1 (make-rect p1 p2 p3))
(perimeter-rect rect1)
(area-rect rect1)

(load "rect_2.scm")

(define p4 (make-point 5 1))

(define s1 (make-segment p1 p4))
(define s2 (make-segment p1 p2))

(define rect1 (make-rect s1 s2))
(perimeter-rect rect1)
(area-rect rect1)
