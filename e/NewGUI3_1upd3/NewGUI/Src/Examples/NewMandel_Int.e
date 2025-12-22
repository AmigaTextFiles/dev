/* 
 *  Runs the NewGUI-Engine (guimessage-handling) in a seperate Task
 * -===============================================================-
 * 
 * The Code for the calculating is taken out of the Amiga-E Example-
 * Sources from gfx/intmandel.e it was only changed to fit into the
 * scheme of the gfx-plugin and into the task-handling-code!
 */

OPT     LARGE 
OPT     OSVERSION = 37

MODULE  'dos/dos'                               -> For SIGBREAKF_CTRL_C
MODULE  'newgui/newgui'                         -> NewGUI-Engine
MODULE  'newgui/ng_guitask'                     -> Task-Code for NewGUI
MODULE  'newgui/ng_showerror'                   -> Error-Handling-Code (not neccesarry)
MODULE  'intuition/intuition'                   -> For window.rport-PTR

ENUM    GUI_MAIN = 1,
        GUI_WIN2

OBJECT  gfx     OF      plugin                  -> A Plugin to do BASIC gfx-Output to a Plugin-Area
 width                                          -> the Plugins Area so the display will not be trashed
 height                                         -> if a resize happens...
PRIVATE                                         -> Feel free to modify it, maybe you could make it
 rastport                                       -> to use a own bitmap/rastport and copy this bitmap into
ENDOBJECT

CONST   GFX = PLUGIN                            -> A Synonym for PLUGIN...

DEF     info:PTR TO guitaskinfo,                -> Guitaskinfo-Structure
        gfx:PTR TO gfx,                         -> BASIC Graphics-Output in a NewGUI - Window
        y=0,                                    -> Starting Point for mandelbrot-generation
        num_line=NIL,                           -> Calculation-Status (+ gadget-adress)
        num_pixel=NIL,                          -> Calculation-Status (+ gadget-adress)
        iterations=20,                          -> Iterations in the Main-calculating loop
        run=TRUE,                               -> Stop/Run the Calculation
        refreshgui=TRUE                         -> Refresh the Number-Display

PROC main()     HANDLE
 opengui()                                      -> Open the gui (in a other task!)

  calculate()                                   -> Calculate the Mandelbrot-GFX

EXCEPT DO                                       -> Exception-Handling, but do it every time the program ends
 ng_endtask(info)                               -> End and kill the gui-task
 IF (gfx<>NIL) THEN END gfx                     -> And free the mem for the plugin if neccessary
  IF exception THEN ng_showerror(exception)     -> If any exception happened then show it
 CleanUp(exception)                             -> Cleanup (with exception as return-code)
ENDPROC

PROC opengui()                                  -> Should open the gui!
  info:=ng_newtask(                             -> initialize a new task for the GUI!!!!
       [NG_WINDOWTITLE,         'NewGUI-Task-Demo',
->        NG_WINDOWTYPE,          WTYPE_NOSIZE,   -> No size-Gadget because the Plugin does not
        NG_GUIID,       GUI_MAIN,               -> a resize occours...
        NG_GUI,
                [ROWS,
                [DBEVELR,
                [EQROWS,
                        [TEXT,'Calculation','Mandelbrot',FALSE,2],
                        [TEXT,'a seperate Task','The GUI runs in',FALSE,2],
                        [TEXT,'NewGUI','with',FALSE,2]
                ]],
                [BEVELR,
                [ROWS,
                        [GFX,0,NEW gfx.gfx(200,100)]    -> The Plugin...
                ]],
                [DBEVELR,
                [ROWS,
                [EQCOLS,
                        num_line:=[NUM,0,'Line',TRUE,3],
                        num_pixel:=[NUM,0,'Pixel',TRUE,3]
                ],
                        [CHECK,{refresh},'Display Render-Info',refreshgui,TRUE],
                [BEVELR,
                [COLS,
                        [TEXT,'Iterations :','Number of',FALSE,3],
                        [SLIDE,{setiteration},'     ',FALSE,1,50,iterations,2,'%2ld']
                ]]]],
                [BAR],
                [BEVELR,
                [EQCOLS,
                        [SBUTTON,{stop},'Stop'],
                [SPACEH],
                        [SBUTTON,{reset},'Reset']
                ]]],
        NIL,NIL],NG_STACK_SIZE)                 -> NG_STACK_SIZE is Standart-Size of 4096 bytes!
ENDPROC

