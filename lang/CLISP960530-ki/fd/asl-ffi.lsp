;;; FFI demos and "how to" for the Amiga
#-FFI(error "Foreign Function Interface (FFI) no available")

(in-package "FFI-DEMOS")
(use-package "FFI")

#|
;;; What I've added to FOREIGN1.LSP
#+AMIGA
(defmacro DEF-LIB-CALL-OUT (&whole whole name library &rest options)
  (check-symbol whole)
  (let* ((alist (parse-options options '(:name :offset :arguments :return-type) whole))
         (c-name (foreign-name name (assoc ':name alist)))
         (offset (second (assoc ':offset alist))))
    `(LET ()
       (SYSTEM::REMOVE-OLD-DEFINITIONS ',name)
       (EVAL-WHEN (COMPILE) (COMPILER::C-DEFUN ',name))
       (SYSTEM::%PUTD ',name
         (FFI::FOREIGN-LIBRARY-FUNCTION ',c-name
          (FFI::FOREIGN-LIBRARY ',library)
          ',offset
          (PARSE-C-FUNCTION ',(remove (assoc ':name alist) alist) ',whole)))
       ',name
) )  )
|#

;; I think what's missing is a C-POINTER-NULL type
;; (C-ARRAY-PTR uint32) might help but would not work with AllocateTagItems
(def-lib-call-out AllocAslRequest "asl.library"
  (:name "AllocAslRequest")
  (:offset -48)
  (:arguments
   (reqType uint32 :in :none :d0)
   (taglist uint32 :in :alloca :a0)) ; don't use c-pointer as we couldn't pass a NULL in!
  (:return-type c-pointer :none))

(def-lib-call-out FreeAslRequest "asl.library"
  (:name "FreeAslRequest")
  (:offset -54)
  (:arguments
   (requester c-pointer :in :none :a0))
  (:return-type nil :none))

(def-lib-call-out AslRequest "asl.library"
  (:name "RequestFile")
  (:offset -60)
  (:arguments
   (requester c-pointer :in :none :a0)
   (taglist uint32 :in :alloca :a1)) ; don't use c-pointer as we couldn't pass a NULL in!
  (:return-type boolean :none))

(defun AddPart2 (dir file)
  (declare (type string dir file))
  ;; pretend we don't know dos.library/AddPart()
  (concatenate
   'string
   dir
   (unless (zerop (length dir))
           (unless (find (char dir (1- (length dir))) ":/") "/"))
   file))


;; DEF-C-STRUCT costs a lot as accessors, constructor and copier are defined
(def-c-struct FR-File-Drawer
  ;; at offset 4 of FileRequester structure
  (File      c-string)
  (Drawer    c-string)
)


;; roughly the level of the AFFI
(defun aslfilerequest2 ()
  (let ((fr (allocaslrequest 0 0)))
    (when t                             ;null-pointer test?
      (unwind-protect
           (when (aslrequest fr 0)
             (let ((file (ffi::foreign-value (ffi::foreign-address-variable "file" fr 4 'c-string)))
                   (dir  (ffi::foreign-value (ffi::foreign-address-variable "drawer" fr 8 'c-string))))
               (addpart2 dir file)))
        (FreeAslRequest fr)))))
; Space: 142 Bytes

;; a FOREIGN-ADDRESS can only be tested for NULL with EQUALP against a known
;; NULL address. Where to get this first one?

;; a FOREIGN-ADDRESS-VARIABLE is a typed reference to an external object
;; (SLOT (FFI::FOREIGN-VALUE ...)) only dereferences given slot
(defun aslfilerequest3 ()
  (let ((fr (allocaslrequest 0 0)))
    (when t                             ;null-pointer test?
      (unwind-protect
           (when (aslrequest fr 0)
             (let* ((frvar (ffi::foreign-address-variable
                            "f+d"       ; name could be NIL (not needed)
                            fr          ; convert object to Lisp now
                            4 (ffi::parse-c-type 'FR-File-Drawer)))
                    (file (slot (ffi::foreign-value frvar) 'File))
                    (dir  (slot (ffi::foreign-value frvar) 'Drawer)))
               (addpart2 dir file)))
        (FreeAslRequest fr)))))
; Space: 182 Bytes

;; drawback is that the whole FR-File-Drawer is dereferenced and converted
;; but here it's an advantage as all slots are used
(defun aslfilerequest5 ()
  (let ((fr (allocaslrequest 0 0)))
    (when t                             ;null-pointer test?
      (unwind-protect
           (when (aslrequest fr 0)
             (let* ((frvar (ffi::foreign-value
                            (ffi::foreign-address-variable
                             "f+d" fr
                             4 (ffi::parse-c-type 'FR-File-Drawer))))
                    (file (FR-File-Drawer-File   frvar))
                    (dir  (FR-File-Drawer-Drawer frvar)))
               (addpart2 dir file)))
        (FreeAslRequest fr)))))
; Space: 122 Bytes

;; a local foreign structure should be set at compile-time, otherwise it conses a lot
(defun aslfilerequest7 ()
  (let ((fr (allocaslrequest 0 0)))
    (when t                             ;null-pointer test?
      (unwind-protect
           (when (aslrequest fr 0)
             (let* ((frvar (ffi::foreign-address-variable
                            "f+d" fr
                            4 '#.(ffi::parse-c-type
                                  '(c-struct nil ;an attempt at local structures
                                    (file c-string)
                                    (drawer c-string)))))
                    ;;<==>(slot (ffi::foreign-value frvar) 'file)
                    (file (ffi::foreign-value (ffi::%slot frvar 'file)))
                    (dir  (ffi::foreign-value (ffi::%slot frvar 'drawer))))
               (addpart2 dir file)))
        (FreeAslRequest fr)))))
; Space: 182 Bytes
;; I don't like the (slot (foreign-value ..)) syntax much, as it makes
;; me think it dereferences the complete object where it does not



;; ffi::parse-c-type at macroexpansion-time so a constant value is compiled in
#|
(defmacro WITH-FOREIGN-VALUE ((var object type &optional (offset 0)) &body body)
  (let ((fvar (gensym)))
    `(LET ((,fvar (FFI::FOREIGN-ADDRESS-VARIABLE
                  "unnamed" ,object ,offset ',(ffi::parse-c-type type))))
       (SYMBOL-MACROLET ((,var (FFI::FOREIGN-VALUE ,fvar)))
         ,@body))))
|#
(defmacro WITH-FOREIGN-VALUE ((var object type &optional (offset 0)) &body body)
  (let ((fvar (gensym)))
    `(LET ((,fvar (FFI::FOREIGN-ADDRESS-VARIABLE
                  "unnamed" ,object ,offset
                  ,(if (consp type)
                       (list 'QUOTE (ffi::parse-c-type type)) ; assume a (STRUCT ...)
                       ;; don't deparse DEF-C-STRUCT types at macroexpansion time
                       `(FFI::PARSE-C-TYPE ',type)))))
       (SYMBOL-MACROLET ((,var (FFI::FOREIGN-VALUE ,fvar)))
         ,@body))))


;; that's beginning to get close to what I like
;; oh, it looks a lot like CMU
(defun aslfilerequest8 ()
  (let ((fr (allocaslrequest 0 0)))
    (when t                             ;null-pointer test?
      (unwind-protect
           (when (aslrequest fr 0)
             (with-foreign-value
              (frvar fr (c-struct nil (file c-string) (drawer c-string)) 4)
              (addpart2 (slot frvar 'drawer)
                        (slot frvar 'file))))
        (FreeAslRequest fr)))))
; Space: 182 Bytes

;; or this, but it requires the overhead of DEF-C-STRUCT
(defun aslfilerequest9 ()
  (let ((fr (allocaslrequest 0 0)))
    (when t                             ;null-pointer test?
      (unwind-protect
           (when (aslrequest fr 0)
             (with-foreign-value
              (frvar fr FR-File-Drawer 4)
              (addpart2 (slot frvar 'drawer)
                        (slot frvar 'file))))
        (FreeAslRequest fr)))))
; Space: 182 Bytes

;; Finally I prefer ASLFILEREQUEST8
;; With local structures you can avoid a lot, but not all of CLOS overhead,
;; but you can't get around DEF-C-STRUCT without local structures.


#|
(def-lib-call-out FindTask "exec.library"
  (:name "FindTask")
  (:offset -294)
  (:arguments
   (name    c-string :in :alloca :a1))
  (:return-type c-pointer :none))
;; how can I tell whether the call succeeded?
;; the result could be either (c-ptr-null my-library), c-pointer or uint32.
|#

