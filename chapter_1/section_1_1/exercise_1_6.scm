(load "./newton_s_method_square_root_1.scm")
(define (new-if predicate then-clause else-clause)
  (cond (predicate then-clause)
        (else else-clause)))
                                        ;test
(new-if (= 2 3) 0 5)
(new-if (= 1 1) 0 5)

                                        ;recode the method sqrt-iter
(define (sqrt-iter guess x)
  (new-if (good-enough? guess x)
      guess
      (sqrt-iter (improve guess x)
                 x)))
                                        ;用new-if修改sqrt-iter会导致死循环
                                        ;这是因为Scheme的解释器采用应用序进行运算，会先对每个子表达式进行运算，因而进入死循环
                                        ;使用if或直接使用cond没有问题是因为它们属于特殊的运输符号，不遵循应用序的规则
                                        ;而将cond包装成new-if后，上述的这个特殊性就被掩盖起来了
