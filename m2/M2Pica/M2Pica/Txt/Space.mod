(*******************************************************************************
 : Program.         Space.mod
 : Author.          Carsten Wartmann (Crazy Video)
 : Address.         Wutzkyallee 83, 12353 Berlin
 : Phone.           030/6614776
 : E-Mail           C.Wartmann@GANDALF.berlinet.de (bevorzugt)
 : E-Mail           Carsten_Wartmann@tfh-berlin.de
 : Version.         0.5
 : Date.            16.Aug.1994
 : Copyright.       PD
 : Language.        Modula-2
 : Compiler.        M2Amiga V4.3
 : Contents.        Animaniton / Einlesen / Scaling von BMP .
*******************************************************************************)

(*$ LargeVars := FALSE*)
(*$StackParms := FALSE*)

MODULE Space ;


FROM SYSTEM       IMPORT ADR,ADDRESS,TAG,BITSET,SHIFT,ASSEMBLE ;

FROM UtilityD     IMPORT tagEnd,tagDone ;

FROM Arts         IMPORT Assert ;

FROM ExecL        IMPORT Forbid,Permit,AllocMem,FreeMem,CopyMem ;
FROM ExecD        IMPORT MemReqs,MemReqSet ;

FROM DosL         IMPORT Delay ;

FROM GraphicsL    IMPORT SetRGB4 ;

FROM IntuitionD   IMPORT ScreenPtr ;
FROM IntuitionL   IMPORT ScreenToFront ;

FROM RandomNumber IMPORT RND ;

FROM VilIntuiSupL IMPORT OpenVillageScreenTagList,CloseVillageScreen,
                         LockVillageScreen,UnLockVillageScreen,
                         VillageRectFill,VillageBlitCopy,WaitVillageBlit,
                         VillageModeRequest,VillageSetDisplayBuf,VillageGetBufAddr ;
FROM VilIntuiSupD IMPORT SetPackedPixel,LinePacked,ClearScreen,ClearBuf,
                         VilFillRecord,VilCopyRecord,VilScrCopy,VilScrAnd,
                         VilDstInvert,VilScrPaint,TavisTags,InvalidID ;

FROM FileSystem   IMPORT Lookup,File,Close,ReadChar,done,ReadBytes,SetPos ;

FROM InOut        IMPORT WriteInt,WriteLn,WriteString,Write,WriteCard,WriteHex ;

FROM String       IMPORT Compare ;

FROM Break        IMPORT InstallException ;

FROM Timer2       IMPORT StartTime,StopTime,TimeVal ;

IMPORT R ;



CONST Bildname = "pics/Space1.bmp" ;
      Bildw    = 640 ;
      Bildh    = 512 ;

      Cookie   = "pics/Kugeln1.bmp" ;
      Cookiew  =  16 ;
      Cookieh  =  240 ;

      Objekte  = 20 ;


TYPE AObjekt = RECORD
       x,y,
       vx,vy,
       as,frm : INTEGER ;
       xa,ya  : ARRAY [0..1] OF INTEGER ;
       adr    : ADDRESS ;
       w,h,
       cnt    : INTEGER ;
     END ;

     LONGPTR = POINTER TO LONGCARD ;



VAR cia[0BFE000H]  : BITSET ;
    Joy1[0DFF00CH] : BITSET ;

    time      : TimeVal ;
    tags      : ARRAY [0..40] OF LONGCARD ;
    bufadr    : ARRAY [0..1] OF ADDRESS ;

    scr       : ScreenPtr ;

    start,
    source,
    kugeln,
    ufo,
    expl      : ADDRESS ;
    aobj      : ARRAY [0..Objekte-1] OF AObjekt ;

    col,buf,
    buf1,
    i,j       : LONGINT ;
    mode      : LONGCARD ;
    tc        : SHORTCARD ;
    x,y,ok,
    xmit,ymit,
    xoff,yoff : LONGINT ;







PROCEDURE Rechts() : BOOLEAN ;
   BEGIN
      RETURN (1 IN Joy1) ;
END Rechts ;

PROCEDURE Links() : BOOLEAN ;
   BEGIN
      RETURN (9 IN Joy1) ;
END Links ;

PROCEDURE XOR(a,b : BOOLEAN) : BOOLEAN ;
   BEGIN
      RETURN ((a OR b) AND NOT (a AND b)) ;
END XOR ;

PROCEDURE Unten() : BOOLEAN ;
   BEGIN
      RETURN XOR(Rechts(),(0 IN Joy1)) ;
