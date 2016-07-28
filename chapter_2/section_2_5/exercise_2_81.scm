;; 按照Louis Reasoner的想法添加上如下的同类型间的强制过程
(define (scheme-number->scheme-number n) n)
(define (complex->complex z) z)
(put-coercion 'scheme-number
              'scheme-number
              scheme-number->scheme-number)
(put-coercion 'complex 'complex complex->complex)
;; a) 如果在体统中添加求幂过程
(define (exp x y) (apply-generic 'exp x y))
;; 但是只在整数包里定义这个过程
;; following added to Scheme-number package
(put 'exp
     '(scheme-number scheme-number)
     (lambda (x y) (tag (expt x y)))) ; using primitive expt
;; 这样的话在用两个复数进行求幂运算时，
;; 会一直在apply-generic中进行complex->complex的强制转换,
;; 转换后继续查找有无定义(exp (complex complex))的过程，
;; 由于找不到，再次强制转换...这样一直进行下去

;; b) Louis的方案并没有解决相同类型强制转换的问题，
;;    就如上一问那样，会有陷入死循环的可能

;; c) 下面的改写将不会在apply-generic中进行同类型的强制转换
;;    不过个人觉得没太大必要进行这种判断，
;;    因为如果找不到同类型的转换过程，一样会正确报错的。
;;    不过出于效率考虑也许这样更好，而且我们也不能保证系统中不会有Louis那样的过程
(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (apply proc (map contents args))
          (if (= (length args) 2)
              (let ((type1 (car type-tags))
                    (type2 (cadr type-tags)))
                (if (eq? type1 type2)
                    (error "No method for these types"
                           (list op type-tags))
                    (let ((a1 (car args))
                          (a2 (cadr args))
                          (t1->t2 (get-coercion type1 type2))
                          (t2->t1 (get-coercion type2 type1)))
                      (cond (t1->t2
                             (apply-generic op (t1->t2 a1) a2))
                            (t2->t1
                             (apply-generic op a1 (t2->t1 a2)))
                            (else
                             (error "No method for there types"
                                    (list op type-tags)))))))
              (error "No method for these types"
                     (list op type-tags)))))))
