(define (make-account balance)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)

  (let ((protected (make-serializer)))
    (define (dispatch m)
      (cond ((eq? m 'withdraw) (protected withdraw))
            ((eq? m 'deposit) (protected deposit))
            ((eq? m 'balance)
             (protected (lambda () banlance))) ; serialized
            (else (error "Unknown request -- MAKE-ACCOUNT"
                         m))))
    dispatch))

(define A (make-account 100))

(parallel-execute ((A 'deposit) 10)
                  (let ((half (/ (A 'balance) 2)))
                    ((A 'withdraw) half)))

;; 即使是这种设置的数值和读取的数值相关的情况，我觉得Ben的担心也是没有必要的
;; 比如上面的例子，在读取balance时可能读到100或者110，计算出的half就是50或55
;; 当half = 55时，balance已经被设置到了110，这时再取出55，余额为55
;; 当half = 50时，((A 'deposit) 10) ((A 'withdraw) 50)将串行化执行，最终余额为60
;; 无论读取方法是否串行化执行，都是这个结果
;; 因为修改余额的方法已经串行化执行了，读取方法并没有必要加入串行化组

;; 追记：这种修改还是有可能是必要的，这要看读取方法是不是所谓的“原子操作”，当读取方法不是原子操作时，就必须将读取方法也加入到串行化组了
;;       不过从书中的上下文可以判断出，对于实现书中代码的scheme，这个修改还是没有必要的
