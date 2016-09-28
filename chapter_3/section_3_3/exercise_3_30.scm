(add-load-path "./")
(load "a_simulator_for_digital_circuits.scm")

(define (half-adder a b s c)
  (let ((d (make-wire))
        (e (make-wire)))
    (or-gate a b d)
    (and-gate a b c)
    (inverter c e)
    (and-gate d e s)
    'ok))

(define (full-adder a b c-in sum c-out)
  (let ((s (make-wire))
        (c1 (make-wire))
        (c2 (make-wire)))
    (half-adder b c-in s c1)
    (half-adder a s sum c2)
    (or-gate c1 c2 c-out)
    'ok))

(define (ripple-carry-adder a-k b-k s-k c)
  (define (iter a-list b-list c-in s-list c-out)
    (full-adder (car a-list)
                (car b-list)
                c-in
                (car s-list)
                c-out)
    (if (null? (cdr a-list))
        (set-signal! c-in 0)
        (iter (cdr a-list)
              (cdr b-list)
              (make-wire)
              (cdr s-list)
              c-in)))
  (if (and (= (length a-k) (length b-k))
           (= (length a-k) (length s-k))
           (not (= (length a-k) 0)))
      (iter a-k b-k (make-wire) s-k c)
      (error "Invalid parameters" a-k b-k s-k c)))

(define a-l (list (make-wire) (make-wire) (make-wire)))
(define b-l (list (make-wire) (make-wire) (make-wire)))
(define s-l (list (make-wire) (make-wire) (make-wire)))
(define carry (make-wire))

(ripple-carry-adder a-l b-l s-l carry)

;; 5 + 4 = 9 (101 + 100 = 1001)
(set-signal! (car a-l) 1)
(set-signal! (caddr a-l) 1)
(set-signal! (car b-l) 1)

(propagate)

(get-signal carry)

(define (print-wire-list l)
  (map get-signal l))

(print-wire-list a-l)
(print-wire-list b-l)
(print-wire-list s-l)

;; 15 + 7 = 22 (1111 + 0111 = 10110)
(define a (list (make-wire) (make-wire) (make-wire) (make-wire)))
(define b (list (make-wire) (make-wire) (make-wire) (make-wire)))
(define s (list (make-wire) (make-wire) (make-wire) (make-wire)))
(define c (make-wire))

(ripple-carry-adder a b s c)

(map (lambda (w)
       (set-signal! w 1))
     a)
(print-wire-list a)

(map (lambda (w)
       (set-signal! w 1))
     b)
(set-signal! (car b) 0)
(print-wire-list b)

(propagate)

(print-wire-list s)
(get-signal c)

;; 半加器的时延：
;; half-adder-s-delay = or-gate-delay + inverter-delay + and-gate-delay
;; half-adder-c-delay = and-gate-delay

;; 全加器的时延：
;; full-adder-sum-delay = 2 * half-adder-s-delay
;; full-adder-c-out-delay = 2 * half-adder-c-delay + or-gate-delay

;; 逐位进位加法器（n位）的时延：
;; ripple-carry-adder-s-k-delay = (n - k) * full-adder-c-out-delay + full-adder-sum-delay
;; ripple-carry-adder-c-delay = n * full-adder-c-out-delay
