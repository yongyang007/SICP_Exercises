                                        ;a)
                                        ;递归计算过程
(define (cont-frac n d k)
  (define (inter i)
    (if (> i k)
        0
        (/ (n i)
           (+ (d i) (inter (+ i 1))))))
  (inter 1))
                                        ;迭代计算过程
(define (cont-frac n d k)
  (define (iter i result)
    (if (< i 1)
        result
        (iter (- i 1)
              (/ (n i)
                 (+ (d i) result)))))
  (iter k 0))
                                        ;黄金分割率的倒数
(cont-frac (lambda (i) 1.0)
           (lambda (i) 1.0)
           11)
                                        ;k不小于11就能保证十进制4位精度
