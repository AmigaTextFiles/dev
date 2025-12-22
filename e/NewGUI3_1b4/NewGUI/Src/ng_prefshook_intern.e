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
MODULE  'iffparse'
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

EXPORT PROC ng_prefsproc(filename,lastid,iffhandle:PTR TO iffhandle,screen:PTR TO screen,winid,x,y,width,height,open,own=NIL,size=0)
 DEF    mode=0,
        scr:scrobject,
        win:winobject,
        another=0,
        node=NIL:PTR TO contextnode
  IF (screen<>NIL) THEN mode:=NEWFILE ELSE mode:=OLDFILE
   IF iffhandle=NIL
    IF (iffparsebase:=OpenLibrary('iffparse.library',37))
     IF (iffhandle:=AllocIFF())
      iffhandle.stream:=Open(filename,mode)
       IF (iffhandle.stream<>NIL)
        InitIFFasDOS(iffhandle)
         IF mode=NEWFILE
          OpenIFF(iffhandle,IFFF_WRITE)
           PushChunk(iffhandle,"NGUI",ID_FORM,IFFSIZE_UNKNOWN)
         ELSE
          OpenIFF(iffhandle,IFFF_READ)
         ENDIF
       ENDIF
     ENDIF
    ENDIF
   ENDIF

   IF (iffhandle<>NIL)
    IF (iffhandle.stream=NIL) THEN mode:=0
    IF (mode=NEWFILE)
     IF (winid=GUI_FIRST)
      scr.modeid:=GetVPModeID(screen.viewport)
      scr.width :=screen.width
      scr.height:=screen.height
      scr.lastid:=lastid

       PushChunk(iffhandle,0,"SCRN",IFFSIZE_UNKNOWN)
        WriteChunkBytes(iffhandle,scr,SIZEOF scrobject)
       PopChunk(iffhandle)

     ENDIF
      win.id    :=winid
      win.x     :=x
      win.y     :=y
      win.width :=width
      win.height:=height
      win.open  :=open

       PushChunk(iffhandle,0,"WIND",IFFSIZE_UNKNOWN)
        WriteChunkBytes(iffhandle,win,SIZEOF winobject)
       PopChunk(iffhandle)

    ELSEIF (mode=OLDFILE)
     IF (winid=0)
      iff_step(iffhandle)                       -> FORM
       another,node:=iff_step(iffhandle)        -> SCRN

        ReadChunkBytes(iffhandle,scr,node.size)

     ELSE
      another,node:=iff_step(iffhandle)         -> WIND

        ReadChunkBytes(iffhandle,win,node.size)

        ^x     :=win.x
        ^y     :=win.y
        ^width :=win.width
        ^height:=win.height
        ^open  :=win.open
     ENDIF
    ENDIF
   ENDIF

   IF (lastid=winid)
    IF (own<>NIL) AND (size>0)
     PushChunk(iffhandle,0,"DATA",IFFSIZE_UNKNOWN)
      WriteChunkBytes(iffhandle,own,size)
     PopChunk(iffhandle)
    ENDIF
    IF (mode=NEWFILE) THEN PopChunk(iffhandle)
     CloseIFF(iffhandle)
      IF (iffhandle.stream<>NIL) THEN Close(iffhandle.stream)
       iffhandle.stream:=NIL
      IF (iffhandle<>NIL) THEN FreeIFF(iffhandle)
     IF (iffparsebase<>NIL) THEN CloseLibrary(iffparsebase)
    iffhandle:=NIL
   ENDIF
ENDPROC iffhandle

PROC iff_step(iffhandle:PTR TO iffhandle)
 DEF    error=0,
        fin=FALSE,
        node=NIL
  error:=ParseIFF(iffhandle,IFFPARSE_RAWSTEP)
   IF (error=IFFERR_EOC)
    fin,node:=iff_step(iffhandle)
   ELSEIF error
    fin:=TRUE
   ELSE
    node:=CurrentChunk(iffhandle)
   ENDIF
ENDPROC fin, node
