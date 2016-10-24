;; 按一个特定顺序访问一组共享状态（比如给每个状态添加一个独有的编号，在并发访问这一组共享状态时首先访问编号最小的），
;; 这样的确可以避免一些死锁情况的发生。
;; 首先应该看一下产生死锁的情况，其实是产生了一个“环”形结构，
;; 书中的例子是一个最简单的“环”：
;; A --> B
;; ^     |
;; |------
;; A的完成要等B完成后，而B的完成要等A完成后，于是就形成了死锁。
;; 多个元素的话原理也是类似的，只要形成了“环形”，就会产生死锁。
;; 而如果都按照一个顺序（升序或降序）去访问的话，就不可能形成“环”形了，从而避免了死锁的产生。

(add-load-path "./")
(load "serializer.scm")

(define (generate-account-id)
  (let ((id 0)
        (s (make-serializer)))
    (s (lambda ()
         (set! id (+ id 1))
         id))))

(define (make-account-and-serializer balance)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (let ((balance-serializer (make-serializer))
        (balance-id (generate-account-id)))
    (define (dispatch m)
      (cond ((eq? m 'withdraw) withdraw)
            ((eq? m 'deposit) deposit)
            ((eq? m 'balance) balance)
            ((eq? m 'serializer) balance-serializer)
            ((eq? m 'id) balance-id)
            (else (error "Unknown request -- MAKE-ACCOUNT"
                         m))))
    dispatch))

(define (exchange account1 account2)
  (let ((difference (- (account1 'balance)
                       (account2 'balance))))
    ((account1 'withdraw) difference)
    ((account2 'deposit) difference)))

(define (serialized-exchange account1 account2)
  (define (inner-exchange smaller bigger)
    (let ((serializer1 (smaller 'serializer))
          (serializer2 (smaller 'serializer)))
      ((serializer1 (serializer2 exchange))
       smaller
       bigger)))
  (let ((id1 (account1 'id))
        (id2 (account2 'id)))
    (if (< id1 id2)
        (inner-exchange account1 account2)
        (inner-exchange account2 account1))))
