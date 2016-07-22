                                        ;导入加式与乘式定义
(add-load-path "../section_2_3/")
(load "symbolic_differentiation.scm")
                                        ;导入以后才会学到的put和get
(add-load-path "./")
(load "put_and_get.scm")

(define (deriv exp var)
  (cond ((number? exp) 0)
        ((variable? exp) (if (same-variable? exp var) 1 0))
        ((sum? exp)
         (make-sum (deriv (addend exp) var)
                   (deriv (augend exp) var)))
        ((product? exp)
         (make-sum
          (make-product (multiplier exp)
                        (deriv (multiplicand exp) var))
          (make-product (deriv (multiplier exp) var)
                        (multiplicand exp))))
        ;<更多规则可以加在这里>
        (else (error "unknown expression type -- DERIV" exp))))
                                        ;可以将上述求导过程以数据导向风格重写为
(define (deriv exp var)
  (cond ((number? exp) 0)
        ((variable? exp) (if (same-variable? exp var) 1 0))
        (else ((get 'deriv (operator exp)) (operands exp) var))))

(define (operator exp) (car exp))
(define (operands exp) (cdr exp))
                                        ;a)上面将算式的代数运算符作为类型标志，
                                        ;而运算符后面的参数则是数据，以数据导向的风格改写求导过程
                                        ;最后根据运算符导向适合的求导过程
                                        ;不能将number?和same-variable?也加入数据导向分派，
                                        ;是因为这两种表达式中没有可以作为类型标志的运算符号

                                        ;b)
(put 'deriv
     '+
     (lambda (operands var)
       (let ((exp (cons '+ operands)))
         (make-sum (deriv (addend exp) var)
                   (deriv (augend exp) var)))))


(put 'deriv
     '*
     (lambda (operands var)
       (let ((exp (cons '* operands)))
         (make-sum
          (make-product (multiplier exp)
                        (deriv (multiplicand exp) var))
          (make-product (deriv (multiplier exp) var)
                        (multiplicand exp))))))

(deriv '(+ x 3) 'x)
(deriv '(* x y) 'x)
(deriv '(* (* x y) (+ x 3)) 'x)

                                        ;c)加入对于乘幂的求导
(define (make-exponentiation b e)
  (cond ((=number? e 0) 1)
        ((=number? e 1) b)
        ((and (number? b) (number? e)) (expt b e))
        (else (list '** b e))))

(define (base e) (cadr e))

(define (exponent e) (caddr e))

(define (exponentiation? e)
  (and (pair? e) (eq? '** (car e))))


(put 'deriv
     '**
     (lambda (operands var)
       (let ((exp (cons '** operands)))
         (let ((b (base exp))
               (e (exponent exp)))
           (make-product
            (make-product e
                          (make-exponentiation b
                                               (make-sum e -1)))
            (deriv b var))))))

(deriv '(** (* x y) 2) 'x)
(deriv '(+ (* a (** x 2)) (* b x)) 'x)
(deriv '(+ (+ (* a (** x 2)) (* b x)) c) 'x)

                                        ;d)如果想一种相反的方式做索引，使得分派代码如下
                                        ;((get (operator exp) 'deriv) (operands exp) var)
                                        ;只需将调用put的地方也颠倒过来就可以了
                                        ;如(put '+ 'deriv (lambda ...))
