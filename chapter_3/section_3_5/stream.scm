(define (memo-proc proc)
  (let ((already-run? #f)
        (result #f))
    (lambda ()
      (if (not already-run?)
          (begin (set! result (proc))
                 (set! already-run? #t)
                 result)
          result))))

(define-macro (delay exp) `(memo-proc (lambda () ,exp)))
(define (force delayed-object)
  (delayed-object))

(define the-empty-stream '())
(define stream-null? null?)

(define-macro (cons-stream a b)
  `(cons ,a (delay ,b)))

(define (stream-car stream)
  (car stream))
(define (stream-cdr stream)
  (force (cdr stream)))

(define (stream-ref s n)
  (if (= n 0)
      (stream-car s)
      (stream-ref (stream-cdr s) (- n 1))))
(define (stream-map proc s)
  (if (stream-null? s)
      the-empty-stream
      (cons-stream (proc (stream-car s))
                   (stream-map proc (stream-cdr s)))))
(define (stream-for-each proc s)
  (if (stream-null? s)
      'done
      (begin (proc (stream-car s))
             (stream-for-each proc (stream-cdr s)))))

(define (display-stream s)
  (stream-for-each display-line s))
(define (display-line x)
  (newline)
  (display x))

(define (stream-enumerate-interval low high)
  (if (> low high)
      the-empty-stream
      (cons-stream
       low
       (stream-enumerate-interval (+ low 1) high))))

(define (stream-filter pred stream)
  (cond ((stream-null? stream) the-empty-stream)
        ((pred (stream-car stream))
         (cons-stream (stream-car stream)
                      (stream-filter pred
                                     (stream-cdr stream))))
        (else (stream-filter pred (stream-cdr stream)))))

;; change stream-map in exercise 3.50
(define (stream-map proc . argstreams)
  (if (stream-null? (car argstreams))
      the-empty-stream
      (cons-stream
       (apply proc (map stream-car argstreams))
       (apply stream-map
              (cons proc (map stream-cdr argstreams))))))

(define (add-streams s1 s2)
  (stream-map + s1 s2))

(define (scale-stream stream factor)
  (stream-map (lambda (x) (* x factor))
              stream))

(define ones (cons-stream 1 ones))

(define integers (cons-stream 1 (add-streams ones integers)))

;; for show n items in a stream
(define (sub-list stream n)
  (if (= n 0)
      '()
      (cons (stream-car stream)
            (sub-list (stream-cdr stream) (- n 1)))))

;; add in exercise 3.54
(define (mul-streams s1 s2)
  (stream-map * s1 s2))

;; add in exercise 3.55
(define (partial-sums stream)
  (cons-stream (stream-car stream)
               (add-streams (partial-sums stream)
                            (stream-cdr stream))))

(define (euler-transfrom s)
  (let ((s0 (stream-ref s 0))
        (s1 (stream-ref s 1))
        (s2 (stream-ref s 2)))
    (cons-stream (- s2 (/ (square (- s2 s1))
                          (+ s0 (* -2 s1) s2)))
                 (euler-transfrom (stream-cdr s)))))

(define (make-tableau transform s)
  (cons-stream s
               (make-tableau transform
                             (transform s))))

(define (accelerated-sequence transform s)
  (stream-map stream-car
              (make-tableau transform s)))
