(add-load-path "./")
(load "exercise_3_70.scm")

(define (weight1 pair)
  (let ((i (car pair))
        (j (cadr pair)))
    (+ (square i) (square j))))

(define weighted-pairs1 (weighted-pairs integers integers weight1))

(define (make-stream1 pairs)
  (let ((p1 (stream-car pairs))
        (p2 (stream-car (stream-cdr pairs)))
        (p3 (stream-car (stream-cdr (stream-cdr pairs)))))
    (let ((weight-p (weight1 p1)))
      (if (= weight-p (weight1 p2) (weight1 p3))
          (cons-stream
           (list weight-p p1 p2 p3)
           (make-stream1 (stream-cdr (stream-cdr (stream-cdr pairs)))))
          (make-stream1 (stream-cdr pairs))))))

(define stream1 (make-stream1 weighted-pairs1))

(sub-list stream1 10)
