(define (lookup given-key set-of-records)
  (if (null? set-of-records)
      #f
      (let ((entry-key (key (entry set-of-records))))
        (cond ((= given-key entry-key)
               (entry set-of-records))
              ((< given-key entry-key)
               (lookup given-key (left-branch set-of-records)))
              (else
               (lookup given-key (right-branch set-of-records)))))))
