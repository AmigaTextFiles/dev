{-------------------------------------------------------------------------}

PROGRAM Aequipotential;

{--------------------------------------------------------------------------

                        Äquipotential V1.15 PAL
                 written by J.Matern December 23, 1990
                      last changed June 28, 1991
                         written in PCQ-Pascal
                      Compiler:PCQ-Compiler V1.1c
                                  //
                Written for the \X/ Amiga; tested on a
                    PAL Amiga 2000, Rev4.1; KickV1.2

                  Thanx to my brother Markus who gave
                     me help and some good ideas!

--------------------------------------------------------------------------}

{$I "Include:Ports.i"       : GetMsg, ReplyMsg, WaitPort }
{$I "Include:Intuition.i"   : AutoRequest, CloseScreen, CloseWindow,
                              ModifyIDCMP, OpenScreen, OpenWindow,
                              ScreenToBack, ScreenToFront, ShowTitle,
                              ViewPortAddress }
{$I "Include:Graphics.i"    : Draw, Move, RectFill, SetAPen,
                              SetDrMd, SetRGB4, WritePixel }
{$I "Include:Exec.i"        : AllocMem, CloseLibrary, FindTask, Forbid,
                              FreeMem, OpenLibrary, Permit }
{$I "Include:Screen.i"      : Screen-Record Definition }
{$I "Include:MathTrans.i"   : OpenMathTrans, CloseMathTrans, SPPow, SPSqrt }
{$I "Include:Text.i"        : GText }
{$I "Include:StringLib.i"   : AllocString, IntToString, stricmp, strcpy }
{$I "Include:Parameters.i"  : GetParam, GetStartupMsg }
{$I "Process.i"             : Process-Record }
{$I "ILBM.i"                : SaveWindowToIFF }
{$I "ReqLibrary.i"          : ColorRequester, FileRequester, GetLong}

{-------------------------------------------------------------------------}

TYPE
   CrossType  = Array[0..33] of Short;   {für den neuen Mauszeiger}

{-------------------------------------------------------------------------}

CONST
   Commands    = 8;
   Ko          = 80.00;
   MaxPot      = 15.00;
   MaxLad      = 20;
   Skonst      = 256;    { PAL  }
  {Skonst      = 200;      NTSC }
   RMBTRAP_f   = $10000; {fehlt in Intuition.i}
   FPF_ROMFONT = 1;      {fehlt in Text.i}
   FPF_TALLDOT = 8;      {fehlt in Text.i}

   EmptyStr: String    = "\0";
   OK      : IntuiText = (0,0,JAM1,0,6,3,nil,"OK",nil);
   Cancel  : IntuiText = (0,0,JAM1,0,7,3,nil,"Cancel",nil);
   Repair  : IntuiText = (0,0,JAM1,0,16,8,nil,"Wollen Sie reparieren?",nil);
   Feintxt : IntuiText = (0,0,JAM1,0,16,8,nil,"Wollen Sie fein berechnen?",nil);
   NoReq   : IntuiText = (0,0,JAM1,0,16,8,nil,"Could not open Req.library!",nil);
   NoMath  : IntuiText = (0,0,JAM1,0,16,8,nil,"Could not open Mathtrans.library!",nil);

   TOPAZ80 : TextAttr  = ("topaz.font",8,FS_NORMAL,FPF_ROMFONT + FPF_TALLDOT);

   NewScr  : NewScreen = (0,0,0,0,0,0,0,0,CUSTOMSCREEN_f,nil,
                          "AequipotV1.15 © 1990/91 by J.Matern",nil,nil);

   NewWin  : NewWindow = (0,0,0,0,-1,-1,MOUSEBUTTONS_f,
                          BACKDROP_f + BORDERLESS_f + SMART_REFRESH_f + ACTIVATE_f + REPORTMOUSE_f + RMBTRAP_f,
                          nil,nil,nil,nil,nil,50,-1,20,-1,CUSTOMSCREEN_f);

   MyLong  : GetLongStruct = (nil,0,-20,20,0,nil,REQVERSION,0,0);

   SaveTit : Array [0..19] of char = 'Save Window as ILBM\0';
   LadTit  : Array [0..16] of char = 'Ladung eingeben!\0';

   Command : Array[1..Commands] of String = ("Mode","Charge","AnimateStart",
                          "AnimateEnd","Frames","Name","*","NextFile");

   CrossSt : CrossType =     ($0000, $0000,  {Die Daten für den}
                                             {KREUZ-Mauszeiger}
                              $0100, $0000,
                              $0100, $0100,
                              $0100, $0000,
                              $0100, $0100,
                              $0100, $0000,
                              $0100, $0100,
                              $0000, $0000,
                              $FC7E, $5454,
                              $0000, $0000,
                              $0100, $0100,
                              $0100, $0000,
                              $0100, $0100,
                              $0100, $0000,
                              $0100, $0100,
                              $0100, $0000,

                              $0000, $0000);

{-------------------------------------------------------------------------}

VAR
   Name_f, Script_f,
   AnGlob_f, AnStart_f,
   Test_f, Screen_f,
   Render_f, Minus_f,
   Mathtest, NoHide,
   MovedMouse, Quit,
   Area, UpperLeft,
   Rect, ReqFlag        : BOOLEAN;
   Frames, PicNum,
   Comm, CommLine,
   x,y,xf,yf,xs,ys,
   i,t,Fast,Leave,
   Anzahl,Modeflag,
   Whoehe,Wbreite,
   Shoehe,Sbreite,Smode,
   Minho,Minbr,Atf,
   strlaeng,
   LeftX, LeftY,
   RightX, RightY,
   Dummy, ILBMError     : INTEGER;
   EPottest,Fak,Dist    : REAL;
   Eingabe, Ausgabe     : TEXT;
   Number, NameStore,
   NextName, NextStore,
   NameEin, NameAus,
   ReadStr, DummyStr,
   xkord, ykord, empty,
   GrMode, SpMode       : STRING;
   Anim_f               : ARRAY [0..MaxLad] OF BOOLEAN;
   Rpktx,Rpkty          : ARRAY [0..4] OF INTEGER;
   Apktx,Apkty,
   Arbfeld,Arbb,Arbh    : ARRAY [0..8] OF INTEGER;
   Anis,AnisX,AnisY,
   Anie,AnieX,AnieY,
   Lad,Ladx,Lady        : ARRAY [0..MaxLad] OF REAL;
   Pottest              : ARRAY [0..4] OF REAL;
   CrossData            : ^CrossType;

   MyFileReq            : ReqFileRequester;
   Answerarray          : ARRAY [0..DSIZE+FCHARS] OF CHAR;
   ReqFileName          : ARRAY [0..FCHARS] OF CHAR;
   DirectoryName        : ARRAY [0..DSIZE] OF CHAR;

   s         : ScreenPtr;
   bw ,qw    : WindowPtr;
   rp        : RastPortPtr;
   m         : MessagePtr;
   vp        : Address;
   IM        : IntuiMessagePtr;
   StoreMsg  : IntuiMessage;
   WBSP      : WBStartupPtr;
   myprocess : ProcessPtr;
   olderrorw : Address;

