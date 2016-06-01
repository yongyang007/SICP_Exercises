(flatmap
 (lambda (new-row)
   (map (lambda (rest-of-queens)
          (adjoin-position new-row k rest-of-queens))
        (queen-cols (-k 1))))
 (enumerate-interval 1 board-size))
                                        ;这种嵌套映射的顺序很明显的增加了递归的次数
                                        ;相比于比效率高的过程在计算(queen-cols k)时
                                        ;多调用了board-size倍的(queen-cols (- k 1))
                                        ;时间大约是board-size^(board-size-1)倍
