-> sample plugins.

OPT OSVERSION=37
MODULE 'tools/EasyGUI', 'tools/exceptions', 'intuition/intuition'

-> a very simple plugin. renders scalable gfx, and lets the user interact :-)

OBJECT myplugin OF plugin
  xm:INT,ym:INT
ENDOBJECT

PROC min_size(fh) OF myplugin IS 100,100

PROC render(x,y,xs,ys,w) OF myplugin IS self.draw(w)

PROC message_test(imsg:PTR TO intuimessage,win:PTR TO window) OF myplugin
  DEF x,y
  IF (imsg.class=IDCMP_MOUSEBUTTONS) AND (imsg.code=SELECTUP)
    x:=imsg.mousex
    y:=imsg.mousey
    IF (x>=self.x) AND (y>=self.y) AND (x<(self.x+self.xs)) AND (y<(self.y+self.ys))
      self.xm:=x-self.x*1000/self.xs	-> scale
      self.ym:=y-self.y*1000/self.ys
      RETURN TRUE
    ENDIF
  ENDIF
ENDPROC FALSE

PROC message_action(win:PTR TO window) OF myplugin
  self.draw(win)
ENDPROC FALSE

PROC draw(win:PTR TO window) OF myplugin
  DEF xm,ym,a,b=0
  xm:=self.xm*self.xs/1000+self.x	-> scale back
  ym:=self.ym*self.ys/1000+self.y
  SetStdRast(win.rport)
  Box(self.x,self.y,self.x+self.xs-1,self.y+self.ys-1,2)
  FOR a:=self.x TO self.x+self.xs-1
    Line(a,self.y,xm,ym,b++)
    Line(a,self.y+self.ys-1,xm,ym,b)
  ENDFOR
ENDPROC

-> now use our plugin

PROC main() HANDLE
  DEF p:PTR TO plugin,mp:PTR TO myplugin
  easygui('those damn handy plugins...',
    [ROWS,
      [TEXT,'just the default plugin:',NIL,TRUE,15],
      [BEVEL,[PLUGIN,0,NEW p]],
      [TEXT,'our own plugin (try mouse):',NIL,TRUE,15],
      [BEVEL,[PLUGIN,0,NEW mp]],
      [SBUTTON,0,'yeah, ok']
    ]
  )
EXCEPT
  report_exception()
ENDPROC