PROC calculate()                                -> Do other important things...
 DEF    zr,zi,ar,ai,dr,di,sr,si,st,x,i,
        xsize=0,ysize=0
  Wait(info.sig OR SIGBREAKF_CTRL_C)            -> Wait until the GUI is ready (or Break!)
   WHILE (ng_checkgui(info)=FALSE)              -> Wait until the GUI will be closed
    IF (y=0)
     xsize:=gfx.width
      ysize:=gfx.height
       sr:=$400000/xsize
       si:=$300000/ysize
      st:=$140000*-2
     zi:=$160000
    ENDIF
    IF (run=TRUE) AND (y<gfx.height)
     IF (xsize<>gfx.width) OR (ysize<>gfx.height)
      xsize:=gfx.width
       ysize:=gfx.height
        sr:=$400000/xsize
        si:=$300000/ysize
       st:=$140000*-2
      zi:=$160000
     ENDIF
       zi:=zi-si
        zr:=st
         FOR x:=0 TO xsize-1
          i:=0
           ar:=zr
            ai:=zi
             REPEAT
              dr:=Shr(ar,10)
               di:=Shr(ai,10)
                ai:=dr*2*di+zi
                 dr:=dr*dr
                di:=di*di
               ar:=dr-di+zr
              i++
             UNTIL (i>iterations) OR (dr+di>$400000)
            IF (refreshgui=TRUE) THEN ng_setattrsA([
                NG_GUI,         info.gui,
                NG_CHANGEGAD,   TRUE,
                NG_GADGET,      num_pixel,
                NG_NEWDATA,     x,
                NIL,            NIL])
           gfx.plot(x,y,Mod(i,16))
          zr:=zr+sr
         ENDFOR
        IF (refreshgui=TRUE) THEN ng_setattrsA([
                NG_GUI,         info.gui,
                NG_CHANGEGAD,   TRUE,
                NG_GADGET,      num_line,
                NG_NEWDATA,     y,
                NIL,            NIL])
      IF Odd(y) THEN Delay(1)
     y++
    ELSE
     Delay(1)
    ENDIF
   ENDWHILE
ENDPROC

PROC stop()                                     -> Stop/Run the GUI...
 IF (run=TRUE)
  run:=FALSE
 ELSE
  run:=TRUE
 ENDIF
ENDPROC

PROC refresh(x,y)                       IS refreshgui:=y

PROC setiteration(x,y)                  IS iterations:=y

PROC reset()
 run:=FALSE
  gfx.clear()
  y:=0
 run:=TRUE
ENDPROC

-> Plugin-Stuff (Not very Flexible at all, because the Display is trashed at resize
-> The problem could be solved with making a temporary rastport and then Copy this
-> rastport into the Plugins-Box... feel free ! :-)

PROC gfx(minwidth,minheight)            OF gfx
 self.width:=minwidth
  self.height:=minheight
ENDPROC

PROC will_resize()                      OF gfx IS RESIZEXANDY

PROC min_size(x,y)                      OF gfx IS self.width, self.height

PROC render(ta,x,a,xs,ys,win:PTR TO window)     OF gfx
 IF (self.rastport=NIL) THEN self.rastport:=win.rport
  run:=FALSE
   y:=0
    self.width:=xs
    self.height:=ys
   self.clear()
  run:=TRUE
ENDPROC

PROC clear()                            OF gfx  
 SetAPen(self.rastport,0)
  RectFill(self.rastport,self.x,self.y,(self.x+self.xs),(self.y+self.ys))
ENDPROC

PROC plot(x,y,color=1)                  OF gfx
 IF (self.rastport<>NIL)
  SetStdRast(self.rastport)
   IF (x<self.xs)
    IF (y<self.ys)
     Plot(x+self.x,y+self.y,color)
     RETURN TRUE
    ENDIF
   ENDIF
  ENDIF
ENDPROC FALSE

PROC line(x1,y1,x2,y2,color=1)          OF gfx
 IF (self.rastport<>NIL)
  SetStdRast(self.rastport)
   IF (x1<self.xs) AND (x2<self.xs)
    IF (y1<self.ys) AND (y2<self.ys)
     Line(x1+self.x,y1+self.y,x2+self.x,y2+self.y,color)
     RETURN TRUE
    ENDIF
   ENDIF
 ENDIF
ENDPROC FALSE

PROC box(x1,y1,x2,y2,color=1)           OF gfx
 IF (self.rastport<>NIL)
  SetStdRast(self.rastport)
   IF (x1<self.xs) AND (x2<self.xs)
    IF (y1<self.ys) AND (y2<self.ys)
     Box(x1+self.x,y1+self.y,x2+self.x,y2+self.y,color)
     RETURN TRUE
    ENDIF
   ENDIF
 ENDIF
ENDPROC FALSE

PROC colour(foreground,background=0)    OF gfx IS Colour(foreground,background)
