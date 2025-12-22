OPT     OSVERSION = 37
OPT     MODULE

MODULE  'graphics/rastport'
MODULE  'graphics/gfx'
MODULE  'graphics/text'
MODULE  'intuition/intuition'
MODULE  'newgui/newgui'
MODULE  'newgui/ng_dnd_xchange'
MODULE  'tools/ghost'

EXPORT  CONST   NEWLISTV = PLUGIN

OBJECT line
 succ           :PTR TO line
 pred           :PTR TO line
 img            :PTR TO image
 selimg         :PTR TO image
 text           :PTR TO CHAR
 num            :LONG
 data           :LONG
ENDOBJECT

EXPORT OBJECT newlistview OF plugin
 numlines       :INT
 line           :INT
 clicked        :LONG
PRIVATE
 displaywidth   :LONG
 displayheight  :LONG
 linelist       :PTR TO line
 firstline      :PTR TO line
 actline        :PTR TO line
 lastline       :PTR TO line
 fh             :INT
 maximgheight   :INT
 maximgwidth    :INT
 showbar        :CHAR
 showselected   :CHAR
 readonly       :CHAR
 addondrop      :CHAR
 clicksec       :LONG
 clickmic       :LONG
ENDOBJECT

PROC disable(bool)      OF newlistview
 self.dis:=bool
  IF bool=TRUE                                                  -> Ghost the View
   ghost(self.gh.wnd,self.x,self.y,self.xs,self.ys)
  ELSE
   ng_setattrsA([
        NG_GUI,         self.gh,
        NG_REDRAW,      self,
        NIL,            NIL])
  ENDIF
ENDPROC

PROC addline(img:PTR TO image,selimg:PTR TO image,text,num,data) OF newlistview
 DEF    list:PTR TO line,
        node:PTR TO line
  list:=self.linelist
   NEW node
    node.img:=img
     node.selimg:=selimg
      node.text:=text
       IF (img.width >self.maximgwidth ) THEN self.maximgwidth :=img.width
       IF (img.height>self.maximgheight) THEN self.maximgheight:=img.height
      node.num:=num 
     node.data:=data
    IF (list=NIL)
     self.linelist:=node
      self.firstline:=node
     self.lastline:=node
    ELSE
     self.lastline.succ:=node
      node.pred:=self.lastline
     self.lastline:=node
    ENDIF
   self.numlines:=self.numlines+1
  ng_setattrsA([
        NG_GUI,         self.gh,
        NG_REDRAW,      self,
        NIL,            NIL])
ENDPROC

PROC remline(line) OF newlistview
 DEF    node:PTR TO line
  node:=self.firstline
   IF line>1
    WHILE (node<>NIL) AND (line>0)
     node:=node.succ
      line:=line-1
     IF line=1
      node.succ.pred:=node.pred
       node.pred.succ:=node.succ
       END node
      self.numlines:=self.numlines-1
     ENDIF
    ENDWHILE
   ELSE
    node.succ.pred:=node.pred
     node.pred.succ:=node.succ
     END node
    self.numlines:=self.numlines-1
   ENDIF
  ng_setattrsA([
        NG_GUI,         self.gh,
        NG_REDRAW,      self,
        NIL,            NIL])
ENDPROC

PROC lineup(num=1) OF newlistview
 REPEAT
  IF (self.firstline.pred<>NIL)
   self.firstline:=self.firstline.pred
    num:=num-1
  ELSE
   num:=0
  ENDIF
 IF num=0 THEN   ng_setattrsA([
        NG_GUI,         self.gh,
        NG_REDRAW,      self,
        NIL,            NIL])
 UNTIL num=0
ENDPROC

PROC linedown(num=1) OF newlistview
 REPEAT
  IF (self.firstline.succ<>NIL) 
   self.firstline:=self.firstline.succ
    num:=num-1
  ELSE
   num:=0
  ENDIF
 IF num=0 THEN ng_setattrsA([
        NG_GUI,         self.gh,
        NG_REDRAW,      self,
        NIL,            NIL])
 UNTIL num=0
ENDPROC

PROC setactline(line:PTR TO line) OF newlistview
 self.actline:=line
  self.dnd_image:=line.img
   self.dnd_selectimage:=line.selimg
    self.dnd_num:=line.num
   self.dnd_text:=line.text
  self.dnd_textlen:=StrLen(line.text)
 self.dnd_info:=DND_INFO_TEXT + DND_INFO_IMAGE
ng_setattrsA([
        NG_GUI,         self.gh,
        NG_REDRAW,      self,
        NIL,            NIL])
ENDPROC