{-------------------------------------------------------------------------}

FUNCTION OpenMyScreen : BOOLEAN;
BEGIN
   NewScr.Font := ADR(TOPAZ80);
   NewScr.Width := Sbreite;
   NewScr.Height:= Shoehe;
   NewScr.Depth := 3 + ModeFlag;
   NewScr.DetailPen := TRUNC(16.0/Fak);
   NewScr.ViewModes := Smode;
   s := OpenScreen(ADR(NewScr));
   OpenMyScreen := s <> nil;
END;

{-------------------------------------------------------------------------}

FUNCTION OpenBackWindow : BOOLEAN;
BEGIN
   NewWin.Width := Wbreite;
   NewWin.Height := Whoehe;
   NewWin.Screen := s;
   bw := OpenWindow(ADR(NewWin));
   OpenBackWindow := bw <> nil;
END;

{-------------------------------------------------------------------------}

PROCEDURE CloseAll;
BEGIN
   IF s <> nil THEN
      ScreenToBack(s);

   IF bw <> nil THEN BEGIN
      Forbid;
      REPEAT
         IM := IntuiMessagePtr(GetMsg(bw^.UserPort));
         IF IM <> nil THEN ReplyMsg(MessagePtr(IM));
      UNTIL IM = nil;
      CloseWindow(bw);
      Permit;
   END;

   IF s <>nil THEN
      CloseScreen(s);

   IF CrossData <> nil THEN
      FreeMem(CrossData,MemChip);

   IF GfxBase <> nil THEN
      CloseLibrary(GfxBase);

   IF Mathtest = TRUE THEN
      CloseMathTrans;

   IF ILBMBase <> nil THEN
      CloseLibrary(ILBMBase);

   IF ReqBase <> nil THEN BEGIN
      PurgeFiles(ADR(MyFileReq));
      CloseLibrary(ReqBase);
   END;

   myprocess^.pr_WindowPtr := olderrorw;
END;

{-------------------------------------------------------------------------}

PROCEDURE OpenMath;
BEGIN
   Mathtest := OpenMathTrans();
   IF (NOT Mathtest) THEN BEGIN
      ReqFlag := AutoRequest(nil,ADR(NoMath),nil,ADR(Ok),0,0,356,60);
      CloseAll;
      EXIT(20);
   END;
END;

{-------------------------------------------------------------------------}

PROCEDURE OpenAll;
BEGIN
   ReqBase := OpenLibrary("req.library", 0);
   IF ReqBase = nil THEN BEGIN
      ReqFlag := AutoRequest(nil,ADR(NoReq),nil,ADR(Ok),0,0,300,60);
      CloseAll;
      EXIT(20);
   END;

   ILBMBase := OpenLibrary("ilbm.library", 0);
   IF ILBMBase = nil THEN BEGIN
      SimpleRequest("Could not open ILBM.library!");
      CloseAll;
      EXIT(20);
   END;

   GfxBase := OpenLibrary("graphics.library", 0);
   IF GfxBase = nil THEN BEGIN
      SimpleRequest("Could not open Graphics.library!");
      CloseAll;
      EXIT(20);
   END;

   IF (NOT OpenMyScreen) THEN BEGIN
      SimpleRequest("Could not open the screen!");
      CloseAll;
      Exit(20);
   END;
   ShowTitle(s, FALSE);

   IF (NOT OpenBackWindow) THEN BEGIN
      SimpleRequest("Could not open window!");
      CloseAll;
      Exit(20);
   END;
   rp:=bw^.RPort;
   MyFileReq.window := bw;
   MyLong.window := bw;

   myprocess := FindTask(nil);
   olderrorw := myprocess^.pr_WindowPtr;
   myprocess^.pr_WindowPtr := bw;
END;

{-------------------------------------------------------------------------}

PROCEDURE InitFileReq;
BEGIN
   MyFileReq.PathName := ADR(Answerarray);
   MyFileReq._Dir := ADR(DirectoryName);
   MyFileReq._File := ADR(ReqFilename);
   MyFileReq.Title := ADR(SaveTit);
   MyFileReq.VersionNumber := REQVERSION;
   MyFileReq.Flags := FRQCACHINGM;
   MyFileReq.dirnamescolor := 2;
   MyFileReq.devicenamescolor := 2;
END;

{-------------------------------------------------------------------------}

FUNCTION Distance(x,y : REAL; xx,yy : INTEGER) : REAL;
{Entfernungsbestimmung mit Pythagoras zwischen (x,y) u. (xx,yy)}
BEGIN
   Distance:=SPsqrt(SQR(x-FLOAT(xx))+SQR(y-FLOAT(yy)));
   {SPsqrt ist viel schneller als SQRT!!}
END;

{-------------------------------------------------------------------------}

FUNCTION Potential(Lad,Dist : REAL) : REAL;
{Potentialbestimmung zur Ladung (Lad) in Entfernung (Dist)}
BEGIN
   Potential:=Ko*(Lad/Dist);
END;

{-------------------------------------------------------------------------}

PROCEDURE SaveIFF;
BEGIN
   MyFileReq.Flags := FRQCACHINGM + FRQSAVINGM;
   IF FileRequester(ADR(MyFileReq)) THEN BEGIN
      ILBMError := SaveWindowToIFF(bw,ADR(Answerarray));
   END;
END;

{-------------------------------------------------------------------------}

PROCEDURE HandleMessage;
BEGIN
   IM := IntuiMessagePtr(WaitPort(bw^.UserPort));
   IM := IntuiMessagePtr(GetMsg(bw^.UserPort));
   StoreMsg := IM^;
   ReplyMsg(MessagePtr(IM));
   CASE StoreMsg.Class OF
      VANILLAKEYS_f : BEGIN
         CASE StoreMsg.Code OF
            99 : ColorRequester(1);           {Taste c}
           115 : SaveIFF;                     {Taste s}
         END;
      END;
      MOUSEBUTTONS_f : BEGIN
         IF StoreMsg.Code = SELECTUP THEN BEGIN
            IF NoHide=TRUE THEN
               NoHide:=FALSE
            ELSE
               NoHide:=TRUE;
            ShowTitle(s, NoHide);
         END;
         IF StoreMsg.Code = MENUUP THEN BEGIN
            Quit:=TRUE;
         END;
      END;
   END;
