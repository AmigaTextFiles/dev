; Basic Demo

(load "allocate")
(load-c-struct "intuition/intuition" '(newwindow window intuitext))
(load-c-struct "graphics/rastport" '(rastport))
(load-c-struct "exec/ports" '(msgport))
(defamiga 'Wait 'exec)
(defamiga 'OpenWindow 'intuition)
(defamiga 'CloseWindow 'intuition)
(defamiga 'SetWindowTitles 'intuition)
(defamiga 'PrintIText 'intuition)
(defvar wtitle "AMXLisp Demo")
(defvar itxt "Hello Word")


; beuark !
(defmacro str-address (str)
   `(memory-long (+ (address-of ,str) 6)))

; !!??????!!!!
(defmacro iexp (x y)
   `(truncate (expt (float ,x) (float ,y))))
; 2^31 ???
(defun power2 (x)
   (cond ((equal x 31) 2147483648)
         (t (iexp 2 x))))

(defun demo ()
   (let ((nw (newamiga newwindow))
         (txt (newamiga intuitext)))
       (send nw :-> 'LeftEdge 10)
       (send nw :-> 'TopEdge 10)
       (send nw :-> 'Width 400)
       (send nw :-> 'Height 100)
       (send nw :-> 'DetailPen 0)
       (send nw :-> 'BlockPen 1)
       (send nw :-> 'IDCMPFlags #x200)  ; CLOSEWINDOW
       (send nw :-> 'Flags #x100f)      ; ACTIVATE | all system gadgets
       (send nw :-> 'MinWidth 40)
       (send nw :-> 'MinHeight 40)
       (send nw :-> 'Type 1)
       (send txt :-> 'FrontPen 2)
       (send txt :-> 'BackPen 3)
       (send txt :-> 'LeftEdge 20)
       (send txt :-> 'TopEdge  20)
       (send txt :-> 'FrontPen 2)
       (send txt :-> 'IText (str-address itxt))

       (let ((myw (send window :new (callamiga 'OpenWindow intuition nw))))
            (callamiga 'SetWindowTitles intuition myw wtitle 0)
            (callamiga 'PrintIText intuition (send myw :-> 'RPort) txt 0 0)
            (dotimes (i 1000) ())
            (callamiga 'Wait exec (power2
                                        (send (send myw :-> 'UserPort)
                                              :-> 'mp_SigBit)))
            (callamiga 'CloseWindow intuition myw)
            (freeamiga nw) (freeamiga txt))))






