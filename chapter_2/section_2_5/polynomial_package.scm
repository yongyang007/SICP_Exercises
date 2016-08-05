;; modify for exercise 2.90
(add-load-path "./")
(load "sparse_package.scm")
(load "dense_package.scm")
(install-sparse-package)
(install-dense-package)

(define (install-polynomial-package)
  ;; internal procedures
  ;; representation of poly
  (define (make-poly variable term-list)
    (cons variable term-list))
  (define (variable p) (car p))
  (define (term-list p) (cdr p))
  (define (variable? x) (symbol? x))
  (define (same-variable? x y)
    (and (variable? x) (variable? y) (eq? x y)))
  ;; representation of terms and term lists
  ;; modify for exercise 2.90
  (define (make-termlist type term-list)
    ((get 'make-termlist type) term-list))
  (define (make-sparse-termlist term-list)
    (make-termlist 'sparse term-list))
  (define (make-dense-termlist term-list)
    (make-termlist 'dense term-list))
  (define (adjoin-term term term-list)
    (apply-generic 'adjoin-term term term-list))
  (define (the-empty-termlist type)
    (make-termlist type '()))
  (define (first-term term-list)
    (apply-generic 'first-term term-list))
  (define (rest-terms term-list)
    (apply-generic 'rest-terms term-list))
  (define (empty-termlist? term-list) (null? (contents term-list)))
  (define (make-term type order coeff)
    ((get 'make-term type) order coeff))
  (define (order term)
    (apply-generic 'order term))
  (define (coeff term)
    (apply-generic 'coeff term))

  (define (add-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
        (make-poly (variable p1)
                   (add-terms (term-list p1)
                              (term-list p2)))
        (error "Polys not in same var -- ADD-POLY"
               (list p1 p2))))
  (define (mul-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
        (make-poly (variable p1)
                   (mul-terms (term-list p1)
                              (term-list p2)))
        (error "Polys not in same var -- MUL-POLY"
               (list p1 p2))))
  ;; exercise 2.88
  (define (sub-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
        (add-poly p1 (negation-poly p2))
        (error "Polys not in same var -- SUB-POLY"
               (list p1 p2))))
  ;; exercise 2.91
  (define (div-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
        (map (lambda (terms)
               (make-poly (variable p1)
                          terms))
             (div-terms (term-list p1)
                        (term-list p2)))
        (error "Polys not in same var -- DIV-POLY"
               (list p1 p2))))
  ;; exercise 2.87
  (define (=zero-poly? p)
    (let ((terms (term-list p)))
      (if (null? terms)
          #t
          (if (null? (filter
                      (lambda (term-coeff) (not (=zero? term-coeff)))
                      (map coeff terms)))
              #t
              #f))))
  ;; exercise 2.88
  (define (negation-poly p)
    (make-poly (variable p)
               ;; modify for exercise 2.90
               (negation-termlist (term-list p))))
  ;; modify for exercixe 2.90
  (define (negation-termlist term-list)
    (apply-generic 'negation term-list))

  (define (add-terms L1 L2)
    (cond ((empty-termlist? L1) L2)
          ((empty-termlist? L2) L1)
          (else
           (let ((t1 (first-term L1))
                 (t2 (first-term L2)))
             (cond ((> (order t1) (order t2))
                    (adjoin-term
                     t1 (add-terms (rest-terms L1) L2)))
                   ((< (order t1) (order t2))
                    (adjoin-term
                     t2 (add-terms L1 (rest-terms L2))))
                   (else
                    (adjoin-term
                     ;; modify for exercixe 2.90
                     (make-term (type-tag t1)
                                (order t1)
                                (add (coeff t1) (coeff t2)))
                     (add-terms (rest-terms L1)
                                (rest-terms L2)))))))))
  (define (mul-terms L1 L2)
    (if (empty-termlist? L1)
        ;; modify for exercixe 2.90
        (the-empty-termlist (type-tag L1))
        (add-terms (mul-term-by-all-terms (first-term L1) L2)
                   (mul-terms (rest-terms L1) L2))))
  (define (mul-term-by-all-terms t1 L)
    (if (empty-termlist? L)
        ;; modify for exercixe 2.90
        (the-empty-termlist (type-tag L))
        (let ((t2 (first-term L)))
          (adjoin-term
           ;; modify for exercixe 2.90
           (make-term (type-tag t1)
                      (+ (order t1) (order t2))
                      (mul (coeff t1) (coeff t2)))
           (mul-term-by-all-terms t1 (rest-terms L))))))
  ;; exercise 2.91
  (define (sub-terms L1 L2)
    (add-terms L1 (negation-termlist L2)))
  (define (div-terms L1 L2)
    (let ((type1 (type-tag L1)))
      (if (empty-termlist? L1)
          (list (the-empty-termlist type1) (the-empty-termlist type1))
          (let ((t1 (first-term L1))
                (t2 (first-term L2)))
            (if (> (order t2) (order t1))
                (list (the-empty-termlist type1) L1)
                (let ((new-c (div (coeff t1) (coeff t2)))
                      (new-o (- (order t1) (order t2))))
                  (let ((rest-of-result
                         (div-terms (sub-terms L1
                                               (mul-term-by-all-terms
                                                (make-term type1 new-o new-c)
                                                L2))
                                    L2)))
                    (list (adjoin-term
                           (make-term type1 new-o new-c)
                           (car rest-of-result))
                          (cadr rest-of-result)))))))))

  ;; interface to rest of the system
  (define (tag p) (attach-tag 'polynomial p))
  (put 'add
       '(polynomial polynomial)
       (lambda (p1 p2) (tag (add-poly p1 p2))))
  (put 'mul
       '(polynomial polynomial)
       (lambda (p1 p2) (tag (mul-poly p1 p2))))
  ;; modify for exercixe 2.90
  (put 'make-sparse
       'polynomial
       (lambda (var terms) (tag (make-poly var
                                           (make-sparse-termlist terms)))))
  (put 'make-dense
       'polynomial
       (lambda (var terms) (tag (make-poly var
                                           (make-dense-termlist terms)))))
  ;; exercise 2.87
  (put '=zero?
       '(polynomial)
       =zero-poly?)
  ;; exercise 2.88
  (put 'negation
       '(polynomial)
       (lambda (p) (tag (negation-poly p))))
  (put 'sub
       '(polynomial polynomial)
       (lambda (p1 p2) (tag (sub-poly p1 p2))))
  ;; exercise 2.91
  (put 'div
       '(polynomial polynomial)
       (lambda (p1 p2) (map tag (div-poly p1 p2))))
  'done)
;; modify for exercixe 2.90
(define (make-sparse-polynomial var terms)
  ((get 'make-sparse 'polynomial) var terms))
(define (make-dense-polynomial var terms)
  ((get 'make-dense 'polynomial) var terms))
