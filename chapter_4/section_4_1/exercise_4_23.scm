;; 正文的实现：

(define (analyze-sequence exps)
  (define (sequentially proc1 proc2)
    (lambda (env) (proc1 env) (proc2 env)))
  (define (loop first-proc rest-procs)
    (if (null? rest-procs)
        first-proc
        (loop (sequentially first-proc (car rest-procs))
              (cdr rest-procs))))
  (let ((procs (map analyze exps)))
    (if (null? procs)
        (error "Empty sequence -- ANALYZE"))
    (loop (car procs) (cdr procs))))

;; 本题中的实现：

(define (analyze-sequence exps)
  (define (execute-sequence procs env)
    (cond ((null? (cdr procs)) ((car procs) env))
          (else ((car procs) env)
                (execute-sequence (cdr procs) env))))
  (let ((procs (map analyze exps)))
    (if (null? procs)
        (error "Empty sequence -- ANALYZE"))
    (lambda (env) (execute-sequence procs env))))

;; 当序列只有一个表达式时，上述两个实现的运行效果是一致的；
;; 当序列有两个表达式时，正文的实现分析出的结果为 (lambda (env) (proc1 env) (proc2 env))
;; 本题的实现所分析出的结果为 ((proc1 env) (proc2 env))
;; 可以看出这本身并不是一个以环境为参数的执行过程，
;; 所以说本题的实现只对每条表达式进行了分析，却没有对整个序列进行分析。
