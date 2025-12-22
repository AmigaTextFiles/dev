MODULE 'intuition/intuition'
MODULE 'shark/shkpointers'
MODULE 'shark/shktools'

DEF w:PTR TO window,pointer
PROC main()

w:=OpenW(0,0,300,100,0,WFLG_ACTIVATE,'Pointer-Demo',0,1,0)

pointer:=mAllocPointer()
mChangePointer(pointer,w,NEWPOINTER)
TextF(20,20,'NEWPOINTER    ')
mClick() ; Delay(20)
mChangePointer(pointer,w,WAITPOINTER)
TextF(20,20,'WAITPOINTER   ')
mClick() ; Delay(20)
mChangePointer(pointer,w,OLDPOINTER)
TextF(20,20,'OLDPOINTER    ')
mClick() ; Delay(20)
mChangePointer(pointer,w,DEATIVEPOINTER)
TextF(20,20,'DEATIVEPOINTER')
mClick() ; Delay(20)
mChangePointer(pointer,w,HIDEPOINTER)
TextF(20,20,'HIDEPOINTER   ')
mClick() ; Delay(20)

mFreePointer(pointer,w)

CloseW(w)

ENDPROC
