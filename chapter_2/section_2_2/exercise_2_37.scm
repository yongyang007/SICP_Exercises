(add-load-path "./")
(load "exercise_2_36.scm")

(define v1 (list 1 2 3 4))
(define v2 (list 5 6 7 8))
(define v3 (list 1 2))
(define v4 (list 3 4))
(define v5 (list 5 6))
(define v6 (list 7 8))
(define m1 (list v1 v2))
(define m2 (list v3 v4 v5 v6))

(define (dot-product v w)
  (accumulate + 0 (map * v w)))
(dot-product v1 v2)


(define (matrix-*-vector m v)
  (map (lambda (x) (dot-product x v)) m))
(matrix-*-vector m1 v1)

(define (transpose mat)
  (accumulate-n cons '() mat))
(transpose m1)

(define (matrix-*-matrix m n)
  (let ((cols (transpose n)))
    (map (lambda (x) (matrix-*-vector cols x)) m)))
(matrix-*-matrix m1 m2)
