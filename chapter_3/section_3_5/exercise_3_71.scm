(add-load-path "./")
(load "exercise_3_70.scm")

(add-load-path "../../tool/")
(load "cube.scm")

(define (ramanujan-weight pair)
  (let ((i (car pair))
        (j (cadr pair)))
    (+ (cube i) (cube j))))

(define ramanujan-weighted-pairs
  (weighted-pairs integers integers ramanujan-weight))

(define (ramanujan-filter pairs)
  (let ((p1 (stream-car pairs))
        (p2 (stream-car (stream-cdr pairs))))
    (if (= (ramanujan-weight p1) (ramanujan-weight p2))
        (cons-stream p1
                     (ramanujan (stream-cdr (stream-cdr pairs))))
        (ramanujan (stream-cdr pairs)))))

(define ramanujan-pairs (ramanujan-filter ramanujan-weighted-pairs))

(define ramanujan-numbers
  (stream-map ramanujan-weight ramanujan-pairs))

(sub-list ramanujan-numbers 6)
