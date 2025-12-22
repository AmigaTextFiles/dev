MODULE MenuGadgetDemo;

   (* MenuGadgetDemo.mod - Erzeugt mehrere MenuGadget und demonstriert deren
    *                      Verwendung.
    * Version  : 1.01 (29.01.93)
    * Compiler : M2Amiga V4.107d
    * Aurfuf   : m2c -zyne+@ MenuGadgetDemo
    *            m2l -cdr MenuGadgetDemo
    * Copyright: © 1993 by Fin Schuppenhauer
    *
    * Dieses Programm demonstriert die Verwendung der Prozeduren für
    * die Erzeugung und Handhabung der MenuGadgets.
    * Dieses Programm darf durchaus verändert werden, jedoch darf eine
    * veränderte Version nicht durch das Orginal ausgetauscht und so
    * weiter vertrieben werden.
    *
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
    *    ° MenuGadget.def     (diese Datei)
    *    ° MenuGadget.mod
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
    *
    * Soft- und Hardware-Voraussetzungen:
    *
    *    ° Amiga xxxx mit mindst. OS2.04
    *    ° Modula-2 Compiler M2Amiga mindst. V4.0
    *
    * Bekannte Fehler:
    *    - keine
    *)

IMPORT   id:IntuitionD, il:IntuitionL,
         gd:GadToolsD,  gl:GadToolsL,
         ed:ExecD,      el:ExecL,
         ud:UtilityD;
FROM IntuitionD   IMPORT WaTags, IDCMPFlags;
FROM GadToolsD    IMPORT GtTags;
FROM SYSTEM       IMPORT ADR,ADDRESS,TAG;
FROM MenuGadget   IMPORT SetMenuGadget, HandleMenuGadget, MENUGADGET_KIND,
                         StrPtr;

CONST (* Definition der Gadget-IDs *)
      MG_SYSTEM = 1;
      MG_OS     = 2;
      TG_SYSTEM = 3;
      SG_OS     = 4;

TYPE  GadgetTypes = (mgSystem, mgOS, tgSystem, sgOS);
      SystemListT = ARRAY [0..9] OF StrPtr;
      OSListT     = ARRAY [0..8] OF StrPtr;

VAR   pubScreen   : id.ScreenPtr;
      window      : id.WindowPtr;
      gadgets     : ARRAY GadgetTypes OF id.GadgetPtr;
      newgadgets  : ARRAY GadgetTypes OF gd.NewGadget;
      tagBuffer   : ARRAY [0..49] OF LONGINT;
      glist       :=id.GadgetPtr{NIL};
      gad         : id.GadgetPtr;
      vi          : ADDRESS;
      SystemList  :=SystemListT{
                     ADR("Amiga 500"),
                     ADR("Amiga 500+"),
                     ADR("Amiga 600"),
                     ADR("Amiga 1000"),
                     ADR("Amiga 1200"),
                     ADR("Amiga 2000"),
                     ADR("Amiga 2500"),
                     ADR("Amiga 3000"),
                     ADR("Amiga 4000"),
                     NIL};
      OSList      :=OSListT{
                     ADR("OS 1.2"),
                     ADR("OS 1.3"),
                     ADR("OS 2.04"),
                     ADR("OS 2.1"),
                     ADR("OS 3.0"),
                     ADR("Unix"),
                     ADR("MS-DOS"),
                     ADR("other"),
                     NIL};
      dummy       : ADDRESS;     (* Weil: Ausdruck zu komplex. Zu wenig...*)

   PROCEDURE HandleIDCMP;
   VAR   item     : LONGINT;
         ende     : BOOLEAN;
         msg      : id.IntuiMessagePtr;
         msgGad   : id.GadgetPtr;
   BEGIN
      ende := FALSE;
      WHILE NOT(ende) DO
         el.WaitPort (window^.userPort);

         msg := gl.GTGetIMsg(window^.userPort);
         WHILE msg#NIL DO
            IF closeWindow IN msg^.class THEN
               ende := TRUE;
            ELSIF gadgetUp IN msg^.class THEN
               msgGad := msg^.iAddress;
               CASE msgGad^.gadgetID OF
                  MG_SYSTEM :
                     item := HandleMenuGadget (gadgets[mgSystem], window);
                     IF item >= 0 THEN
                        dummy := SystemList[item];
                        gl.GTSetGadgetAttrsA (gadgets[tgSystem], window,
                           NIL, TAG(tagBuffer,
                           gttxText,      dummy,
                           ud.tagEnd));
                     END;
                | MG_OS :
                     item := HandleMenuGadget (gadgets[mgOS], window);
                     IF item >= 0 THEN
                        dummy := OSList[item];
                        gl.GTSetGadgetAttrsA (gadgets[sgOS], window,
                           NIL, TAG(tagBuffer,
                           gtstString,    dummy,
                           ud.tagEnd));
                     END;
                | SG_OS :
                  ELSE
               END;
            END;
            gl.GTReplyIMsg (msg);
            msg := gl.GTGetIMsg(window^.userPort);
         END;
      END;
   END HandleIDCMP;