END;

{-------------------------------------------------------------------------}

PROCEDURE RechnePotential; {Potential an jedem der fünf Rechenpunkte wird
                            berechnet=Pottest[0-4]}
BEGIN
   FOR t:=0 TO 4 DO BEGIN
      Pottest[t]:=0.0;
      FOR i:=1 TO Anzahl DO BEGIN
         Dist:=Distance(Ladx[i],Lady[i],Rpktx[t],Rpkty[t]);
         IF Dist<>0.0 THEN BEGIN
            Pottest[t]:=Pottest[t]+Potential(Lad[i],Dist);
         END ELSE
            Pottest[t]:=100.0*Lad[i];
      END;
   END;
END;

{-------------------------------------------------------------------------}

PROCEDURE Drawing(x,y : INTEGER); {Potential an x,y wird berechnet und
                                   gezeichnet}
BEGIN {Drawing}
   EPottest:=0.0;
   FOR i:=1 TO Anzahl DO BEGIN {Aufsummieren der Einzelpotentiale über
                                die verschiedenen Ladungen}
      Dist:=Distance(Ladx[i],Lady[i],x,y);
      IF Dist<>0.0 THEN BEGIN
         EPottest:=EPottest+Potential(Lad[i],Dist);
      END ELSE
         Epottest:=100.0*Lad[i];
   END;
   IF ABS(EPottest)<MaxPot THEN BEGIN     {wenn Potential nicht zu groß}
      SetAPen(rp,ROUND((EPottest+16.0)/Fak)); {dann Farbwahl und}
      WritePixel(rp,x,y);                     {Setzen eines Punktes}
   END;
END; {Drawing}

{-------------------------------------------------------------------------}

PROCEDURE FastDraw(xsta, ysta, xe, ye, xste, yste : INTEGER; Modus : BOOLEAN);
                        {Schneller Überblick über die Grafik}
                        {oder Reperatur, je nach Modus}
BEGIN {FastDraw}
   y:=ysta;
   REPEAT
   {Schleife für y-Koordinate}
      x:=xsta;
      REPEAT
      {Schleife für x-Koordinate}
         EPottest:=0.0;
         m:=GetMsg(bw^.UserPort);
         IF m <> nil THEN BEGIN {Abbruch bei Mausknopf}
            HandleMessage;
            IF Quit=TRUE THEN BEGIN
               x:=xe+1;
               y:=ye+1;
            END;
         END;
         FOR i:=1 TO Anzahl DO BEGIN    {Potential Aufsummieren}
            Dist:=Distance(Ladx[i],Lady[i],x,y);
            IF Dist<>0.0 THEN BEGIN
               EPottest:=EPottest+Potential(Lad[i],Dist);
            END ELSE
               EPottest:=100.0*Lad[i];
         END;
         IF ABS(EPottest)<MaxPot THEN BEGIN {falls Potential nicht zu groß}
            SetAPen(rp,ROUND((EPottest+16.0)/Fak)); {dann Farbwahl und}
            IF Modus THEN
               WritePixel(rp,x,y)                       {Punkt setzen}
            ELSE                                        {oder}
               RectFill(rp,x,y,x+xste,y+yste+1);        {Fläche füllen}
         END;
         x:=x+xste;
      UNTIL x >= xe; {Schleifenende x}
      y:=y+yste;
   UNTIL y >= ye; {Schleifenende y}
END; {FastDraw}

{-------------------------------------------------------------------------}

PROCEDURE Clear; {Window löschen}
BEGIN
   SetAPen(rp,0);
   RectFill(rp,0,0,Sbreite,Shoehe);
   SetAPen(rp,TRUNC(16.0/Fak));
END;

{-------------------------------------------------------------------------}

PROCEDURE Cross(x,y : INTEGER); {Zeichnet Kreuz bei x,y}
BEGIN
   MOVE(rp,x-2,y);
   DRAW(rp,x+2,y);
   MOVE(rp,x,y-2);
   DRAW(rp,x,y+2);
END;

{-------------------------------------------------------------------------}

PROCEDURE LadMark; {Übergibt Koordinaten jeder Ladung an Cross}
BEGIN
   Clear;
   FOR i:=1 TO Anzahl DO BEGIN
      x:=TRUNC(Ladx[i]);
      y:=TRUNC(Lady[i]);
      Cross(x,y);
   END;
END;

{-------------------------------------------------------------------------}

PROCEDURE Color; {Farbpalette wird in Abhängigkeit von ScreenAuflösung
                  gesetzt}
BEGIN {Color}
   vp:= ViewPortAddress(bw);
   IF ModeFlag=2 THEN BEGIN
      SetRGB4(vp, 0, 0, 0, 0);
      FOR i:=1 TO 16 DO
         SetRGB4(vp, i,15, i-1,0);
      FOR i:=16 TO 31 DO
         SetRGB4(vp, i,31-i,31-i,i-16);
   END ELSE BEGIN
      SetRGB4(vp, 0, 0, 0, 0);
      FOR i:=1 TO 8 DO
         SetRGB4(vp,i,15,i*2-1,0);
      FOR i:=8 TO 15 DO
         SetRGB4(vp, i,31-2*i,31-2*i,i*2-16);
   END;
   SetAPen(rp,TRUNC(16.0/Fak));
END; {Color}

{-------------------------------------------------------------------------}

PROCEDURE Pointtest; {Berechnung von fünf Probekoordinaten in Abhängigkeit
                      vom Arbeitspunkt; Berechnung des Potentials an den
                      fünf Rechenpunkten; je nach Ergebnis Füllen der
                      Fläche, Veränderung der Arbeitstiefe (Atf) und des
                      Arbeitsbereichs}
