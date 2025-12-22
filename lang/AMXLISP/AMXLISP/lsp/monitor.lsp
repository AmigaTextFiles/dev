;demo file that shows you the essential ressources in your Amiga

(progn
   (defamiga 'FindTask 'exec )
   (load-c-struct "exec/lists")
   (load-c-struct "exec/tasks")
   (load-c-struct "exec/nodes")
   (load-c-struct "exec/libraries" )
   (load-c-struct "exec/execbase" )
   (load-c-struct "exec/ports")
   (load-c-struct "graphics/text" '(textfont))
   (load-c-struct "graphics/gfxbase" )
   (load-c-struct "exec/types" )
   (load-c-struct "exec/memory" ))

; we should use this but I can't get make-symbol to work
;(defun monitor (name)
;   (let ((exbase (execbase :new (cassoc 'base exec))))
;        (funcall (make-symbol (strcat "monitor-" (symbol-name name))))))
;so instead we fix
(setq exbase (send execbase :new (cassoc 'base exec)))

; how to get an Xlisp list with all the nodes from a c_list
(defun get-list (liststruct)
   (let* ((headnode (send liststruct :-> 'lh_head))
          (thelist (list headnode)))
         (get-list-aux headnode thelist)))
(defun get-list-aux (anode thelist)
   (let ((nextnode (send anode :-> 'ln_succ)))
        (if (equal (send nextnode :ptr) 0)
            thelist
            (append1 (get-list-aux nextnode thelist) nextnode))))

(defun monitor-task ()
   (let ((taskreadylist (send exbase :-> 'TaskReady))
         (taskwaitlist (send exbase :-> 'TaskWait)))
        (print "***** TASK READY *******")
        (mapc 'analyse-task (get-list taskreadylist))
        (print "***** TASK WAIT *******")
        (mapc 'analyse-task (get-list taskwaitlist))))

(defun analyse-task (nodestruct)
   (let ((tname (c-to-string (send (send nodestruct :-> 'ln_Name) :ptr)))
         (tpri (send nodestruct :-> 'ln_pri)))
        (princ "Task Name: ") (princ tname) (terpri)
        (princ "  with priority:") (princ tpri) (terpri)))

(defun monitor-library ()
   (let ((liblist (send exbase :-> 'LibList)))
        (mapc 'analyse-library (get-list liblist))))

(defun monitor-device ()
   (let ((devlist (send exbase :-> 'DeviceList)))
        (mapc 'analyse-library (get-list devlist))))

(defun analyse-library (nodestruct)
   (princ "Library Name: ")
   (princ  (c-to-string (send (send nodestruct :-> 'ln_Name) :ptr)))
   (terpri)
   (let ((libstruct (send library :new (send nodestruct :ptr))))
        (princ "  version: ") (princ (send libstruct :-> 'lib_version))(terpri)
        (print "  revision:  ") (princ (send libstruct :-> 'lib_revision))(terpri)
        (princ " Current OpenCnt: ") (princ (send libstruct :-> 'lib_OpenCnt))(terpri)
        (print "  IdString:  ")
        (print  (c-to-string (send (send libstruct :->  'lib_IdString) :ptr)))
        ))

(defun monitor-port ()
   (let ((portlist (send exbase :-> 'PortList)))
        (mapc 'analyse-port (get-list portlist))))

(defun analyse-port (nodestruct)
   (princ "Port Name: ") (princ (c-to-string (send (send nodestruct :-> 'ln_Name) :ptr)))(terpri)
   (let ((portstruct (send msgport :new (send nodestruct :ptr))))
        (princ " adresse: ")(princ (send portstruct :ptr))(terpri)
        (princ " sigbit: ")(princ (send portstruct :-> 'mp_sigbit))(terpri)
        ))


; there is in GfxBase a pointer to the list of fonts
(defun monitor-font ()
   (let ((graphicsbase (send gfxbase :ptr (openlibrary 'graphics))))
        (mapc 'analyse-font
              (get-list (send graphicsbase :-> 'TextFonts)))
        (callamiga 'CloseLibrary exec graphicsbase)))


(defun analyse-font (nodestruct)
   (princ "Font Name: ") (princ (c-to-string (send (send nodestruct :-> 'ln_Name) :ptr)))(terpri)
   (let ((fontstruct (send textfont :new (send nodestruct :ptr))))
        (princ "YSize : ")(princ (send fontstruct :-> 'tf_Ysize))(terpri)
        (princ " Style : ")(princ (send fontstruct :-> 'tf_Style))(terpri)
        (princ " Flags : ")(princ (send fontstruct :-> 'tf_Flags))(terpri)
        (princ " XSize : ")(princ (send fontstruct :-> 'tf_Xsize)))(terpri)
        )

(defun monitor-mem ()
   (let ((memorylist (send exbase :-> 'memlist)))
        (mapc 'analyse-mem (get-list memorylist))))


(defun analyse-mem (nodestruct)
   (princ "Node Name: ")(princ (c-to-string (send (send nodestruct :-> 'ln_Name) :ptr)))(terpri)
   (let ((nodestruct (send memheader :new (send nodestruct :ptr))))
   (princ "  Attributes: ")(princ (send nodestruct :-> 'mh_Attributes))(terpri)
   (unless (equal (send nodestruct :-> 'mh_Attributes) 0)
           (analyse-chunk (send nodestruct :-> 'mh_First)))
   (princ " Lower: ")(princ (send (send nodestruct :-> 'mh_Lower) :ptr ))(terpri)
   (princ " Upper: ")(princ (send (send nodestruct :-> 'mh_Upper) :ptr))(terpri)
   (princ "Free Bytes: ")(princ (send nodestruct :-> 'mh_Free))(terpri)
   ))

(defun analyse-chunk (chunk)
   (if (equal (send chunk :ptr) 0)
       (terpri)
       (progn (princ (send chunk :-> 'mc_Bytes))
              (analyse-chunk (send chunk :-> 'mc_Next)))))

;we still have to write lhoblist
;(defun monitor-? () (lhoblist 'monitor))

(defun examine-task (name)
   (let ((taskptr (callamiga 'FindTask exec name)))
        (when (equal taskptr 0)
              (error  "task not found" name))
        (let ((mytask (send node :new taskptr)))
             (princ "Priority: ")(princ (send mytask :-> 'ln_pri))(terpri)
             (let ((mytask (send task :new taskptr)))
             (princ "  Flags: ")(princ (send mytask :-> 'tc_Flags))(terpri)
             (princ "  State: ")(princ (send mytask :-> 'tc_State))
             (princ "Sig: ")
             (princ "Alloc ")(princ (send mytask :-> 'tc_SigAlloc))
             (princ " Wait ")(princ (send mytask :-> 'tc_SigWait))
             (princ " Recvd ")(princ (send mytask :-> 'tc_SigRecvd))
             (princ " Except ")(princ (send mytask :-> 'tc_SigExcept))
             (terpri)
             (princ "Traps: ")
             (princ "Alloc ")(princ (send mytask :-> 'tc_TrapAlloc))
             (princ " Able ")(princ (send mytask :-> 'tc_TrapAble))
             (princ " Data ")(princ (aref (send mytask :-> 'tc_TrapData) 0 ))
             (princ " Code ")(princ (aref (send mytask :-> 'tc_TrapCode) 0 ))
             (terpri)
             (princ "Except: ")
             (princ " Data ")(princ (aref (send mytask :-> 'tc_ExceptData) 0 ))
             (princ " Code ")(princ (aref (send mytask :-> 'tc_ExceptCode) 0 ))
             (terpri)
             (princ "Stack: ")
             (princ " Pointer ")(princ (aref (send mytask :-> 'tc_SPReg) 0 ))
             (princ " Lower ")(princ (aref (send mytask :-> 'tc_SPLower) 0 ))
             (princ " Upper ")(princ (aref (send mytask :-> 'tc_SPUpper) 0 ))
             (terpri)
             (princ "Memory: ")
             (let ((mlist (get-list (send mytask :-> 'tc_MemEntry))))
                  (mapc 'analyse-entry mlist)))))
)
;(defun analyse-entry (nodestruct)
;   (typevector nodestruct 'mementry)
;   (show nodestruct))





