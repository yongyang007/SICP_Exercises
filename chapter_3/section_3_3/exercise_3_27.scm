(define (memoize f)
  (let ((table (make-table)))
    (lambda (x)
      (let ((previously-computed-result (lookup x table)))
        (or previously-computed-result
            (let ((result (f x)))
              (insert! x result table)
              result))))))

(define memo-fib
  (memoize (lambda (n)
             (cond ((= n 0) 0)
                   ((= n 1) 1)
                   (else (+ (memo-fib (- n 1))
                            (memo-fib (- n 2))))))))

;; 因为之前计算的结果都会被保存到表中，
;; 所以计算n的斐波那契数时，前面的数最多只会计算n-1次，
;; 剩下的都是从表中提取结果

;; 如果直接定义为(memoize fib)是不行的，由环境图可以看到，
;; memo-fib所指向的环境中，包含了我们想用于存储计算结果的table，
;; 所以在递归过程中，我们所调用的过程也应指向这个环境，
;; 这样才能利用我们创建的table存储或提取递归过程中所产生或所需要的结果
;; 而fib指向全局环境，因此这么定义memo-fib并不会起到提高效率的作用
