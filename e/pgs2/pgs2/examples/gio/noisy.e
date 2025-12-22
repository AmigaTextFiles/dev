/* noisy.e: compiles to noisy.gio for use as Photogenics loader
   based roughly on noise.c supplied with photogenics v1.2
   [note: the `z' is a hack because currently EC assigns registers itself] */

LIBRARY 'Noisy.gio',1,1,'E example gio' IS
  gioInfo, gioExamine, gioRead, gioWrite, gioSavePrefs,
  gioCleanUp, gioAbout, gioStartup, gioShutDown, gioLoadPrefs

MODULE 'pgs', 'photogenics/gio', 'gio'

PROC gioInfo() IS GIOF_LOADER24
PROC gioCleanUp(g:PTR TO giodata,z) IS EMPTY
PROC gioSavePrefs(g:PTR TO giodata,z) IS EMPTY
PROC gioLoadPrefs(g:PTR TO giodata,z) IS EMPTY
PROC gioAbout(g:PTR TO giodata,z) IS EMPTY
PROC gioStartup() IS EMPTY
PROC gioShutDown() IS EMPTY
PROC main() IS EMPTY

PROC gioExamine(g:PTR TO giodata,z)
  DEF width=100, height=100

  dosbase := g.dosbase
  pgsbase := g.pgsbase

  g.flags:=gioInfo()
  IF GetDimensions('Size of new Noisy image',{width},{height})<>1
     g.error:=GIO_ABORTED
  ELSE
     g.width:=width
     g.height:=height
     g.depth:=24
     g.error:=GIO_OK
  ENDIF
ENDPROC g.error

PROC gioRead(g:PTR TO giodata,z)
  DEF x,y,p:PTR TO CHAR,d
  dosbase := g.dosbase
  pgsbase := g.pgsbase

  SetProgress('Creating Noisy image...',0);
  FOR y:=0 TO g.height-1
    IF y AND $F = 0
      IF SetProgress(0,y*100/g.height)<>1
        g.error:=GIO_ABORTED
        RETURN g.error
      ENDIF
    ENDIF
    p:=GetLine(g,y)
    FOR x:=0 TO g.width-1 DO FOR d:=1 TO 3 DO p[]++:=d*16+x*y     ->Rnd(256)
    ReleaseLine(g,y)
  ENDFOR
  g.error:=NIL
ENDPROC g.error

PROC gioWrite(g:PTR TO giodata,z)
  g.error:=GIO_WRONGTYPE
ENDPROC g.error
