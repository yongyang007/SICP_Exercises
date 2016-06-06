                                        ;递归运算过程
(define (accumulate combiner null-value term a next b)
  (if (> a b)
      null-value
      (combiner (term a)
                (accumulate combiner null-value term (next a) next b))))

(add-load-path "./")
(load "exercise_1_31.scm")

(define (sum term a next b)
  (accumulate + 0 term a next b))
                                        ;test
(sum square 1 add-one 5)

(define (product term a next b)
  (accumulate * 1 term a next b))
                                        ;test
(product square 1 add-one 3)

                                        ;迭代运算过程
(define (accumulate combiner null-value term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (iter (next a) (combiner (term a) result))))
  (iter a null-value))
