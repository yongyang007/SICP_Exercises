(add-load-path "./")
(load "exercise_2_68.scm")
(load "exercise_2_69.scm")

(define lyric-pairs '((A 2) (NA 16) (BOOM 1) (SHA 3) (GET 2) (YIP 9) (JOB 2) (WAH 1)))

(define lyric '(Get a job
                      Sha na na na na na na na na
                      Get a job
                      Sha na na na na na na na na
                      Wah yip yip yip yip yip yip yip yip yip
                      Sha boom))

(define lyric-tree (generate-huffman-tree lyric-pairs))

(define lyric-bit #!fold-case (encode lyric lyric-tree))
(length lyric-bit) ; => 84

                                        ;如果用定长编码，共有8种文字，则每种文字的编码长度为3
                                        ;这段歌词编码后的长度为
(* 3 (length lyric)) ; => 108
