(add-load-path "./")
(load "generic_arithmetic_system.scm")

(define (type-tag datum)
  (cond ((number? datum) 'scheme-number)
        ((pair? datum) (car datum))
        (else (error "Bad tagged datum -- TYPE-TAG" datum))))
(define (contents datum)
  (cond ((number? datum) datum)
        ((pair? datum) (cdr datum))
        (else (error "Bad tagged datum -- CONTENTS" datum))))
(define (attach-tag type-tag contents)
  (if (and (number? contents) (eq? 'scheme-number type-tag))
      contents
      (cons type-tag contents)))

(load "scheme_number_package.scm")

(add 1 2)
(sub 3 4)
(mul 5 6)
(div 7 8)
