(add-load-path "./")
(load "stream.scm")

(define s (cons-stream 1 (add-streams s s)))

;; 这也将生成2的各个幂

(sub-list s 11)
