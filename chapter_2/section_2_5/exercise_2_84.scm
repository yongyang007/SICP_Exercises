(add-load-path "./")
(load "generic_arithmetic_system.scm")

(define tower-of-types '(integer rational real complex))

(define (level-in-tower type tower)
  (define (iter type-list result)
    (cond ((null? type-list) #f)
          ((eq? type (car type-list)) result)
          (else (iter (cdr type-list) (+ result 1)))))
  (iter tower 0))

(define (raise-times n x)
  (if (= n 0)
      x
      (raise-times (- n 1) (raise x))))

(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (apply proc (map contents args))
          (if (= (length args) 2)
              (let ((type1 (car type-tags))
                    (type2 (cadr type-tags)))
                (let ((t1 (level-in-tower type1 tower-of-types))
                      (t2 (level-in-tower type2 tower-of-types)))
                  (if (or (not t1)
                          (not t2)
                          (= t1 t2))
                      (error "No method for these types"
                             (list op type-tags))
                      (let ((a1 (car args))
                            (a2 (cadr args))
                            (delta (- t1 t2)))
                        (if (> delta 0)
                            (apply-generic op a1 (raise-times delta a2))
                            (apply-generic op (raise-times (abs delta) a1) a2))))))
              (error "No method for these types"
                     (list op type-tags)))))))

(define int-1 (make-integer 2.8))
(define rational-1 (make-rational 3 6))
(define real-1 (make-real 2))
(define complex-1 (make-complex-from-real-imag 3 7))

(add int-1 rational-1)
(add rational-1 real-1)
(add real-1 complex-1)
(add int-1 real-1)
(add rational-1 complex-1)
(add int-1 complex-1)
(add complex-1 int-1)
(add complex-1 rational-1)
