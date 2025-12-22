(*#-- BEGIN AutoRevision header, please do NOT edit!
*
* $VER: ShowIFF.mod 1.2 (29.03.98)
* Auth: T.B. <tonyiommi@geocities.com>
*
* Desc: Shows IFF gfx using the iff.library by Christian A. Weber <weber@amiga.physik.unizh.ch>
*       Handles ILBM 1..8 bit, EHB, HAM6, HAM8, XPK.
* Reqs: MC680x0 cpu, 68020 and ppc enhanced XPK packers available.
* Lang: MODULA-2
* Comp: Cyclone © by M. Timmermans
* Rmrk: You can turn EntryClear off and all optimizations on.
* ToDo: If I had the time, I could do the following:
*       1. two screen switching, window for mouse handling -> ser: mouses, overscan, scrolling
*       2. Tooltypes/Shellargs/Wildcards
*       3. 24bit IFF support: IFF24, DEEP, YUVN, RGB8, RGBN, SHAM
*       4. conversion mode with renderlib support: scaling, 24bit to HAM conversion, saving etc.
*       5. ACBM, IPBM support, to make the list of supported gfx IFF´s complete
*       But there are Multiview and the Datatypes and so I stopped this test project.
*
*-- END AutoRevision header --*)

MODULE ShowIFF;

FROM SYSTEM IMPORT ADR,LONGSET,SHORTSET;
FROM UtilityD IMPORT tagDone;
IMPORT ml: ModulaLib, arg: Arguments, io: InOut, String;
IMPORT dd: DosD, dl: DosL, gd: GraphicsD, gl: GraphicsL, id: IntuitionD, il: IntuitionL,
 rt: ReqTools, xd: XpkMasterD, xl: XpkMasterL, (*UAE,*) IFF;

TYPE StrPtr = POINTER TO Str;
 Str = ARRAY[1..108] OF CHAR;

VAR fileName:Str;
 i:INTEGER;
 
PROCEDURE ProcessILBM(VAR fileName:ARRAY OF CHAR);
 CONST MaxColours = 256; //AA necessary
  OK=0; IFFERROR=1; COLERROR=2; NOSCREEN=3; XPKFIBERROR=4; XPKEXERROR=5;  //exceptions

 VAR iff: IFF.FileHandlePtr;
  bmhd: IFF.BitMapHeaderPtr;
  cmap: ARRAY[1..MaxColours] OF CARDINAL;
  colours: INTEGER;
  viewmode: gd.ViewModeSet;
  newScreen: id.NewScreen; screen: id.ScreenPtr;
  xpkComp: BOOLEAN; xpkError: INTEGER;

 //this one has to be enhanced in order to support ser: mouses
 PROCEDURE WaitLMB;
  CONST leftButton = 6;
  VAR ciapra[0BFE001H]: SHORTSET;
 BEGIN
  WHILE leftButton IN ciapra DO dl.Delay(10) END;
  WHILE ~(leftButton IN ciapra) DO dl.Delay(10) END;
 END WaitLMB;

 PROCEDURE CheckXPK;
  //side effects: VAR xpkComp: BOOLEAN; xpkError: INTEGER; WriteString;
  VAR fib: xd.FibPtr; success: BOOLEAN;
 BEGIN fib := NIL;
  fib := xl.AllocObject(xd.objFIB,NIL);
  IF fib = NIL THEN ml.Raise(XPKFIBERROR); END;
  xpkError := xl.Examine(fib,[xd.inName,ADR(fileName),tagDone]);
  IF xpkError # xd.errOK THEN xl.FreeObject(xd.objFIB,fib); fib := NIL; ml.Raise(XPKEXERROR); END;
  IF fib^.type = xd.typePacked THEN
   xpkComp := TRUE;
   io.Write(" "); io.WriteString(fib^.packer);
   io.Write(" "); io.WriteInt(fib^.ratio,0); io.Write("%");
  ELSE xpkComp := FALSE;
  END; (* IF *)
  xl.FreeObject(xd.objFIB,fib); fib := NIL;
 END CheckXPK;

 PROCEDURE WriteIFFError(err: INTEGER);
 BEGIN
  CASE err OF
  |16:io.WriteString("File not found!");
  |17:io.WriteString("Read error!");
  |18:io.WriteString("Not enough memory!");
  |19:io.WriteString("Not an IFF file!");
  |20:io.WriteString("Write error!");
  |24:io.WriteString("IFF file is not an ILBM file!");
  |25:io.WriteString("BMHD chunk not found!");
  |26:io.WriteString("BODY chunk not found!");
  |27:io.WriteString("Too many planes!");
  |28:io.WriteString("False compression type!");
  |29:io.WriteString("ANHD chunk not found!");
  |30:io.WriteString("DLTA chunk not found!");
  ELSE io.WriteString("Unknown IFF error!");
  END; (* CASE *)
  io.WriteLn;
 END WriteIFFError;

 PROCEDURE OpenScreen;
 BEGIN screen := NIL;
  WITH newScreen DO
   leftEdge := 0; topEdge := 0; detailPen := 0; blockPen := 0; type:=id.ScreenFlagSet{};
   font := NIL; gadgets := NIL; customBitMap := NIL;
   WITH bmhd^ DO
    width:=bmhd^.pageWidth; height:=bmhd^.pageHeight; depth:=bmhd^.nPlanes;
	  //many prgs save faulty BMHDs, forgetting the Hires flag
    //calc viewmode using the pic resolution to work around this
    viewModes:=viewmode;    defaultTitle:=ADR("ShowIFF"); 
   END; (* WITH bmhd^ *)
  END; (* WITH newScreen *)
  screen := il.OpenScreen(newScreen);
  IF screen = NIL THEN ml.Raise(NOSCREEN); END;
 END OpenScreen;

 PROCEDURE CloseScreen;
 BEGIN IF screen # NIL THEN il.CloseScreen(screen); screen := NIL; END;
 END CloseScreen;