BEGIN {Pointtest}
   Rpktx[0]:=Apktx[Atf]; {Berechnung der Probekoordinaten}
   Rpkty[0]:=Apkty[Atf];
   Rpktx[1]:=Apktx[Atf]+Arbb[Atf]-1;
   Rpkty[1]:=Apkty[Atf];
   Rpktx[2]:=Apktx[Atf];
   Rpkty[2]:=Apkty[Atf]+Arbh[Atf]-1;
   Rpktx[3]:=Apktx[Atf]+Arbb[Atf]-1;
   Rpkty[3]:=Apkty[Atf]+Arbh[Atf]-1;
   Rpktx[4]:=Apktx[Atf]+Arbb[Atf+1]-1;
   Rpkty[4]:=Apkty[Atf]+Arbh[Atf+1]-1;
   RechnePotential; {Berechnung des Potentials an den fünf Punkten}
   IF (ROUND(Pottest[0]/Fak)=ROUND(Pottest[1]/Fak)) AND
    (ROUND(Pottest[1]/Fak)=ROUND(Pottest[2]/Fak)) AND
    (ROUND(Pottest[2]/Fak)=ROUND(Pottest[3]/Fak)) AND
    (ROUND(Pottest[3]/Fak)=ROUND(Pottest[4]/Fak)) THEN BEGIN {Falls das
                        Potential an allen fünf Punkten identisch ist}
      IF ABS(Pottest[0])<MaxPot THEN BEGIN
         SetAPen(rp,ROUND((Pottest[0]+16.0)/Fak)); {dann Farbauswahl und}
         RectFill(rp,Rpktx[0],Rpkty[0],Rpktx[3],Rpkty[3]); {Füllen der
                                          entsprechenden Fläche}
      END;
{*}   IF Arbfeld[Atf]=5 THEN BEGIN {Test, ob momentane Arbeitstiefe schon
                          vollständig bearbeitet wurde}
         REPEAT
            Arbfeld[Atf]:=1;       {dann Arbeitstiefe verringern}
            DEC(Atf);
         UNTIL Arbfeld[Atf]<5;
      END ELSE
         INC(Arbfeld[Atf]); {sonst Arbeitsbereich erhöhen}
   END ELSE BEGIN                 {wenn Fläche nicht gefüllt werden konnte,}
      IF (Atf=8) THEN BEGIN       {maximale Arbeitstiefe erreicht ist}
         IF (ABS(Pottest[0]/Fak)<Maxpot) OR
          (ABS(Pottest[1]/Fak)<Maxpot) OR
          (ABS(Pottest[2]/Fak)<Maxpot) OR
          (ABS(Pottest[3]/Fak)<Maxpot) THEN BEGIN {und Fläche nicht schwarz}
            FOR x:=Rpktx[0] TO Rpktx[3] DO BEGIN     {wird Fläche Pixel}
               FOR y:=Rpkty[0] TO Rpkty[3] DO BEGIN  {für Pixel berechnet}
                  Drawing(x,y);
               END;
            END;
         END;
         IF Arbfeld[Atf]=5 THEN BEGIN {siehe *}
            REPEAT
               Arbfeld[Atf]:=1;
               DEC(Atf);
            UNTIL Arbfeld[Atf]<5;
         END ELSE
            INC(Arbfeld[Atf]);
      END ELSE BEGIN    {Fläche konnte nicht gefüllt werden, maximale
                         Arbeitstiefe ist aber noch nicht erreicht}
         IF Arbfeld[Atf]=5 THEN
            Arbfeld[Atf]:=1
         ELSE
            INC(Arbfeld[Atf]);
         INC(Atf);    {Arbeitstiefe erhöhen}
      END;
   END;
END; {Pointtest}

{-------------------------------------------------------------------------}

PROCEDURE Areatest; {Test, in welchem der vier möglichen Arbeitsbereiche
                     momentan gerade gerechnet wird und entsprechende Wahl
                     des Arbeitpunktes (Apktx,Apkty) der momentanen
                     Arbeitstiefe (Atf)}
BEGIN {Areatest}
   REPEAT
      CASE Arbfeld[Atf] OF
         1 : BEGIN  {Bereich 1=links oben}
            xf:=0;
            yf:=0;
         END;
         2 : BEGIN  {Bereich 2=rechts oben}
            xf:=1;
            yf:=0;
         END;
         3 : BEGIN  {Bereich 3=links unten}
            xf:=0;
            yf:=1;
         END;
         ELSE BEGIN {Bereich 4=rechts unten}
            xf:=1;
            yf:=1;
         END;
      END;
      Apktx[Atf]:=Apktx[Atf-1]+xf*Arbb[Atf]; {Berechnung des neuen}
      Apkty[Atf]:=Apkty[Atf-1]+yf*Arbh[Atf]; {Arbeitpunktes in Tiefe Atf}
      Pointtest;
      Leave:=Apktx[Atf]+Arbb[Atf];
      m:=GetMsg(bw^.UserPort); {Test auf linke Maustaste}
      IF m <> nil THEN BEGIN
         HandleMessage;
         IF Quit=TRUE THEN               {und verlassen zum Hauptprogramm}
            Leave:=(640 DIV Modeflag)+1; {falls diese gedrückt wurde}
      END;
   UNTIL Leave>(640 DIV ModeFlag); {Test, ob der gesamte
                                    Bildschirm bereits
                                    berechnet wurde}
END; {Areatest}

{-------------------------------------------------------------------------}

PROCEDURE LadKoord;
BEGIN
   ModifyIDCMP(bw, MOUSEBUTTONS_f + MOUSEMOVE_f);
   Quit:=FALSE;
   MovedMouse:=FALSE;
   Anzahl:=0;
   Move(rp,(Sbreite-296) DIV 2,Shoehe DIV 2);
   GText(rp,"Mit linkem Mausknopf Ladungen setzen,",37);
   Move(rp,(Sbreite-240) DIV 2,(Shoehe DIV 2)+10);
   GText(rp,"mit rechtem Mausknopf beenden!",30);
   REPEAT
      IM := IntuiMessagePtr(WaitPort(bw^.UserPort));
      IM := IntuiMessagePtr(GetMsg(bw^.UserPort));
      StoreMsg := IM^;
      ReplyMsg(MessagePtr(IM));
         CASE StoreMsg.Class OF
         MOUSEMOVE_f : BEGIN
            IF MovedMouse=FALSE THEN BEGIN
               Clear;
               MovedMouse:=TRUE;
            END ELSE BEGIN
               x:=StoreMsg.MouseX;
               y:=StoreMsg.MouseY;
               strlaeng:=IntToStr(xkord,x);
               Move(rp,Sbreite-25,Shoehe-12);
               Gtext(rp, empty, 3);
               Move(rp,Sbreite-25,Shoehe-12);
               Gtext(rp, xkord, strlaeng);
               strlaeng:=IntToStr(ykord,y);
               Move(rp,Sbreite-25,Shoehe-2);
               Gtext(rp, empty, 3);
               Move(rp,Sbreite-25,Shoehe-2);
               Gtext(rp, ykord, strlaeng);
            END;
         END;
         MOUSEBUTTONS_f : BEGIN
            IF (StoreMsg.Code = SELECTUP) AND
            (MovedMouse=TRUE) THEN BEGIN {linker Mausknopf}
               INC(Anzahl);
               x:=StoreMsg.MouseX;
               y:=StoreMsg.MouseY;
               Cross(x,y);
               Ladx[Anzahl]:=FLOAT(x);
               Lady[Anzahl]:=FLOAT(y);
            END;
            IF StoreMsg.Code = MENUUP THEN BEGIN   {rechter Mausknopf}
               Quit:=TRUE;
            END;
         END;
      END;
   UNTIL ((Quit=TRUE) OR (Anzahl=MaxLad)) AND (Anzahl>0);
   ModifyIDCMP(bw, MOUSEBUTTONS_f);
   Quit:=FALSE;
