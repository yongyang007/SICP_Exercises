;; 在完成各种检查之前，所有的可能性个数为5^5 = 3125种
;; 以这个为基数，在完成都不住在同一层的检查后，个数为5! = 120种
;; 完成某某人不在某一层的检查后，个数为(5^4)*4 = 2500种
;; 完成某人的层数高于另一人的检查后，个数为(5^3)*(4+3+2+1) = 1250种
;; 完成某两人不住相邻层的检查后，个数为(5^3)*(3*2+2*3) = 1500种

(define (multiple-dwelling)
  (let ((baker (amb 1 2 3 4 5)))
    (require (not (= baker 5)))
    (let ((cooper (amb 1 2 3 4 5)))
      (require (not (= cooper 1)))
      (require (distinct? (list baker cooper)))
      (let ((fletcher (amb 1 2 3 4 5)))
        (require (not (= fletcher 5)))
        (require (not (= fletcher 1)))
        (require (not (= (abs (- fletcher cooper)) 1)))
        (require (distinct? (list baker cooper fletcher)))
        (let ((miller (amb 1 2 3 4 5)))
          (require (> miller cooper))
          (require (distinct? (list baker cooper fletcher miller)))
          (let ((smith (amb 1 2 3 4 5)))
            (require (not (= (abs (- smith fletcher)) 1)))
            (require (distinct? (list baker cooper fletcher miller smith)))
            (list (list 'baker baker)
                  (list 'cooper cooper)
                  (list 'fletcher fletcher)
                  (list 'miller miller)
                  (list 'smith smith))))))))
;; TODO: 解释器成后有待验证

