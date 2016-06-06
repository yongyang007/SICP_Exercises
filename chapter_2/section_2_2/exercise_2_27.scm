(add-load-path "./")
(load "exercise_2_18.scm")

(define x (list (list 1 2) (list 3 4)))

(reverse x)

(define (deep-reverse items)
  (define (iter origin result)
    (if (null? origin)
        result
        (let ((first-item (car origin))
              (others (cdr origin)))
          (if (pair? first-item)
              (iter others
                    (cons (deep-reverse first-item)
                          result))
              (iter others
                    (cons first-item result))))))
  (iter items '()))

(deep-reverse x)

(define y (list 1 2 (list 3 (list 4 5 6) 7 8) 9 (list 10 11)))

(deep-reverse y)