END;

{-------------------------------------------------------------------------}

PROCEDURE LadGet;
BEGIN
   SetRGB4(vp, 2, 0, 0, 10);
   MyLong.titlebar := ADR(LadTit);
   FOR t := 1 TO Anzahl DO BEGIN
      SetAPen(rp,TRUNC(16.0/Fak));
      DrawCircle(rp,TRUNC(Ladx[t]),TRUNC(Lady[t]),5);
      IF t = 1 THEN
         MyLong.defaultval := 5
      ELSE
         MyLong.defaultval := TRUNC(Lad[t-1]);
      IF (GetLong(ADR(MyLong))) THEN
         Lad[t] := FLOAT(MyLong.result);
      SetAPen(rp,0);
      DrawCircle(rp,TRUNC(Ladx[t]),TRUNC(Lady[t]),5);
   END;
   Color;
END;

{-------------------------------------------------------------------------}

PROCEDURE Usage;
BEGIN
   WRITELN('Usage: AEQUIPOT [ScriptFile] OR [ScreenMode RenderingMode]');
   WRITELN('       Where ScreenMode is h(igh) or l(ow)');
   WRITELN('       and RenderingMode is s(low) or f(ast)');
   WRITELN('       and ScriptFile is name of file to start from.');
   WRITELN;
   EXIT(20);
END;

{-------------------------------------------------------------------------}

PROCEDURE RectArea;   {Zeichnet Rechteck (LeftX,LeftY/RightX,RightY)}
BEGIN
   Move(rp, LeftX, LeftY);
   Draw(rp, RightX, LeftY);
   Draw(rp, RightX, RightY);
   Draw(rp, LeftX, RightY);
   Draw(rp, LeftX, LeftY);
END;

{-------------------------------------------------------------------------}

PROCEDURE SetRepArea;
BEGIN
   ModifyIDCMP(bw, MOUSEMOVE_f + MOUSEBUTTONS_f);
   SetDrMd(rp, COMPLEMENT);
   Rect:=FALSE;
   UpperLeft:=FALSE;
   Area:=FALSE;
   REPEAT
      IM := IntuiMessagePtr(WaitPort(bw^.UserPort));
      IM := IntuiMessagePtr(GetMsg(bw^.UserPort));
      StoreMsg := IM^;
      ReplyMsg(MessagePtr(IM));
         CASE StoreMsg.Class OF
         MOUSEMOVE_f : BEGIN
            IF UpperLeft=TRUE THEN BEGIN
               RectArea;
               RightX := (StoreMsg.MouseX DIV 5)*5+4;
               RightY := (StoreMsg.MouseY DIV 4)*4+3;
               RectArea;
            END;
         END;
         MOUSEBUTTONS_f : BEGIN
            IF (StoreMsg.Code = SELECTUP) THEN BEGIN    {linker Mausknopf}
               IF UpperLeft THEN BEGIN                  {zum 2. mal}
                  UpperLeft:=FALSE;
                  RightX := (StoreMsg.MouseX DIV 5)*5+4;
                  RightY := (StoreMsg.MouseY DIV 4)*4+3;
               END ELSE BEGIN                           {zum 1. mal}
                  IF Rect = TRUE THEN                   {wenn Umrandung da}
                     RectArea;                          {diese löschen}
                  UpperLeft := TRUE;
                  Rect := TRUE;
                  LeftX := (StoreMsg.MouseX DIV 5)*5;
                  LeftY := (StoreMsg.MouseY DIV 4)*4;
                  RightX := LeftX;
                  RightY := LeftY;
                  RectArea;
               END;
            END;
            IF (StoreMsg.Code = MENUUP) AND
             (UpperLeft = FALSE) AND
             (Rect = TRUE) THEN BEGIN {rechter Mausknopf u. Bereich gewählt}
               RectArea;
               Area:=TRUE;
            END;
         END;
      END;
   UNTIL Area=TRUE;
   ModifyIDCMP(bw, MOUSEBUTTONS_f);
   SetDrMd(rp, JAM1);
END;

{-------------------------------------------------------------------------}

PROCEDURE RepairArea; {reparieren der Grafik}
BEGIN
   IF RightX < LeftX THEN BEGIN
      Dummy := LeftX;
      LeftX := RightX;
      RightX:= Dummy;
   END;
   IF RightY < LeftY THEN BEGIN
      Dummy := LeftY;
      LeftY := RightY;
      RightY:= Dummy;
   END;
   FastDraw(LeftX,LeftY,RightX,RightY,1,1,TRUE);
END;

{-------------------------------------------------------------------------}

PROCEDURE Error (ComStr : String; Lin, Num : Short);
BEGIN
   WRITELN('Error in line ',Lin,': "',ComStr,'"');
   CASE Num OF
      1 : WRITELN('Unknown Command');
      2 : WRITELN('Unknown Parameter');
      3 : WRITELN('Too many charges, max = ',MaxLad);
      4 : WRITELN('Parameter is missing');
      5 : WRITELN('Expecting + or -');
      6 : WRITELN('Parameter too large');
      7 : WRITELN('Missing AnimateStart');
      8 : WRITELN('Missing AnimateEnd');
      9 : WRITELN('Missing Frames');
     10 : WRITELN('Missing Animation');
     11 : WRITELN('No Name spezified');
     12 : WRITELN('Frames must be larger than 1');
     13 : WRITELN('Duplicate Frames');
     14 : WRITELN('No Charge spezified');
     15 : WRITELN('No Mode spezified');
     16 : WRITELN('Could not open file');
   END;
   CloseAll;
   Close(Eingabe);
   EXIT(10);
END;

{-------------------------------------------------------------------------}

PROCEDURE TestPar;
BEGIN
   IF i = Dummy THEN
      Error(ReadStr,CommLine,4);
END;

{-------------------------------------------------------------------------}

FUNCTION StrToInt(st : String) : INTEGER;
VAR
   Ret,t : Short;

BEGIN
   Ret := 0;
   IF StrLen(st) > 3 THEN
      Error(ReadStr,CommLine,6);
   FOR t := StrLen(st)-1 DOWNTO 0 DO BEGIN
      Ret := Ret + ((ORD(st[t])-48)*ROUND(SPPow(FLOAT(Strlen(st)-t-1),10.0)));
   END;
   IF Minus_f THEN
      StrToInt := (-1) * Ret
   ELSE
      StrToInt := Ret
END;

{-------------------------------------------------------------------------}

