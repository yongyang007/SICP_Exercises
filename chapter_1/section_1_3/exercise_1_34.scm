(define (f g)
  (g 2))

(f square)

(f (lambda (z) (* z (+ z 1))))

(f f)
                                        ;(f f) 的展开形式如下：
                                        ;(f (lambda (g) (g 2)))
                                        ;((lambda (g) (g 2))
                                        ;     (lambda (g) (g 2)))
                                        ;((lambda (g) (g 2)) 2)
                                        ;(2 2)
                                        ;The objetc 2 is not applicable.
