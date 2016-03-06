(load "./exercise_1_42.scm")

(define (repeated f n)
  (define (iter result i)
    (if (= i 0)
        result
        (iter (compose f result)
              (- i 1))))
  (iter (lambda (x) x) n))

((repeated square 2) 5)