END Unten ;

PROCEDURE Oben() : BOOLEAN ;
   BEGIN
      RETURN XOR(Links(),(8 IN Joy1)) ;
END Oben ;


PROCEDURE WaitMaus(delay : INTEGER) ;
BEGIN
  WHILE (6 IN cia) DO
  END ;
  Delay(delay) ;
END WaitMaus ;


PROCEDURE Erg(elap : TimeVal) ;
  BEGIN
    WriteLn ;
    WriteString("Ergebnis : ") ;
    WriteInt(elap.secs,6) ;
    WriteInt(elap.micro,10) ;
    WriteLn ;
  END Erg ;


(* Bringt BMP direkt auf den Bildschirm *)
PROCEDURE ReadBMPS(name : ARRAY OF CHAR ; scr : ScreenPtr ; w,h : LONGCARD) ;
VAR f     : File ;
    act,i : LONGINT ;
    start : ADDRESS ;


  BEGIN
    Lookup(f,name,40000,FALSE) ;
    Assert(f.res=done,ADR("Kann File nicht öffnen !")) ;
    start := LockVillageScreen(scr) ;

    SetPos(f,1078) ;
    INC(start,LONGCARD(scr^.width)*(h-1)) ;
    FOR y:=1 TO h DO
      ReadBytes(f,start,w,act) ;
      DEC(start,scr^.width) ;
    END ;

    UnLockVillageScreen(scr) ;
    Close(f) ;
  END ReadBMPS ;


