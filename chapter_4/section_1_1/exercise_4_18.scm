;; 如果用下面的扫描方式
(lambda <vars>
  (let ((u '*unassigned*)
        (v '*unassigned*))
    (let ((a <e1>)
          (b <e2>))
      (set! u a)
      (set! v b))
    <e3>))
;; 去变换前面的solve过程
(define (solve f y0 dt)
  (define y (integral (delay dy) y0 dt))
  (define dy (stream-map f y))
  y)

;; 变换后的结果为：（变换1）
(define (solve f y0 dt)
  (let ((y '*unassigned*)
        (dy '*unassigned*))
    (let ((a (integral (delay dy) y0 dt))
          (b (stream-map f y)))
      (set! y a)
      (set! dy b)
      y)))

;; 按照正文的扫描方式变化的结果为：（变换2）
(define (solve f y0 dt)
  (let ((y '*unassigned*)
        (dy '*unassigned*))
    (set! y (integral (delay dy) y0 dt))
    (set! dy (stream-map f y))
    y))

;; 对于变换2：当设置y时，虽然dy还是*unassigned*，但是有delay所以不会去解释dy的值；
;; 当设置dy时，y的值已经被设置，所以可以正确执行。
;; 对于变换1：当let设置a时，同样因为有delay的原因可以正确执行；
;; 可是设置b时，y的值还是*unassigned*，所以回报错。
