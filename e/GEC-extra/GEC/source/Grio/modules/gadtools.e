
OPT MODULE
OPT PREPROCESS
OPT REG=5


->#define GT33


#ifndef GT33
OPT OSVERSION=36
#endif

#ifdef GT33
MODULE 'grio/libver'
#endif


MODULE 'gadtools','libraries/gadtools','intuition/intuition',
       'intuition/screens','graphics/rastport','utility/tagitem',
       'diskfont','graphics/text','exec/nodes'


MODULE 'grio/clearwinport','grio/tags'

MODULE 'tools/textlen'



EXPORT OBJECT gadtools
  gadlist
  offx,offy
  tattr:PTR TO textattr
  font:PTR TO textfont
  window:PTR TO window
  screen:PTR TO screen
  menu:PTR TO menu
  PRIVATE
  gad:PTR TO gadget
  ng:newgadget
  pubscr
  nm:PTR TO newmenu
  width
  height
ENDOBJECT


EXPORT ENUM GTERR_NO,GTERR_GTLIB,GTERR_SCR,GTERR_VISUAL,
            GTERR_CONTEXT



PROC new(screen=NIL,tattr=NIL,gdid=1) OF gadtools
DEF scr=NIL:PTR TO screen,err=GTERR_NO
#ifdef GT33
IF libver(intuitionbase,36)
#endif
   gadtoolsbase:=OpenLibrary('gadtools.library',36)
   self.pubscr:=scr:=LockPubScreen(screen)
#ifdef GT33
ELSE
   gadtoolsbase:=OpenLibrary('gadtools13.library',33)
   scr:=OpenWorkBench()
ENDIF
#endif
self.screen:=scr
IF gadtoolsbase
   IF scr
      self.offx:=scr.wborleft
      self.offy:=scr.wbortop+scr.rastport.txheight+1
      IF tattr
         IF diskfontbase:=OpenLibrary('diskfont.library',33)
            self.font:=OpenDiskFont(tattr)
            CloseLibrary(diskfontbase)
         ENDIF
      ENDIF
      IF self.font=NIL
         self.font:=OpenFont(scr.font)
         tattr:=scr.font
      ENDIF
      IF self.font
         self.tattr:=tattr
         self.ng.textattr:=tattr
         self.ng.visualinfo:=GetVisualInfoA(scr,NIL)
         IF self.ng.visualinfo
            self.gad:=CreateContext(self+4)  ->  {self.gadlist}
            IF self.gad
               self.ng.gadgetid:=gdid
            ELSE
               err:=GTERR_CONTEXT
            ENDIF
         ELSE
            err:=GTERR_VISUAL
         ENDIF
      ENDIF
   ELSE
      err:=GTERR_SCR
   ENDIF
ELSE
   err:=GTERR_GTLIB
ENDIF
IF err THEN self.end()
ENDPROC err




PROC end() OF gadtools
IF gadtoolsbase
   self.closeWin()
   IF self.gadlist
      FreeGadgets(self.gadlist)
      self.gadlist:=NIL
   ENDIF
   IF self.ng.visualinfo
      FreeVisualInfo(self.ng.visualinfo)
      self.ng.visualinfo:=NIL
   ENDIF
   IF self.font
      CloseFont(self.font)
      self.font:=NIL
   ENDIF
   IF self.pubscr
      UnlockPubScreen(NIL,self.pubscr)
      self.pubscr:=NIL
   ENDIF
   CloseLibrary(gadtoolsbase)
ENDIF
ENDPROC


PROC gadget(kind,left,top,width,height,name,flags,user=NIL,tags=NIL) OF gadtools
DEF gad=0,fnt:PTR TO textfont,nwidth,nheight,xwidth
IF self.gad
   fnt:=self.font
   self.ng.flags:=flags
   self.ng.leftedge:=self.calcXX(left)
   self.ng.topedge:=self.calcYY(top)
   self.ng.width:=Max(xwidth:=self.calcX(width),nwidth:=self.calcText(name,findTagItem(GT_UNDERSCORE,tags)))
   IF (kind=CHECKBOX_KIND) OR (kind=STRING_KIND) OR (kind=MX_KIND)
      IF ((flags AND PLACETEXT_RIGHT)=PLACETEXT_RIGHT) OR ((flags AND PLACETEXT_LEFT)=PLACETEXT_LEFT)
         self.ng.width:=xwidth ; nwidth:=nwidth+xwidth+textlen(' ',self.tattr)
      ENDIF
   ENDIF
   self.ng.height:=nheight:=self.calcY(height)
   self.ng.gadgettext:=name
   self.ng.userdata:=user
   IF (gad:=CreateGadgetA(kind,self.gad,self.ng,tags))
      self.gad:=gad
      self.ng.gadgetid:=self.ng.gadgetid+1
      self.width:=Max(Max(nwidth,xwidth)+self.ng.leftedge,self.width)
      self.height:=Max(nheight+self.ng.topedge,self.height)
   ENDIF
ENDIF
ENDPROC gad



