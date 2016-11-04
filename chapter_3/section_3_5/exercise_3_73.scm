(add-load-path "./")
(load "stream.scm")

(define (RC R C dt)
  (lambda (i v0)
    (add-streams
     (integral (scale-stream i (/ 1 C)) v0 dt)
     (scale-stream i R))))

(define RC1 (RC 5 1 0.5))

(sub-list (RC1 ones 0) 10)
