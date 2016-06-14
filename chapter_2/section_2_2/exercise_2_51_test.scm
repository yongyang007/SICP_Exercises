(add-load-path "./")
(load "exercise_2_51.scm")
(load "painter.scm")

(draw (lambda () ((below (flip-vert house) house) frame)))
