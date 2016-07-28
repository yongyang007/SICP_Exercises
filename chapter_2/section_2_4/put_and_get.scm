(add-load-path "./")
(load "make_table.scm")

(define operation-table (make-table))
(define put (operation-table 'insert-proc!))
(define get (operation-table 'lookup-proc))