BEGIN
   (* Unser Fenster soll auf dem Default-Public-Screen erscheinen; wir
    * besorgen uns einen Lock auf diesen, um der Applikation, die den
    * Screen erzeugt hat mitzuteilen, daß wir ein Fenster hierauf ge-
    * öffnet haben (bzw. noch werden).
    *)
   pubScreen := il.LockPubScreen(NIL);
   IF pubScreen # NIL THEN
      (* Für die Benutzung der Routinen der gadTool.libraray benötigen
       * wir einen Zeiger auf die VisualInfo-rmationen des Screens:
       *)
      vi := gl.GetVisualInfoA(pubScreen,TAG(tagBuffer,ud.tagEnd));
      IF vi # NIL THEN
         (* Außerdem brauchen wir für die Gadgets noch zusätzlichen
          * Platz, in dem das Betriebssystem Daten zum Handling mit den
          * GadTools-Gadget ablegen kann:
          *)
         gad := gl.CreateContext(glist);
         IF gad # NIL THEN
            (* Ok. Jetzt können wir unseres Gadgets definieren und das
             * Fenster öffnen:
             *)
            WITH newgadgets[tgSystem] DO
               leftEdge    := 20;
               topEdge     := 20;
               width       := 300;
               height      := 12;
               gadgetText  := ADR("System");
               textAttr    := pubScreen^.font;
               gadgetID    := TG_SYSTEM;
               flags       := gd.NewGadgetFlagSet{gd.placetextAbove};
               visualInfo  := vi;
               userData    := NIL;
            END;
            WITH newgadgets[sgOS] DO
               leftEdge    := 20;
               topEdge     := 50;
               width       := 300;
               height      := 12;
               gadgetText  := ADR("Operating System");
               textAttr    := pubScreen^.font;
               gadgetID    := SG_OS;
               flags       := gd.NewGadgetFlagSet{gd.placetextAbove};
               visualInfo  := vi;
               userData    := NIL;
            END;
            WITH newgadgets[mgSystem] DO
               width       := 13;
               height      := 12;
               leftEdge    := 320;
               topEdge     := 20;
               gadgetText  := NIL;
               textAttr    := pubScreen^.font;
               gadgetID    := MG_SYSTEM;
               flags       := gd.NewGadgetFlagSet{};
               visualInfo  := vi;
               userData    := ADR(SystemList);
            END;
            WITH newgadgets[mgOS] DO
               width       := 13;
               height      := 12;
               leftEdge    := 320;
               topEdge     := 50;
               gadgetText  := NIL;
               textAttr    := pubScreen^.font;
               gadgetID    := MG_OS;
               flags       := gd.NewGadgetFlagSet{};
               visualInfo  := vi;
               userData    := ADR(OSList);
            END;
            gadgets[tgSystem] := gl.CreateGadgetA(gd.textKind, gad^,
                  newgadgets[tgSystem], TAG(tagBuffer,
                  gttxText,   ADR("Select your system -->"),
                  gttxBorder, TRUE,
                  ud.tagEnd));
            IF gadgets[tgSystem]#NIL THEN
               gadgets[sgOS] := gl.CreateGadgetA(gd.stringKind,
                     gadgets[tgSystem]^, newgadgets[sgOS], TAG(tagBuffer,
                     gtstString, ADR("Type in your OS or select one -->"),
                     gtstMaxChars, 60,
                     ud.tagEnd));
               IF gadgets[sgOS]#NIL THEN
                  gadgets[mgSystem] := SetMenuGadget(MENUGADGET_KIND,
                        gadgets[sgOS]^, newgadgets[mgSystem], TAG(tagBuffer,
                        ud.tagEnd));
                  gadgets[mgOS] := SetMenuGadget(MENUGADGET_KIND,
                        gadgets[mgSystem]^, newgadgets[mgOS], TAG(tagBuffer,
                        ud.tagEnd));

                  window := il.OpenWindowTagList(NIL,TAG(tagBuffer,
                        waTitle,       ADR("MenuGadgetDemo"),
                        waWidth,       400,
                        waHeight,      80,
                        waLeft,        0,
                        waTop,         170,
                        waGadgets,     glist,
                        waCloseGadget, TRUE,
                        waDragBar,     TRUE,
                        waActivate,    TRUE,
                        waGimmeZeroZero,TRUE,
                        waPubScreen,   pubScreen,
                        waIDCMP,       id.IDCMPFlagSet{closeWindow}+gd.buttonIDCMP,
                        ud.tagEnd));
                  IF window # NIL THEN
                     (* Ok. Alles konnte erfolgreich initialisiert werden.
                      * Jetzt können wir unser Programm starten:
                      *)
                      gl.GTRefreshWindow (window, NIL);

                      HandleIDCMP;

                  END;
                  il.CloseWindow(window);
               END;
            END;
         END;
         gl.FreeGadgets(glist);
         gl.FreeVisualInfo(vi);
      END;
      il.UnlockPubScreen(NIL,pubScreen);
   END;
END MenuGadgetDemo.
