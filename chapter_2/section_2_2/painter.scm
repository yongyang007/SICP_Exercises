(use gl)
(use gl.glut)

(add-load-path "./")
(load "vector.scm")
(load "segment.scm")
(load "frame.scm")

(define (draw-line p1 p2)
  (define (t z) (- (* 2 z) 1)) ;因为坐标原点在画布中心
  (gl-begin GL_LINE_LOOP)
  (gl-vertex (t (xcor-vect p1)) (t (ycor-vect p1)))
  (gl-vertex (t (xcor-vect p2)) (t (ycor-vect p2)))
  (gl-end))

(define (segments->painter segment-list)
  (lambda (frame)
    (for-each
     (lambda (segment)
       (draw-line
        ((frame-coord-map frame) (start-segment segment))
        ((frame-coord-map frame) (end-segemnt segment))))
     segment-list)))

(define (transform-painter painter origin corner1 corner2)
  (lambda (frame)
    (let ((m (frame-coord-map frame)))
      (let ((new-origin (m origin)))
        (painter
         (make-frame new-origin
                     (sub-vect (m corner1) new-origin)
                     (sub-vect (m corner2) new-origin)))))))

(define (flip-vert painter)
  (transform-painter painter
                     (make-vect 0.0 1.0)
                     (make-vect 1.0 1.0)
                     (make-vect 0.0 0.0)))

(define (shrink-to-upper-right painter)
  (transform-painter painter
                     (make-vect 0.5 0.5)
                     (make-vect 1.0 0.5)
                     (make-vect 0.5 1.0)))

(define (rotate90 painter)
  (transform-painter painter
                     (make-vect 1.0 0.0)
                     (make-vect 1.0 1.0)
                     (make-vect 0.0 0.0)))

(define (squash-inwards painter)
  (transform-painter painter
                     (make-vect 0.0 0.0)
                     (make-vect 0.65 0.35)
                     (make-vect 0.35 0.65)))

(define (beside painter1 painter2)
  (let ((left (transform-painter painter1
                                 (make-vect 0.0 0.0)
                                 (make-vect 0.5 0.0)
                                 (make-vect 0.0 1.0)))
        (right (transform-painter painter2
                                  (make-vect 0.5 0.0)
                                  (make-vect 1.0 0.0)
                                  (make-vect 0.5 1.0))))
    (lambda (frame)
      (left frame)
      (right frame))))

(define draw-house
  (segments->painter (list
                      (make-segment (make-vect 0.5 1.0)
                                    (make-vect 0.0 0.5))
                      (make-segment (make-vect 0.0 0.5)
                                    (make-vect 0.2 0.5))
                      (make-segment (make-vect 0.2 0.5)
                                    (make-vect 0.2 0.0))
                      (make-segment (make-vect 0.2 0.0)
                                    (make-vect 0.8 0.0))
                      (make-segment (make-vect 0.8 0.0)
                                    (make-vect 0.8 0.5))
                      (make-segment (make-vect 0.8 0.5)
                                    (make-vect 1.0 0.5))
                      (make-segment (make-vect 1.0 0.5)
                                    (make-vect 0.8 0.7))
                      (make-segment (make-vect 0.8 0.7)
                                    (make-vect 0.8 0.9))
                      (make-segment (make-vect 0.8 0.9)
                                    (make-vect 0.7 0.9))
                      (make-segment (make-vect 0.7 0.9)
                                    (make-vect 0.7 0.8))
                      (make-segment (make-vect 0.7 0.8)
                                    (make-vect 0.5 1.0)))))

(define (house frame)
  (draw draw-house frame))

(define (draw draw-func frame)
  (let ((draw-func draw-func)
        (frame frame))
    (define (disp)
      (gl-clear GL_COLOR_BUFFER_BIT)
      (gl-color 0.0 0.0 0.0 0.0)
      (draw-house frame)
      (gl-flush))
    (define (init)
      (gl-clear-color 1.0 1.0 1.0 1.0))
    (glut-init '())
    (glut-init-display-mode GLUT_RGBA)
    (glut-create-window "Painter")
    (glut-display-func disp)
    (init)
    (glut-main-loop)))
