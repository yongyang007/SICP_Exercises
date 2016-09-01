(define (call-the-cops)
  "call 110")

(define (make-account balance password)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (let ((max-times 7)
        (incorrect-times 0))
    (lambda (p m)
      (if (eq? p password)
          (begin (set! incorrect-times 0)
                 (cond ((eq? m 'withdraw) withdraw)
                       ((eq? m 'deposit) deposit)
                       (else (error "Unknow request -- MAKE-ACCOUNT"
                                    m))))
          (lambda (x)
            (set! incorrect-times (+ incorrect-times 1))
            (if (< incorrect-times max-times)
                (format #f
                        "Insufficient password ~d time(s). If you accessed more than ~d consecutive times with an incorrect password, we will call the cops!"
                        incorrect-times
                        max-times)
                (call-the-cops)))))))

(define acc (make-account 100 'my-password))
((acc 'my-password 'deposit) 10)
((acc 'wrong 'withdraw) 100)
