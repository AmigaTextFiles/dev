;------------- XLISP INTERFACE WITH AMIGA KERNEL ------------------------
; (C) Copyright Francois Rouaix 1987
;------------------------------------------------------------------------
;Added function to XLISP 1.7 core:
;   memory-byte
;   memory-word
;   memory-long
;   callasm
;------------------------------------------------------------------------
;Format for the XLincludes:
;(Structure-name (field)*)
;for each field the format is:
;(fieldname offset type)
;type is :
;   field=BYTE or eq         : 1
;   field=WORD or eq         : 2
;   field=LONG or eq         : 4
;   field=APTR               : byte . t
;   field=array              : size-of-array . type-of-elements
;   field=structure          : structurename
;   field=structure pointer  : structurename . t





;We first define a Class 'Amiga' that knows only two methods that are:
;read-field (address type)  :<address> is the absolute address in memory
;                           :<type> is the length in bytes to be
;                           read (1,2 or 4)
;write-field (address type value)   :the same, with <value> being the
;                                   :value to store in memory
;If <obj> is an instance of <class> class, it is apparently
;impossible to get the symbol used to define this class
;all we can get is #<Object: ...> by (send <obj> :class)
;So we implement :
;a class variable <defined> where we store an a-list of
;objects . name.
;And two methods (name & add-name) for this feature
;it may be interessant to store  the links between include files
;to provide an "autoload" for structure definitions



;---you should never call this function----
(defun  read-field (address type)
   (cond ((equal type 1)   ;BYTE
          (memory-byte address))
         ((equal type 2)  ;WORD
          (memory-word address))
         ((equal type 4)  ;LONG
          (memory-long address))
         ((consp type)  ;ARRAY/STRUCT/PTR/UNION
          (if (numberp (car type))
            ;this is an ARRAY
              (let* ((nb (car type))
                     (ln (cdr type))
                     (tmpvector (make-array nb)))
                    (dotimes (i nb tmpvector)
                             (aset tmpvector
                                   i
                                   (read-field (+ address
                                                  (* i (if (numberp ln)
                                                           ln
                                                           (send (send (eval ln) :new 0) :size-of))))
                                               (if (numberp ln)
                                                   ln
                                                   (cons ln t)))
                             )))
            ;STRUCT/PTR/UNION
              (let* ((tmpstruct ( send (eval (car type)) :new
                             (if (null (cdr type))
                                 address            ; the structure is here
                                 (memory-long address))))) ; it is a pointer
                   tmpstruct)))

         (t (error "Bad field description" type))))


(defun write-field (address type value)
   (cond ((equal type 1) (memory-byte address value))
         ((equal type 2) (memory-word address value))
         ((equal type 4) (memory-long address value))
         (t
          (if (numberp (car type))       ;this is an array
              (let ((ln (cdr type)))
                   (dotimes (i ln value)
                            (write-field (+ address (* i ln))
                                         type
                                         (aref value i))))

              ;this is a structure
              (if (null (cdr type)) ;the structure is really here
                  (print "Not yet implemented")
                  ;(mvmemory (aref value 0)
                  ;          (size-of (type-of champ))
                  ;          address)
                  (memory-long address value))))))


;there is apparently a problem with Lattice v3.03 's calloc
;examine the (send class :new ..) method
;when called with no class variables, we get an "insufficient vector space"
;it seems that the newvector() call fails because we ask a null allocation
;and returns a NULL that looks like an out_of_memory error

(setq Amiga (send Class :new '() '(defined)))

