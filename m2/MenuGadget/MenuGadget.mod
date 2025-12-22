IMPLEMENTATION MODULE MenuGadget;

   (* MenuGadget.mod - Quellcode der Prozeduren.
    * Version  : 1.01 (29.01.93)
    * Compiler : M2Amiga V4.107d
    * Aufruf   : m2c -zyne+@
    * Copyright: © 1993 by Fin Schuppenhauer
    * Dieses Programm ist SHAREWARE. Wenn es Dir gefällt und Du es
    * häufiger benutzt (bzw. die hier zur Verfügung gestellten Prozeduren
    * in eigene Programme einbaust), dann sende bitte eine kleine
    * Entschädigung (mindestens eine Postkarte) an die folgende Adresse:
    *
    *       Fin Schuppenhauer
    *       Braußpark 10
    *       2000 Hamburg 26
    *
    * Für Kritik, Fehlerberichte und Verbesserungsvorschläge danke ich
    * im vorraus.
    *
    * Zu diesem Programm gehören folgende Dateien:
    *
    *    ° MenuGadget.def
    *    ° MenuGadget.mod     (diese Datei)
    *    ° MenuGadget.sym
    *    ° MenuGadget.obj
    *    ° MenuGadget.readme
    *    ° MenuGadgetDemo.mod
    *    ° MenuGadgetDemo
    *
    * Diese Dateien liegen entweder in dieser Form oder gepackt als
    * MenuGadget.lzh-File vor.
    *
    * SIE DÜRFEN NICHT VERÄNDERT WERDEN (wenn nicht anderes erklärt wird)
    * UND NUR KOMPLETT ÜBER ELEKTRONISCHEN WEGE ODER AUF PUBLIC DOMAIN
    * DISK WEITERGEGEBEN WERDEN. IN BEIDEN FÄLLEN DARF DIE UNKOSTENPAU-
    * SCHALE NICHT DM 5.- ÜBERSCHREITEN.
    * FÜR DIE FUNKTIONSFÄHIGKEIT DER PROGRAMME SOWIE MÖGLICHE SCHÄDEN
    * BEI DEREN BENUTZUNG WIRD KEINE GARANTIE ÜBERNOMMEN.
    *)

IMPORT   id:IntuitionD, il:IntuitionL,
         gd:GadToolsD,  gl:GadToolsL,
         grd:GraphicsD, grl:GraphicsL,
         ed:ExecD,      el:ExecL,
         ud:UtilityD;
FROM Heap         IMPORT Allocate;
FROM IntuitionD   IMPORT WaTags, IDCMPFlags;
FROM String       IMPORT Length;
FROM SYSTEM       IMPORT ADR,ADDRESS,TAG,ASSEMBLE,CAST,BITSET;


PROCEDURE CreateGRBorder(width, height : INTEGER) : id.BorderPtr;
VAR   borders  : ARRAY [1..3] OF id.BorderPtr;
      koords   : ARRAY [1..3] OF POINTER TO ARRAY [1..8] OF INTEGER;
      b        : SHORTINT;
