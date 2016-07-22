(add-load-path "./")
(load "put_and_get.scm")
(load "tagged_data.scm")

(define (get-record company name)
  ((get 'get-record company) name))
(define (get-salary record)
  (if record
      (apply-generic 'get-salary record)
      0))

(define (load-company-1-file)
  (define company1
    '((Tom 100)
      (Bell 150)
      (Lily 200)))

  (define (get-record name)
    (define (search items)
      (cond ((null? items) #f)
            ((eq? name (caar items)) (car items))
            (else (search (cdr items)))))
    (search company1))
  (define (get-salary record)
    (cadr record))

  (define (tag x) (attach-tag 'company1 x))

  (put 'get-record
       'company1
       (lambda (name)
         (let ((record (get-record name)))
           (if record
               (tag record)
               record))))
  (put 'get-salary
       '(company1)
       get-salary)
  'done)
(load-company-1-file)

(define (load-company-2-file)
  (define Tom (cons 'Tom 200))
  (define John (cons 'John 200))
  (define Nana (cons 'Nana 300))
  (define company2 (cons Tom (cons John Nana)))

  (define (get-record name)
    (define (search items)
      (cond ((not (pair? (cdr items)))
             (if (eq? name (car items))
                 items
                 #f))
            ((eq? name (caar items)) (car items))
            (else (search (cdr items)))))
    (search company2))
  (define (get-salary record)
    (cdr record))

  (define (tag x) (attach-tag 'company2 x))

  (put 'get-record
       'company2
       (lambda (name)
         (let ((record (get-record name)))
           (if record
               (tag record)
               record))))
  (put 'get-salary
       '(company2)
       get-salary)
  'done)
(load-company-2-file)

(define record-1 (get-record 'company1 'Tom))
(define record-2 (get-record 'company1 'John))
(define record-3 (get-record 'company1 'Lily))
(define record-4 (get-record 'company2 'Tom))
(define record-5 (get-record 'company2 'John))
(define record-6 (get-record 'company2 'Nana))
(define record-7 (get-record 'company2 'Lily))

(get-salary record-1)
(get-salary record-2)
(get-salary record-3)
(get-salary record-4)
(get-salary record-5)
(get-salary record-6)
(get-salary record-7)

(add-load-path "../../tool/")
(load "flatmap.scm")

(define (find-employee-record name companies)
  (flatmap
   (lambda (company)
     (let ((record (get-record company name)))
       (if record
           (list record)
           '())))
   companies))

(define companies '(company1 company2))
(find-employee-record 'Tom companies)
(find-employee-record 'John companies)
(find-employee-record 'Lity companies)
(find-employee-record 'Lily companies)

                                        ;如果再添加新的公司，只需要实现并在表中put进相应的
                                        ;get-record和get-salary方法即可
