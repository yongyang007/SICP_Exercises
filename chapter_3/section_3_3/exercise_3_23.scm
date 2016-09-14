(add-load-path "./")
(load "queues.scm")

(define (make-node item) (cons '() (cons item '())))
(define (next-node node) (cddr node))
(define (previous-node node) (car node))
(define (item-node node) (cadr node))
(define (set-next-node! node next) (set-cdr! (cdr node) next))
(define (set-previous-node! node previous) (set-car! node previous))

(define (make-deque) (cons '() '()))

(define (empty-deque? deque)
  (or (null? (front-ptr deque))
      (null? (rear-ptr deque))))

(define (front-deque deque)
  (if (empty-deque? deque)
      (error "FRONT called with an empty deque" deque)
      (item-node (front-ptr deque))))

(define (rear-deque deque)
  (if (empty-deque? deque)
      (error "REAR called with an empty deque" deque)
      (item-node (rear-ptr deque))))

(define (init-deque! deque item insert-deque!)
  (let ((new-node (make-node item)))
    (cond ((empty-deque? deque)
           (set-front-ptr! deque new-node)
           (set-rear-ptr! deque new-node)
           deque)
          (else
           (insert-deque! new-node)))))

(define (front-insert-deque! deque item)
  (init-deque! deque
               item
               (lambda (node)
                 (set-previous-node! (front-ptr deque) node)
                 (set-next-node! node (front-ptr deque))
                 (set-front-ptr! deque node)
                 deque)))

(define (rear-insert-deque! deque item)
  (init-deque! deque
               item
               (lambda (node)
                 (set-next-node! (rear-ptr deque) node)
                 (set-previous-node! node (rear-ptr deque))
                 (set-rear-ptr! deque node)
                 deque)))

(define (front-delete-deque! deque)
  (cond ((empty-deque? deque)
         (error "FRONT-DELETE! called with an empty deque" deque))
        (else
         (let ((next (next-node (front-ptr deque))))
           (if (not (null? next))
               (set-previous-node! next '()))
           (set-next-node! (front-ptr deque) '())
           (set-front-ptr! deque next)
           deque))))

(define (rear-delete-deque! deque)
  (cond ((empty-deque? deque)
         (error "rear-delete! called with an empty deque" deque))
        (else
         (let ((previous (previous-node (rear-ptr deque))))
           (if (not (null? previous))
               (set-next-node! previous '()))
           (set-previous-node! (rear-ptr deque) '())
           (set-rear-ptr! deque previous)
           deque))))

(define (print-deque deque)
  (define (iter node items)
    (if (null? node)
        items
        (iter (previous-node node) (cons (item-node node) items))))
  (if (empty-deque? deque)
      '()
      (iter (rear-ptr deque) '())))

(define d1 (make-deque))
(print-deque d1)
(print-deque (front-insert-deque! d1 'b))
(print-deque (front-insert-deque! d1 'a))
(print-deque (rear-insert-deque! d1 'c))
(front-deque d1)
(rear-deque d1)

(print-deque (front-delete-deque! d1))
(print-deque (rear-delete-deque! d1))
