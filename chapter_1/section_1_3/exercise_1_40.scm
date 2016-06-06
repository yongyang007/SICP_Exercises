(add-load-path "./")
(add-load-path "../../tool/")
(load "newtons_method.scm")
(load "square.scm")
(load "cube.scm")

(define (cubic a b c)
  (lambda (x)
    (+ (cube x)
       (* a (square x))
       (* b x)
       c)))

(newtons-method (cubic 2 3 4) 1)
                                        ;-1.6506291914330982