BEGIN
   (* Using Allocate() from the modul, i don't have to take care of
    * clearing the memory at the end of a program. The modul does
    * this for me.
    *)
   FOR b := 1 TO 3 DO
      Allocate (borders[b], SIZE(id.Border));
      Allocate (koords[b], 2*6);
   END;
   (* Koordinaten für die helle Seite: *)
   koords[1]^[1] := 0;       koords[1]^[2] := height-2;
   koords[1]^[3] := 0;       koords[1]^[4] := 0;
   koords[1]^[5] := width;   koords[1]^[6] := 0;
   (* Koordinaten für die dunkle Seite: *)
   koords[2]^[1] := width;   koords[2]^[2] := 1;
   koords[2]^[3] := width;   koords[2]^[4] := height-1;
   koords[2]^[5] := 0;       koords[2]^[6] := height-1;
   (* Koordinaten für das Dreieck: *)
   koords[3]^[1] := 3;       koords[3]^[2] := 2;
   koords[3]^[3] := width-3; koords[3]^[4] := 2;
   koords[3]^[5] := (width DIV 2);   koords[3]^[6] := height-3;
   koords[3]^[7] := 2;       koords[3]^[8] := 2;
   WITH borders[1]^ DO
      (* Helle Seite *)
      leftEdge    := 0;
      topEdge     := 0;
      frontPen    := 2;
      backPen     := 0;
      drawMode    := grd.jam1;
      count       := 3;
      xy          := koords[1];
      nextBorder  := borders[2];
   END;
   WITH borders[2]^ DO
      (* Dunkle Seite *)
      leftEdge    := 0;
      topEdge     := 0;
      frontPen    := 1;
      backPen     := 0;
      drawMode    := grd.jam1;
      count       := 3;
      xy          := koords[2];
      nextBorder  := borders[3];
   END;
   WITH borders[3]^ DO
      (* Dreieck *)
      leftEdge    := 0;
      topEdge     := 0;
      frontPen    := 1;
      backPen     := 0;
      drawMode    := grd.jam1;
      count       := 4;
      xy          := koords[3];
      nextBorder  := NIL;
   END;
   RETURN borders[1];
END CreateGRBorder;

PROCEDURE CreateSRBorder(width, height : INTEGER) : id.BorderPtr;
VAR   borders  : ARRAY [1..3] OF id.BorderPtr;
      koords   : ARRAY [1..3] OF POINTER TO ARRAY [1..8] OF INTEGER;
      b        : SHORTINT;
BEGIN
   FOR b := 1 TO 3 DO
      Allocate (borders[b], SIZE(id.Border));
      Allocate (koords[b], 2*6);
   END;
   (* Koordinaten für die helle Seite: *)
   koords[1]^[1] := 0;       koords[1]^[2] := height-2;
   koords[1]^[3] := 0;       koords[1]^[4] := 0;
   koords[1]^[5] := width;   koords[1]^[6] := 0;
   (* Koordinaten für die dunkle Seite: *)
   koords[2]^[1] := width;   koords[2]^[2] := 1;
   koords[2]^[3] := width;   koords[2]^[4] := height-1;
   koords[2]^[5] := 0;       koords[2]^[6] := height-1;
   (* Koordinaten für das Dreieck: *)
   koords[3]^[1] := 3;       koords[3]^[2] := 2;
   koords[3]^[3] := width-3; koords[3]^[4] := 2;
   koords[3]^[5] := (width DIV 2);   koords[3]^[6] := height-3;
   koords[3]^[7] := 2;       koords[3]^[8] := 2;
   WITH borders[1]^ DO
      (* Helle Seite *)
      leftEdge    := 0;
      topEdge     := 0;
      frontPen    := 1;
      backPen     := 0;
      drawMode    := grd.jam1;
      count       := 3;
      xy          := koords[1];
      nextBorder  := borders[2];
   END;
   WITH borders[2]^ DO
      (* Dunkle Seite *)
      leftEdge    := 0;
      topEdge     := 0;
      frontPen    := 2;
      backPen     := 0;
      drawMode    := grd.jam1;
      count       := 3;
      xy          := koords[2];
      nextBorder  := borders[3];
   END;
   WITH borders[3]^ DO
      (* Dreieck *)
      leftEdge    := 0;
      topEdge     := 0;
      frontPen    := 1;
      backPen     := 0;
      drawMode    := grd.jam1;
      count       := 4;
      xy          := koords[3];
      nextBorder  := NIL;
   END;
   RETURN borders[1];
END CreateSRBorder;

PROCEDURE SetMenuGadget (kind : LONGCARD; VAR previous : id.Gadget;
          VAR ng : gd.NewGadget; taglist  : ud.TagItemPtr) : id.GadgetPtr;
