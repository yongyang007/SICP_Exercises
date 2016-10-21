;; 考虑是否下面的过程就能完成从一个账户向另一个转移款项
;; 即使存在多个人并发的在多个账户间转移款项

(define (tranasfer from-account to-account amount)
  ((from-account 'withdraw) amount)
  ((to-account 'deposit) amount))

;; 这一过程不存在问题
;; 在多个账户间转移款项与交换多个账户间余额的区别就是，
;; 假设from-account内的余额至少有amount那么多的情况下，
;; 在多个账户内进行存取的数额与该账户当前余额并没有关系。
;; 所以仅仅需要对单个账户的存取过程进行串行化处理就可以避免问题了。
