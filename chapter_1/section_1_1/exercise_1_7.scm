(load "./newton_s_method_square_root_1.scm")
(sqrt 1.0e-30)
                                        ;结果比预期值大
                                        ;对于数值很小的数：
                                        ;也许被开方数于猜测数平方差的绝对值一下子就小于good-enough?方法中设定的值了，
                                        ;所以起不到判断的作用
(sqrt 1.0e60)
                                        ;进入死循环
                                        ;对于数值非常大的数：
                                        ;由于计算机可以表示的精度不够，也许被开方数于猜测数平方差的绝对值永远也不可能小于设定值，
                                        ;而使程序进入死循环
(load "./newton_s_method_square_root_2.scm")

(sqrt 1.0e-30)
(sqrt 1.0e60)
(sqrt 0.01)
(sqrt 9)
(sqrt 2)

(load "./newton_s_method_square_root_3.scm")

(sqrt 1.0e-30)
