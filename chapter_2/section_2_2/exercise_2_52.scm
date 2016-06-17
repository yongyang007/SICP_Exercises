                                        ;a
(define wave
  (draw-black-line-painter
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
                        (make-vect 1.0 0.144))
                       (make-segment
                        (make-vect 0.418 0.888)
                        (make-vect 0.475 0.866))
                       (make-segment
                        (make-vect 0.582 0.888)
                        (make-vect 0.525 0.866))
                       (make-segment
                        (make-vect 0.433 0.822)
                        (make-vect 0.5 0.79))
                       (make-segment
                        (make-vect 0.567 0.822)
                        (make-vect 0.5 0.79))))))

                                        ;b
(define (corner-split painter n)
  (if (= n 0)
      painter
      (let ((up (up-split painter (- n 1)))
            (right (right-split painter (- n 1))))
        (let ((top-left (identity up))
              (bottom-right (identity right))
              (corner (corner-split painter (- n 1))))
          (beside (below painter top-left)
                  (below bottom-right corner))))))

                                        ;c
(define (square-limit painter)
  (let ((combine4 (square-of-four flip-vert rotate180
                                  identity flip-horiz)))
    (combine4 painter)))
