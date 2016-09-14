(add-load-path "./")
(load "queues.scm")

(define q1 (make-queue))

(insert-queue! q1 'a) ; => ((a) a)

(insert-queue! q1 'b) ; => ((a b) b)

(delete-queue! q1) ; => ((b) b)

(delete-queue! q1) ; => (() b)

;; 因为队列的结构是一个序对，内容分别指向队列的首尾元素，如果将这个内容直接打印出来，自然好像一个元素被插入了两次

(define (print-queue queue) (front-ptr queue))

(print-queue (insert-queue! q1 'a))
(print-queue (insert-queue! q1 'b))
(print-queue (delete-queue! q1))
(print-queue (delete-queue! q1))
