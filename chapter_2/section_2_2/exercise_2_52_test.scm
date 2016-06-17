(add-load-path "./")
(load "picture_language.scm")
(load "exercise_2_52.scm")

(draw (lambda () ((square-limit (corner-split wave 4)) frame)))
