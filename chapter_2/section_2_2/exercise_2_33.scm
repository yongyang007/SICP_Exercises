(add-load-path "../../tool/")
(load "accumulate.scm")

(define (map p sequence)
  (accumulate (lambda (x y) (append (list (p x)) y)) '() sequence))
(map (lambda (x) (+ x 1)) (list 1 2 3 4 5))

(define (append seq1 seq2)
  (accumulate cons seq2 seq1))
(append (list 1 2 3) (list 4 5 6 7))

(define (length sequence)
  (accumulate (lambda (x y) (+ 1 y)) 0 sequence))
(length (list 1 2 3 4 5 6))
