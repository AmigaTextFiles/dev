OPT     OSVERSION = 37
OPT     MODULE

MODULE  'graphics/rastport'
MODULE  'graphics/text'
MODULE  'intuition/intuition'
MODULE  'newgui/newgui'

EXPORT PROC ng_performdnd(win:PTR TO window,self:PTR TO plugin)         -> Planned for Future: GELs-Support!
 DEF    x=0:REG,
        y=0:REG,
        oldx=0:REG,
        oldy=0:REG,
        dndwin=NIL:PTR TO window                                        -> A Window which should be (mis-)taken for Drag'N'Drop!

  IF (self.dis=FALSE)                                                   -> Only if the Plugin isn`t disabled!
    IF Odd(self.dnd_info)                                               -> If there is an Image inside... (unnecessary if there is a String too!)
     dndwin:=OpenWindowTagList(NIL,                                     -> Open the Window
       [WA_FLAGS,       WFLG_BORDERLESS OR WFLG_RMBTRAP OR WFLG_NOCAREREFRESH,
        WA_LEFT,        win.leftedge+self.x,
        WA_TOP,         win.topedge+self.y,
        WA_WIDTH,       self.dnd_selectimage.width,
        WA_HEIGHT,      self.dnd_selectimage.height,
        WA_TITLE,       NIL,
        WA_CUSTOMSCREEN,win.wscreen,                                    -> Open on the actual NewGUI-Screen!
        NIL,            NIL])
     IF (dndwin<>NIL) THEN DrawImage(dndwin.rport,self.dnd_selectimage,0,0) -> Draw the selected Image inside the Window!
    ELSEIF Even(self.dnd_info)                                          -> If there is an String inside!
     IF (dndwin:=OpenWindowTagList(NIL,                                 -> open the Window
       [WA_FLAGS,       WFLG_BORDERLESS OR WFLG_RMBTRAP OR WFLG_NOCAREREFRESH,
        WA_LEFT,        win.leftedge+self.x,
        WA_TOP,         win.topedge+self.y,
        WA_WIDTH,       TextLength(win.rport,self.dnd_text,self.dnd_textlen), -> Get the Text-Length in Pixels
        WA_HEIGHT,      self.gh.tattr.ysize,
        WA_TITLE,       NIL,
        WA_CUSTOMSCREEN,win.wscreen,
        NIL,            NIL]))
       SetABPenDrMd(dndwin.rport,2,3,RP_JAM2)                           -> Set Front-/BackPen and Drawmode!
      Move(dndwin.rport,0,self.gh.tattr.ysize-3)                        -> Move to the right position (-3 = Baseline-Position!)
     Text(dndwin.rport,self.dnd_text,self.dnd_textlen)                  -> Print the Text to this PositioN!
     ENDIF
    ENDIF
    IF (dndwin<>NIL)                                                    -> If the window is open...
     WHILE Mouse()>0                                                    -> Loop, `till the Left Button is released (Unfine, because Mouse() isn`t really good for this!)
      oldx:=x                                                           -> Store the "old" mouse-coordinates to calculate
       oldy:=y                                                          -> the relative-coordinates needed for the Move!
        x:=win.mousex                                                   -> Get the actual Mouse-Position from the window-mousex and mousey
        y:=win.mousey                                                   -> variable (relative to the Screens leftupper-edge!)
       Delay(1)                                                         -> Important (!) because we don`t need all the CPU-Time for this loop!!!!!
      IF (oldx<>0) OR (oldy<>0) THEN MoveWindow(dndwin,(x-oldx),(y-oldy))-> Move the window (ATTENTION! Relative-Coordinates are needed!)
     ENDWHILE
    CloseWindow(dndwin)                                                 -> Close the window again!
   ENDIF
  ENDIF
ENDPROC x,y                                                             -> IMPORTANT!!! Return the last Mouse-Position!!!!