PROC openWin(x,y,width,height,idcmp,wflags,title,port=NIL,tags=NIL,lockpub=TRUE,screentitle=NIL,menu=NIL) OF gadtools
DEF fnt:PTR TO textfont,win=NIL:PTR TO window,z,scr:PTR TO screen
IF self.window=NIL
   IF fnt:=self.font
      scr:=self.screen
      width:=Max(self.calcXX(width),self.width+4)+scr.wborright
      height:=Max(self.calcYY(height),self.height+4)+scr.wborbottom
      IF (z:=scr.width-x-width)<0
         x:=x+z
      ENDIF
      IF (z:=scr.height-y-height)<0
         y:=y+z
      ENDIF
      wflags:=wflags OR WFLG_NEWLOOKMENUS
      IF scr.width>=width
         IF scr.height>=height
            #ifdef GT33
            IF win:=OpenW(x,y,width,height,IF port THEN NIL ELSE idcmp,
                          wflags,title,self.screen,15,self.gadlist,tags)
               IF screentitle THEN SetWindowTitles(win,-1,screentitle)
            #endif
            #ifndef GT33
            IF win:=OpenWindowTagList(NIL,[WA_LEFT,x,WA_TOP,y,WA_WIDTH,width,WA_HEIGHT,height,
                                           WA_CUSTOMSCREEN,self.screen,WA_TITLE,title,WA_FLAGS,wflags,
                                           WA_IDCMP,IF port THEN NIL ELSE idcmp,WA_GADGETS,self.gadlist,
                                           WA_SCREENTITLE,screentitle,TAG_MORE,tags,TAG_DONE])
            #endif
               Gt_RefreshWindow(win,NIL)
               IF port
                  win.userport:=port
                  ModifyIDCMP(win,idcmp)
               ENDIF
               SetFont(win.rport,fnt)
               IF lockpub=FALSE
                  IF self.pubscr
                     UnlockPubScreen(NIL,scr)
                     self.pubscr:=NIL
                  ENDIF
               ENDIF
            ENDIF
            self.window:=win
            self.nm:=menu
            self.setMenu()
         ENDIF
      ENDIF
   ENDIF
ENDIF
ENDPROC win




PROC reCalc(size,fontsize)
  MOVE.L size,D1
  MOVE.L fontsize,D0
  MULU   D1,D0
  ADDQ.L #3,D0
  LSR.L  #3,D0
ENDPROC D0



PROC calcX(size) OF gadtools IS reCalc(size,self.font.xsize)
PROC calcY(size) OF gadtools IS reCalc(size,self.font.ysize)


PROC calcXX(size) OF gadtools IS self.calcX(size)+self.offx
PROC calcYY(size) OF gadtools IS self.calcY(size)+self.offy


PROC calcText(text,key=NIL) OF gadtools
IF text
 textlen_key(text,self.tattr,key)
ENDIF
ENDPROC D0

PROC calcTextX(text,key=NIL) OF gadtools IS self.calcText(text,key)+self.offx


PROC closeWin() OF gadtools
IF self.window
   self.setMenu(NIL)
   clearWinPort(self.window)
   CloseWindow(self.window)
   self.window:=NIL
ENDIF
ENDPROC D0



PROC refreshGads(g=0,num=-1) OF gadtools
DEF gg:PTR TO gadget
IF self.window
   #ifdef GT33
   IF libver(gadtoolsbase,36)
   #endif
      IF g=0
         g:=self.gadlist
      ELSE
         gg:=self.gadlist
         WHILE gg
            EXIT gg=g
            gg:=gg.nextgadget
         ENDWHILE 
         IF gg=NIL
            g:=self.gadlist
            num:=-1
         ENDIF
      ENDIF
      RefreshGList(g,self.window,NIL,num)
   #ifdef GT33
   ELSE
      Gt_RefreshWindow(self.window,NIL)
   ENDIF
   #endif
ENDIF
ENDPROC


PROC bevelBox(x,y,width,height,recessed=FALSE,type=BBFT_BUTTON) OF gadtools
DEF nwidth,nheight,nx,ny
IF self.window
 nx:=self.calcXX(x)
 ny:=self.calcYY(y)
 nwidth:=self.calcX(width)
 nheight:=self.calcY(height)
 DrawBevelBoxA(self.window.rport,nx,ny,nwidth,nheight,
               [GT_VISUALINFO,self.ng.visualinfo,IF recessed THEN
               GTBB_RECESSED ELSE TAG_IGNORE,recessed,
               GTBB_FRAMETYPE,type,TAG_DONE])
 self.width:=Max(nwidth+nx,self.width)
 self.height:=Max(nheight+ny,self.height)
ENDIF
ENDPROC



PROC setMenu(nm=1:PTR TO newmenu) OF gadtools
DEF menu
IF nm=1
   nm:=self.nm
ELSE
   self.nm:=nm
ENDIF
IF menu:=self.menu
   ClearMenuStrip(self.window)
   FreeMenus(menu)
   self.menu:=NIL
ENDIF
IF nm
   IF (menu:=CreateMenusA(nm,NIL))
      IF LayoutMenusA(menu,self.ng.visualinfo,[GTMN_NEWLOOKMENUS,TRUE,NIL])
         IF SetMenuStrip(self.window,menu)
            RETURN self.menu:=menu
         ENDIF
      ENDIF
      FreeMenus(menu)
   ENDIF
ENDIF
ENDPROC NIL






