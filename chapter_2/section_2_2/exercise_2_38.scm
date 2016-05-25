(load "../../tool/accumulate.scm")

(define fold-right accumulate)
(define (fold-left op initial sequence)
  (define (iter result rest)
    (if (null? rest)
        result
        (iter (op result (car rest))
              (cdr rest))))
  (iter initial sequence))

(fold-right / 1 (list 1 2 3))
                                        ; => 3/2
(fold-left / 1 (list 1 2 3))
                                        ; => 1/6
(fold-right list '() (list 1 2 3))
                                        ; => (1 (2 (3 ())))
(fold-left list '() (list 1 2 3))
                                        ; => (((() 1) 2) 3)

                                        ;若使fold-right和fold-left产生相同结果，op需要满足交换律
