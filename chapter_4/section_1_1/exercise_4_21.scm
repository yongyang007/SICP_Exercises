;; a)
((lambda (n)
   ((lambda (fact)
      (fact fact n))
    (lambda (ft k)
      (if (= k 1)
          1
          (* k (ft ft (- k 1)))))))
 10)

;; Fibonacci number
((lambda (n)
   ((lambda (fibonacci)
      (fibonacci fibonacci n))
    (lambda (fib k)
      (cond ((= k 0) 0)
            ((= k 1) 1)
            (else (+ (fib fib (- k 2))
                     (fib fib (- k 1))))))))
 10)

;; b)
(define (f x)
  (define (even? n)
    (if (= n 0)
        #t
        (odd? (- n 1))))
  (define (odd? n)
    (if (= n 0)
        #f
        (even? (- n 1))))
  (even? x))

(f 5)

(define (f x)
  ((lambda (even? odd?)
     (even? even? odd? x))
   (lambda (ev? od? n)
     (if (= n 0) #t (od? ev? od? (- n 1))))
   (lambda (ev? od? n)
     (if (= n 0) #f (ev? ev? od? (- n 1))))))

(f 5)

;; 要不依赖定义或者letrec而描述出递归过程，
;; 关键就是把需要递归的方法作为参数来传递
