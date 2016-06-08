                                        ;a
(define outline-painter
  (segments->painter (list
                     (make-segment (make-vect 0.0 0.0)
                                   (make-vect 1.0 0.0))
                     (make-segment (make-vect 1.0 0.0)
                                   (make-vect 1.0 1.0))
                     (make-segment (make-vect 1.0 1.0)
                                   (make-vect 0.0 1.0))
                     (make-segment (make-vect 0.0 1.0)
                                   (make-vect 0.0 0.0)))))

                                        ;b
(define cross-painter
  (segments->painter (list
                      (make-segment (make-vect 0.0 0.0)
                                    (make-vect 1.0 1.0))
                      (make-segment (make-vect 0.0 1.0)
                                    (make-vect 1.0 0.0)))))

                                        ;c
(define diamond-painter
  (segments->painter (list
                      (make-segment (make-vect 0.5 0.0)
                                    (make-vect 1.0 0.5))
                      (make-segment (make-vect 1.0 0.5)
                                    (make-vect 0.5 1.0))
                      (make-segment (make-vect 0.5 1.0)
                                    (make-vect 0.0 0.5))
                      (make-segment (make-vect 0.0 0.5)
                                    (make-vect 0.5 0.0)))))

                                        ;d
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
