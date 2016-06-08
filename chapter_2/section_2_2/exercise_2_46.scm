(define (make-vect x y)
  (cons x y))

(define (xcor-vect v)
  (car v))

(define (ycor-vect v)
  (cdr v))

(define (operate-vect op v1 v2)
  (make-vect (op (xcor-vect v1)
                 (xcor-vect v2))
             (op (ycor-vect v1)
                 (ycor-vect v2))))

(define (add-vect v1 v2)
  (operate-vect + v1 v2))

(define (sub-vect v1 v2)
  (operate-vect - v1 v2))

(define (scale-vect s v)
  (operate-vect *
                (make-vect s s)
                v))

(define v1 (make-vect 1 2))
(define v2 (make-vect 3 4))

(add-vect v1 v2)
(sub-vect (scale-vect 2 v1) v2)
