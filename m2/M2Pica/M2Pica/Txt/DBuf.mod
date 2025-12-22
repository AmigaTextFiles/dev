(*******************************************************************************
 : Program.         DBuf.MOD
 : Author.          Carsten Wartmann (Crazy Video)
 : Address.         Wutzkyallee 83, 12353 Berlin
 : Phone.           030/6614776
 : Version.         0.99
 : Date.            22.Feb.1994
 : Copyright.       PD
 : Language.        Modula-2
 : Compiler.        M2Amiga V4.096d
 : Contents.        Demo des Double Buffering der Picasso.
*******************************************************************************)

MODULE DBuf ;


FROM SYSTEM   IMPORT ADR,ADDRESS,TAG,BYTE,BITSET ;

FROM UtilityD IMPORT tagEnd,tagDone ;

FROM Arts     IMPORT Assert ;

FROM ExecL    IMPORT Forbid,Permit ;

FROM DosL     IMPORT Delay ;

FROM GraphicsL  IMPORT SetRGB4 ;

FROM IntuitionD IMPORT ScreenPtr ;
FROM IntuitionL IMPORT ScreenToFront ;

FROM RandomNumber IMPORT RND ;

FROM VilIntuiSupL IMPORT OpenVillageScreenTagList,CloseVillageScreen,GetMemSize,
                         LockVillageScreen,UnLockVillageScreen,VillageRectFill,
                         WaitVillageBlit,OpenVillageScreen,VillageModeRequest,
                         VillageSetDisplayBuf,VillageGetBufAddr ;
FROM VilIntuiSupD IMPORT SetPackedPixel,SetTrueColorPixel,SetPPM,LinePacked,
                         VilFillRecord,TavisTags,InvalidID ;




VAR scr    : ScreenPtr ;
    start,
    oldadr : ADDRESS ;
    col    : LONGINT ;
    ok,buf : LONGCARD ;
    bufadr : ARRAY [0..1] OF ADDRESS ;
    xa,ya  : ARRAY [0..1] OF LONGINT ;
    x,y,
    xs,ys,
    i      : LONGINT ;
    fill   : VilFillRecord ;
    tags   : ARRAY [0..40] OF LONGCARD ;

    cia[0BFE000H]  : BITSET ;



BEGIN
  scr := OpenVillageScreenTagList(TAG(tags,tavisScreenWidth  , 640,
                                           tavisScreenHeight , 480,
                                           tavisScreenDepth  ,   8,
                                           tavisDoubleBuffer,    2,
                                           tagDone)) ;

  Assert(scr#NIL,ADR("Kann PICASSO Screen nicht öffnen !")) ;

  FOR col:=1 TO 255 DO
    SetRGB4(ADR(scr^.viewPort),col,col,255-col,0) ;
  END ;

  start := LockVillageScreen(scr) ;
  UnLockVillageScreen(scr) ;

  FOR buf:=0 TO 1 DO
    bufadr[buf] := VillageGetBufAddr(scr,buf) ;
  END ;

  xs := 4 ;
  ys := 5 ;

  buf := 1 ;
  VillageSetDisplayBuf(scr,0) ;

  WHILE (6 IN cia) DO
    INC(x,xs) ;
    INC(y,ys) ;

    IF (x>=540) OR (x<=0) THEN
      xs:=xs*(-1) ;
      INC(x,xs) ;
    END ;

    IF (y>=380) OR (y<=0) THEN
      ys:=ys*(-1) ;
      INC(y,ys) ;
    END ;

    fill.dstAdr   := ADDRESS(LONGINT(bufadr[buf]) + LONGINT(scr^.width) * ya[buf] + xa[buf]) ;
    fill.color    := 0 ;
    fill.width    := 100 ;
    fill.height   := 100 ;
    ok := VillageRectFill(scr,ADR(fill)) ;
    WaitVillageBlit ;

    fill.dstAdr   := ADDRESS(LONGINT(bufadr[buf]) + LONGINT(scr^.width) * y + x) ;
    fill.dstPitch := scr^.width ;
    fill.width    := 100 ;
    fill.height   := 100 ;
    fill.color    := x MOD 255 + 1 ;
    xa[buf] := x ;
    ya[buf] := y ;

    ok := VillageRectFill(scr,ADR(fill)) ;
    WaitVillageBlit ;

    VillageSetDisplayBuf(scr,buf) ;
    buf := (buf + 1) MOD 2 ;

  END ;

CLOSE
  IF scr#NIL THEN
    UnLockVillageScreen(scr) ;
    CloseVillageScreen(scr) ;
  END ;

END DBuf .
