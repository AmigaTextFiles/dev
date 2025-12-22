
; ************************************
;
;  Rainbow example file for PureBasic
;
;    © 2000 - Fantaisie Software -
;
; ************************************


 If InitRainbow(0) AND InitScreen(0)

   OpenScreen(0,320,256,4,0)
   CreateRainbow(0,256)

   For c.l=0 To 255
     RainbowColor(0,c.l,c.l,c.l,c.l)
   Next

   RainbowEnd(0)
   ShowRainbow(0,ScreenID())

   Repeat

     VWait() : VWait()
     mb.w=MouseButtons()

     If mb.w = 2 AND s.w = 0
       HideRainbow(0) : s.w=1 
       Delay(20) : mb.w=0
     EndIf

     If mb.w = 2 AND s.w = 1
       ShowRainbow(0,ScreenID()) : s.w=0
       Delay(20)
     EndIf

     If mb.w = 3
       quit.w=1
     EndIf

   Until quit = 1

 EndIf

 PrintN("End of Program.")
 End

