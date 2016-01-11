(define (a-plus-abs-b a b)
  ((if (> b 0) + -) a b))
                                        ;a加b的绝对值
(a-plus-abs-b 2 3)
(a-plus-abs-b 2 -5)
