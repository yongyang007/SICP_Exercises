(define (count-pairs x)
  (define counted-pairs '())
  (define (inner x)
    (if (or (not (pair? x)) (memq x counted-pairs))
        0
        (begin (set! counted-pairs (cons x counted-pairs))
               (+ (inner (car x))
                  (inner (cdr x))
                  1))))
  (inner x))

(define s1 (cons (cons '() '()) (cons '() '())))
(count-pairs s1)

(define s2
  (let ((p1 (cons '() '()))
        (p2 (cons '() '())))
    (set-cdr! p2 p1)
    (cons p1 p2)))
(count-pairs s2)

(define s3
  (let ((p1 (cons '() '()))
        (p2 (cons '() '()))
        (p3 (cons '() '())))
    (set-car! p1 p2)
    (set-cdr! p1 p2)
    (set-car! p2 p3)
    (set-cdr! p2 p3)
    p1))
(count-pairs s3)

(define s4
  (let ((p1 (cons '() '()))
        (p2 (cons '() '()))
        (p3 (cons '() '())))
    (set-cdr! p1 p2)
    (set-cdr! p2 p3)
    (set-cdr! p3 p1)
    p1))
(count-pairs s4)
