(define (and-gate a1 a2 output)
  (define (and-action-procedure)
    (let ((new-value
           (logical-and (get-signal a1) (get-signal a2))))
      (after-delay and-gate-delay
                   (lambda ()
                     (set-signal! output new-value)))))
  (add-action! a1 and-action-procedure)
  (add-action! a2 and-action-procedure)
  'ok)

;; 假设在一个时间段里
;; a1 : 0 -> 1
;; a2 : 1 -> 0
;; 所以(a1 a2)的状态依次就是(1 1) (1 0)
;; output的状态就依次是 1 0

;; 在先进先出的次序下，output先是被设置为1，而后被设置为0，结果正确
;; 而后进先出的次序下，output的情况正好相反，最后被设置成1，不是正确的结果
