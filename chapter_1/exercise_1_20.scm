(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (remainder a b))))

                                        ;(gcd 206 40)
                                        ;正则序求值：
                                        ;由于展开出来太大了，就只写出推导过程了：
                                        ;在展开的第n层，计算出当时参数a和b所需调用remainder所需的次数分别设为
                                        ;a(n) b(n) 则
                                        ;a(0) = b(0) = 0
                                        ;a(n) = b(n - 1)
                                        ;b(n) = a(n - 1) + b(n - 1) + 1 = b(n - 1) + b(n - 2) + 1
                                        ;计算(gcd 206 40)共需要5次展开，除了最后一层会计算a，其他几层都会在if里计算b
                                        ;b(0) + b(1) + b(2) + b(3) + b(4) + a(4)
                                        ;= 0 + 1 + 2 + 4 + 7 + 4 = 18
                                        ;一共调用18次remainder


                                        ;应用序求值：
                                        ;(gcd 40 (remainder 206 40))
                                        ;(gcd 6 (remainder 40 6))
                                        ;(gcd 4 (remainder 6 4))
                                        ;(gcd 2 (remainder 4 2))
                                        ;2
                                        ;一共调用4次remainder
