;;; dump.scm

;;; (Use of this file may be hazardous to your garbage collector!!!)

;;;
;;; Object TAGS are in bits 31:28
;;;

(define TAG_PAIR		#x00)	; cdr offset = 0, car offset = 4
(define TAG_STREAM		#x01)	; pair underneath
(define TAG_ENV 		#x02)	; pair underneath
(define TAG_CLOSURE		#x03)	; pair underneath
(define TAG_VECTOR		#x04)	; size, byte_size, ref, ref, ...
(define TAG_NUMBER		#x05)	; constant or pointer to rawdata in 23:0
(define TAG_STRING		#x06)	; size, char, char, ...
(define TAG_PORT		#x07)	; subtagged, value stored in bits 23:0
(define TAG_SMALLCONST		#x08)	; small constants -- see below
(define TAG_SYMBOL		#x09)	; index into symbol list
(define TAG_EOF_OBJECT		#x0A)	; point ptr in 24:0, but don't reuse it
(define TAG_ENIGMA		#x0B)	; for "boxed" values; value in bits 23:0
(define TAG_STORAGE		#x0C)	; "scrap" memory -- unspecified format
; --- no tag $0D
; --- no tag $0E
(define TAG_RAWDATA		#x0F)	; raw data in heap; size in bits 23:0

(define TAG_IMPOSSIBLE		TAG_SMALLCONST) ; marks gc forwarding pointers
(define TAG_UNIT		TAG_SMALLCONST)
(define TAG_EMPTY_LIST		TAG_SMALLCONST)
(define TAG_EMPTY_STREAM	TAG_SMALLCONST)
(define TAG_CHARACTER		TAG_SMALLCONST) ; character in bits 7:0
(define TAG_BOOLEAN		TAG_SMALLCONST)
(define TAG_STACK_MARKER	TAG_SMALLCONST) ; don't store this anywhere!!!


;;;
;;; Subtags are in bits 27:24
;;;

(define SC_SUBTAG_IMPOSSIBLE	#x00)
(define SC_SUBTAG_UNIT		#x01)
(define SC_SUBTAG_EMPTY_LIST	#x02)
(define SC_SUBTAG_EMPTY_STREAM	#x03)
(define SC_SUBTAG_CHARACTER	#x04)
(define SC_SUBTAG_BOOLEAN	#x05)
(define SC_SUBTAG_STACK_MARKER	#x06)

(define CL_SUBTAG_UNSPECIFIED	#x00)
(define CL_SUBTAG_PRIMITIVE	#x01)
(define CL_SUBTAG_PROCEDURE	#x02)
(define CL_SUBTAG_COMPILED	#x03)
(define CL_SUBTAG_THUNK 	#x04)
(define CL_SUBTAG_PROMISE	#x05)
(define CL_SUBTAG_CONTINUATION	#x06)

(define NUM_SUBTAG_CONSTANT	#x00)	; signed value stored in bits 15:0
(define NUM_SUBTAG_FIXNUM	#x01)	; pointer to rawdata holding a longword
(define NUM_SUBTAG_RATNUM	#x02)	; not currently used
(define NUM_SUBTAG_BIGNUM	#x03)	;  "     "       "
(define NUM_SUBTAG_FLONUM	#x04)	;  "     "       "
(define NUM_SUBTAG_NUMBER_PAIR	#x05)	;  "     "       "


(define tag-name
  (vector
    'TAG_PAIR
    'TAG_STREAM
    'TAG_ENV
    'TAG_CLOSURE
    'TAG_VECTOR
    'TAG_NUMBER
    'TAG_STRING
    'TAG_PORT
    'TAG_SMALLCONST
    'TAG_SYMBOL
    'TAG_EOF_OBJECT
    'TAG_ENIGMA
    'TAG_STORAGE
    '*UNKNOWN-TAG*
    '*UNKNOWN-TAG*
    'TAG_RAWDATA))



(define closure? procedure?)

(define (call-with-tag&subtag&ref obj proc)
  (let ((rep (obj->rep obj)))
    (call-with-quotient&remainder (car rep) #x10
      (lambda (tag subtag)
	(proc tag subtag (cdr rep))))))

(define (dump-obj-rep obj)
  (call-with-tag&subtag&ref obj
    (lambda (tag subtag ref)
      (list tag (vector-ref tag-name tag) subtag ref))))


(define (error-if-not-closure obj)
  (if (not (closure? obj))
      (error "object not a closure" obj)))



(define (closure-params closure)
  (error-if-not-closure closure)
  (dump-obj-rep (!storage-ref closure 1)))



(define (compound-procedure-params proc)
  (if (compound-procedure? proc)
      (!storage-ref proc 1)
      (error "object not a compound procedure" proc)))

(define (compound-procedure-body proc)
  (if (compound-procedure? proc)
      (car (!storage-ref proc 0))
      (error "object not a compound procedure" proc)))

(define (compound-procedure-env proc)
  (if (compound-procedure? proc)
      (cadr (!storage-ref proc 0))
      (error "object not a compound procedure" proc)))



;-------------------------------------------------------------------------------
;
; CONTINUATION STRUCTURE
; ----------------------
;
; (#u body-code env-stuff . pspec)
;
;      pspec:1 (boxed)	(parameter specifier: exactly 1 argument)
;  body-code:boxed pointer to 68k code
;  env-stuff:(Scheme_stack proc_stack state_point . ???)
;
;	      env:environment in which continuation was created
;    Scheme_stack:VECTOR containing the Scheme stack during creation
;      proc_stack:STORAGE containing the processor stack during creation
;     state_point:the state point during creation
;
; All the Scheme registers are pushed onto the Scheme_stack before the
; vector is created.
;
;-------------------------------------------------------------------------------
;
; STATE POINT STRUCTURE
; ---------------------
;
; (parent_state_point entry_thunk exit_thunk boxed_interrupt_mask . ???)
;
; Note that state points have no special tags; they are just lists.
; It is not currently intended that they be first-class (or even expressible)
; in the system.
;
;-------------------------------------------------------------------------------

(define (dump-continuation cont)
  (if (continuation? cont)
      (list (dump-obj-rep (car (!storage-ref cont 0)))
	    (cadr (!storage-ref cont 0)))
      (error "object not a continuation" cont)))

(define (dump-continuation-proc-stack cont)
  (let ((cont-dump (dump-continuation cont)))
    (let ((proc-stack (cadr (cadr cont-dump))))
      (let ((proc-stack-rep (!storage-rep-ref proc-stack 0)))
	(let ((byte-size (+ (* #x1000000 (car proc-stack-rep)) (cdr proc-stack-rep))))
	  (let ((n-items (inexact->exact (/ byte-size 4))))
	    (define (dump-items i item-list)
	      (if (< i 1)
		  item-list
		  (dump-items (- i 1) (cons (!storage-rep-ref proc-stack i) item-list))))
	    (dump-items n-items '()) ))))))

(define (dump-continuation-Scheme-stack cont)
  (let ((cont-dump (dump-continuation cont)))
    (let ((Scheme-stack (car (cadr cont-dump))))
      Scheme-stack)))



;-------------------------------------------------------------------------------
;
; ENVIRONMENT STRUCTURE
; ---------------------
;      env
;	 \
;	  OO
;	 /  \
;	/    \		  To find a binding, search each frame in var-list from
; var-list  val-list	  frame0 for the desired symbol.  If found at frame F,
;			  binding B, then find its value in frame F, binding B
;			  of val-list.
; var-list
;   -or-
; val-list
;	\
;	 OO-----OO-- - - --OO-nil
;	 |	|	   |
;	 |	|	   |
;      frame0 frame1	 frameJ-1
;
;  frameI
;     \
;      OO-----OO-- - - --OO-nil
;      |      | 	 |
;      |      | 	 |
;    var0   var1       varK-1
;    -or-   -or-       -or-
;    val0   val1       valK-1
;
;-------------------------------------------------------------------------------

(define (dump-env-var-frame-list env)
  (if (environment? env)
      (!storage-ref env 1)
      (error "object not an environment" env)))

(define (dump-env-val-frame-list env)
  (if (environment? env)
      (!storage-ref env 0)
      (error "object not an environment" env)))

(define (dump-env env)
  (cons (dump-env-var-frame-list env)
	(dump-env-val-frame-list env)))

(define (dump-env-bindings env)
  (map (lambda (var-list val-list)
	 (map (lambda (var val)
		(cons var val))
	      var-list
	      val-list))
       (dump-env-var-frame-list env)
       (dump-env-val-frame-list env)))



;;; EOF dump.scm

