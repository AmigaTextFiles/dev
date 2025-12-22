(*******************************************************************************
 : Program.         Picatest.MOD
 : Author.          Carsten Wartmann (Crazy Video)
 : Address.         Wutzkyallee 83, 12353 Berlin
 : Phone.           030/6614776
 : Version.         0.99
 : Date.            22.Feb.1994
 : Copyright.       PD
 : Language.        Modula-2
 : Compiler.        M2Amiga V4.3d
 : Contents.        24-Bit Demoprogramm.
*******************************************************************************)

MODULE PicaTest ;


FROM SYSTEM       IMPORT ADR,ADDRESS,TAG,BYTE ;

FROM UtilityD     IMPORT tagEnd,tagDone ;

FROM ExecL        IMPORT Forbid,Permit ;

FROM Arts         IMPORT Assert ;

FROM DosL         IMPORT Delay ;

FROM IntuitionD   IMPORT ScreenPtr ;
FROM IntuitionL   IMPORT ScreenToFront ;

FROM RandomNumber IMPORT RND ;

FROM VilIntuiSupL IMPORT OpenVillageScreenTagList,CloseVillageScreen,
                         LockVillageScreen,UnLockVillageScreen,VillageModeRequest,
                         VillageBlitCopy,VillageRectFill,WaitVillageBlit,
                         VillageScreenData ;
FROM VilIntuiSupD IMPORT SetTrueColorPixel,LineTrueColor,
                         VilFillRecord,VilCopyRecord,VilScrCopy,
                         TavisTags,InvalidID,
                         ScreenDataTags ;




VAR scr    : ScreenPtr ;
    start  : ADDRESS ;
    x,y,ok,
    size   : LONGINT ;
    mode   : LONGCARD ;
    tags   : ARRAY [0..40] OF LONGCARD ;
    copy   : VilCopyRecord ;
    fill   : VilFillRecord ;



BEGIN
  mode := VillageModeRequest(TAG(tags,tavisMinDepth,  24,
                                           tagDone)) ;
  Assert(mode#InvalidID,ADR("Kein Screenmode gewählt !")) ;

  scr := OpenVillageScreenTagList(TAG(tags,tavisScreenModeID,  mode,
                                           tagDone)) ;
  Assert(scr#NIL,ADR("Kann PICASSO Screen nicht öffnen !")) ;

  FOR x:=0 TO 300 DO
    LineTrueColor(scr,RND(scr^.width),RND(scr^.height),
                      RND(scr^.width),RND(scr^.height),RND(255),RND(255),RND(255)) ;
  END ;
  Delay(2*50) ;

  start := LockVillageScreen(scr) ;
  UnLockVillageScreen(scr) ;
  FOR x:=0 TO 255 DO
    FOR y:=0 TO 255 DO
      SetTrueColorPixel(scr,x,y,x,y,0) ;
    END ;
  END ;
  FOR x:=0 TO 255 DO
    FOR y:=0 TO 255 DO
      SetTrueColorPixel(scr,255+x,y,y,0,x) ;
    END ;
  END ;

  UnLockVillageScreen(scr) ;
  Delay(1*50) ;

  Forbid() ;
   ScreenToFront(scr) ;
   start := LockVillageScreen(scr) ;
  Permit() ;

  FOR y:=0 TO (scr^.height DIV 32) DO
    FOR x:=0 TO (scr^.width DIV 32)-1 DO
      copy.scrAdr   := ADDRESS(LONGINT(start) + (LONGINT(scr^.width) * (y*32) + x*32)*3) ;
      copy.dstAdr   := ADDRESS(LONGINT(start) + (LONGINT(scr^.width)
                               * RND(scr^.height DIV 32)*32 + RND(scr^.width DIV 32)*32)*3) ;
      copy.scrPitch := scr^.width ;
      copy.dstPitch := scr^.width ;
      copy.width    := 32 ;
      copy.height   := 32 ;
      copy.rop      := VilScrCopy ;

      ok := VillageBlitCopy(scr,ADR(copy)) ;
      WaitVillageBlit ;
    END ;
  END ;
  Delay(4*50) ;

  FOR y:=0 TO (scr^.height DIV 32) DO
    FOR x:=0 TO (scr^.width DIV 32)-1 DO
      fill.dstAdr   := ADDRESS(LONGINT(start) + (LONGINT(scr^.width)
                               * RND(scr^.height DIV 32)*32 + RND(scr^.width DIV 32)*32)*3) ;
      fill.dstPitch := scr^.width ;
      fill.width    := 32 ;
      fill.height   := 32 ;
      fill.color    := RND(16777216)  ;

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

END PicaTest .
