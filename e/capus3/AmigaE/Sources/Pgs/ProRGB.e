->> EDEVHEADER
/*= © NasGûl =========================
 ESOURCE ProRGB.e
 EDIR    Workbench:AmigaE/Sources/Pgs
 ECOPT   ERRLINE
 EXENAME ProRGB.gio
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
->> LIBRARY DEF

LIBRARY 'ProRGB.gio',1,0,'ProRGB.gio 1.0 (4.1.96) © NasGûl' IS
  gioInfo, gioExamine, gioRead, gioWrite

-><
->> MODULES

MODULE '*pgs', '*gio','dos/dos'

-><
->> OBJECTS

OBJECT proheader
    width:INT
    height:INT
    dxoffset:INT
    dyoffset:INT
    viewwidth:INT
    viewheight:INT
    modes:LONG
    stockmethod:LONG
ENDOBJECT

-><
PROC main() IS EMPTY
PROC gioInfo() IS (GIOF_LOADER24 OR GIOF_LOADFILE)
->> gioExamine(g:PTR TO giodata,z)
PROC gioExamine(g:PTR TO giodata,z)
    DEF proh:PTR TO proheader,data
    pgsbase:=g.pgsbase
    g.flags:=gioInfo()
    data:=g.data
    IF StrCmp(data,'CSPRORGB1',9)
    proh:=data+9
    g.width:=proh.width
    g.height:=proh.height
    g.depth:=24
    g.error:=LOAD_OK
    ELSE
    g.error:=LOAD_WRONGTYPE
    ENDIF
ENDPROC g.error
-><
->> gioRead(g:PTR TO giodata,z)
PROC gioRead(g:PTR TO giodata,z)
    DEF y,p:PTR TO CHAR
    pgsbase:=g.pgsbase
    SetProgress('Loading ProRGB File...',0)
    Seek(g.filehandle,29,OFFSET_BEGINNING)
    FOR y:=0 TO g.height-1
    IF SetProgress(0,y*100/g.height)<>1
        g.error:=LOAD_ABORTED
        RETURN g.error
    ENDIF
    p:=GetLine(g,y)
    Read(g.filehandle,p,g.width*3)
    ReleaseLine(g,y)
  ENDFOR
  g.error:=LOAD_OK
ENDPROC g.error
-><
->> gioWrite(g:PTR TO giodata,z)
PROC gioWrite(g:PTR TO giodata,z)
  g.error:=LOAD_WRONGTYPE
ENDPROC g.error
-><
