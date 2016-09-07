;; 递归版本
(define (factorial n)
  (if (= n 1)
      1
      (* n (factorial (- n 1)))))
(factorial 6)
;; define语句在外部环境添加factorial
;; (factorial 6)创建环境E1(n:6)
;; E1中求值(- n 1)，得到结果5，调用(factorial 5)创建E2(n:5)
;; E2中求值(- n 1)，得到结果4，调用(factorial 4)创建E3(n:4)
;; E3中求值(- n 1)，得到结果3，调用(factorial 3)创建E4(n:3)
;; E4中求值(- n 1)，得到结果2，调用(factorial 2)创建E5(n:2)
;; E5中求值(- n 1)，得到结果1，调用(factorial 1)创建E6(n:1)
;; E6中返回1，在E5中求值(* n 1)得到结果2返回给E4
;; 在E4中求值(* n 2)得到结果6，返回给E3
;; 在E3中求值(* n 6)得到结果24，返回给E2
;; 在E2中求值(* n 24)得到结果120，返回给E1
;; 在E1中求值(* n 120)得到结果720

;; 迭代版本
(define (factorial n)
  (fact-iter 1 1 n))
(define (fact-iter product counter max-count)
  (if (> counter max-count)
      product
      (fact-iter (* counter product)
                 (+ counter 1)
                 max-count)))
(factorial 6)
;; define语句在外部环境添加factorial和fact-iter
;; (factorial 6)创建环境E1(n:6)
;; E1中调用(fact-iter 1 1 6)创建环境E2(product:1 counter:1 max-count:6)
;; E2中计算(* counter product)和(+ counter 1)得到结果1和2，调用(fact-iter 1 2 6)创建环境E3(product:1 counter:2 max-count:6)
;; E3中计算(* counter product)和(+ counter 1)得到结果2和3，调用(fact-iter 2 3 6)创建环境E4(product:2 counter:3 max-count:6)
;; E4中计算(* counter product)和(+ counter 1)得到结果6和4，调用(fact-iter 6 4 6)创建环境E5(product:6 counter:4 max-count:6)
;; E5中计算(* counter product)和(+ counter 1)得到结果24和5，调用(fact-iter 24 5 6)创建环境E6(product:24 counter:5 max-count:6)
;; E6中计算(* counter product)和(+ counter 1)得到结果120和6，调用(fact-iter 120 6 6)创建环境E7(product:120 counter:6 max-count:6)
;; E7中计算(* counter product)和(+ counter 1)得到结果720和7，调用(fact-iter 720 7 6)创建环境E8(product:720 counter:7 max-count:6)
;; E8中返回720
