
 If InitRainbow(0) And InitScreen(0)

   OpenScreen(0,320,256,4,0)
   CreateRainbow(0,256)

   For c.l=0 To 255
     RainbowColor(0, c.l, c.l*256*256+c.l*256+c.l)
   Next c.l

   RainbowEnd(0)
   ShowRainbow(0,ScreenID())


   Repeat

     VWait()
     mb.w=MouseButtons()

     If mb.w = 2 AND s.w = 0
       HideRainbow(0) : s.w=1 
       Delay(5) : mb.w=0
     EndIf

     If mb.w = 2 AND s.w = 1
       ShowRainbow(0,ScreenID()) : s.w=0
       Delay(5)
     EndIf

   Until mb.w = 3

 EndIf

 PrintN("End of Program.")
 End