PROCEDURE ModeCheck(ComStr : String);
BEGIN
   Dummy := StrPos(ComStr,' ');
   IF Dummy = -1 THEN
      Error(ComStr,CommLine,4);
   i := Dummy;
   REPEAT
      IF isalpha(ComStr[i]) THEN BEGIN
         IF ((ComStr[i] = 'h') OR (ComStr[i] = 'H') OR
            (ComStr[i] = 'l') OR (ComStr[i] = 'L')) AND
            (Screen_f = FALSE) THEN BEGIN
            IF (ComStr[i] = 'l') OR (ComStr[i] = 'L') THEN
               Smode := 1
            ELSE
               Smode := 2;
            Screen_f := TRUE;
         END;
         IF ((ComStr[i] = 'f') OR (ComStr[i] = 'F') OR
            (ComStr[i] = 's') OR (ComStr[i] = 'S')) AND
            (Render_f = FALSE) THEN BEGIN
            IF (ComStr[i] = 'f') OR (ComStr[i] = 'F') THEN
               Fast := 1
            ELSE
               Fast := 2;
            Render_f := TRUE;
         END;
      END;
   INC(i);
   UNTIL i = strlen(ComStr);
   IF (NOT Screen_f) OR (NOT Render_f) THEN
      Error(ComStr,CommLine,4);
END;

{-------------------------------------------------------------------------}

PROCEDURE ChargeCheck(ComStr : String);
BEGIN
   IF Anzahl = MaxLad+1 THEN
      Error(ComStr,CommLine,3);
   Dummy := StrPos(ComStr,' ');
   IF Dummy = -1 THEN
      Error(ComStr,CommLine,4);
   i := Dummy;
   Dummy := strlen(ComStr);
   WHILE NOT isdigit(ComStr[i]) DO BEGIN
      TestPar;
      INC(i);
   END;
   Number := StrDup(EmptyStr);
   t := 0;
   WHILE isdigit(ComStr[i]) DO BEGIN
      TestPar;
      Number[t] := ComStr[i];
      INC(t);
      INC(i);
   END;
   LadX[Anzahl] := FLOAT(StrToInt(Number));
   WHILE NOT isdigit(ComStr[i]) DO BEGIN
      TestPar;
      INC(i);
   END;
   Number := StrDup(EmptyStr);
   t := 0;
   WHILE isdigit(ComStr[i]) DO BEGIN
      TestPar;
      Number[t] := ComStr[i];
      INC(t);
      INC(i);
   END;
   LadY[Anzahl] := FLOAT(StrToInt(Number));
   WHILE isspace(ComStr[i]) DO BEGIN
      TestPar;
      INC(i);
   END;
   IF (ComStr[i] <> '+') AND (ComStr[i] <> '-') THEN
      Error(ComStr,CommLine,5);
   IF (ComStr[i] = '+') THEN
      Minus_f := FALSE
   ELSE
      Minus_f := TRUE;
   INC(i);
   Number := StrDup(EmptyStr);
   t := 0;
   WHILE isdigit(ComStr[i]) DO BEGIN
      TestPar;
      Number[t] := ComStr[i];
      INC(t);
      INC(i);
   END;
   IF t = 0 THEN
      Error(ReadStr,CommLine,4);
   Lad[Anzahl] := FLOAT(StrToInt(Number));
   Anim_f[Anzahl] := FALSE;
   INC(Anzahl);
   Minus_f := FALSE;
   AnStart_f := FALSE;
END;

{-------------------------------------------------------------------------}

PROCEDURE AniStartCheck(ComStr : String);
BEGIN
   AnGlob_f := TRUE;
   IF AnStart_f THEN
      Error(ComStr,CommLine,8);
   AnStart_f := TRUE;
   IF Anzahl = MaxLad+1 THEN
      Error(ComStr,CommLine,3);
   Dummy := StrPos(ComStr,' ');
   IF Dummy = -1 THEN
      Error(ComStr,CommLine,4);
   i := Dummy;
   Dummy := strlen(ComStr);
   WHILE NOT isdigit(ComStr[i]) DO BEGIN
      TestPar;
      INC(i);
   END;
   Number := StrDup(EmptyStr);
   t := 0;
   WHILE isdigit(ComStr[i]) DO BEGIN
      TestPar;
      Number[t] := ComStr[i];
      INC(t);
      INC(i);
   END;
   AnisX[Anzahl] := FLOAT(StrToInt(Number));
   WHILE NOT isdigit(ComStr[i]) DO BEGIN
      TestPar;
      INC(i);
   END;
   Number := StrDup(EmptyStr);
   t := 0;
   WHILE isdigit(ComStr[i]) DO BEGIN
      TestPar;
      Number[t] := ComStr[i];
      INC(t);
      INC(i);
   END;
   AnisY[Anzahl] := FLOAT(StrToInt(Number));
   WHILE isspace(ComStr[i]) DO BEGIN
      TestPar;
      INC(i);
   END;
   IF (ComStr[i] <> '+') AND (ComStr[i] <> '-') THEN
      Error(ComStr,CommLine,5);
   IF (ComStr[i] = '+') THEN
      Minus_f := FALSE
   ELSE
      Minus_f := TRUE;
   INC(i);
   Number := StrDup(EmptyStr);
   t := 0;
   WHILE isdigit(ComStr[i]) DO BEGIN
      TestPar;
      Number[t] := ComStr[i];
      INC(t);
      INC(i);
   END;
   IF t = 0 THEN
      Error(ReadStr,CommLine,4);
   Anis[Anzahl] := FLOAT(StrToInt(Number));
   Minus_f := FALSE;
END;

{-------------------------------------------------------------------------}

PROCEDURE AniEndCheck(ComStr : String);
BEGIN
   IF NOT AnStart_f THEN
      Error(ComStr,CommLine,7);
   AnStart_f := FALSE;
   Dummy := StrPos(ComStr,' ');
   IF Dummy = -1 THEN
      Error(ComStr,CommLine,4);
   i := Dummy;
   Dummy := strlen(ComStr);
   WHILE NOT isdigit(ComStr[i]) DO BEGIN
      TestPar;
      INC(i);
   END;
   Number := StrDup(EmptyStr);
   t := 0;
   WHILE isdigit(ComStr[i]) DO BEGIN
      TestPar;
      Number[t] := ComStr[i];
      INC(t);
      INC(i);
   END;
   AnieX[Anzahl] := FLOAT(StrToInt(Number));
   WHILE NOT isdigit(ComStr[i]) DO BEGIN
      TestPar;
      INC(i);
   END;
   Number := StrDup(EmptyStr);
   t := 0;
   WHILE isdigit(ComStr[i]) DO BEGIN
      TestPar;
      Number[t] := ComStr[i];
      INC(t);
      INC(i);
   END;
   AnieY[Anzahl] := FLOAT(StrToInt(Number));
   WHILE isspace(ComStr[i]) DO BEGIN
      TestPar;
      INC(i);
   END;
   IF (ComStr[i] <> '+') AND (ComStr[i] <> '-') THEN
      Error(ComStr,CommLine,5);
   IF (ComStr[i] = '+') THEN
      Minus_f := FALSE
   ELSE
      Minus_f := TRUE;
   INC(i);
   Number := StrDup(EmptyStr);
   t := 0;
   WHILE isdigit(ComStr[i]) DO BEGIN
      TestPar;
      Number[t] := ComStr[i];
      INC(t);
      INC(i);
   END;
   IF t = 0 THEN
      Error(ReadStr,CommLine,4);
   Anie[Anzahl] := FLOAT(StrToInt(Number));
   Minus_f := FALSE;
   Anim_f[Anzahl] := TRUE;
   INC(Anzahl);
