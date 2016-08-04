;; 适合于稠密多项式项表的过程

  ;; representation of terms and term lists
  (define (adjoin-term term term-list)
    (define (iter terms n)
      (if (= n 1)
          (cons (coeff term) terms)
          (iter (cons 0 terms)
                (- n 1))))
    (let ((delta (- (order term) (- (length term-list) 1))))
      (if (and (> delta 0) (not (= (coeff term) 0)))
          (iter term-list delta)
          term-list)))
  (define (the-empty-termlist) '())
  (define (first-term term-list) (make-term (- (length term-list) 1)
                                            (car term-list)))
  (define (rest-terms term-list) (cdr term-list))
  (define (empty-termlist? term-list) (null? term-list))
  (define (make-term order coeff) (cons order coeff))
  (define (order term) (car term))
  (define (coeff term) (cdr term))

;; test
(define term-list '(2 4 1 0 8))
(first-term term-list)
(rest-terms term-list)
(empty-termlist? term-list)
(adjoin-term (make-term 7 3) term-list)
(adjoin-term (make-term 3 7) term-list)

  ;; for test
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
                     (make-term (order t1)
                                (add (coeff t1) (coeff t2)))
                     (add-terms (rest-terms L1)
                                (rest-terms L2)))))))))
  (define (mul-terms L1 L2)
    (if (empty-termlist? L1)
        (the-empty-termlist)
        (add-terms (mul-term-by-all-terms (first-term L1) L2)
                   (mul-terms (rest-terms L1) L2))))
  (define (mul-term-by-all-terms t1 L)
    (if (empty-termlist? L)
        (the-empty-termlist)
        (let ((t2 (first-term L)))
          (adjoin-term
           (make-term (+ (order t1) (order t2))
                      (mul (coeff t1) (coeff t2)))
           (mul-term-by-all-terms t1 (rest-terms L))))))
(add-load-path "./")
(load "generic_arithmetic_system.scm")

(add-terms '(1 2 3 4 0 6) '(7 0 0 2 3 7 8 0 0))
(mul-term-by-all-terms (make-term 1 1) '(1 2 0 4 5 6))
(mul-terms '(1 2 1) '(2 1 1 0))
(empty-termlist? (add-terms '(1 2 3 4) '(-1 -2 -3 -4)))
(add-terms '(2 2 3 4) '(-1 -2 -3 -4))