BEGIN //ProcessILBM
 iff := NIL; bmhd := NIL;
 TRY
  iff := IFF.OpenIFF(ADR(fileName),IFF.modeRead); IF iff = NIL THEN ml.Raise(IFFERROR); END;
  bmhd := IFF.GetBMHD(iff); IF bmhd = NIL THEN ml.Raise(IFFERROR); END;
  colours := IFF.GetColorTab(iff,ADR(cmap));
  IF colours = 0  THEN ml.Raise(IFFERROR); END;
  IF colours > MaxColours THEN ml.Raise(COLERROR); END;
  viewmode := IFF.GetViewModes(iff);  //if no CAMG found, iff_lib calculates the vmode using the BMHD

  IF ~ml.wbStarted THEN //verbose
   io.WriteString(fileName); io.Write(" ");
   io.WriteInt(bmhd^.w,0); io.Write("*"); io.WriteInt(bmhd^.h,0); io.Write("*"); io.WriteInt(bmhd^.nPlanes,0);
   IF gd.superHires IN viewmode THEN io.WriteString(" SUPERHIRES");
   ELSIF gd.hires IN viewmode THEN io.WriteString(" HIRES");
   END; (* IF *)
   IF gd.lace IN viewmode THEN io.WriteString(" LACE"); END;
   IF gd.ham IN viewmode THEN io.WriteString(" HAM"); END;
   IF gd.extraHalfbrite IN viewmode THEN io.WriteString(" EHB"); END;
   CheckXPK;
   IF ~xpkComp & (bmhd^.compression = 0) THEN io.WriteString(" noComp"); END;
   IF bmhd^.compression = IFF.cmpFibDelta THEN io.WriteString(" FibDelta")
   ELSIF bmhd^.compression = IFF.cmpByteRun1 THEN io.WriteString(" CBR1")
   END; (* IF *)
  END; (* IF ~ml.wbStarted *)
  
  OpenScreen;
  gl.LoadRGB4(ADR(screen^.viewPort),ADR(cmap),colours);
  IF ~IFF.DecodePic(iff,screen^.rastPort.bitMap) THEN ml.Raise(IFFERROR); END;
  WaitLMB;
  CloseScreen;
 
 FINALLY
  CASE ml.ExceptNr OF
  |OK:(* no exception *)
  |IFFERROR:WriteIFFError(IFF.Error());
  |COLERROR:io.WriteString("Colourtable overflow.");
  |NOSCREEN:io.WriteString("Couldn´t open screen!");
  |XPKFIBERROR:io.WriteString("Couldn´t alloc XPK FIB!");
  |XPKEXERROR:IGNORE xl.PrintFault(xpkError,NIL);
  ELSE ml.Raise(ml.ExceptNr);
  END; (* CASE *)
  IF ~ml.wbStarted THEN io.WriteLn; END;
  CloseScreen;
  IF iff # NIL THEN IFF.Close(iff); iff := NIL END;
 END; (* FINALLY *)