VAR   gad   : id.GadgetPtr;
BEGIN
   gad := gl.CreateGadgetA(gd.genericKind,previous,ng,taglist);
   IF gad # NIL THEN
      (* Ok. Gadget konnte erzeugt werden. Jetzt nehmen wir noch die
       * eigenen Änderungen vor:
       *)
      WITH gad^ DO
         flags       := id.GadgetFlagSet{id.gadgHImage};
         activation  := id.ActivationFlagSet{id.relVerify};
         gadgetRender:= CreateGRBorder(width, height);
         selectRender:= CreateSRBorder(width, height);
      END;
   END;
   RETURN gad;
END SetMenuGadget;


PROCEDURE HandleMenuGadget (mg : id.GadgetPtr; win : id.WindowPtr) : LONGINT;
CONST ITEM_OUTOFBOUNDS = -42;    (* äquiv. mit ITEM_NOSELECTION *)
TYPE  StrPtrArray = POINTER TO ARRAY [0..31] OF StrPtr;
VAR   menuwin  : id.WindowPtr;   (* Dies Wird unser Menü sein.          *)
      winWidth,
      winHeight: INTEGER;        (* Breite und Höhe des Menü-Fensters.  *)
      winLeft,
      winTop   : INTEGER;        (* Linke obere Ecke des Menü-Fensters  *)
      rp       : grd.RastPortPtr;(* ...des Menü-Fensters f. Zeichenoper.*)
      ySize    : INTEGER;        (* Höhe des verwendeten Zeichensatzes  *)

      entry    : StrPtrArray;    (* Zgr. auf Array m. Adr. d. Zeichenk. *)
      entries  : INTEGER;        (* Anzahl der Menüeinträge.            *)
      maxwidth : INTEGER;        (* Breite des längsten Eintrags in Pix.*)
      tl       : INTEGER;        (* Hilfsvariable                       *)

      activeItem : INTEGER;      (* Hervorgehobenes Item                *)
      item       : INTEGER;      (* Akt. Item und Rückgabewert          *)
      outOfBounds:BOOLEAN;       (* Mauszgr. innerhalb des Fensters?    *)

      msg      : id.IntuiMessagePtr;   (* Zgr. auf IntuiMessage         *)

      y        : INTEGER;        (* Diverse Hilfsvariablen...           *)
      ende     : BOOLEAN;
      tagBuffer : ARRAY [0..24] OF LONGINT;

   PROCEDURE Item (y : INTEGER) : INTEGER;
   VAR   item  : INTEGER;
   BEGIN
      IF (y<=1) OR (y>=winHeight-3) THEN
         RETURN ITEM_OUTOFBOUNDS;
      ELSE
         RETURN y DIV (ySize+1);
      END;
   END Item;
   PROCEDURE ComplementItem (item : INTEGER);
   BEGIN
      grl.SetDrMd (rp, grd.DrawModeSet{grd.complement});
      grl.RectFill (rp, 3, item*(ySize+1)+1, winWidth-3, (item+1)*(ySize+1));
   END ComplementItem;

