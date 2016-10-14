(set! balance (+ balance 10))             ; Peter
(set! balance (- balance 20))             ; Paul
(set! balance (- balance (/ balance 2)))  ; Mary

;; a)
;; balance分别有3! - 2 = 4种可能值，分别是
;; (100 + 10 - 20) / 2 = 45
;; (100 + 10) / 2 - 20 = 35
;; (100 - 20) / 2 + 10 = 50
;; 100 / 2 + 10 -20 = 40