END ProcessILBM;

PROCEDURE FileReq; (* ReqTools *)
 VAR fileReq: rt.FileRequesterPtr; fList: rt.FileListPtr; titleStrPtr: StrPtr;
  path,fileName: Str;
BEGIN fileReq := NIL; fList := NIL;
 ml.Assert(dl.GetCurrentDirName(ADR(path),SIZE(Str)), ADR("Couldn´t get current dirname!"));
 fileName :="";
 io.WriteLine("ShowIFF © T.B. <tonyiommi@geocities.com> written in MODULA-2");
 fileReq := rt.AllocRequestA(rt.TypeFileReq,NIL);
 titleStrPtr := ADR("ShowIFF error"); //not enough address registers
 IF fileReq = NIL THEN rt.vEZRequest(ADR("Couldn´t open file requester!"),NIL,NIL,[rt.ezReqTitle,titleStrPtr,tagDone],NIL); ml.Exit(dd.fail); END;
 fileReq^.flags := LONGSET{rt.fReqMultiSelect,rt.fReqNoBuffer};
 rt.ChangeReqAttrA(fileReq,[rt.fiDir,ADR(path),tagDone]);
 fList := rt.FileRequest(fileReq,ADR(fileName),ADR("Select ILBM files"),NIL);
 IF fileReq # NIL THEN

  String.Copy(path,StrPtr(fileReq^.dir)^);

  WHILE fList # NIL DO
   IF String.Length(path)>0 THEN
     String.Copy(fileName,path);
     String.Concat(fileName,"/");
     String.Concat(fileName,StrPtr(fList^.name)^);
   ELSE
     String.Copy(fileName,StrPtr(fList^.name)^);
   END; (* IF *)

   ProcessILBM(fileName);

   fList := fList^.next;
  END; (* WHILE fList # NIL *)
  rt.FreeRequest(fileReq); fileReq := NIL;
 ELSE rt.vEZRequest(ADR("Not enough memory for\nfile requester!"),ADR("Oh boy!"),NIL,[rt.ezReqTitle,titleStrPtr,tagDone],NIL);
 END; (* IF fileReq # NIL *)
END FileReq;

BEGIN
(*
 IF UAE.IsRunning() THEN
  io.WriteLine("This prg is registered to all AMIGAs.\nIf you are not running an AMIGA, you have to pay a Shareware fee of 10 Euros to the author.");
  ml.Exit(dd.fail);
 END; (* IF UAE *)
*)
 IF (arg.NumArgs()=0) & (~ml.wbStarted) THEN
  arg.GetArg(0,fileName); String.Copy(fileName,StrPtr(dl.FilePart(ADR(fileName)))^); String.Upper(fileName);
  io.WriteString(fileName); io.WriteLine(" © T.B. <tonyiommi@geocities.com> written in MODULA-2");
  ml.Exit(dd.fail);

 ELSIF arg.NumArgs() # 0 THEN //Arguments handles Shell & WB args !
  FOR i:=1 TO arg.NumArgs() DO
   arg.GetArg(i,fileName);  //expand wildcards !?
   IF String.Compare(fileName,"?")=0 THEN
    arg.GetArg(0,fileName); String.Copy(fileName,StrPtr(dl.FilePart(ADR(fileName)))^); String.Upper(fileName);
    io.WriteString("usage: "); io.WriteString(fileName); io.WriteString(" <filename> ...\n");
    ml.Exit(dd.fail);
   END; (* IF *)
   ProcessILBM(fileName);
  END; (* FOR i:=1 TO arg.NumArgs() *)

 ELSE FileReq;  //wbStarted, no args
 END; (* IF *)
END ShowIFF.