BEGIN
   entries := 0;
   maxwidth:= 0;
   ySize := win^.iFont^.ySize;
   entry := mg^.userData;        (* Hier steht das Array mit den Adressen
                                  * der Zeichenketten der Einträge. *)
   (* Anzahl der Einträge und maximale Länge eines Eintrages ermitteln: *)
   WHILE entry^[entries] # NIL DO
      tl := grl.TextLength(win^.rPort, entry^[entries], Length(entry^[entries]^));
      IF tl > maxwidth THEN maxwidth := tl; END;
      INC (entries);
   END;
   winWidth := maxwidth+6;
   winHeight:= (entries+1)*ySize+2;
   winLeft  := mg^.leftEdge + win^.leftEdge;
   winTop   := mg^.topEdge  + win^.topEdge;
   IF id.gimmeZeroZero IN win^.flags THEN
      INC (winLeft, win^.borderLeft);
      INC (winTop, win^.borderTop);
   END;

   (* Jetzt das rahmenlose Fenster öffnen, welches dem Anwender ein Menü
    * vorgaukelt: *)
   menuwin := il.OpenWindowTagList(NIL,TAG(tagBuffer,
      waLeft,           winLeft,
      waTop,            winTop,
      waInnerHeight,    winHeight,
      waInnerWidth,     winWidth,
      waAutoAdjust,     TRUE,
      waGimmeZeroZero,  TRUE,
      waBorderless,     TRUE,
      waActivate,       TRUE,
      waReportMouse,    TRUE,
      waPubScreen,      win^.wScreen,
      waIDCMP,          id.IDCMPFlagSet{mouseMove,mouseButtons,inactiveWindow},
      ud.tagEnd));
   IF menuwin=NIL THEN RETURN ITEM_CREATIONERR; END;

   (* Fenster geöffnet. Jetzt das Menü aufbauen: *)
   rp := menuwin^.rPort;
   grl.SetRast (rp,1);
   grl.SetAPen (rp, 2);
   grl.Move (rp, 0, 0);
   grl.Draw (rp, winWidth-1, 0);
   grl.Draw (rp, winWidth-1, winHeight-1);
   grl.Draw (rp, 0, winHeight-1);
   grl.Draw (rp, 0, 0);
   grl.SetBPen (rp,1);
   grl.SetAPen (rp,0);
   FOR y := 0 TO entries DO
      grl.Move (rp, 3, y*(ySize+1)+ySize);
      grl.Text (rp, entry^[y], Length(entry^[y]^));
   END;

   (* IDCMP-LOOP *)
   activeItem := 0;
   ComplementItem (activeItem);
   outOfBounds := FALSE;
   ende := FALSE;
   WHILE NOT(ende) DO
      el.WaitPort(menuwin^.userPort);

      msg := gl.GTGetIMsg(menuwin^.userPort);
      WHILE msg#NIL DO
         IF mouseMove IN msg^.class THEN
            IF ((msg^.mouseX > 0) AND (msg^.mouseX < winWidth)) AND
               ((msg^.mouseY > 0) AND (msg^.mouseY < winHeight-2)) THEN
               (* nur, wenn wir uns innerhalb des Fensters befinden, wird
                * dieser Teil ausgeführt. *)
               item := Item(msg^.mouseY);
               IF item#activeItem THEN
                  (* Nur, wenn sich der Mauszeiger über einem neuen Item
                   * befindet, deaktivieren wir das alte und aktivieren das
                   * neue item. *)
                  IF NOT(outOfBounds) THEN
                     (* Ausnahme: Wir deaktivieren das alte Item nicht,
                      * wenn wir von außerhalb des Fensters wieder herein-
                      * kommen. Das alte Item ist dann schon deaktiviert.
                      *)
                     ComplementItem (activeItem);
                  END;
                  outOfBounds := FALSE;
                  activeItem := item;
                  ComplementItem (activeItem);
               ELSE
                  (* Wenn der Mauszeiger immer noch über dem gleichen Item
                   * steht, passiert nichts. *)
                  IF outOfBounds THEN
                     (* Ausnahme: Wir kommen von außerhalb des Fensters
                      * wieder rein. Dann war dieses Item deaktiviert und
                      * wir müssen es jetzt wieder aktivieren. *)
                     ComplementItem (activeItem);
                     outOfBounds := FALSE;
                  END;
               END;
            ELSE
               (* Außerhalb des Fensters, nix passiert. *)
               IF NOT(outOfBounds) THEN
                  (* Ausnahme: Wir waren gerade zuvor noch innerhalb des
                   * Fensters, also deaktivieren wir das aktive Item. *)
                  ComplementItem (activeItem);
                  outOfBounds := TRUE;
               END;
            END;
         ELSIF mouseButtons IN msg^.class THEN
            ende := TRUE;
         ELSIF inactiveWindow IN msg^.class THEN
            item := ITEM_NOSELECTION;
            ende := TRUE;
         END;

         gl.GTReplyIMsg (msg);
         msg := gl.GTGetIMsg(menuwin^.userPort);
      END;
   END;

   il.CloseWindow (menuwin);
   RETURN item;
END HandleMenuGadget;


BEGIN
END MenuGadget.