END;

{-------------------------------------------------------------------------}

PROCEDURE FrameCheck(ComStr : String);
BEGIN
   IF Frames <> 1 THEN
      Error(ComStr,CommLine,13);
   IF NOT AnGlob_f THEN
      Error(ComStr,CommLine,10);
   Dummy := StrPos(ComStr,' ');
   IF Dummy = -1 THEN
      Error(ComStr,CommLine,4);
   i := Dummy;
   Dummy := strlen(ComStr);
   WHILE NOT isdigit(ComStr[i]) DO BEGIN
      TestPar;
      INC(i);
   END;
   Number := StrDup(EmptyStr);
   t := 0;
   WHILE isdigit(ComStr[i]) DO BEGIN
      TestPar;
      Number[t] := ComStr[i];
      INC(t);
      INC(i);
   END;
   Frames := StrToInt(Number);
   IF Frames < 2 THEN
      Error(ComStr,CommLine,12);
END;

{-------------------------------------------------------------------------}

PROCEDURE NameCheck(ComStr : String);
BEGIN
   IF (Frames = 1) AND (AnGlob_f) THEN
      Error("Global",0,9);
   Name_f := TRUE;
   Dummy := StrPos(ComStr,' ');
   IF Dummy = -1 THEN
      Error(ComStr,CommLine,4);
   i := Dummy;
   Dummy := strlen(ComStr);
   WHILE isspace(ComStr[i]) DO BEGIN
      TestPar;
      INC(i);
   END;
   FOR t := i TO StrLen(ComStr) DO BEGIN
      NameAus[t-i] := ComStr[t];
      Answerarray[t-i] := ComStr[t];
   END;
   IF AnGlob_f THEN BEGIN
      NameStore := StrDup(NameAus);
      Dummy := IntToStr(DummyStr,Frames);
      StrCat(NameAus,DummyStr);
   END;
   Answerarray[t-i+1] := '\0';
   IF NOT Open(NameAus,Ausgabe) THEN
      Error(NameAus,CommLine,16)
   ELSE
      CLOSE(Ausgabe);
END;

{-------------------------------------------------------------------------}

PROCEDURE NextCheck(ComStr : String); {Noch nicht implementiert}
BEGIN
END;

{-------------------------------------------------------------------------}

PROCEDURE ComPara(Num : Short; ComStr : String);
BEGIN
   CASE Num OF
      1 : ModeCheck(ComStr);
      2 : ChargeCheck(ComStr);
      3 : AniStartCheck(ComStr);
      4 : AniEndCheck(ComStr);
      5 : FrameCheck(ComStr);
      6 : NameCheck(ComStr);
      7 : ;
      8 : NextCheck(ComStr);
   END;
END;

{-------------------------------------------------------------------------}

PROCEDURE Parameter;
BEGIN
   GrMode := AllocString(80);
   SPMode := AllocString(80);
   DummyStr := AllocString(100);
   ReadStr := AllocString(100);
   Number := AllocString(100);
   NameEin := AllocString(100);
   NameAus := AllocString(100);
   NextName := AllocString(100);
   NextStore := AllocString(100);
   xkord := AllocString(4);
   ykord := AllocString(4);
   empty := AllocString(4);
   empty := "   ";

   WBSP := GetStartupMsg();

   IF WBSP <> nil THEN BEGIN                  {WB-Start}
      REPEAT
         WRITE('Geben Sie den Grafikmodus ein h(igh) oder l(ow): ');
         READLN(GrMode);
      UNTIL (stricmp(GrMode,"h")=0) OR (stricmp(GrMode,"l")=0);
      REPEAT
         WRITE('Geben Sie den Rechenmodus an f(ast) oder s(low): ');
         READLN(Spmode);
      UNTIL (stricmp(SpMode,"f")=0) OR (stricmp(SpMode,"s")=0);
   END ELSE BEGIN                             {CLI-Start}
      GetParam(1, GrMode);
      GetParam(2, SpMode);
   END;

   IF (stricmp(SpMode,"\0")=0) AND            {Try to read scriptfile}
      (stricmp(GrMode,"\0")<>0) THEN BEGIN
      NameEin := StrDup(GrMode);
      IF ReOpen(NameEin,Eingabe) THEN BEGIN
          CommLine := 0;
          Anzahl := 1;
          WHILE NOT EOF(Eingabe) DO BEGIN
            READLN(Eingabe,ReadStr);
            INC(CommLine);
            FOR i:= 1 TO Commands DO BEGIN
               IF NOT Test_f THEN BEGIN
                  Test_f := StrNieq(Command[i],ReadStr,strlen(Command[i]));
                  IF Test_f THEN Comm := i;
               END;
            END;
            IF NOT Test_f THEN Error(ReadStr,CommLine,1);
            ComPara(Comm,ReadStr);
            Test_f := FALSE;
         END;
      IF Anzahl = 1 THEN
         Error("Global",0,14);
      IF Smode = 0 THEN
         Error("Global",0,15);
      IF NOT Name_f THEN
         Error("Global",0,11);
      Close(Eingabe);
      Script_f := TRUE;
      Anzahl := Anzahl - 1;
      END ELSE BEGIN
         WRITELN('Could not open Scriptfile!');
         WRITELN;
         Usage;
      END;
   END;

   IF NOT Script_f THEN BEGIN
      IF (stricmp(GrMode,"h")=0) OR (stricmp(GrMode,"l")=0) THEN BEGIN
         IF (stricmp(SpMode,"f")=0) OR (stricmp(SpMode,"s")=0) THEN BEGIN
            IF stricmp(GrMode,"l")=0 THEN
               Smode:=1
            ELSE
               Smode:=2;
            IF stricmp(SpMode,"f")=0 THEN
               Fast:=1
            ELSE
               Fast:=2;
         END ELSE
            Usage;
      END ELSE
          Usage;
   END;
