(load "./exercise_2_38.scm")

(define (reverse sequence)
  (fold-right (lambda (x y) (append y (list x))) '() sequence))
(reverse (list 1 2 3 4))

(define (reverse sequence)
  (fold-left (lambda (x y) (cons y x)) '() sequence))
(reverse (list 4 3 2 1))
