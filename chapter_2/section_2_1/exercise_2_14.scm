(add-load-path "./")
(load "exercise_2_12.scm")

(define A (make-center-percent 20 2))
(define B (make-center-percent 10 1))

(define A/A (div-interval A A))
A/A ; => (0.9607843137254903 . 1.040816326530612)
(center A/A) ;=> 1.000800320128051
(percent A/A) ;=> 3.9984006397440868
(define A/B (div-interval A B))
A/B ;=> (1.9405940594059408 . 2.0606060606060606)
(center A/B) ;=> 2.0006000600060005
(percent A/B) ;=> 2.9994001199759994
                                        ;可以看出除法使误差累计
