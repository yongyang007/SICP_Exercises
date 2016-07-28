(add-load-path "./")
(load "exercise_2_78.scm")
(load "coercion.scm")

(define (apply-generic op . args)
  (define (get-coercion-args type-tags)
    (if (null? type-tags)
        #f
        (let ((result-args (coercion-args (car type-tags) args)))
          (if result-args
              result-args
              (get-coercion-args (cdr type-tags))))))
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (apply proc (map contents args))
          (if (> (length args) 1)
              (if (same-types? type-tags)
                  (error "No method for there types"
                         (list op type-tags))
                  (let ((same-type-args (get-coercion-args type-tags)))
                    (if same-type-args
                        (apply apply-generic (cons op same-type-args))
                        (error "No method for there types"
                               (list op type-tags)))))
              (error "No method for these types"
                     (list op type-tags)))))))

(add-load-path "../../tool/")
(load "accumulate.scm")

(define (same-types? types)
  (let ((first (car types))
        (others (cdr types)))
    (accumulate (lambda (type result)
                  (and (eq? type first)
                       result))
                #t
                others)))

(define (coercion-args target-type-tag args)
  (define (merge first others)
    (if others
        (cons first others)
        #f))
  (if (null? args)
      '()
      (let ((type1 (type-tag (car args)))
            (type2 target-type-tag)
            (a (car args))
            (others (coercion-args target-type-tag (cdr args))))
        (if (eq? type1 type2)
            (merge a others)
            (let ((t1->t2 (get-coercion type1 type2)))
              (if t1->t2
                  (merge (t1->t2 a) others)
                  #f))))))

;; test
(define c1 (make-complex-from-real-imag 1 2))
(define r1 (make-rational 1 2))

(equal? '(complex complex) '(complex complex))

(add 1 c1 2)
(add c1 1 2)
(add 1 2 c1)
(add -1 c1)

(add 1 r1)
(add 1 r1 c1 2)
(add c1 2 3 4)
(add 1 2 3 4)

;; 可以看到，和上一题类似，
;; 在所有参数的类型都一样的时候（包括转换之后），
;; 也应该在表中找不到对应过程时抛出错误，
;; 否则也会和上一题那样陷入死循环。
