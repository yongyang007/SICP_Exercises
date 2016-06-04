(load "./picture_language.scm")

(define right-split (split beside below))
(define up-split (split below beside))

(define (split combine1 combine2)
  (lambda (painter n)
    (if (= n 0)
        (painter)
        (let ((smaller ((split combine1 combine2) painter)))
          (combine1 painter (combine2 smaller smaller))))))
