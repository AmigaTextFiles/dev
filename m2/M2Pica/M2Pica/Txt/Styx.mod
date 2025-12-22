(*******************************************************************************
 : Program.         Styx.MOD
 : Author.          Carsten Wartmann (Crazy Video)
 : Address.         Wutzkyallee 83, 12353 Berlin
 : Phone.           030/6614776
 : E-Mail           C.Wartmann@AMBO.in-berlin.de (bevorzugt)
 : E-Mail           Carsten_Wartmann@tfh-berlin.de
 : Version.         0.99
 : Date.            16.11.1994
 : Copyright.       PD
 : Language.        Modula-2
 : Compiler.        M2Amiga V4.3d
 : Contents.        Flying Lines.
*******************************************************************************)

MODULE Styx ;

FROM SYSTEM       IMPORT ADR,ADDRESS,TAG,BITSET ;

FROM UtilityD     IMPORT tagEnd,tagDone ;

FROM Arts         IMPORT Assert ;

FROM ExecL        IMPORT Forbid,Permit ;

FROM DosL         IMPORT Delay ;

FROM GraphicsL    IMPORT SetRGB4 ;

FROM IntuitionD   IMPORT ScreenPtr ;
FROM IntuitionL   IMPORT ScreenToFront ;

FROM RandomNumber IMPORT RND ;

FROM VilIntuiSupL IMPORT OpenVillageScreenTagList,CloseVillageScreen,
                         LockVillageScreen,UnLockVillageScreen,
                         VillageModeRequest ;
FROM VilIntuiSupD IMPORT LinePacked,
                         TavisTags,InvalidID ;



CONST Lines = 100 ;


TYPE Line = RECORD
       x1,y1,
       x2,y2 : INTEGER ;
     END ;


VAR scr      : ScreenPtr ;
    start    : ADDRESS ;
    col      : LONGINT ;
    mode     : LONGCARD ;
    x1,y1,
    x2,y2,
    x1a,ya1,
    x2a,y2a,
    x1s,y1s,
    x2s,y2s  : INTEGER ;
    i,il,
    width,
    height   : LONGINT ;
    ok       : LONGINT ;
    tags     : ARRAY [0..40] OF LONGCARD ;
    lines    : ARRAY [0..Lines] OF Line ;


    cia[0BFE000H]  : BITSET ;



BEGIN
  mode := VillageModeRequest(TAG(tags,tavisMinDepth,  8,
                                      tavisMaxDepth,  8,
                                           tagDone)) ;
  Assert(mode#InvalidID,ADR("Kein Screenmode gewählt !")) ;

  scr := OpenVillageScreenTagList(TAG(tags,tavisScreenModeID,  mode,
                                           tagDone)) ;
  Assert(scr#NIL,ADR("Kann PICASSO Screen nicht öffnen !")) ;

  FOR col:=0 TO 41 DO
    SetRGB4(ADR(scr^.viewPort),col+4,252,col*6,0);
    SetRGB4(ADR(scr^.viewPort),col+46,246-col*6,252,0);
    SetRGB4(ADR(scr^.viewPort),col+88,0,252,col*6);
    SetRGB4(ADR(scr^.viewPort),col+130,0,246-col*6,252);
    SetRGB4(ADR(scr^.viewPort),col+172,col*6,0,252);
    SetRGB4(ADR(scr^.viewPort),col+214,252,0,246-col*6)
  END;

  width  := LONGINT(scr^.width-1) ;
  height := LONGINT(scr^.height-1) ;

  x1 := 200 ; y1 := 200 ;
  x2 := 300 ; y2 := 237 ;
  x1s := 4 ; y1s := -4 ;
  x2s := 5 ; y2s := -7 ;

  FOR i:=0 TO Lines DO
    lines[i].x1 := x1 ;
    lines[i].y1 := y1 ;
    lines[i].x2 := x2 ;
    lines[i].y2 := y2 ;
  END ;
  i:=0 ;

  WHILE (6 IN cia) DO
    INC(x1,x1s) ;
    INC(y1,y1s) ;
    INC(x2,x2s) ;
    INC(y2,y2s) ;
    i := (i + 1) MOD Lines ;

    IF (x1>=width) OR (x1<=0) THEN
      x1s:=x1s*(-1) ;
      INC(x1,x1s) ;
    END ;
    IF (y1>=height) OR (y1<=0) THEN
      y1s:=y1s*(-1) ;
      INC(y1,y1s) ;
    END ;
    IF (x2>=width) OR (x2<=0) THEN
      x2s:=x2s*(-1) ;
      INC(x2,x2s) ;
    END ;
    IF (y2>=height) OR (y2<=0) THEN
      y2s:=y2s*(-1) ;
      INC(y2,y2s) ;
    END ;
    lines[i].x1 := x1 ;
    lines[i].y1 := y1 ;
    lines[i].x2 := x2 ;
    lines[i].y2 := y2 ;

    col := x1 MOD 251 + 4 ;
    LinePacked(scr,x1,y1,x2,y2,col) ;
    il := (i - (Lines-1)) MOD Lines ;
    LinePacked(scr,lines[il].x1,lines[il].y1,lines[il].x2,lines[il].y2,0) ;

  END ;

CLOSE
  IF scr#NIL THEN
    UnLockVillageScreen(scr) ;
    CloseVillageScreen(scr) ;
  END ;

END Styx .

