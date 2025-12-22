PROGRAM Images_in_Gadgets;

{ Kleiner Quickhack
    
  zeigt, wie man unter OS2.x/3.x Images in
  GadTools-Gadgets einbaut.
  
  Images sind (C) 1996 by Björn Schotte und
  dürfen weder verändert noch kopiert werden!!
  
  Mißbrauch strafbar!!
  
  Autor erreichbar unter...
  
  ... snail-mail:
  
      Björn Schotte
        Am Burkardstuhl 45
        D-97267 Himmelstadt
        
        (nur mit Rückporto!)
        
  ... EMail:
  
      bjoern@bomber.mayn.de
        
}

{
    Translated to PCQ. Just renamed some vars and
    moved the imagedatas to const.
    Removed two functions (regarding EasyReq) and used
    EasyReqArgs in pcq.lib instead. Removed the taglistarray
    for the window. Uses OpenWindowTags now.
    Compiles without any problems.
    Jun 03 1998.
    nils.sjoholm@mailbix.swipnet.se
}

{$I "Include:Exec/Libraries.i"}
{$I "Include:Intuition/Intuition.i"}
{$I "Include:Libraries/GadTools.i"}
{$I "Include:PCQUtils/Utils.i"}  { for EasyReqArgs }

const

       MSG_CANT_OPEN_GTLIB = "Can't open gadtools.library V37 or higher.";
       MSG_NO_PS = "Can't lock Public Screen";
       MSG_NO_VI = "Can't get Visual Info";
       MSG_NO_MEM = "Not enough memory free";
       MSG_NO_WP = "Can't open window";

     renderd : Chip array [1..176] of Word = (
    {* Plane 0 *}
        $0000,$0000,
        $0000,$0010,
        $0000,$0010,
        $0000,$0010,
        $01C0,$0010,
        $03E0,$0010,
        $07F0,$0010,
        $0000,$0010,
        $0000,$0810,
        $039A,$C810,
        $0000,$0810,
        $031E,$0810,
        $0000,$4810,
        $03E6,$0810,
        $0000,$0810,
        $0000,$0810,
        $07FF,$F810,
        $0000,$0010,
        $0000,$0010,
        $0000,$0010,
        $0000,$0010,
        $7FFF,$FFF0,
    {* Plane 1 *}
        $FFFF,$FFE0,
        $8000,$0000,
        $8000,$0000,
        $8000,$0000,
        $81C0,$0000,
        $83E0,$0000,
        $87F0,$0000,
        $8000,$0000,
        $87FF,$E000,
        $8465,$2000,
        $87FF,$E000,
        $84E1,$E000,
        $87FF,$A000,
        $8419,$E000,
        $87FF,$E000,
        $8400,$0000,
        $8000,$0000,
        $8000,$0000,
        $8000,$0000,
        $8000,$0000,
        $8000,$0000,
        $0000,$0000,
    {* Plane 2 *}
        $0000,$0000,
        $0000,$0020,
        $0000,$0020,
        $0000,$0020,
        $0000,$0020,
        $01C0,$0020,
        $03E0,$0020,
        $0FFF,$F820,
        $0800,$1020,
        $0800,$1020,
        $0800,$1020,
        $0800,$1020,
        $0800,$1020,
        $0800,$1020,
        $0800,$1020,
        $0BFF,$F020,
        $0800,$0020,
        $0000,$0020,
        $0000,$0020,
        $0000,$0020,
        $7FFF,$FFE0,
        $0000,$0000,

        $0000,$0000,
        $0000,$0000,
        $0000,$0000,
        $0000,$0000,
        $0000,$0000,
        $0000,$0000,
        $0000,$0000,
        $0000,$0000,
        $0000,$0000,
        $0000,$0000,
        $0000,$0000,
        $0000,$0000,
        $0000,$0000,
        $0000,$0000,
        $0000,$0000,
        $0000,$0000,
        $0000,$0000,
        $0000,$0000,
        $0000,$0000,
        $0000,$0000,
        $0000,$0000,
        $0000,$0000
    );

  renderi : Image = (0,0,28,22,4,@renderd,$ff,$0,NIL);

   selectd : Chip Array[1..176] of word = (
        { Plane 0 }
                $FFFF,$FFE0,
                $8000,$0000,
                $8000,$0000,
                $8000,$0000,
                $8000,$0000,
                $80E0,$0000,
                $81F0,$0000,
                $83F8,$0000,
                $8000,$0000,
                $8000,$0400,
                $81CD,$6400,
                $8000,$0400,
                $818F,$0400,
                $8000,$2400,
                $81F3,$0400,
                $8000,$0400,
                $8000,$0400,
                $83FF,$FC00,
                $8000,$0000,
                $8000,$0000,
                $8000,$0000,
                $0000,$0000,
        { Plane 1 }
                $0000,$0000,
                $0000,$0010,
                $0000,$0010,
                $0000,$0010,
                $0000,$0010,
                $00E0,$0010,
                $01F0,$0010,
                $03F8,$0010,
                $0000,$0010,
                $03FF,$F010,
                $0232,$9010,
                $03FF,$F010,
                $0270,$F010,
                $03FF,$D010,
                $020C,$F010,
                $03FF,$F010,
                $0200,$0010,
                $0000,$0010,
                $0000,$0010,
                $0000,$0010,
                $0000,$0010,
                $7FFF,$FFF0,
        { Plane 2 }
                $0000,$0000,
                $0000,$0020,
                $0000,$0020,
                $0000,$0020,
                $0000,$0020,
                $0000,$0020,
                $00E0,$0020,
                $01F0,$0020,
                $07FF,$FC20,
                $0400,$0820,
                $0400,$0820,
                $0400,$0820,
                $0400,$0820,
                $0400,$0820,
                $0400,$0820,
                $0400,$0820,
                $05FF,$F820,
                $0400,$0020,
                $0000,$0020,
                $0000,$0020,
                $7FFF,$FFE0,
                $0000,$0000,

        $0000,$0000,
        $0000,$0000,
        $0000,$0000,
        $0000,$0000,
        $0000,$0000,
        $0000,$0000,
        $0000,$0000,
        $0000,$0000,
        $0000,$0000,
        $0000,$0000,
        $0000,$0000,
        $0000,$0000,
        $0000,$0000,
        $0000,$0000,
        $0000,$0000,
        $0000,$0000,
        $0000,$0000,
        $0000,$0000,
        $0000,$0000,
        $0000,$0000,
        $0000,$0000,
        $0000,$0000
                     );

  selecti : Image = (0,0,28,22,4,@selectd,$ff,$0,NIL);

  ng : NewGadget = (1,1,28,22,NIL,NIL,1,0,NIL,NIL);
            
