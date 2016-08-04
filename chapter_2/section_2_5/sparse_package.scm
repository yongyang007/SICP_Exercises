;; exercise 2.90
(define (install-sparse-package)
  ;; internal procedures
  ;; representation of terms and term lists
  (define (adjoin-term term term-list)
    (if (=zero? (coeff term))
        term-list
        (cons term term-list)))
  (define (first-term term-list) (car term-list))
  (define (rest-terms term-list) (cdr term-list))
  (define (make-term order coeff) (list order coeff))
  (define (order term) (car term))
  (define (coeff term) (cadr term))

  ;; interface to rest of the system
  (define (tag x) (attach-tag 'sparse x))
  (put 'adjoin-term
       '(sparse sparse)
       (lambda (t l) (tag (adjoin-term t l))))
  (put 'first-term
       '(sparse)
       (lambda (l) (tag (first-term l))))
  (put 'rest-terms
       '(sparse)
       (lambda (l) (tag (rest-terms l))))
  (put 'make-term
       'sparse
       (lambda (o c) (tag (make-term o c))))
  (put 'order '(sparse) order)
  (put 'coeff '(sparse) coeff)
  (put 'make-termlist
       'sparse
       (lambda (l) (tag l)))
  (put 'negation
       '(sparse)
       (lambda (l) (tag (map
                         (lambda (t) (make-term (order t)
                                                (negation (coeff t))))
                         l))))
  'done)
