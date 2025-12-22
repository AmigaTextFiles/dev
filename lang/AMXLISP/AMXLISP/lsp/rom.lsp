; This VERY simple file shows you all Resident Structures known
; by the system. We get the ResModules array pointer in ExecBase
; and we look at every NON_NULL pointer in this table.
; For each Resident Structure, we show all fields, and translate
; the two identification strings into XLISP strings

(load-c-struct "exec/execbase")
(load-c-struct "exec/resident")
(setq eb (send execbase :new (cassoc 'base exec)))
(setq resmods (send (send eb :-> 'resmodules) :ptr))
(defun resmods ()
   (do ((i 0 (setq i (+ i 4))))
    ((equal (memory-long (+ resmods i)) 0))
    (setq rt (send resident :new (memory-long (+ resmods i))))
    (send rt :fshow)
;   (when (> (send rt :-> 'rt_flags)   128)
    (print (c-to-string (send (send rt :-> 'rt_name) :ptr)))
    (print (c-to-string (send (send rt :-> 'rt_idstring) :ptr)))
;    )
    ))