VAR
  ps            : ScreenPtr;
  vi            : Address;
  xoff, yoff,i  : Integer;
  gl,g          : GadgetPtr;
  wp            : WindowPtr;

PROCEDURE CleanUp(why : STRING; rc : Integer);
var
  i : Integer;
BEGIN
  IF wp <> NIL THEN CloseWindow(wp);
  IF gl <> NIL THEN FreeGadgets(gl);
  IF vi <> NIL THEN FreeVisualInfo(vi);
  IF GadToolsBase <> NIL THEN CloseLibrary(GadToolsBase);
  IF why <> NIL then i := EasyReqArgs("Images-Example",why,"OK");
  Exit(rc);
END;

PROCEDURE ZeroVars;
BEGIN
  ps := NIL; gl := NIL; GadToolsBase := NIL; vi := NIL;
  gl := NIL; wp := NIL;
END;

{ Clones some datas from default pubscreen for fontsensitive
  placing of gadgets. }
PROCEDURE CloneDatas;
BEGIN
  ps := LockPubScreen(NIL);
  IF ps = NIL THEN CleanUp(MSG_NO_PS,20)
  ELSE
  BEGIN
     xoff := ps^.WBorLeft;
     yoff := ps^.WBorTop + ps^.Font^.ta_YSize + 1;
     vi := GetVisualInfoA(ps,NIL);
     UnLockPubScreen(NIL, ps);
     IF vi = NIL THEN CleanUp(MSG_NO_VI, 20);
  END;
END;

PROCEDURE GenerateWindow;
BEGIN
  gl := NIL; gl := CreateContext(adr(gl));
  IF gl = NIL THEN CleanUp(MSG_NO_MEM, 20);
  
  ng.ng_VisualInfo := vi;
  ng.ng_LeftEdge := ng.ng_LeftEdge + xoff;
  ng.ng_TopEdge  := ng.ng_TopEdge + yoff;
  {
      
     Jetzt wird's spannend: Das Gadget wird als GENERIC_KIND
     kreiert und dann werden relevante Felder mit den Daten
     (Flags, Activation, GadgetType etc.) wie unter OS1.x
     gefüllt.
  }
  g := CreateGadgetA(GENERIC_KIND,gl,adr(ng),NIL);
  IF g = NIL THEN CleanUp(MSG_NO_MEM, 20);
  
  g^.GadgetType := GTYP_BOOLGADGET;
  g^.Flags := GFLG_GADGIMAGE OR GFLG_GADGHIMAGE; { 2 Images }
  g^.Activation := GACT_RELVERIFY; { Verhalten wie ein BUTTON_KIND-Gadget }
  g^.GadgetRender := @renderi;
  g^.SelectRender := @selecti;
  
  { Das war alles!! :-) }
      
  wp := OpenWindowTags(Nil, WA_Gadgets,     gl,
                            WA_Title,       "Images in Gadgets",
                            WA_Flags,       WFLG_SMART_REFRESH OR WFLG_NOCAREREFRESH OR
                                            WFLG_DEPTHGADGET OR WFLG_DRAGBAR OR WFLG_CLOSEGADGET OR
                                            WFLG_ACTIVATE,
                            WA_Idcmp,       IDCMP_GADGETUP OR IDCMP_CLOSEWINDOW,
                            WA_InnerWidth,  100,
                            WA_InnerHeight, 50,
                            TAG_DONE);
  IF wp = NIL THEN CleanUp(MSG_NO_WP, 20);
END;

PROCEDURE MainWait;
VAR
  msg   : IntuiMessagePtr;
  class : Integer;
  ende  : BOOLEAN;
  i     : Integer;
BEGIN
  ende := FALSE;
  REPEAT
    msg := IntuiMessagePtr(WaitPort(wp^.UserPort));
     msg := GT_GetIMsg(wp^.UserPort);
     WHILE msg <> NIL DO
     BEGIN
        class := msg^.Class;
        GT_ReplyIMsg(msg);
        CASE class OF
          IDCMP_CLOSEWINDOW : ende := TRUE;
          IDCMP_GADGETUP :
            { Da nur 1 Gadget vorhanden, entfällt Abfrage der GadgetID! }
             i := EasyReqArgs("Images-Example","You have klicked on the gadget!","Wheeew!");
        ELSE END;
       msg := GT_GetIMsg(wp^.UserPort);
     END;
  UNTIL ende;
END;
    
BEGIN
  ZeroVars;
  GadToolsBase := OpenLibrary("gadtools.library",37);
  IF GadToolsBase = NIL THEN CleanUp(MSG_CANT_OPEN_GTLIB, 20);
  CloneDatas;
  GenerateWindow;
  MainWait;
  CleanUp(NIL,0);
END.
