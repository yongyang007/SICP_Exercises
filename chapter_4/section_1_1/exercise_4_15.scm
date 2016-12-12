(define (run-forever) (run-forever))

(define (try p)
  (if (halts? p p)
      (run-forever)
      'halted))

(try try)

;; 如果(try try)的结果是(run-forever)，则说明(haltes? try try)的结果是真，则(try try)不应该一直运行下去；
;; 如果(try try)的结果是'halted，则说明(haltes? try try)的结果是假，则(try try)不应该终止。
;; 所以无论(try try)的结果是什么，都与haltes?的判断相反，可谓自相矛盾。