(send Amiga :answer :read-field '(address type) (cddr (getfn read-field)))
(send Amiga :answer :write-field '(address type value) (cddr (getfn write-field)))
(send Amiga :answer :name '(obj) '((cassoc obj defined)))
(send Amiga :answer :add-name '(obj name)
         '((setq defined (cons (cons obj name) defined))))

(defun class-of (o) (send o :name (send o :class)))

;for each C structure in RKM, we will define a class, that has Amiga
;for super-class and:
;-a class variable <descript> : containing the description
;of the  fields of the structure (see complete definition in docs)
;-a class variable <size> : the size (in bytes) of the structure
;-an instance variable <pointer> : the actual pointer in memory
;-a method <access-field> with the parameters : <field-name>
;            and eventually the <value> to store in that field.
;-a method <isnew> to force initialization of pointer variable



;this function to share the body definition of the method
;"->" (pronounce access-field) for every structure definition
;further access to this body via (cddar afshare)
;                                       not in 2.0 see getfn macro
;pointer, description and size are local variables, within the scope
;of the method
(defun afshare (fieldname & optional value)      ; don't call this
   (when (eq pointer 0)
         (error "Uninitialized structure: " self))   ;security
   (let* ((fieldinfo (assoc fieldname description))  ;return alist entry
          (offset (cadr fieldinfo))                  ;get offset
          (type (cddr fieldinfo)))                   ;get field description
          (when (null offset)                        ;
                (error "Bad field name: " fieldname))
          (if (null value)
              (send self :read-field (+ offset pointer) type)
              (send self :write-field (+ offset pointer) type value))))




(setq include-path "xlinclude:")
(setq include-suffix ".l")
(defun load-c-struct (includename &optional structlist)
   (let ((handle (open (strcat include-path includename include-suffix))))
        (when (null handle)
              (error "Can't find include file: " includename))
        (do ((l (read handle) (read handle)))
            ((null l) (close handle))
            (when (or (null structlist) (member (car l) structlist))
                (define-c-struct l)))))

(defmacro define-c-struct (l)
`(progn
   (set (car ,l) (send Class :new '(pointer) '(description size) Amiga))
   (send (eval (car ,l)) :answer :isnew '(ptr) (cddr (getfn isnewshare)))
   (send (eval (car ,l)) :answer :ptr '() '(pointer))
   (send (eval (car ,l)) :answer :-> '(fieldname &optional value)
                                 (cddr (getfn afshare)))
   (send (eval (car ,l)) :answer :init '(descript) (cddr (getfn initshare)))
   (send (eval (car ,l)) :answer :size-of '() (cddr (getfn size-of)))
   (send (eval (car ,l)) :answer :fshow '() (cddr (getfn showshare)))

   (let ((tmp (send (eval (car ,l)) :new 0)))
         (send tmp :init (cdr ,l))
         (send tmp :add-name (eval (car ,l)) (symbol-name (car ,l))))))


;example of structure definitio  (done by define-c-struct)
;(setq Window (Class :new '(pointer) '(description size) Amiga))
;(Window :answer :isnew '(ptr) (cddar isnewshare))
;(Window :answer :ptr '() '(pointer))
;(Window :answer :-> '(fieldname &optional value)
;                              (cddar afshare))
;(Window :answer :init '(descript) (cddar initshare))
;(setq w0 (Window :new 0))
;(w0 :init --the description loaded from include file--)
;(w0 :add-name w0 (symbol-name 'window))

(defun isnewshare (ptr)
   (setq pointer ptr)
   self)

;isnewshare should also compute the size of the structure
;and initialize the class variable <size>
(defun initshare (descript)
   (setq description descript)
   self)

; shared function for computing size of structure
;descript is in the scope
(defun size-of ()
   (let* ((lastfield (last description))
          (lastoffset (cadar lastfield))
          (lln (cddar lastfield)))
         (+ lastoffset
            (cond ((atom lln) lln)
                  (t (if (numberp (car lln))
                         (* (car lln) (cdr lln))
                         (if (cdr lln)
                             4
                             (send (car lln) :size-of))))))))

(defun showshare ()
   (setq *breakenable* ())
   (mapc (lambda (field)
            (princ (symbol-name (car field)))
            (princ ": ")
            (errset
               (let ((fval (send self :-> (car field))))
                  (if (objectp fval)
                      (progn (princ (class-of fval))
                             (princ "  ")
                             (princ (send fval :ptr)))
                      (princ fval))
                  (terpri))
               t )
            )

          description)
   (setq *breakenable* t)
   )


