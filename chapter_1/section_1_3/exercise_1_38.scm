(load "./exercise_1_37.scm")

(+ (cont-frac (lambda (i) 1.0)
              (lambda (i)
                (if (= 0 (remainder (+ i 1) 3))
                    (* 2.0 (/ (+ i 1) 3))
                    1.0))
              21)
   2)
