(define (unless condition usual-value exceptional-value)
  (if condition exceptional-value usual-value))

(define (factorial n)
  (unless (= n 1)
          (* n (factorial (- n 1)))
          1))

(factorial 5)

;; 在应用序的Scheme中，计算(factorial 5)会陷入死循环，
;; 因为，参数总会先被计算出来，factorial方法将一直被调用，
;; 在正则序的语言里可以正常工作
