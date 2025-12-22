->> EDEVHEADER
/*= © NasGûl =========================
 ESOURCE Stars.e
 EDIR    Workbench:AmigaE/Sources/Pgs
 ECOPT   ERRLINE
 EXENAME Stars.gio
 MAKE    EC
 AUTHOR  NasGûl
 TYPE    EXELIB
 =====================================*/
-><
->> ©/DISTRIBUTION/UTILISATION
/*=====================================

 - TOUTE UTILISATION COMMERCIALE DES CES SOURCES EST
   INTERDITE SANS MON AUTORISATION.

 - TOUTE DISTRIBUTION DOIT ETRE FAITES EN TOTALITE (EXECUTABLES/MODULES E/SOURCES E).

 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 !! TOUTE INCLUSION SUR UN CD-ROM EST INTERDITE SANS MON AUTORISATION.!!
 !! SEULES LES DISTRIBUTIONS DE FRED FISH ET AMINET CDROM SONT AUTO-  !!
 !! RISES A DISTRIBUER CES PROGRAMMES/SOURCES.                        !!
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

=====================================*/
-><
/* Modified by Dominique Dutoit (eightyfour@hotmail.com) to use with
** Photogenics 2.0+.
*/
->> LIBRARY DEF

LIBRARY 'Stars.gio',1,1,'E example gio' IS
  gioInfo, gioExamine, gioRead, gioWrite, gioSavePrefs,
  gioCleanUp, gioAbout, gioStartup, gioShutDown, gioLoadPrefs

-><
->> MODULES

MODULE 'pgs', 'gio', 'photogenics/gio'

-><
PROC main() IS EMPTY
PROC gioInfo() IS GIOF_LOADER24
->> gioExamine(g:PTR TO giodata,z)
PROC gioExamine(g:PTR TO giodata,z)
  DEF width=320, height=256
  dosbase:=g.dosbase
  pgsbase:=g.pgsbase
  g.flags:=gioInfo()
  IF GetDimensions('Size of new stars image',{width},{height})<>1
    g.error:=GIO_ABORTED
  ELSE
    g.width:=width
    g.height:=height
    g.depth:=24
    g.error:=GIO_OK
  ENDIF
ENDPROC g.error
-><
->> gioRead(g:PTR TO giodata,z)
PROC gioRead(g:PTR TO giodata,z)
  DEF x,y,p:PTR TO CHAR,d,color=0,r=666,sr[256]:STRING
  pgsbase:=g.pgsbase
  StrCopy(sr,'666',ALL)
->  GetOneOption('RanDom Stars','Ok','Cancel',{r})
  GetString('Stars','Select Random number',sr)
  r:=Val(sr,NIL)
  SetProgress('Creating Stars image...',0);
  FOR y:=0 TO g.height-1
    IF y AND $F = 0
      IF SetProgress(0,y*100/g.height)<>1
        g.error:=GIO_ABORTED
        RETURN g.error
      ENDIF
    ENDIF
    p:=GetLine(g,y)
    FOR x:=0 TO g.width-1
        IF Rnd(r)=1 THEN color:=Rnd(250) ELSE color:=0
        FOR d:=1 TO 3
            p[]++:=color
        ENDFOR
    ENDFOR
    ReleaseLine(g,y)
  ENDFOR
  g.error:=NIL
ENDPROC g.error
-><
->> gioWrite(g:PTR TO giodata,z)
PROC gioWrite(g:PTR TO giodata,z)
  g.error:=GIO_WRONGTYPE
ENDPROC g.error
-><
PROC gioSavePrefs(g:PTR TO giodata,z) IS EMPTY
PROC gioCleanUp(g:PTR TO giodata,z) IS EMPTY
PROC gioAbout(g:PTR TO giodata,z) IS EMPTY
PROC gioStartup() IS EMPTY
PROC gioShutDown() IS EMPTY
PROC gioLoadPrefs(g:PTR TO giodata,z) IS EMPTY