END;

{-------------------------------------------------------------------------}

PROCEDURE TextDef;    {Fak ist mir erst jetzt bekannt}
BEGIN
   OK.FrontPen := TRUNC(16.0/Fak);
   Cancel.FrontPen := TRUNC(16.0/Fak);
   Repair.FrontPen := TRUNC(16.0/Fak);
   Feintxt.FrontPen := TRUNC(16.0/Fak);
END;

{-------------------------------------------------------------------------}

PROCEDURE PointerDef;
BEGIN
   CrossData := AllocMem(68,MemChip);
   IF CrossData <> nil THEN BEGIN
      CrossData^ := CrossSt;
      SetPointer(bw,CrossData,15,16,-8,-7);
   END;
END;

{-------------------------------------------------------------------------}

PROCEDURE NewPicData;
BEGIN
   FOR i := 1 TO Anzahl DO BEGIN
      IF Anim_f[i] THEN BEGIN
         LadX[i] := AnisX[i]-((AnisX[i]-AnieX[i])/FLOAT(Frames))*FLOAT(PicNum);
         LadY[i] := AnisY[i]-((AnisY[i]-AnieY[i])/FLOAT(Frames))*FLOAT(PicNum);
         Lad[i] := Anis[i]-((Anis[i]-Anie[i])/FLOAT(Frames))*FLOAT(PicNum);
      END;
   END;
END;

{-------------------------------------------------------------------------}

PROCEDURE SetApkt;
BEGIN
   FOR t:=0 TO 8 DO BEGIN {t heißt eigentlich Atf, ist aber schon besetzt}
      Arbb[t]:=TRUNC(FLOAT(Minbr)*SPPow(8.0-FLOAT(t),2.0)); {2^(8-t)}
      Arbh[t]:=TRUNC(FLOAT(Minho)*SPPow(8.0-FLOAT(t),2.0));
      Arbfeld[t]:=1;
      Apktx[t]:=0;
      Apkty[t]:=0;
   END;
END;

{-------------------------------------------------------------------------}

PROCEDURE SetAtf;
BEGIN
   Atf := ModeFlag;
END;

{-------------------------------------------------------------------------}

PROCEDURE Init; {Programmstart wird vorbereitet}
BEGIN {Init}
   WRITELN;
   WRITELN('Aequipot V1.15 PAL (June 28, 1991)');
   WRITELN('Copyright © 1990/91 Juergen Matern. All rights reserved.');
   WRITELN;

   PicNum := 1;
   Frames := 1;
   Minbr:=5;
   Minho:=4;

   Parameter;

   IF Smode=1 THEN BEGIN   {LoRes-Einstellungen}
      Sbreite:=320;
      Shoehe:=Skonst;
      Wbreite:=320;
      Whoehe:=Shoehe;
      Smode:=16384;      {LoRes=16384}
      ModeFlag:=2;
      SetAtf;
   END ELSE BEGIN        {HiRes-Einstellungen}
      Sbreite:=640;
      Shoehe:=2*Skonst;
      Wbreite:=640;
      Whoehe:=Shoehe;
      Smode:=32772;      {HiRes=32768 Lace=4}
      ModeFlag:=1;
      SetAtf;
   END;

   Fak:=(3.0-FLOAT(ModeFlag));
   xs:=Minbr*(3-ModeFlag);
   ys:=Minho*(3-ModeFlag);

   SetApkt;
   TextDef;

   Quit:=FALSE;
END; {Init}

{-------------------------------------------------------------------------}

BEGIN {MAIN}
   OpenMath;
   Init;
   OpenAll;
   InitFileReq;
   PointerDef;
   Color;

   REPEAT
      IF NOT Script_f THEN BEGIN
         LadKoord;
         LadGet;
      END ELSE BEGIN
         NewPicData;
         SetApkt;
         SetAtf;
      END;

      LadMark;

      NoHide:=TRUE;
      ShowTitle(s, NoHide);

      IF Fast=1 THEN
         FastDraw(0,0,640 DIV Modeflag,(Skonst*2) DIV Modeflag,xs,ys,FALSE)
      ELSE
         Areatest;

      IF (NOT Quit) AND
       (NOT Script_f) AND
       (Fast = 1) THEN BEGIN
         Reqflag:=AutoRequest(bw,ADR(Feintxt),ADR(OK),ADR(Cancel),0,0,257,60);
         IF ReqFlag THEN BEGIN
            NoHide:=TRUE;
            ShowTitle(s, NoHide);
            Clear;
            LadMark;
            AreaTest;
            Fast := 2;
         END;
      END;

      IF (NOT Quit) AND
       (NOT Script_f) AND
       (Fast = 2) THEN BEGIN
         NoHide:=FALSE;
         ShowTitle(s, NoHide);
         REPEAT
            Reqflag:=AutoRequest(bw,ADR(Repair),ADR(OK),ADR(Cancel),0,0,225,60);
            IF ReqFlag THEN BEGIN
               SetRepArea;
               RepairArea;
            END ELSE BEGIN
               NoHide:=TRUE;
               ShowTitle(s, NoHide);
            END;
         UNTIL ReqFlag = FALSE;
      END;

      IF NOT Quit THEN BEGIN
         IF Script_f THEN BEGIN
            ShowTitle(s, FALSE);
            NameAus := StrDup(NameStore);
            IF AnGlob_f THEN BEGIN
               Dummy := IntToStr(DummyStr,PicNum);
               StrCat(NameAus,DummyStr);
               FOR i:= 0 TO strlen(NameAus) DO
                  Answerarray[i] := NameAus[i];
               Answerarray[i+1] := '\0';
            END;
            ILBMError := SaveWindowToIFF(bw,ADR(Answerarray));
            IF ILBMError <> 0 THEN BEGIN
               SimpleRequest("Couldn't save picture!");
               Quit := TRUE;
               PicNum := Frames+1;
            END;
            IF NOT AnGlob_f THEN
               PicNum := Frames+1
            ELSE
               INC(PicNum);
         END ELSE
            PicNum := Frames+1;
      END ELSE
         PicNum := Frames+1;
   UNTIL PicNum = Frames+1;

   WHILE Quit=FALSE DO BEGIN
      ModifyIDCMP(bw, MOUSEBUTTONS_f + VANILLAKEYS_f);
      m:=WaitPort(bw^.UserPort);
      m:=WaitPort(bw^.UserPort);
      IF m <> nil THEN BEGIN
         HandleMessage;
      END;
   END;

   CloseAll;
END. {MAIN}

{-------------------------------------------------------------------------}
