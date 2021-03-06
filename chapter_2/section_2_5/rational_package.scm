(define (install-rational-package)
  ;; internal procedures
  (define (numer x) (car x))
  (define (denom x) (cdr x))
  (define (make-rat n d)
    (let ((g (gcd n d)))
      (cons (/ n g) (/ d g))))
  (define (add x y)
    (make-rat (+ (* (numer x) (denom y))
                 (* (numer y) (denom x)))
              (* (denom x) (denom y))))
  (define (sub x y)
    (make-rat (- (* (numer x) (denom y))
                 (* (numer y) (denom x)))
              (* (denom x) (denom y))))
  (define (mul x y)
    (make-rat (* (numer x) (numer y))
              (* (denom x) (denom y))))
  (define (div x y)
    (make-rat (* (numer x) (denom y))
              (* (denom x) (numer y))))
  ;; exercise 2.79
  (define (equ? x y)
    (and (= (numer x) (numer y))
         (= (denom x) (denom y))))
  ;; exercise 2.80
  (define (=zero? x)
    (= (numer x) 0))
  ;; exercise 2.85
  (define (project x)
    (make-integer (floor->exact (/ (numer x) (denom x)))))
  ;; interface to rest of the system
  (define (tag x) (attach-tag 'rational x))
  (put 'add
       '(rational rational)
       (lambda (x y) (tag (add x y))))
  (put 'sub
       '(rational rational)
       (lambda (x y) (tag (sub x y))))
  (put 'mul
       '(rational rational)
       (lambda (x y) (tag (mul x y))))
  (put 'div
       '(rational rational)
       (lambda (x y) (tag (div x y))))
  (put 'make
       'rational
       (lambda (n d) (tag (make-rat n d))))
  ;; exercise 2.79
  (put 'equ?
       '(rational rational)
       equ?)
  ;; exercise 2.80
  (put '=zero?
       '(rational)
       =zero?)
  ;; exercise 2.83
  (put 'raise
       '(rational)
       (lambda (x) (make-real (/ (numer x) (denom x)))))
  ;; exercise 2.85
  (put 'project '(rational) project)
  ;; exercise 2.88
  (put 'negation
       '(rational)
       (lambda (x) (tag (make-rat (- (numer x))
                                  (denom x)))))
  'done)

(define (make-rational n d)
  ((get 'make 'rational) n d))
