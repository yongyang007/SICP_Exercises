(add-load-path "./")
(load "painter.scm")
(load "exercise_2_49.scm")

(define (outline frame)
  (draw (draw-black-line-painter outline-painter)
        frame
        (lambda ()
          (gl-clear-color 1.0 1.0 1.0 1.0)
          (gl-line-width 5.0))))
;(outline frame)

(define (cross frame)
  (draw (lambda (frame)
          (gl-color 1.0 0.0 0.0 1.0)
          (cross-painter frame))
        frame
        (lambda ()
          (gl-clear-color 1.0 1.0 1.0 1.0)
          (gl-line-width 10.0))))
;(cross frame)

(define (diamond frame)
  (draw (lambda (frame)
          (gl-color 0.04313 0.1765 0.3922 1.0)
          (diamond-painter frame))
        frame
        (lambda ()
          (gl-clear-color 1.0 1.0 1.0 1.0)
          (gl-line-width 5.0))))
;(diamond frame)

(define (wave frame)
  (draw (draw-black-line-painter wave-painter)
        frame
        (lambda ()
          (gl-clear-color 1.0 1.0 1.0 1.0))))
(wave frame)
