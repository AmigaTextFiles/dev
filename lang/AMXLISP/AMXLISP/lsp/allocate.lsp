; Basis for memory-management of C heap from AMXLisp
; Of course we could have used AllocRemember...

(unless (boundp 'heap-c-alloc) (defvar heap-c-alloc ()))
(defamiga 'AllocMem 'exec)
(defamiga 'FreeMem 'exec)

; chip = t for Chip memory
(defun newamiga (struct &optional chip)
   (let* ((tmpstruct (send struct :new 0))
          (size (send tmpstruct :size-of))
          (adrs (callamiga 'AllocMem exec size (if chip #x10003 #x10005))))
         (if (eq adrs 0)
             (error "Can't allocate :" size)
             (progn (send tmpstruct :isnew adrs)
                    (setq heap-c-alloc (cons (cons adrs size) heap-c-alloc))
                    tmpstruct))))


(defun freeamiga (struct)
   (if (objectp struct)
       (let ((x (assoc (send struct :ptr) heap-c-alloc)))
           (when x
               (callamiga 'FreeMem exec (send struct :ptr) (cdr x))
               (setq heap-c-alloc (delete x heap-c-alloc :test 'equal))))))



; (free-heap) function for cleanup
(defun free-heap ()
   (mapc '(lambda (x)
            (callamiga 'FreeMem exec (car x) (cdr x)))
         heap-c-alloc)
   (setq heap-c-alloc ()))

