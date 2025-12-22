(define (depth tree)
        (if (empty-tree? tree) 
            0
            (max (1+ (depth (left-branch tree)))
                 (1+ (depth (right-branch tree))))))

(define (level-n tree n lev)
        (cond ((empty-tree? tree) '())
              ((= lev n) (list (entry tree)))
              (else (append (level-n (left-branch tree) n (1+ lev))
                            (level-n (right-branch tree) n (1+ lev))))))

(define (level-all tree lev max-lev)
        (if (> lev max-lev)
            '()
            (append (level-n tree lev 0)
                    (level-all tree (1+ lev) max-lev))))

(define (level-read tree)
        (level-all tree 0 (depth tree)))
