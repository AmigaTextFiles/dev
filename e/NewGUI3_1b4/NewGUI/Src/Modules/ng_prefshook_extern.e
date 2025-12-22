/* 
 *  PrefsHook.m
 * -===========-
 * 
 * Saves and loads NewGUI-Prefs as IFF-Files (using iffparse.library)
 * 
 */

OPT     OSVERSION = 37
OPT     MODULE

MODULE  'intuition/intuition'
MODULE  'intuition/screens'
MODULE  'tools/iff_support'
MODULE  'libraries/iffparse'

OBJECT  scrobject
 modeid         :LONG
 width          :LONG
 height         :LONG
 lastid         :LONG
ENDOBJECT

OBJECT  winobject
 id             :LONG
 x              :LONG
 y              :LONG
 width          :LONG
 height         :LONG
 open           :LONG
ENDOBJECT

CONST   GUI_FIRST=1

EXPORT PROC ng_prefsproc(filename,lastid,iffhandle:PTR TO iffhandle,screen:PTR TO screen,winid,x,y,width,height,open,own=NIL,ownsize=0)
 DEF    mode=0,
        scr:scrobject,
        win:winobject,
        another=0,
        size=0,id=0,type=0,node=NIL
  IF (screen<>NIL) THEN mode:=NEWFILE ELSE mode:=OLDFILE
   IF iffhandle=NIL
    iffhandle:=iff_init()
     mode:=iff_open(iffhandle,filename,mode,"NEWG")
   ENDIF

    IF (iffhandle.stream=NIL) THEN mode:=0

    IF (mode=NEWFILE)
     IF (winid=GUI_FIRST)
      scr.modeid:=GetVPModeID(screen.viewport)
      scr.width :=screen.width
      scr.height:=screen.height
      scr.lastid:=lastid
       iff_beginchunk(iffhandle,"SCRN")
        iff_writeraw(iffhandle,scr,SIZEOF scrobject)
       iff_endchunk(iffhandle)
     ENDIF
      win.id    :=winid
      win.x     :=x
      win.y     :=y
      win.width :=width
      win.height:=height
      win.open  :=open
       iff_beginchunk(iffhandle,"WIND")
        iff_writeraw(iffhandle,win,SIZEOF winobject)
       iff_endchunk(iffhandle)
    ELSEIF (mode=OLDFILE)

     IF (winid=0)
      iff_step(iffhandle)                       -> FORM
       another,node:=iff_step(iffhandle)        -> SCRN
        id,size,type:=iff_info(node)
         iff_read(iffhandle,scr,size)
     ELSE
      another,node:=iff_step(iffhandle)         -> WIND
       id,size,type:=iff_info(node)
        iff_read(iffhandle,win,size)
         ^x     :=win.x
         ^y     :=win.y
         ^width :=win.width
         ^height:=win.height
         ^open  :=win.open
     ENDIF

    ENDIF

   IF (lastid=winid)
    IF (own<>NIL) AND (ownsize>0)
     iff_beginchunk(iffhandle,"DATA")
      iff_writeraw(iffhandle,own,ownsize)
     iff_endchunk(iffhandle)
    ENDIF
     IF (iffhandle<>NIL)
      iff_close(iffhandle,mode)
       iff_exit(iffhandle)
      iffhandle:=NIL
     ENDIF
   ENDIF
ENDPROC iffhandle
