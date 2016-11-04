(add-load-path "./")
(load "stream.scm")

(define (merge-weighted s1 s2 weight)
  (cond ((stream-null? s1) s2)
        ((stream-null? s2) s1)
        (else
         (let ((s1car (stream-car s1))
               (s2car (stream-car s2)))
           (cond ((< (weight s1car) (weight s2car))
                  (cons-stream s1car
                               (merge-weighted (stream-cdr s1) s2 weight)))
                 ((> (weight s1car) (weight s2car))
                  (cons-stream s2car
                               (merge-weighted s1 (stream-cdr s2) weight)))
                 (else
                  (cons-stream s1car
                               (cons-stream s2car
                                            (merge-weighted (stream-cdr s1)
                                                            (stream-cdr s2)
                                                            weight)))))))))

(define (weighted-pairs s t weight)
  (cons-stream
   (list (stream-car s) (stream-car t))
   (merge-weighted
    (stream-map (lambda (x) (list (stream-car s) x))
                (stream-cdr t))
    (weighted-pairs (stream-cdr s) (stream-cdr t) weight)
    weight)))

;; a)
(define pairs1 (weighted-pairs integers
                               integers
                               (lambda (pair)
                                 (let ((i (car pair))
                                       (j (cadr pair)))
                                   (+ i j)))))
(sub-list pairs1 30)

;; b)
(define pairs2 (weighted-pairs integers
                               integers
                               (lambda (pair)
                                 (let ((i (car pair))
                                       (j (cadr pair)))
                                   (+ (* 2 i)
                                      (* 3 j)
                                      (* 5 i j))))))
(sub-list pairs2 30)
