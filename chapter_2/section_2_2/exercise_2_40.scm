(load "../../tool/accumulate.scm")
(load "../../tool/flatmap.scm")
(load "../../tool/enumerate-interval.scm")

(define (unique-pairs n)
  (flatmap (lambda (i)
             (map (lambda (j) (list i j))
                  (enumerate-interval 1 (- i 1))))
           (enumerate-interval 1 n)))

(unique-pairs 6)

(define (make-pair-sum pair)
  (list (car pair) (cadr pair) (+ (car pair) (cadr pair))))

(map make-pair-sum (unique-pairs 4))

(load "../../tool/square.scm")
(load "../../tool/prime.scm")

(define (prime-sum? pair)
  (prime? (+ (car pair) (cadr pair))))

(prime-sum? (list 1 2))
(prime-sum? (list 1 3))

(define (prime-sum-pairs n)
  (map make-pair-sum
       (filter prime-sum?
               (unique-pairs n))))
(prime-sum-pairs 6)
