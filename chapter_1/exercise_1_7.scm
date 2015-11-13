(load "./newton_s_method_square_root.scm")
(sqrt 1.0e-30)                          ;结果比预期值大
                                        ;对于数值很小的数：
                                        ;也许被开方数于猜测数平方差的绝对值一下子就小于good-enough?方法中设定的值了，
                                        ;所以起不到判断的作用
(sqrt 1.0e60)
                                        ;进入死循环
                                        ;对于数值非常大的数：
                                        ;由于计算机可以表示的精度不够，也许被开方数于猜测数平方差的绝对值永远也不可能小于设定值，
                                        ;而使程序进入死循环
(define (sqrt-iter old-guess new-guess x)
  (if (good-enough? old-guess new-guess)
      new-guess
      (sqrt-iter new-guess
                 (improve new-guess x)
                 x)))
(define (good-enough? old-guess new-guess)
  (< (abs (- 1.0 (/ old-guess new-guess))) 0.001))
(define (sqrt x)
  (sqrt-iter 1.0 (* 1.0 x) x))

(sqrt 1.0e-30)
(sqrt 1.0e60)
(sqrt 0.01)
(sqrt 9)
(sqrt 2)
