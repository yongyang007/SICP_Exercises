(add-load-path "../../chapter_2/section_2_2")
(load "exercise_2_42.scm")

(define (queens board-size)
  (define (iter k solution)
    (if (= k board-size)
        solution
        (let ((new-row (apply amb (enumerate-interval 1 board-size))))
          (let ((positions (adjoin-position new-row k solvtion)))
            (require (safe? k positions))
            (iter (+ k 1) positions)))))
  (iter 0 '()))

;; TODO: 验证
