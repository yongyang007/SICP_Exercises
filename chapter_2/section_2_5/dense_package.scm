;; exercise 2.90
(define (install-dense-package)
  ;; internal procedures
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
  (define (first-term term-list) (make-term (- (length term-list) 1)
                                            (car term-list)))
  (define (rest-terms term-list) (cdr term-list))
  (define (make-term order coeff) (cons order coeff))
  (define (order term) (car term))
  (define (coeff term) (cdr term))


  ;; interface to rest of the system
  (define (tag x) (attach-tag 'dense x))
  (put 'adjoin-term
       '(dense dense)
       (lambda (t l) (tag (adjoin-term t l))))
  (put 'first-term
       '(dense)
       (lambda (l) (tag (first-term l))))
  (put 'rest-terms
       '(dense)
       (lambda (l) (tag (rest-terms l))))
  (put 'make-term
       'dense
       (lambda (o c) (tag (make-term o c))))
  (put 'order '(dense) order)
  (put 'coeff '(dense) coeff)
  (put 'make-termlist
       'dense
       (lambda (l) (tag l)))
  (put 'negation
       '(dense)
       (lambda (l) (tag (map negation l))))
  'done)
