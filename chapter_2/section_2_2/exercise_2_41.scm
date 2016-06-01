(load "./exercise_2_40.scm")

(define (unique-triples n)
  (flatmap (lambda (i)
             (map (lambda (j)
                    (cons i j))
                  (unique-pairs (- i 1))))
           (enumerate-interval 1 n)))
(unique-triples 5)

(define (sum-equal? sum triple)
  (= sum (accumulate + 0 triple)))
(sum-equal? 10 (list 2 3 5))
(sum-equal? 10 (list 3 4 5))

(define (sum-equal-triples s n)
  (filter (lambda (t)
            (sum-equal? s t))
          (unique-triples n)))

(sum-equal-triples 10 13)
