;       This is an example to test RemCom
;       ©1992 By Dalibor S. Kezele


; here is the begin of routine

start:
        moveq   #0,d0           ; set init
loop:
        addq.b  #1,d0
        move.w  d0,$dff180      ; -> background
        move.w  d0,$dff182      ; -> colour 1
leftmb:
        btst    #6,$bfe001      ; check left button
        bne.s   loop            ; repeat if not pressed
end:
        moveq   #0,d0
        rts                     ; return