PROC newlistview(width,height,showbar,showselected,readonly,addondrop)  OF newlistview
 self.displaywidth:=width
  self.displayheight:=height
   self.showbar:=IF showbar=0 THEN 0 ELSE 1
    self.showselected:=IF showselected=0 THEN 0 ELSE 1
     self.readonly:=IF readonly=0 THEN 0 ELSE 1
    self.addondrop:=IF addondrop=0 THEN 0 ELSE 1
   self.maximgheight:=8
  self.maximgwidth:=10
 self.type:=DND_DRAGDROPBOX         -> or DND_DRAGBOX or DND_DROPBOX
ENDPROC

PROC min_size(ta,fh)    OF newlistview 
 self.fh:=fh
  IF (fh>self.maximgheight) THEN self.maximgheight:=fh
ENDPROC self.displaywidth,(self.displayheight*self.maximgheight)+4

PROC will_resize()      OF newlistview IS RESIZEXANDY

PROC message_test(imsg:PTR TO intuimessage,win:PTR TO window) OF newlistview
 DEF    line=1,
        scanedlines=0,
        node:PTR TO line,
        linepos=0
 self.clicked:=FALSE
  IF (self.readonly<>1) AND (self.dis=FALSE)
   IF (imsg<>NIL)
    IF (imsg.class=IDCMP_MOUSEBUTTONS) AND (imsg.code=SELECTDOWN)
     IF (imsg.mousex>=self.x) AND (imsg.mousex<=(self.x+self.xs))
      IF (imsg.mousey>=self.y) AND (imsg.mousey<=(self.y+self.ys))
       node:=self.firstline
        scanedlines:=((self.ys-4)/self.maximgheight)+1
         WHILE (line<scanedlines)
          linepos:=(self.maximgheight*(line))+self.y
           IF (imsg.mousey>=linepos)
            node:=node.succ
           ELSE
            IF (node=self.actline)
             IF (self.clicksec>0) AND (self.clickmic>0)
              IF DoubleClick(self.clicksec,self.clickmic,imsg.seconds,imsg.micros) THEN self.clicked:=TRUE
               self.clicksec:=0
              self.clickmic:=0
             ELSE
               self.clicksec:=imsg.seconds
              self.clickmic:=imsg.micros
             ENDIF
            ELSE
             self.setactline(node)
              self.line:=line-1
              line:=0
               self.clicksec:=imsg.seconds
              self.clickmic:=imsg.micros
             self.clicked:=FALSE
            ENDIF
           ENDIF
          EXIT (line=0)
         line:=line+1
         ENDWHILE
      ENDIF
     ENDIF
    ENDIF
   ENDIF
  ENDIF
ENDPROC self.handlednd(imsg)

PROC message_action(class,qual,code,win:PTR TO window) OF newlistview
 IF (self.dnd_dest<>NIL)
  self.dnd_xchange(self,FALSE)
 ENDIF
ENDPROC self.clicked

PROC render(ta:PTR TO textattr,x,y,xs,ys,w:PTR TO window)     OF newlistview
 DEF    node:PTR TO line,
        lines=0,
        showedlines=0
  IF (ta=NIL)
   ta:=self.gh.tattr
    x:=self.x
     y:=self.y
     xs:=self.xs
    ys:=self.ys
   w:=self.gh.wnd
  ENDIF
   SetDrMd(w.rport,RP_JAM1)
    SetAPen(w.rport,0)
     SetBPen(w.rport,0)
    RectFill(w.rport,x,y,(x+xs),(y+ys))
   lines:=(ys-4)/self.maximgheight
    node:=self.firstline
     WHILE (lines>showedlines)
      IF (node<>NIL)
       IF (self.showselected=1) AND (self.actline<>NIL)
        IF (node=self.actline)
         SetAPen(w.rport,3)
          SetBPen(w.rport,3)
         RectFill(w.rport,self.x,self.y+(self.maximgheight*showedlines),self.x+self.xs,self.y+((showedlines+1)*self.maximgheight))
        ENDIF
       ENDIF
        drawline(self,node,w.rport,ta,showedlines)
       node:=node.succ
       ENDIF
        showedlines:=showedlines+1
     ENDWHILE
    IF (self.showbar=1)
     SetAPen(w.rport,1)
      Move(w.rport,self.x+1+self.maximgwidth,self.y)
      Draw(w.rport,self.x+1+self.maximgwidth,self.y+self.ys)
     SetAPen(w.rport,2)
      Move(w.rport,self.x+self.maximgwidth+2,self.y)
      Draw(w.rport,self.x+self.maximgwidth+2,self.y+self.ys)
    ENDIF
   IF self.dis=TRUE THEN ghost(w,x,y,xs,ys)

