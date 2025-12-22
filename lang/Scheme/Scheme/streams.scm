;;; streams.scm

(define (display-stream s)
  (define (display-stream-elements s)
    (if (empty-stream? s)
	#u
	(begin (display (head s))
	       (display " ")
	       (display-stream-elements (tail s)))))
  (display "#[ ")
  (display-stream-elements s)
  (display "]")
  #u)

(define (map-stream proc s)
  (if (empty-stream? s)
      the-empty-stream
      (cons-stream (proc (head s))
		   (map-stream proc (tail s)))))

(define (map-2-streams op s1 s2)
  (if (or (empty-stream? s1) (empty-stream? s2))
      (if (and (empty-stream? s1) (empty-stream? s2))
	  the-empty-stream
	  (error "streams different lengths" (list s1 s2)))
      (cons-stream (op (head s1) (head s2))
		   (map-2-streams op (tail s1) (tail s2)))))

(define (interleave-streams s1 s2)
  (if (empty-stream? s1)
      s2
      (cons-stream (head s1)
		   (interleave-streams s2 (tail s1)))))

(define (filter-stream pred s)
  (cond ((empty-stream? s)
	 the-empty-stream)
	((pred (head s))
	 (cons-stream (head s)
		      (filter-stream pred (tail s))))
	(else
	 (filter-stream pred (tail s)))))

(define (sieve-stream pred-f s)
  (cons-stream (head s)
    (sieve-stream pred-f
      (filter-stream (pred-f (head s)) (tail s)))))

(define (list->stream lst)
  (define (iter l s)
    (if l
	(iter (cdr l) (cons-stream (car l) s))
	s))
  (iter lst the-empty-stream))



;-------------------------------------------------------------------------------

(define ones
  (cons-stream 1 ones))

(define (integers-from n)
  (cons-stream n (integers-from (+ 1 n))))

(define natural-numbers
  (integers-from 0))

(define fibonacci-numbers
  (cons-stream 1
    (cons-stream 1
      (map-2-streams
	+
	fibonacci-stream
	(tail fibonacci-stream)))))

(define prime-numbers
  (sieve-stream
    (lambda (divisor)
      (lambda (test-val)
	(not (zero? (remainder test-val divisor)))))
    (integers-from 2)))



; EOF streams.scm

