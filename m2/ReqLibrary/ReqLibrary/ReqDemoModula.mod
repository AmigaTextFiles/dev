MODULE ReqDemoModula;

IMPORT ReqD,
       ReqL,
       ReqSupport,
       DosD,
       Arts,
       SYSTEM,
       I:IntuitionD,
       IL: IntuitionL,
       E:ExecD,
       EL: ExecL,
       G:GraphicsD,
       GL:GraphicsL,
       tm:TaskMemory;

VAR freq,fontreq: ReqD.ReqFileRequester;
    gadblocks: ARRAY[0..8] OF ReqD.GadgetBlock;
    dirstring : ReqD.DirString;
    filestring: ReqD.FileString;
    wholefile : ReqD.PathString;
    wholefilePtr : ReqD.PathStringPtr;
    ScP: I.ScreenPtr;
    oldWinP,WinP    : I.WindowPtr;
    IMessPtr: I.IntuiMessagePtr;
    gadgetPtr: I.GadgetPtr;
    myproc : DosD.ProcessPtr;
    gadgetnum : INTEGER;
    x,y: LONGINT;

TYPE gadstringType = ARRAY[0..8],[0..33] OF CHAR;

VAR gadstrings: gadstringType;


PROCEDURE OpenAll();
   VAR NSc  : I.NewScreen;
       Nw   : I.NewWindow;

   BEGIN
      NSc.leftEdge     := 0;    NSc.topEdge      := 0;
      NSc.width        := GL.graphicsBase^.normalDisplayColumns;
      NSc.height       := GL.graphicsBase^.normalDisplayRows;
      NSc.depth        := 3;    NSc.detailPen    := 0;
      NSc.blockPen     := 1;    NSc.viewModes    :=G.ViewModeSet{G.hires};
      NSc.type         := I.customScreen;
      NSc.defaultTitle := SYSTEM.ADR("Show off requester library.");
      NSc.font         := NIL;
      NSc.gadgets      := NIL;  NSc.customBitMap := NIL;
      ScP := IL.OpenScreen(NSc); Arts.Assert(ScP#NIL,SYSTEM.ADR("Couldn't open screen!"));

      Nw.leftEdge      := 0;    Nw.topEdge       := 0;
      Nw.width         := NSc.width; Nw.height := NSc.height;
      Nw.detailPen     := -1;    Nw.blockPen      := -1;
      Nw.idcmpFlags    := I.IDCMPFlagSet{I.gadgetUp};
      Nw.flags         := I.WindowFlagSet{I.activate,I.backDrop,I.borderless};
      Nw.firstGadget   := NIL;  Nw.checkMark     := NIL;
      Nw.screen        := ScP;  Nw.bitMap        := NIL;
      Nw.minWidth      := 128;  Nw.minHeight     := 24;
      Nw.maxWidth      := -1;   Nw.maxHeight     := -1;
      Nw.title         := NIL;  Nw.type          := I.customScreen;

      FOR gadgetnum:=0 TO 8 DO
         x := Nw.leftEdge + 20 + (gadgetnum MOD 2) * (Nw.width DIV 2);
         y := (Nw.height-4*20) DIV 2 + (gadgetnum DIV 2) * 20;
         ReqL.LinkGadget(SYSTEM.ADR(gadblocks[gadgetnum]),SYSTEM.ADR(gadstrings[gadgetnum]),Nw, x, y);
         gadblocks[gadgetnum].gadget.gadgetID := gadgetnum;
      END; (* FOR *)
      gadgetPtr := SYSTEM.ADR(gadblocks[8].gadget);
      gadgetPtr^.topEdge  := 20;
      gadgetPtr^.leftEdge := (Nw.width-gadgetPtr^.width) DIV 2;
      WinP := IL.OpenWindow(Nw);
      Arts.Assert(WinP#NIL,SYSTEM.ADR("Couldn't open window!"));
   END OpenAll;


PROCEDURE ShowFileReq;

   BEGIN
      freq.versionNumber:=ReqL.reqVersion;
      freq.dir   := SYSTEM.ADR(dirstring);
      freq.file  := SYSTEM.ADR(filestring);
      freq.pathName := wholefilePtr;
      freq.flags := ReqD.UmmFlagSet{ReqD.infogadget};
      freq.dirnamescolor := 2;
      freq.devicenamescolor := 2;
      freq.show := "*";

      IF ReqL.FileRequest(SYSTEM.ADR(freq))
         THEN
            ReqSupport.SimpleRequest("You selected the file '%s'.",SYSTEM.ADR(wholefilePtr));
         ELSE
            ReqSupport.SimpleRequest("You didn't select a file.",NIL);
      END; (* IF *)
   END ShowFileReq;


PROCEDURE ShowColorReq;

   BEGIN
      IF (ReqL.ColorRequester(1) # 0)
         THEN
      END; (* IF *)
   END ShowColorReq;


PROCEDURE ShowSimpleText;

   BEGIN
      ReqSupport.SimpleRequest("     SimpleRequest()  is  a  tiny bit of\n glue  code  which  passes  a single text\n string " +
                               " (with  optional  printf()  style\n formatting) to the TextRequest() routine\n in  the  library. " +
                               "The  SimpleRequest()\n routine  can be  easily modified to fit\n your own peculiar purposes.",NIL);
   END ShowSimpleText;


PROCEDURE ShowTwoGadText;

   TYPE yesnoType = ARRAY[0..1],[0..3] OF CHAR;

   VAR yesno : yesnoType;
       result : INTEGER;
       yesnoPtr : POINTER TO ARRAY[0..3] OF CHAR;

   BEGIN
      yesno[0]:="no";
      yesno[1]:="yes";
      result := ReqSupport.TwoGadRequest("Just testing the two gadget requester.",NIL);
      yesnoPtr := SYSTEM.ADR(yesno[result]);
      ReqSupport.SimpleRequest("You responded with a '%s' to this requester.",SYSTEM.ADR(yesnoPtr));
   END ShowTwoGadText;


PROCEDURE ShowThreeGadText;

   TYPE responseType = ARRAY[0..2],[0..65] OF CHAR;

   VAR response : responseType;
       myTextStruct : ReqD.TRStructure;
       result : INTEGER;

   BEGIN
      response[0]:="You really should use it.";
      response[1]:="Excellent choice. You have good taste.";
      response[2]:="Oh come on, make up your mind.\nYou won't regret choosing 'yes'.";

      myTextStruct.text := SYSTEM.ADR("     Would you use the requester library\nin your programs?");
      myTextStruct.controls := NIL;
      myTextStruct.window := NIL;
      myTextStruct.middleText := SYSTEM.ADR("Perhaps...");
      myTextStruct.positiveText := SYSTEM.ADR("Oh yeah, for sure!");
      myTextStruct.negativeText := SYSTEM.ADR("Methinks not.");
      myTextStruct.title := SYSTEM.ADR("Show off text requester.");
      myTextStruct.keyMask := {0..15};
      myTextStruct.textcolor := 0;
      myTextStruct.detailcolor := 0;
      myTextStruct.blockcolor := 0;
      myTextStruct.versionnumber := ReqL.reqVersion;
      myTextStruct.rfu1 := 0;
      result := ReqL.TextRequest(SYSTEM.ADR(myTextStruct));
      ReqSupport.SimpleRequest(response[result],NIL);
   END ShowThreeGadText;


PROCEDURE ShowFontReq;

   TYPE restype = RECORD
                     fname : ReqD.FileStringPtr;
                     size  : LONGINT;
                     style : LONGINT;
                  END; (* RECORD *)

   VAR fontname : ReqD.FileString;
       dirname  : ReqD.DirString;
       result   : restype;

   BEGIN
      dirname := "fonts:";
      fontname := "";
      fontreq.versionNumber:=ReqL.reqVersion;
      fontreq.dir  := SYSTEM.ADR(dirname);
      fontreq.file := SYSTEM.ADR(fontname);
      fontreq.fontnamescolor := 2;
      fontreq.flags := ReqD.UmmFlagSet{ReqD.getfonts};
      IF ReqL.FileRequest(SYSTEM.ADR(fontreq))
         THEN
            result.fname := fontreq.file;
            result.size  := fontreq.fontYSize;
            result.style := fontreq.fontStyle;
            ReqSupport.SimpleRequest("You selected the font '%s',\nsize %ld, type %ld.",SYSTEM.ADR(result));
         ELSE
            ReqSupport.SimpleRequest("You didn't select a font.",NIL);
      END; (* IF *)
END ShowFontReq;


PROCEDURE ShowGetString;

   CONST textlength = 74;

   VAR mybuffer : ARRAY[0..textlength] OF CHAR;
       mybufferPtr: POINTER TO ARRAY[0..textlength] OF CHAR;

   BEGIN
      mybufferPtr:=SYSTEM.ADR(mybuffer);
      mybuffer := "The default text.";
      IF ReqL.GetString(mybufferPtr,SYSTEM.ADR("Type anything, then hit return."),NIL,50,textlength)
         THEN
            ReqSupport.SimpleRequest("I'll bet you typed:\n%s",SYSTEM.ADR(mybufferPtr));
         ELSE
            ReqSupport.SimpleRequest("You didn't enter anything!",NIL);
      END; (* IF *)
   END ShowGetString;


PROCEDURE ShowGetLong;

   VAR mygetlongstruct : ReqD.GetLongStruct;

   BEGIN
      mygetlongstruct.titlebar := SYSTEM.ADR("Enter a number.");
      mygetlongstruct.defaultval := 1234;
      mygetlongstruct.minlimit := MIN(LONGINT);
      mygetlongstruct.maxlimit := MAX(LONGINT);
      mygetlongstruct.window := NIL;
      mygetlongstruct.versionnumber := ReqL.reqVersion;
      mygetlongstruct.flags := SYSTEM.LONGSET{};
      mygetlongstruct.rfu2 := 0;

      IF ReqL.GetLong(SYSTEM.ADR(mygetlongstruct))
         THEN
            ReqSupport.SimpleRequest("You entered the number '%ld'.",SYSTEM.ADR(mygetlongstruct.result));
         ELSE
            ReqSupport.SimpleRequest("You didn't enter a number.",NIL);
      END; (* IF *)
   END ShowGetLong;


BEGIN
   wholefilePtr:=SYSTEM.ADR(wholefile);

   gadstrings[0]:="Show the file requester.";
   gadstrings[1]:="Show the color requester.";
   gadstrings[2]:="Show a simple text requester.";
   gadstrings[3]:="Show a two gadget requester.";
   gadstrings[4]:="Show a three gadget requester.";
   gadstrings[5]:="Show the font requester.";
   gadstrings[6]:="Show the 'get text' requester.";
   gadstrings[7]:="Show the 'get number' requester.";
   gadstrings[8]:="Exit the demo.";

   OpenAll;
   myproc := SYSTEM.CAST(DosD.ProcessPtr,EL.FindTask(NIL));
   oldWinP := myproc^.windowPtr;
   myproc^.windowPtr := WinP;

   LOOP
      EL.WaitPort(WinP^.userPort);
      IMessPtr := EL.GetMsg(WinP^.userPort);
      WHILE (IMessPtr # NIL) DO
         gadgetPtr := IMessPtr^.iAddress;
         gadgetnum := gadgetPtr^.gadgetID;

         CASE gadgetnum OF
            |0: ShowFileReq;
            |1: ShowColorReq;
            |2: ShowSimpleText;
            |3: ShowTwoGadText;
            |4: ShowThreeGadText;
            |5: ShowFontReq;
            |6: ShowGetString;
            |7: ShowGetLong;
            |8: EXIT;
            ELSE
         END; (* CASE *)
         EL.ReplyMsg(IMessPtr);
      END; (* WHILE *)
   END; (* LOOP *)

CLOSE
   IF (myproc^.windowPtr # NIL)
      THEN
         myproc^.windowPtr := oldWinP;
   END; (* IF *)

   IF (WinP # NIL)
      THEN
         IL.CloseWindow(WinP);
   END; (* IF *)

   IF (ScP # NIL)
      THEN
         IL.CloseScreen(ScP);
   END; (* IF *)

END ReqDemoModula.
