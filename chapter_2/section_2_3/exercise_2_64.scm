(add-load-path "./")
(load "sets_as_binary_trees.scm")

(define (list->tree elements)
  (car (partial-tree elements (length elements))))

(define (partial-tree elts n)
  (if (= n 0)
      (cons '() elts)
      (let ((left-size (quotient (- n 1) 2)))
        (let ((left-result (partial-tree elts left-size)))
          (let ((left-tree (car left-result))
                (non-left-elts (cdr left-result))
                (right-size (- n (+ left-size 1))))
            (let ((this-entry (car non-left-elts))
                  (right-result (partial-tree (cdr non-left-elts)
                                              right-size)))
              (let ((right-tree (car right-result))
                    (remaining-elts (cdr right-result)))
                (cons (make-tree this-entry left-tree right-tree)
                      remaining-elts))))))))

;;a
;;该过程根据要进行平衡树转化的元素个数，
;;将要转化的元素平分成两部分（后一部分多出一个做为节点），
;;由于元素为顺序，故而前一部分做为左子树的元素继续递归生成平衡树，
;;后一部分去掉第一个元素做为节点后递归生成右子树，
;;最后将节点和左右子树组成一个树。
;;递归直至产生一个左右子树都为空的叶子节点为止

;;(1 3 5 7 9 11)利用该过程所生成的树为：
;;           5
;;          / \
;;         1   9
;;          \ / \
;;          3 7 11

;;b
;;这个过程的步数增长为Θ(n)
