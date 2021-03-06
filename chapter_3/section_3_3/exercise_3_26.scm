;; record
(define (make-record key value) (cons key value))
(define (key-record record) (car record))
(define (value-record record) (cdr record))
(define (set-value-record! record value) (set-cdr! record value))

;; tree
(define (make-tree entry left right) (list entry left right))
(define (entry-tree tree) (car tree))
(define (left-branch-tree tree) (cadr tree))
(define (right-branch-tree tree) (caddr tree))
(define (set-left-branch-tree! tree left)
  (set-car! (cdr tree) left))
(define (set-right-branch-tree! tree right)
  (set-car! (cddr tree) right))

(define (make-table compare)
  (let ((local-table (list '*table*)))

    ;; organize records by binary tree
    (define (assoc key tree)
      (if (null? tree)
          #f
          (let ((entry (entry-tree tree)))
            (cond ((= 0 (compare key (key-record entry)))
                   entry)
                  ((= -1 (compare key (key-record entry)))
                   (assoc key (left-branch-tree tree)))
                  (else
                   (assoc key (right-branch-tree tree)))))))
    (define (lookup key)
      (let ((record (assoc key (cdr local-table))))
        (if record
            (value-record record)
            #f)))
    (define (make-record-tree key value) (make-tree (make-record key value) '() '()))
    (define (insert-to-tree! key value tree)
      (let ((entry (entry-tree tree)))
        (cond ((= 0 (compare key (key-record entry)))
               (set-value-record! entry value)
               'ok)
              ((= -1 (compare key (key-record entry)))
               (let ((left (left-branch-tree tree)))
                 (cond ((null? left)
                        (set-left-branch-tree! tree (make-record-tree key value))
                        'ok)
                       (else
                        (insert-to-tree! key value left)))))
              (else
               (let ((right (right-branch-tree tree)))
                 (cond ((null? right)
                        (set-right-branch-tree! tree (make-record-tree key value))
                        'ok)
                       (else
                        (insert-to-tree! key value right))))))))
    (define (insert! key value)
      (let ((tree (cdr local-table)))
        (cond ((null? tree)
               (set-cdr! local-table (make-record-tree key value))
               'ok)
              (else
               (insert-to-tree! key value tree)))))
    (define (print) local-table)
    (define (dispatch m)
      (cond ((eq? m 'lookup-proc) lookup)
            ((eq? m 'insert-proc!) insert!)
            ((eq? m 'print-proc) (print))
            (else (error "unknown operation -- table" m))))
    dispatch))

(define (compare-with-int a b)
  (cond ((= a b) 0)
        ((< a b) -1)
        (else 1)))
(define (compare-with-string a b)
  (cond ((string=? a b) 0)
        ((string<? a b) -1)
        (else 1)))
(define (compare-with-symbol a b)
  (compare-with-string (symbol->string a)
                       (symbol->string b)))

(define (lookup table key) ((table 'lookup-proc) key))
(define (insert! table key value) ((table 'insert-proc!) key value))

(define table-int-key (make-table compare-with-int))
(insert! table-int-key 4 "4")
(insert! table-int-key 2 "2")
(insert! table-int-key 5 "5")
(insert! table-int-key 1 "1")
(insert! table-int-key 3 "3")
(insert! table-int-key 6 "6")
(lookup table-int-key 3)
(insert! table-int-key 3 "three")

(define table-symbol-key (make-table compare-with-symbol))
(insert! table-symbol-key 'd "d")
(insert! table-symbol-key 'b "b")
(insert! table-symbol-key 'e "e")
(insert! table-symbol-key 'a "a")
(insert! table-symbol-key 'c "c")
(insert! table-symbol-key 'f "f")
(lookup table-symbol-key 'a)
(insert! table-symbol-key 'a "A")
(insert! table-symbol-key 'g "G")
(lookup table-symbol-key 'g)
