/* 
 *  Modul zum Speichern/Laden der Bildschirmfarben eines Screens
 * -============================================================-
 * 
 * Features:
 * ---------
 *      - Speichert die Daten im IFF-ILBM Format als ColorMap, daher von Zeichenprogramm Im- und Exportierbar!
 *      - Ohne Assembler-Unterstützung (daher relativ übersichtlich im Gegensatz zur ASM-Version von mir :-))
 *      - Kickstart 2.x-Konform, ECS/OCS Unterstützung (Durch benutzung von SetRGB4 bzw. GetRGB4)
 * 
 * Nachteile:
 * ----------
 *      - Auf 32 Farben beschränkt (Gerade weil Set- und GetRGB4 benutzt wird... durch änderungen kann auch
 *        SetRGB32 ect... benutzt werden, dies wird aber (meines Wissens nach) nicht von Kick 2.x [OCS/ECS] unterstützt!)
 */

OPT     MODULE
OPT     REG=5

MODULE  'graphics/view'
MODULE  'intuition/intuition'
MODULE  'intuition/screens'

OBJECT bitmapheader
 w                      :INT
 h                      :INT
 x                      :INT
 y                      :INT
 planes                 :CHAR
 masking                :CHAR
 compression            :CHAR
 pad1                   :CHAR
 transparentcolor       :INT
 xaspect                :CHAR
 yaspect                :CHAR
 pagewidth              :INT
 pageheight             :INT
ENDOBJECT

EXPORT PROC ng_readpalette(filename,screen:PTR TO screen,scr_depth)
 DEF    handle,
        buffer[10]:ARRAY OF CHAR,
        i,
        l,
        ol,
        vp:PTR TO viewport,
        max
  IF (handle:=Open(filename,OLDFILE))
   Read(handle,buffer,8)
    IF (StrCmp('FORM',buffer,4))=TRUE
     Read(handle,buffer,4)
      IF (StrCmp('ILBM',buffer,4))=TRUE
       l:=0
        REPEAT
         ol:=Seek(handle,l,0)
          Read(handle,buffer,4)
         Read(handle,{l},4)
        UNTIL StrCmp('CMAP',buffer,4) OR (ol<0)
       IF (ol>0)
        max:=Shl(1,scr_depth)
         IF l/3<=max THEN max:=l/3
           vp:=screen.viewport
            FOR i:=0 TO max-1
             Read(handle,buffer,3)
             SetRGB4(vp,i,Shr(buffer[0],4),Shr(buffer[1],4),Shr(buffer[2],4))
            ENDFOR
       ENDIF
      ENDIF
    ENDIF
   Close(handle)
  ENDIF
ENDPROC

EXPORT PROC ng_writepalette(filename,screen:PTR TO screen,scr_depth,scr_modeid=NIL)
 DEF    cmem=NIL,
        handle=NIL,
        size,
        formsize,
        mode,
        bmhd:PTR TO bitmapheader
  IF (size:=allocCMAP(screen.viewport,{cmem},scr_depth))<>0
   NEW bmhd
   bmhd.planes :=scr_depth
   bmhd.xaspect:=1
   bmhd.yaspect:=1
    IF (handle:=Open(filename,NEWFILE))
     formsize:=size+50
      Write(handle,'FORM',4)
      Write(handle,{formsize},4)
      Write(handle,'ILBMBMHD',8)
      Write(handle,[20],4)
      Write(handle,bmhd,20)
       Write(handle,'CMAP',4)
       Write(handle,{size},4)
       Write(handle,cmem,size)
        mode:=scr_modeid
         Write(handle,'CAMG',4)
         Write(handle,[4],4)
         Write(handle,{mode},4)
     Close(handle)
    ENDIF
    Dispose(cmem)
   END bmhd
  ENDIF
ENDPROC

PROC allocCMAP(vp:PTR TO viewport,m:PTR TO LONG,scr_depth)
 DEF    size,
        cm:PTR TO colormap,
        farbe,
        i,
        mem
  size:=3*Shl(1,scr_depth)
   IF (size AND 1)=1 THEN INC size
    mem:=New(size)
     cm:=vp.colormap
      FOR i:=0 TO Shl(1,scr_depth)-1
       farbe:=GetRGB4(cm,i)
        PutChar(mem+(3*i),Shr(farbe AND $F00,4))
        PutChar(mem+1+(3*i),farbe AND $F0)
        PutChar(mem+2+(3*i),Shl(farbe AND $F,4))
      ENDFOR
     ^m:=mem
ENDPROC size
