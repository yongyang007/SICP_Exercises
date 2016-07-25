(add-load-path "../section_2_4/")
(load "put_and_get.scm")
(load "tagged_data.scm")

(define (add x y) (apply-generic 'add x y))
(define (sub x y) (apply-generic 'sub x y))
(define (mul x y) (apply-generic 'mul x y))
(define (div x y) (apply-generic 'div x y))
;; exercise 2.79
(define (equ? x y) (apply-generic 'equ? x y))
;; exercise 2.80
(define (=zero? x) (apply-generic '=zero? x))

(add-load-path "./")
(load "scheme_number_package.scm")
(load "rational_package.scm")
(load "complex_package.scm")

(install-scheme-number-package)
(install-rational-package)
(install-complex-package)

(define s1 (make-scheme-number 1))
(define s2 (make-scheme-number 2))

(define r1 (make-rational 1 2))
(define r2 (make-rational 3 6))

(define c1 (make-complex-from-real-imag 1 2))
(define c2 (make-complex-from-real-imag 3 4))
(define c3 (make-complex-from-mag-ang 5 6))
(define c4 (make-complex-from-mag-ang 7 8))

(add s1 s2)
(sub s1 s2)
(mul s1 s2)
(div s1 s2)

(add r1 r2)
(sub r1 r2)
(mul r1 r2)
(div r1 r2)

(add c1 c2)
(sub c1 c2)
(mul c3 c4)
(div c3 c4)
