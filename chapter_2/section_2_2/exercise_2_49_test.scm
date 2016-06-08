(add-load-path "./")
(load "painter.scm")
(load "exercise_2_49.scm")

(define outline
  (lambda (frame)
    (gl-color 0.0 1.0 0.0 1.0)
    (gl-line-width 5.0)
    (outline-painter frame)))
;(draw (lambda () (outline frame)))

(define cross
  (lambda (frame)
    (gl-color 1.0 0.0 0.0 1.0)
    (gl-line-width 10.0)
    (cross-painter frame)))
;(draw (lambda () (cross frame)))

(define diamond
  (lambda (frame)
    (gl-color 0.04313 0.1765 0.3922 1.0)
    (gl-line-width 5.0)
    (diamond-painter frame)))
;(draw (lambda () (diamond frame)))

(define wave
  (draw-black-line-painter wave-painter))
;(draw (lambda () (wave frame)))
