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

                                        ;load filp-horiz, rotate180 and rotate270
(load "exercise_2_50.scm")

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
  (let ((split-point (make-vect 0.5 0.0)))
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
        (right frame)))))

(define (below painter1 painter2)
  (let ((split-point (make-vect 0.0 0.5)))
    (let ((paint-bottom
           (transform-painter painter1
                              (make-vect 0.0 0.0)
                              (make-vect 1.0 0.0)
                              split-point))
          (paint-top
           (transform-painter painter2
                              split-point
                              (make-vect 1.0 0.5)
                              (make-vect 0.0 1.0))))
      (lambda (frame)
        (paint-bottom frame)
        (paint-top frame)))))

(define house-painter
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

(define (draw-black-line-painter draw-painter)
  (lambda (frame)
    (gl-color 0.0 0.0 0.0 0.0)
    (draw-painter frame)))

(define house
  (draw-black-line-painter house-painter))

(define (draw painter-operation)
  (let ((op painter-operation))
    (define (disp)
      (gl-clear GL_COLOR_BUFFER_BIT)
      (op)
      (gl-flush))
    (glut-init '())
    (glut-init-display-mode GLUT_RGBA)
    (glut-init-window-size 666 666)
    (glut-create-window "Painter")
    (glut-display-func disp)
    (gl-clear-color 1.0 1.0 1.0 1.0)
    (glut-main-loop)))

(define wave-painter
  (segments->painter (list
                      (make-segment
                       (make-vect 0.006 0.840)
                       (make-vect 0.155 0.591))
                      (make-segment
                       (make-vect 0.006 0.635)
                       (make-vect 0.155 0.392))
                      (make-segment
                       (make-vect 0.304 0.646)
                       (make-vect 0.155 0.591))
                      (make-segment
                       (make-vect 0.298 0.591)
                       (make-vect 0.155 0.392))
                      (make-segment
                       (make-vect 0.304 0.646)
                       (make-vect 0.403 0.646))
                      (make-segment
                       (make-vect 0.298 0.591)
                       (make-vect 0.354 0.492))
                      (make-segment
                       (make-vect 0.403 0.646)
                       (make-vect 0.348 0.845))
                      (make-segment
                       (make-vect 0.354 0.492)
                       (make-vect 0.249 0.0))
                      (make-segment
                       (make-vect 0.403 0.0)
                       (make-vect 0.502 0.293))
                      (make-segment
                       (make-vect 0.502 0.293)
                       (make-vect 0.602 0.0))
                      (make-segment
                       (make-vect 0.348 0.845)
                       (make-vect 0.403 1.0))
                      (make-segment
                       (make-vect 0.602 1.0)
                       (make-vect 0.652 0.845))
                      (make-segment
                       (make-vect 0.652 0.845)
                       (make-vect 0.602 0.646))
                      (make-segment
                       (make-vect 0.602 0.646)
                       (make-vect 0.751 0.646))
                      (make-segment
                       (make-vect 0.751 0.646)
                       (make-vect 1.0 0.343))
                      (make-segment
                       (make-vect 0.751 0.0)
                       (make-vect 0.657 0.442))
                      (make-segment
                       (make-vect 0.657 0.442)
                       (make-vect 1.0 0.144)))))

(define wave
  (draw-black-line-painter wave-painter))
