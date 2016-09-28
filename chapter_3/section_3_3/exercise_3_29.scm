(add-load-path "/")
(load "a_simulator_for_digital_circuits.scm")

(define (or-gate a1 a2 output)
  (let ((b (make-wire))
        (c (make-wire))
        (d (make-wire)))
    (inverter a1 b)
    (inverter a2 c)
    (and-gate b c d)
    (inverter d output)
    'ok))

;; 此时 or-gate-delay = 3 * inverter-delay + and-gate-delay
