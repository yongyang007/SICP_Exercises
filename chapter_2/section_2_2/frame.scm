(define (make-frame origin edge1 edge2)
  (list origin edge1 edge2))

(define (frame-origin frame)
  (car frame))

(define (frame-edge1 frame)
  (cadr frame))

(define (frame-edge2 frame)
  (caddr frame))

(define (frame-coord-map frame)
  (lambda (v)
    (add-vect
     (frame-origin frame)
     (add-vect (scale-vect (xcor-vect v)
                           (frame-edge1 frame))
               (scale-vect (ycor-vect v)
                           (frame-edge2 frame))))))

(define frame (make-frame (make-vect 0 0)
                          (make-vect 1 0)
                          (make-vect 0 1)))
