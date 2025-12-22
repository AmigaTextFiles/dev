
           opt      c-,o-
Ymax       = 256                        ; Maximum allowed Y position
Ymin       = 0                          ; Minimum allowed Y position



           ********************
           clr.l    d0
           move.b   $dff00a,d0          ; joy0dat
           move.w   d0,oldy             ; setup lastreading variable
           move.w   #0,ypos             ; clear ypos
           ********************
           ; Your program goes here. You should put 'Bsr Readmouse' in your
           ; VBlank (level 3) interupt and then when you want to read the mouse
           ; position you should just get the word found at Ypos: which contains
           ; the mouse position.



           *******************          ; Include this subroutine in your
                                        ; program.
readmouse:
           clr.w    d0
           move.b   $dff00a,d0          ; joy0dat
           move.w   oldy,d1
           sub      d0,d1
           move.w   d1,yp               ; calculate diference between the
                                        ; last reading and the current reading

           move.w   d0,oldy             ; store the current reading

           cmp.w    #128,yp             ; is the diference greater that 128
                                        ; (129-255)
           blt      mouse_not_128
           sub.w    #256,yp             ; make it 0 to 127

mouse_not_128:
           cmp.w    #-128,yp            ; is the differnce between -128 and 0
           bgt      mouse_not_minus
           add.w    #256,yp             ; make it in the range 0 to 127

mouse_not_minus:
           move.w   yp,d0
           add.w    d0,yp2              ; add on the difference to the mouse
                                        ; position

           cmp.w    #ymin,yp2           ; check if it goes out of range
           bge.s    ypos_ok1
           move.w   #ymin,yp2           ; stop if going out of range
ypos_ok1:

           cmp.w    #ymax,yp2           ; check if it goes out of range
           blt.s    ypos_ok2
           move.w   #ymax,yp2           ; stop if going out of range
ypos_ok2:

           move.w   #256,d0             ; invert the reading as mouse reader
           sub.w    yp2,d0              ; gives the reverse info
           move.w   d0,ypos             ; store in user var

           rts


ypos:      dc.w     0
oldy:      dc.w     0
yp:        dc.w     0
yp2:       dc.w     0


           end


