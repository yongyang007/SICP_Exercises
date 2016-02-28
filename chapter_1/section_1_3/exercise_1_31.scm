(define (product term a next b)
  (if (> a b)
      1
      (* (term a)
         (product term (next a) next b))))
                                        ;递归计算过程
(define (add-one x) (+ x 1))
(define (prototype x) x)
(define (factorial n)
  (product prototype 1 add-one n))

(load "../../tool/square.scm")
(define (pi)
  (define (term-john x) (/ (* 4 (square x))
                           (- (* 4 (square x)) 1)))
  (* 2.0
     (product term-john 1 add-one 1000)))

(define (product term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (iter (next a) (* (term a) result))))
  (iter a 1))
                                        ;迭代计算过程
