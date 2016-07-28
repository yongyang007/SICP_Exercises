(add-load-path "../section_2_4/")
(load "make_table.scm")

(define coercion-table (make-table))
(define put-coercion (coercion-table 'insert-proc!))
(define get-coercion (coercion-table 'lookup-proc))

(define (scheme-number->complex n)
  (make-complex-from-real-imag (contents n) 0))

(put-coercion 'scheme-number
              'complex
              scheme-number->complex)