ENDPROC

PROC drawline(self:PTR TO newlistview,node:PTR TO line,rport,ta:PTR TO textattr,pos)
 DEF    len=0,
        tex:textextent,
        x,y
  x:=self.x
   y:=self.y
    SetBPen(rport,0)
     IF (node=self.actline)
      SetAPen(rport,2)
       DrawImage(rport,node.selimg,self.x+1,self.y+(self.maximgheight*pos))
     ELSE
      SetAPen(rport,1)
       DrawImage(rport,node.img,self.x+1,self.y+(self.maximgheight*pos))
     ENDIF
     TextExtent(rport,node.text,StrLen(node.text),tex)
    len:=TextFit(rport,node.text,StrLen(node.text),tex,NIL,1,self.xs-self.maximgwidth-8,256)
   Move(rport,self.x+self.maximgwidth+6,self.y+(self.maximgheight*pos)+(self.maximgheight+self.fh/2))
  Text(rport,node.text,len)
ENDPROC

PROC end()              OF newlistview
 DEF    node:PTR TO line,
        next=NIL
  IF (self.linelist<>NIL)
   node:=self.linelist
    WHILE (node<>NIL)
     next:=node.succ
      END node
     node:=next
    ENDWHILE
   self.linelist:=NIL
    self.actline:=NIL
    self.firstline:=NIL
   self.lastline:=NIL
  ENDIF
ENDPROC

PROC dnd_xchange(plug,called)      OF newlistview
 DEF    action
  action:=ng_dnd_xchange(self,called,DND_ACT_PUT)
   IF called=FALSE
ng_setattrsA([
        NG_GUI,         self.gh,
        NG_REDRAW,      self,
        NIL,            NIL])
ng_setattrsA([
        NG_GUI,         self.gh,
        NG_REDRAW,      self.dnd_dest,
        NIL,            NIL])
   ENDIF
ENDPROC action

PROC performdnd(win:PTR TO window)     OF newlistview                   -> A little changed ng_performdnd.m
 DEF    x=0:REG,
        y=0:REG,
        oldx=0:REG,
        oldy=0:REG,
        dndwin=NIL:PTR TO window

  IF (self.dis=FALSE)
    IF (win.mousex>=self.x) AND (win.mousex<=(self.x+self.maximgwidth+3))
     dndwin:=OpenWindowTagList(NIL,
       [WA_FLAGS,       WFLG_BORDERLESS OR WFLG_RMBTRAP OR WFLG_NOCAREREFRESH,
        WA_LEFT,        win.leftedge+self.x+1,
        WA_TOP,         win.topedge+self.y+(self.line*self.maximgheight),
        WA_WIDTH,       self.dnd_selectimage.width,
        WA_HEIGHT,      self.dnd_selectimage.height,
        WA_TITLE,       NIL,
        WA_CUSTOMSCREEN,win.wscreen,
        NIL,            NIL])
     IF (dndwin<>NIL) THEN DrawImage(dndwin.rport,self.dnd_selectimage,0,0)
    ELSE
     dndwin:=OpenWindowTagList(NIL,
       [WA_FLAGS,       WFLG_BORDERLESS OR WFLG_RMBTRAP OR WFLG_NOCAREREFRESH,
        WA_LEFT,        win.leftedge+self.x+self.maximgwidth+6,
        WA_TOP,         win.topedge+self.y+(self.maximgheight*self.line)+((self.maximgheight-self.fh)/2)+3,     -> +3 = FONT.BASELINE
        WA_WIDTH,       TextLength(win.rport,self.dnd_text,self.dnd_textlen),
        WA_HEIGHT,      self.gh.tattr.ysize,
        WA_TITLE,       NIL,
        WA_CUSTOMSCREEN,win.wscreen,
        NIL,            NIL])
     IF (dndwin<>NIL)
      SetABPenDrMd(dndwin.rport,2,3,RP_JAM2)
       Move(dndwin.rport,0,self.gh.tattr.ysize-3)
      Text(dndwin.rport,self.dnd_text,self.dnd_textlen)
     ENDIF
    ENDIF
    IF (dndwin<>NIL)
     WHILE Mouse()>0
      oldx:=x
       oldy:=y
        x:=win.mousex
        y:=win.mousey
       Delay(1)
      IF (oldx<>0) OR (oldy<>0) THEN MoveWindow(dndwin,(x-oldx),(y-oldy))
     ENDWHILE
    CloseWindow(dndwin)
   ENDIF
  ENDIF
ENDPROC x,y
