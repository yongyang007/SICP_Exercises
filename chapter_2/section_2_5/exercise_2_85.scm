(add-load-path "./")
(load "exercise_2_84.scm")

(define (drop? x)
  (if (pair? x)
      (let ((level (level-in-tower (type-tag x) tower-of-types)))
        (if level
            (if (= level 0)
                #f
                (equ? x (raise (project x))))
            #f))
      #f))
(define (drop x) (project x))

(define (simplify value)
  (if (drop? value)
      (simplify (drop value))
      value))

;; 关于简化的问题，raise和project的结果不应该参与简化的,
;; 当然这些方法也可以不放在apply-generic中做处理
(define no-simplity '(raise project))

(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (let ((result (apply proc (map contents args))))
            (if (memq op no-simplity)
                result
                (simplify result)))
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

(define int-1 (make-integer 5))
(define rational-1 (make-rational 33 16))
(define rational-2 (make-rational 31 16))
(define rational-3 (make-rational 32 16))
(define real-1 (make-real 0.1875))
(define real-2 (make-real (/ 13 16)))
(define real-3 (make-real (/ 12 16)))
(define real-4 (make-real (/ 16 3)))
(define complex-1 (make-complex-from-real-imag 7 0))
(define complex-2 (make-complex-from-real-imag 7 1))
(define complex-3 (make-complex-from-real-imag 8 -1))

(project complex-1)
(project complex-2)
(project real-1)
(project rational-1)
(project rational-2)

(drop? complex-1)
(drop? complex-2)
(drop? real-1)
(drop? rational-1)
(drop? rational-3)
(drop? int-1)

(add complex-2 complex-3)
(add real-1 real-2)
(add real-1 real-3)
(mul real-1 real-2)
(div real-1 real-1)
(add rational-1 rational-2)
(div rational-2)
(mul rational-1 real-4)
