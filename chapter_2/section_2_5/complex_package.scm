(add-load-path "./")
(load "rectangular_package.scm")
(load "polar_package.scm")

(install-rectangular-package)
(install-polar-package)

(define (install-complex-package)
  ;; imported procedures from rectangular and polar packages)
  (define (make-from-real-imag x y)
    ((get 'make-from-real-imag 'rectangular) x y))
  (define (make-from-mag-ang r a)
    ((get 'make-from-mag-ang 'polar) r a))
  ;; internal procedures
  (define (add z1 z2)
    (make-from-real-imag (+ (real-part z1) (real-part z2))
                         (+ (imag-part z1) (imag-part z2))))
  (define (sub z1 z2)
    (make-from-real-imag (- (real-part z1) (real-part z2))
                         (- (imag-part z1) (imag-part z2))))
  (define (mul z1 z2)
    (make-from-mag-ang (* (magnitude z1) (magnitude z2))
                       (+ (angle z1) (angle z2))))
  (define (div z1 z2)
    (make-from-mag-ang (/ (magnitude z1) (magnitude z2))
                       (- (angle z1) (angle z2))))
  ;; exercise 2.79
  (define (equ? z1 z2)
    (and (= (real-part z1) (real-part z2))
         (= (imag-part z1) (imag-part z2))))
  ;; exercise 2.79
  ;; (define (equ? z1 z2)
  ;;   (and (= (magnitude z1) (magnitude z2))
  ;;        (= (angle z1) (angle z2))))
  ;; exercise 2.80
  (define (=zero? z)
    (= (magnitude z) 0))
  ;; exercise 2.85
  (define (project z)
    (make-real (real-part z)))
  ;; interface to rest of system
  (define (tag z) (attach-tag 'complex z))
  (put 'add
       '(complex complex)
       (lambda (z1 z2) (tag (add z1 z2))))
  (put 'sub
       '(complex complex)
       (lambda (z1 z2) (tag (sub z1 z2))))
  (put 'mul
       '(complex complex)
       (lambda (z1 z2) (tag (mul z1 z2))))
  (put 'div
       '(complex complex)
       (lambda (z1 z2) (tag (div z1 z2))))
  (put 'make-from-real-imag
       'complex
       (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang
       'complex
       (lambda (r a) (tag (make-from-mag-ang r a))))
  (put 'real-part '(complex) real-part)
  (put 'imag-part '(complex) imag-part)
  (put 'magnitude '(complex) magnitude)
  (put 'angle '(complex) angle)
  ;; exercise 2.79
  (put 'equ?
       '(complex complex)
       equ?)
  ;; exercise 2.80
  (put '=zero?
       '(complex)
       =zero?)
  ;; for exercise 2.82
  (put 'add
       '(complex complex complex)
       (lambda (z1 z2 z3)
         (tag (add (add z1 z2) z3))))
  ;; exercise 2.85
  (put 'project '(complex) project)
  ;; exercise 2.88
  (put 'negation
       '(complex)
       (lambda (x) (tag (make-from-real-imag (- (real-part x))
                                             (- (imag-part x))))))
  'done)

(define (make-complex-from-real-imag x y)
  ((get 'make-from-real-imag 'complex) x y))
(define (make-complex-from-mag-ang r a)
  ((get 'make-from-mag-ang 'complex) r a))

(define (real-part z) (apply-generic 'real-part z))
(define (imag-part z) (apply-generic 'imag-part z))
(define (magnitude z) (apply-generic 'magnitude z))
(define (angle z) (apply-generic 'angle z))
