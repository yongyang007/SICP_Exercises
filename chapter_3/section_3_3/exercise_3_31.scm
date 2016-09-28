(define (accept-action-procedure! proc)
  (set! action-procedures (cons proc action-procedures)))

;; 如果这样定义accept-action-procedure!
;; 我们想要执行的过程将不会在改变信号量前被加入到待处理表中
;; 那么后续的过程也都不会被执行了
;; 也就是说那时运行(propagate)后我们不会看到任何变化（因为agenda表中没有任何item）
