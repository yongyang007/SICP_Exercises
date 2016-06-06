                                        ;因为 φ^2 = φ + 1
                                        ;所以 φ = 1 + 1/φ
                                        ;即黄金分割率φ为变换x |-> 1 + 1/x的不动点
(add-load-path "./")
(load "fixed_point.scm")

(fixed-point (lambda (x) (+ 1 (/ 1 x))) 1.0)
