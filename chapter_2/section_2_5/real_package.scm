(define (install-real-package)
  (define (tag x)
    (attach-tag 'real x))
  ;; internal procedures
  ;; exercise 2.85
  (define (project x)
    (define (iter rational real n)
      (if (= real 0)
          rational
          (let ((int-part (floor->exact real)))
            (iter
             (apply-generic 'add
                            rational
                            (make-rational int-part (expt 10 n)))
             (* 10 (- real int-part))
             (+ n 1)))))
    (iter (make-rational 0 1) x 0))
  ;; interface to rest of system
  (put 'add
       '(real real)
       (lambda (x y) (tag (+ x y))))
  (put 'sub
       '(real real)
       (lambda (x y) (tag (- x y))))
  (put 'mul
       '(real real)
       (lambda (x y) (tag (* x y))))
  (put 'div
       '(real real)
       (lambda (x y) (tag (/ x y))))
  (put 'make
       'real
       (lambda (x) (tag (* x 1.0))))
  (put 'equ?
       '(real real)
       =)
  (put '=zero?
       '(real)
       (lambda (x) (= x 0)))
  ;; exercise 2.83
  (put 'raise
       '(real)
       (lambda (x) (make-complex-from-real-imag x 0)))
  ;; exercise 2.85
  (put 'project '(real) project)
  ;; exercise 2.86
  (put 'sine
       '(real)
       (lambda (x) (tag (sin x))))
  (put 'cosine
       '(real)
       (lambda (x) (tag (cos x))))
  (put 'arctan
       '(real real)
       (lambda (y x) (tag (atan y x))))
  (put 'square
       '(real)
       (lambda (x) (tag (* x x))))
  (put 'square-root
       '(real)
       (lambda (x) (tag (sqrt x))))
  ;; exercise 2.88
  (put 'negation
       '(real)
       (lambda (x) (tag (- x))))
  'done)

(define (make-real n)
  ((get 'make 'real) n))
