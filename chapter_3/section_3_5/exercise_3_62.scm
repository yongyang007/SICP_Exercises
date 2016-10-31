(add-load-path "./")
(load "exercise_3_61.scm")

(define (div-series s1 s2)
  (if (= (stream-car s2) 0)
      (error "attempt to calculate a series division which has a zero constant term")
      (mul-series s1
                  (mul-inverse s2))))

(define tangent-series (div-series sine-series cosine-series))

(sub-list tangent-series 10)
