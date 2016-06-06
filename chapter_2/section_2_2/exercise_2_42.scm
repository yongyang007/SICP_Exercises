(add-load-path "../../tool/")
(load "flatmap.scm")
(load "enumerate-interval.scm")

(define (queens board-size)
  (define (queen-cols k)
    (if (= k 0)
        (list empty-board)
        (filter
         (lambda (positions) (safe? k positions))
         (flatmap
          (lambda (rest-of-queens)
            (map (lambda (new-row)
                   (adjoin-position new-row k rest-of-queens))
                 (enumerate-interval 1 board-size)))
          (queen-cols (- k 1))))))
  (queen-cols board-size))

(define (make-position row col) (list row col))
(define (position-row position) (car position))
(define (position-col position) (cadr position))
(define (adjoin-position row col positions)
  (cons (make-position row col) positions))
(define empty-board '())
(define (safe? k positions)
  (null?
   (filter (lambda (row) (= row (position-row (car positions))))
           (append
            (map position-row (cdr positions))
            (flatmap
             (lambda (position)
               (list (+ (position-row position) (- k (position-col position)))
                     (- (position-row position) (- k (position-col position)))))
             (cdr positions))))))

(length (queens 1))
(length (queens 2))
(length (queens 3))
(length (queens 4))
(length (queens 5))
(length (queens 6))
(length (queens 7))
(length (queens 8))
