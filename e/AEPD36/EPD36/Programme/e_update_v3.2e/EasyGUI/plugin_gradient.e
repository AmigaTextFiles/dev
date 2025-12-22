-> A slightly more useful plugin: the BOOPSI gradientslider.gadget as plugin

OPT OSVERSION=37

MODULE 'tools/EasyGUI', 'tools/exceptions', 'intuition/intuition', 'intuition/gadgetclass',
       'intuition/icclass', 'gadgets/gradientslider'

OBJECT gradientplugin OF plugin
  grad:PTR TO gadget
  gradbase
  curval
ENDOBJECT

PROC gradientplugin() OF gradientplugin
  self.gradbase:=OpenLibrary('gadgets/gradientslider.gadget',39)
  IF self.gradbase=NIL THEN Raise("grad")
ENDPROC

PROC end() OF gradientplugin
  IF self.gradbase THEN CloseLibrary(self.gradbase)
ENDPROC

PROC min_size(fh) OF gradientplugin IS 100,30
PROC will_resize() OF gradientplugin IS RESIZEX

PROC render(x,y,xs,ys,w) OF gradientplugin
  self.grad:=NewObjectA(NIL,'gradientslider.gadget',
    [GA_TOP,y,GA_LEFT,x,GA_WIDTH,xs,GA_HEIGHT,ys,GRAD_CURVAL,self.curval,
     GA_ID,1,GRAD_PENARRAY,[1,2,-1]:INT,GRAD_KNOBPIXELS,16,0])
  IF self.grad=NIL THEN Raise("grad")
  AddGList(w,self.grad,-1,1,NIL)
  RefreshGList(self.grad,w,NIL,1)
ENDPROC

PROC clear_render(win:PTR TO window) OF gradientplugin
  IF self.grad
    RemoveGList(win,self.grad,1)
    DisposeObject(self.grad)
  ENDIF
ENDPROC

PROC message_test(imsg:PTR TO intuimessage,win:PTR TO window) OF gradientplugin IS
  imsg.class=IDCMP_MOUSEBUTTONS ->??

PROC message_action(win:PTR TO window) OF gradientplugin
  DEF val=0
  GetAttr(GRAD_CURVAL,self.grad,{val})
  self.curval:=val
ENDPROC TRUE

PROC main() HANDLE
  DEF gp=NIL:PTR TO gradientplugin
  easygui('BOOPSI in EasyGUI!',
    [ROWS,
      [TEXT,'from sys:classes/gadgets...',NIL,TRUE,15],
      [PLUGIN,{gradaction},NEW gp.gradientplugin()],
      [SBUTTON,0,'sure']
    ])
EXCEPT
  END gp
  report_exception()
ENDPROC

PROC gradaction(i,gp:PTR TO gradientplugin)
  WriteF('gradient value = \z$\h[4]\n',gp.curval)
ENDPROC
