(*******************************************************************************
 : Program.         Picatest16.MOD
 : Author.          Carsten Wartmann (Crazy Video)
 : Address.         Wutzkyallee 83, 12353 Berlin
 : Phone.           030/6614776
 : Version.         0.99
 : Date.            22.Feb.1994
 : Copyright.       PD
 : Language.        Modula-2
 : Compiler.        M2Amiga V4.3d
 : Contents.        15-Bit Demoprogramm.
*******************************************************************************)

MODULE PicaTest16 ;


FROM SYSTEM       IMPORT ADR,ADDRESS,TAG,SHIFT ;

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
                         VillageRectFill,VillageBlitCopy,WaitVillageBlit,
                         VillageModeRequest ;
FROM VilIntuiSupD IMPORT Set16BitPixel,Line16Bit,
                         VilFillRecord,VilCopyRecord,VilScrCopy,VilScrAnd,VilDstInvert,
                         TavisTags,InvalidID ;



VAR scr    : ScreenPtr ;
    start  : ADDRESS ;
    col    : LONGINT ;
    mode   : LONGCARD ;
    x,y,ok,
    r,g,b  : LONGINT ;
    tags   : ARRAY [0..40] OF LONGCARD ;
    copy   : VilCopyRecord ;
    fill   : VilFillRecord ;



BEGIN
  mode := VillageModeRequest(TAG(tags,tavisMinDepth,  15,
                                      tavisMaxDepth,  15,
                                           tagDone)) ;
  Assert(mode#InvalidID,ADR("Kein Screenmode gewählt !")) ;

  scr := OpenVillageScreenTagList(TAG(tags,tavisScreenModeID,  mode,
                                           tagDone)) ;
  Assert(scr#NIL,ADR("Kann PICASSO Screen nicht öffnen !")) ;

  start := LockVillageScreen(scr) ;

  FOR b:=0 TO 31 DO
   FOR g:=0 TO 63 DO
    FOR r:=0 TO 31 DO
     Set16BitPixel(scr,r+(b MOD 8)*32,g+(b DIV 8)*64,r,g,b) ;
    END ;
   END ;
  END ;

  UnLockVillageScreen(scr) ;

  Delay(3*50) ;

  FOR x:=0 TO 255 DO
    Line16Bit(scr,RND(scr^.width),RND(scr^.height),
                  RND(scr^.width),RND(scr^.height),RND(32),RND(64),RND(32)) ;
  END ;

  Delay(3*50) ;

  Forbid() ;
   ScreenToFront(scr) ;
   start := LockVillageScreen(scr) ;
  Permit() ;

  FOR y:=0 TO (scr^.height DIV 32) DO
    FOR x:=0 TO (scr^.width DIV 32)-1 DO
      copy.scrAdr   := ADDRESS(LONGINT(start) + (LONGINT(scr^.width) * (y*32) + x*32)*2) ;
      copy.dstAdr   := ADDRESS(LONGINT(start) + (LONGINT(scr^.width)
                               * RND(scr^.height DIV 32)*32 + RND(scr^.width DIV 32)*32)*2) ;
      copy.scrPitch := scr^.width ;
      copy.dstPitch := scr^.width ;
      copy.width    := 32 ;
      copy.height   := 32 ;
      copy.rop      := VilScrCopy ;

      ok := VillageBlitCopy(scr,ADR(copy)) ;
      WaitVillageBlit ;
    END ;
  END ;

  Delay(3*50) ;

  FOR y:=0 TO (scr^.height DIV 32) DO
    FOR x:=0 TO (scr^.width DIV 32)-1 DO
      fill.dstAdr   := ADDRESS(LONGINT(start) + (LONGINT(scr^.width)
                               * RND(scr^.height DIV 32)*32 + RND(scr^.width DIV 32)*32)*2) ;
      fill.dstPitch := scr^.width ;
      fill.width    := 32 ;
      fill.height   := 32 ;
      fill.color    := RND(16777216) ; (* Merged RGB...*)

      ok := VillageRectFill(scr,ADR(fill)) ;
      WaitVillageBlit ;
    END ;
  END ;

  UnLockVillageScreen(scr) ;

  Delay(5*50) ;

CLOSE
  IF scr#NIL THEN
    UnLockVillageScreen(scr) ;
    CloseVillageScreen(scr) ;
  END ;

END PicaTest16 .
