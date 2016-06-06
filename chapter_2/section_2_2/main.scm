(use gl)
(use gl.glut)

(add-load-path "./")
(load "vector.scm")
(load "segment.scm")
(load "frame.scm")
(load "painter.scm")

(define (init)
  (gl-clear-color 1.0 1.0 1.0 1.0))

(define (disp)
  (gl-clear GL_COLOR_BUFFER_BIT)
  (gl-color 0.0 0.0 0.0 0.0)

  (house frame)

  (gl-flush))

(define (main args)
  (glut-init args)
  (glut-create-window "House")
  (glut-display-func disp)
  (init)
  (glut-main-loop)
  0)
