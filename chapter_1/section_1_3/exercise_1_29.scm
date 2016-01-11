(load "../../tool/cube.scm")
(load "./sum.scm")

(define (simpson-s-rule f a b n)
  (define h (* (/ (- b a) n) 1.0))
  (define (y k) (f (+ a (* k h))))
  (define (simpson-term x)
    (cond ((or (= x 0) (= x n)) (y x))
          ((odd? x) (* 4 (y x)))
          (else (* 2 (y x)))))
  (define (simpson-next x) (+ x 1))
  (*
   (/ h 3.0)
   (sum simpson-term 0 simpson-next n)))

(simpson-s-rule cube 0 1 100)
(simpson-s-rule cube 0 1 1000)
