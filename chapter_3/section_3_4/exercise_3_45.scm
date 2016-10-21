(define (make-account-and-serializer balance)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (let ((balance-serializer (make-serializer)))
    (define (dispatch m)
      (cond ((eq? m 'withdraw) (balance-serializer withdraw))
            ((eq? m 'deposit) (balance-serializer deposit))
            ((eq? m 'balance) balance)
            ((eq? m 'serializer) balance-serializer)
            (else (error "Unknown request -- MAKE-ACCOUNT"
                         m))))
    dispatch))

(define (deposit account amount)
  ((account 'deposit) amount))

;; 这种写法的错误点就在于，如果已经将serializer提取出来单独管理的话，就不应该再在内部使用它，
;; 特别考虑下面serialized-exchange的实现

(define (exchange account1 account2)
  (let ((difference (- (account1 'balance)
                       (account2 'balance))))
    ((account1 'withdraw) difference)
    ((account2 'deposit) difference)))
(define (serialized-exchange account1 account2)
  (let ((serializer1 (account1 'serializer))
        (serializer2 (account2 'serializer)))
    ((serializer1 (serializer2 exchange))
     account1
     account2)))

;; 如果这里的withdraw和deposit已经自动放入对应账户的串行化组就会出现问题，
;; 因为serializer-exchange也要将exchange过程依次放入两个账户的串行化组，
;; 而exchange过程中又分别调用了两个账户的withdraw和deposit，这就会使serializer-exchange永远不能执行完成。
;; （withdraw和deposit都会等待exchange完成后才会执行，而exchange的执行由需要执行withdraw和deposit）
