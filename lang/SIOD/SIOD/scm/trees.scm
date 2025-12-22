(define the-empty-tree 'empty-tree)

(define (empty-tree? x) 
        (eq? x the-empty-tree))

(define (make-tree l e r)
        (list l e r))

(define (make-leaf e)
        (list the-empty-tree e the-empty-tree))

(define (left-branch tree)
        (car tree))

(define (right-branch tree)
        (caddr tree))

(define (entry tree)
        (cadr tree))

(define (post tree)
        (if (empty-tree? tree)
            nil
            (append (post (left-branch tree)) 
                    (post (right-branch tree))
                    (list (entry tree)))))
(define (pre tree)
        (if (empty-tree? tree)
            nil
            (append (list (entry tree))
                    (pre (left-branch tree)) 
                    (pre (right-branch tree)))))
(define (in tree)
        (if (empty-tree? tree)
            nil
            (append (in (left-branch tree))
                    (list (entry tree)) 
                    (in (right-branch tree)))))