(* Liest BMP in einen Speicherbereich *)
PROCEDURE ReadBMP(name : ARRAY OF CHAR ; w,h : LONGCARD) : ADDRESS ;
VAR f     : File ;
    act,i : LONGINT ;
    start,
    cnt   : ADDRESS ;

  BEGIN
    start := AllocMem(w*h,MemReqSet{fast}) ;
    Assert(start#NIL,ADR("Kein Speicher !")) ;

    Lookup(f,name,40000,FALSE) ;
    Assert(f.res=done,ADR("Kann File nicht öffnen !")) ;

(* Warum stehen BMP-Bilder auf dem Kopf ?
    SetPos(f,1078) ;
    ReadBytes(f,start,w*h,act) ;
    IF (act<LONGINT(w*h)) THEN
      Close(f) ;
      Assert(FALSE,ADR("Fehler beim Bildlesen (w*h?) !")) ;
    END ;
*)
    cnt := start ;
    SetPos(f,1078) ;
    INC(cnt,w*(h-1)) ;
    FOR y:=1 TO h DO
      ReadBytes(f,cnt,w,act) ;
      DEC(cnt,w) ;
    END ;

    Close(f) ;
    RETURN(start) ;

  END ReadBMP ;

(* Extrahiert die Palette eines BMP *)
PROCEDURE ReadPAL(name : ARRAY OF CHAR ; scr : ScreenPtr) ;
VAR f     : File ;
    act,i : LONGINT ;
    r,g,b,
    s     : SHORTCARD ;

  BEGIN
    Lookup(f,name,10000,FALSE) ;
    Assert(f.res=done,ADR("Kann File nicht öffnen !")) ;

    SetPos(f,54) ;
    FOR col:=0 TO 255 DO
      ReadBytes(f,ADR(b),1,act) ;
      ReadBytes(f,ADR(g),1,act) ;
      ReadBytes(f,ADR(r),1,act) ;
      ReadBytes(f,ADR(s),1,act) ;
      SetRGB4(ADR(scr^.viewPort),col,r,g,b) ;
    END ;

    Close(f) ;
  END ReadPAL ;



(* Skaliert auf Screen *)
PROCEDURE ScaleS(scr : ScreenPtr ; xs,ys,w,h,xd,yd,faktor : LONGINT) ;
VAR x,y,
    xx,yy : LONGINT ;
    dst,
    srt   : ADDRESS ;

  BEGIN
    start := LockVillageScreen(scr) ;

    srt := (LONGINT(start)+xs+ys*LONGINT(scr^.width)) ;
    dst := (LONGINT(start)+xd+yd*LONGINT(scr^.width)) ;

    y:=10 ;
    WHILE (y<=h*10) DO
      x:=0 ;
      WHILE (x<w*10) DO
        xx := x DIV 16 ;
        ADDRESS(LONGINT(dst)+x DIV faktor)^ := ADDRESS(LONGINT(srt)+xx)^ ;
        INC(x,faktor) ;
      END ;
      yy := y DIV 10 ;
      srt := ADDRESS(LONGINT(start)+LONGINT(scr^.width)*yy) ;
      INC(dst,scr^.width) ;
      INC(y,faktor) ;
    END ;
    UnLockVillageScreen(scr) ;

  END ScaleS ;

(*Skaliert Bild aus Speicher auf Screen hoch/runter *)
(*Doch noch xs/ys angeben....*)
PROCEDURE Scale(source : ADDRESS ; scr : ScreenPtr ; w,h,xd,yd,faktor : LONGINT) ;
VAR x,y,
    xx,yy   : LONGINT ;
    dst,srt : ADDRESS ;

  BEGIN
    start := LockVillageScreen(scr) ;

    dst := (LONGINT(start)+xd+yd*LONGINT(scr^.width)) ;
    srt := source ;

    y:=16 ;
    WHILE (y<=SHIFT(h,4)) DO
      x:=0 ;
      WHILE (x<SHIFT(w,4)) DO
        xx := SHIFT(x,-4) ;
        ADDRESS(LONGINT(dst)+x DIV faktor)^ := ADDRESS(LONGINT(srt)+xx)^ ;
        INC(x,faktor) ;
      END ;
      srt := ADDRESS(LONGINT(source)+w*SHIFT(y,-4)) ;
      INC(dst,scr^.width) ;
      INC(y,faktor) ;
    END ;
    UnLockVillageScreen(scr) ;

  END Scale ;


(*Skaliert Bild aus Speicher auf Dest hoch/runter *)
(*Doch noch xs/ys angeben....*)
(*$StackChk := FALSE *)
(*$RangeChk := FALSE *)
(*$OverflowChk := FALSE *)
(*$NilChk := FALSE *)
(*$EntryClear := FALSE *)
(*$CaseChk := FALSE *)
(*$ReturnChk := FALSE *)
PROCEDURE ScaleM(scr : ScreenPtr ; source : ADDRESS ; dest : ADDRESS ;
                 w{R.D2},h,xd,yd,faktor{R.D0} : LONGINT) ;
VAR x{R.D3},
    xs{R.D5},
    sw{R.D1}   : LONGINT ;
    y{R.D4}    : LONGINT ;
    dst{R.A1},
    srt{R.A0}  : ADDRESS ;

  BEGIN
    sw := scr^.width ;
    y  := 16 ;
    xs := SHIFT(w,4) ;
    dst := (LONGINT(dest)+xd+yd*sw) ;
    srt := source ;

    WaitVillageBlit ;

    WHILE (y<=SHIFT(h,4)) DO
      x:=0 ;
      WHILE (x<xs) DO
        ADDRESS(dst+ADDRESS(x DIV faktor))^ := ADDRESS(srt+ADDRESS(SHIFT(x,-4)))^ ;
        INC(x,faktor) ;
      END ;
      srt := source+ADDRESS(w*SHIFT(y,-4)) ;
      INC(dst,sw) ;
      INC(y,faktor) ;
    END ;

  END ScaleM ;



(*$StackChk := FALSE *)
(*$RangeChk := FALSE *)
(*$OverflowChk := FALSE *)
(*$NilChk := FALSE *)
(*$EntryClear := FALSE *)
(*$CaseChk := FALSE *)
(*$ReturnChk := FALSE *)
PROCEDURE CookieCut(scr : ScreenPtr ; source{R.A0} : ADDRESS ;
                                      dest{R.A1}   : ADDRESS ;
                                      w{R.D5},h{R.D7},xd,yd : LONGINT ;
                                      trans{R.D3} : SHORTCARD) ;
VAR x{R.D0},y{R.D1},sw{R.D2}   : LONGINT ;

  BEGIN
    sw := scr^.width ;
    INC(dest,xd) ;
    INC(dest,sw*yd) ;
    sw:=sw-w ;
    FOR y:=1 TO h DO
      FOR x:=1 TO w DO
        IF SHORTCARD(source^)#trans THEN
          dest^ := source^ ;
        END ;
        INC(dest,1) ;
        INC(source,1) ;
      END ;
      INC(dest,sw) ;
    END ;

  END CookieCut ;


PROCEDURE SaveBack(scr : ScreenPtr ; source : ADDRESS ;
                                     dest   : ADDRESS ;
                                     w,h,xd,yd : LONGINT) ;
VAR x,y,sw   : LONGINT ;
    dst{R.A1},
    srt{R.A0}  : ADDRESS ;

  BEGIN
    sw := scr^.width ;
    INC(source,xd) ;
    INC(source,sw*yd) ;
    WaitVillageBlit ;
    FOR y:=1 TO h DO
      FOR x:=1 TO w DO
          dest^ := source^ ;
        INC(dest,1) ;
        INC(source,1) ;
      END ;
      INC(source,sw-w) ;
    END ;

  END SaveBack ;


PROCEDURE RestBack(scr : ScreenPtr ; source : ADDRESS ;
                                     dest   : ADDRESS ;
                                     w,h,xd,yd : LONGINT) ;
VAR x,y,sw   : LONGINT ;
    dst{R.A1},
    srt{R.A0}  : ADDRESS ;

  BEGIN
    sw := scr^.width ;
    INC(dest,xd) ;
    INC(dest,sw*yd) ;
    WaitVillageBlit ;
    FOR y:=1 TO h DO
      FOR x:=1 TO w DO
          dest^ := source^ ;
        INC(dest,1) ;
        INC(source,1) ;
      END ;
      INC(dest,sw-w) ;
    END ;

  END RestBack ;


(*$StackChk := FALSE *)
(*$RangeChk := FALSE *)
(*$OverflowChk := FALSE *)
(*$NilChk := FALSE *)
(*$EntryClear := FALSE *)
(*$CaseChk := FALSE *)
(*$ReturnChk := FALSE *)
PROCEDURE Restore(scr : ScreenPtr ; source{R.A0} : LONGPTR ;
                                    dest{R.A1}   : LONGPTR ;
                                    w{R.D3},h{R.D4},xd,yd : LONGINT) ;
VAR x{R.D0},y{R.D1},sw{R.D2}   : LONGINT ;

  BEGIN
    sw := scr^.width ;
    INC(dest,xd) ;
    INC(dest,sw*yd) ;
    INC(source,xd) ;
    INC(source,sw*yd) ;
    sw:=sw-w ;
    FOR y:=1 TO h DO
      FOR x:=1 TO SHIFT(w,-2) DO
        dest^ := source^ ;
        INC(dest,4) ;
        INC(source,4) ;
      END ;
      INC(dest,sw) ;
      INC(source,sw) ;
    END ;

  END Restore ;



PROCEDURE Swap(VAR a{R.A0},b{R.A1} : LONGINT) ;
VAR temp{R.D0} : LONGINT ;
  BEGIN
    temp:=a ; a:=b; b:=temp ;
  END Swap ;



BEGIN
  InstallException ;

(*
  mode := VillageModeRequest(TAG(tags,tavisMinDepth,    8,
                                      tavisMaxDepth,    8,
                                      tavisMinHeight, 256,
                                           tagDone)) ;
  Assert(mode#InvalidID,ADR("Kein Screenmode gewählt !")) ;
*)
  scr := OpenVillageScreenTagList(TAG(tags,tavisScreenWidth,  640,
                                           tavisScreenHeight, 512,
                                           tavisScreenDepth,    8,
                                           tavisDoubleBuffer,   2,
                                           tagDone)) ;
  Assert(scr#NIL,ADR("Kann PICASSO Screen nicht öffnen !")) ;

  start := LockVillageScreen(scr) ;
  FOR buf:=0 TO 1 DO
    bufadr[buf] := VillageGetBufAddr(scr,buf) ;
  END ;

  xmit := scr^.width  DIV 2 ;
  ymit := scr^.height DIV 4 ;   (* wg. DoubleBuffer !!!!!!! *)
  xoff := Bildw * 8 ;
  yoff := Bildh * 8 ;

  UnLockVillageScreen(scr) ;

  ReadPAL(Bildname,scr) ;
  source := ReadBMP(Bildname,Bildw,Bildh) ;


  kugeln := ReadBMP("pics/Kugeln1.bmp",16,16*15) ;
  ufo    := ReadBMP("pics/Ufo.bmp",32,33*8) ;
  expl   := ReadBMP("pics/Explosion.bmp",16,16*4) ;


  FOR i:=0 TO 6 DO
    aobj[i].adr := ufo ;
    aobj[i].x   := RND(scr^.width-100)+50 ;
    aobj[i].y   := RND((scr^.height DIV 2)-100)+50 ;
    aobj[i].vx  := RND(8)+1 ;
    aobj[i].vy  := 0 ; (*RND(8)+1 ;*)
    aobj[i].frm := RND(aobj[i].cnt) ;
    aobj[i].as  :=  1 ;
    aobj[i].w   := 32 ;
    aobj[i].h   := 33 ;
    aobj[i].cnt := 8 ;
  END ;

  FOR i:=6 TO 15 DO
    aobj[i].adr := kugeln ;
    aobj[i].x   := RND(scr^.width-100)+50 ;
    aobj[i].y   := RND((scr^.height DIV 2)-100)+50 ;
    aobj[i].vx  := RND(8)+1 ;
    aobj[i].vy  := RND(8)+1 ;
    aobj[i].frm := RND(aobj[i].cnt) ;
    aobj[i].as  :=  1 ;
    aobj[i].w   := 16 ;
    aobj[i].h   := 16 ;
    aobj[i].cnt := 15 ;
  END ;

  FOR i:=15 TO Objekte-1 DO
    aobj[i].adr := expl ;
    aobj[i].x   := RND(scr^.width-100)+50 ;
    aobj[i].y   := RND((scr^.height DIV 2)-100)+50 ;
    aobj[i].vx  := RND(8)+1 ;
    aobj[i].vy  := RND(8)+1 ;
    aobj[i].frm := RND(aobj[i].cnt) ;
    aobj[i].as  :=  1 ;
    aobj[i].w   := 16 ;
    aobj[i].h   := 16 ;
    aobj[i].cnt :=  4 ;
  END ;

  buf := 0 ;
  VillageSetDisplayBuf(scr,buf) ;
  ClearBuf(scr,bufadr[buf]) ;
  WaitVillageBlit ;
  CopyMem(source,bufadr[buf],Bildw*Bildh) ;
  buf := 1 ;
  VillageSetDisplayBuf(scr,buf) ;
  ClearBuf(scr,bufadr[buf]) ;
  WaitVillageBlit ;
  CopyMem(source,bufadr[buf],Bildw*Bildh) ;

  buf  := 0 ;  (* ToDo : Gleich die BuffAdr tauschen... ???*)
  buf1 := 1 ;

  Forbid() ;
  StartTime() ;

(*  FOR j:=0 TO 500 DO*)

  WHILE (6 IN cia) DO
   FOR i:=0 TO Objekte-1 DO
     Restore(scr,source,bufadr[buf],aobj[i].w,aobj[i].h,aobj[i].xa[buf],aobj[i].ya[buf]) ;
   END ;
   FOR i:=0 TO Objekte-1 DO

     aobj[i].frm := (aobj[i].frm + aobj[i].as) MOD aobj[i].cnt ;

     CookieCut(scr,aobj[i].adr + ADDRESS(aobj[i].frm * (aobj[i].w * aobj[i].h)),
                   bufadr[buf],aobj[i].w,aobj[i].h,aobj[i].x,aobj[i].y,0) ;

     aobj[i].xa[buf] := aobj[i].x ;
     aobj[i].ya[buf] := aobj[i].y ;

     aobj[i].x := aobj[i].x + aobj[i].vx ;
     IF (aobj[i].x<=0) OR (aobj[i].x>=scr^.width-aobj[i].w) THEN
       aobj[i].vx := aobj[i].vx * (-1) ;
       aobj[i].x  := aobj[i].x + aobj[i].vx ;
     END ;
     aobj[i].y := aobj[i].y + aobj[i].vy ;
     IF (aobj[i].y<=0) OR (aobj[i].y>=SHIFT(scr^.height,-1)-aobj[i].h) THEN
       aobj[i].vy := aobj[i].vy * (-1) ;
       aobj[i].y  := aobj[i].y + aobj[i].vy ;
     END ;

   END (*FOR i*) ;

   VillageSetDisplayBuf(scr,buf) ;
   Swap(buf,buf1) ;

  END (*WHILE*) ;

  StopTime(time) ;
  Permit() ;
  Erg(time) ;


CLOSE
  IF scr#NIL THEN
    UnLockVillageScreen(scr) ;
    CloseVillageScreen(scr) ;
  END ;
  IF source#NIL THEN
    FreeMem(source,Bildw*Bildh) ;
  END ;
  IF kugeln#NIL THEN
    FreeMem(kugeln,16*16*15) ;
  END ;
  IF ufo#NIL THEN
    FreeMem(ufo,32*33*8) ;
  END ;
  IF expl#NIL THEN
    FreeMem(expl,16*16*4) ;
  END ;

END Space.

