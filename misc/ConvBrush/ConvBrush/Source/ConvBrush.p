program ConvBrush;

{ ConvBrush v1.1 © 1991-94 David Kinder
  Converts an IFF brush to various source file formats
  Written in PCQ Pascal v1.2b }

{$I-}
{$I "Include:Exec/Libraries.i"}
{$I "Include:Exec/Memory.i"}
{$I "Include:Intuition/Intuition.i"}
{$I "Include:Utils/Parameters.i"}
{$I "Include:Utils/StringLib.i"}
{$I "ConvBrush.i"}

type
    WordPtr = ^short;

const
    arpdata : short = GADGHCOMP+SELECTED;
    oldid : short = 3;
    StdInName : String = "CON:0/0/1/1//AUTO";
    StdOutName : String = StdInName;
    ConvTitle : String = "ConvBrush v1.1";
    OS2 : boolean = false;

var
    abort,title : boolean;
    planes,comp : byte;
    code,height,txtoff : short;
    class,bsize,index,width,bwidth : integer;
    ArpBase,AslBase,GfxBase : LibraryPtr;
    sourcef,destf,backf,labelf,iff,asfile,asdir,adfile,addir : string;
    brush : file of char;
    dest : text;
    mem,mem2 : ^byte;
    w : WindowPtr;
    myfont,boldfont : TextAttrPtr;
    msg : IntuiMessagePtr;
    strgadg : array [1..3] of GadgetPtr;
    modegadg : array [1..2] of GadgetPtr;
    arpgadg : GadgetPtr;
    abttxt : array [1..9] of IntuiTextPtr;
    errtxt : array [1..4] of IntuiTextPtr;
    wtext : array [1..4] of IntuiTextPtr;
{$SX}
    Logo,GadgA,GadgB,Logo_2,GadgA_2,GadgB_2 : ImagePtr;
    AbsExecBase : LibraryPtr;
{$SN}

function OpenMyWindow : boolean;

const
    strpts1 : array [0..9] of short = (0,11,0,0,182,0,1,0,1,10);
    strpts2 : array [0..9] of short = (183,0,183,11,1,11,182,11,182,1);
    strpts3 : array [0..9] of short = (0,11,0,0,95,0,1,0,1,10);
    strpts4 : array [0..9] of short = (96,0,96,11,1,11,95,11,95,1);

    actpts1 : array [0..9] of short = (0,12,0,0,283,0,1,0,1,11);
    actpts2 : array [0..9] of short = (284,0,284,12,1,12,283,12,283,1);

    arppts1 : array [0..9] of short = (0,11,0,0,76,0,1,0,1,10);
    arppts2 : array [0..9] of short = (77,0,77,11,1,11,76,11,76,1);

var
    nw : NewWindowPtr;
    actgadg : array [1..2] of GadgetPtr;
    strptr : array [1..3] of StringInfoPtr;
    strbord : array [1..4] of BorderPtr;
    actbord : array [1..2] of BorderPtr;
    arpbord : array [1..2] of BorderPtr;
    acttext : IntuiTextPtr;
    arptext : IntuiTextPtr;
    wbscr : ScreenPtr;
    tgadg : GadgetPtr;

begin
    new(myfont);
    with myfont^ do begin
	ta_Name := "topaz.font";
	ta_YSize := 8;
	ta_Style := FS_NORMAL;
    end;
    new(boldfont);
    with boldfont^ do begin
	ta_Name := "topaz.font";
	ta_YSize := 8;
	ta_Style := FSF_BOLD;
    end;

    new(modegadg[2]);
    with modegadg[2]^ do begin
	LeftEdge := 160;
	TopEdge := 73;
	Width := 137;
	Height := 12;
	Flags := GADGHCOMP+GADGIMAGE;
	Activation := GADGIMMEDIATE;
	GadgetType := BOOLGADGET;
	if OS2 = false then GadgetRender := GadgB else
            GadgetRender := GadgB_2;
	GadgetID := 4;
    end;

    new(modegadg[1]);
    with modegadg[1]^ do begin
	NextGadget := modegadg[2];
	LeftEdge := 12;
	TopEdge := 73;
	Width := 137;
	Height := 12;
	Flags := GADGHCOMP+GADGIMAGE+SELECTED;
	Activation := GADGIMMEDIATE;
	GadgetType := BOOLGADGET;
	if OS2 = false then GadgetRender := GadgA else
	    GadgetRender := GadgA_2;
	GadgetID := 3;
    end;

    new(actbord[2]);
    with actbord[2]^ do begin
	if OS2 = false then FrontPen := 2 else FrontPen := 1;
	Count := 5;
	XY := @actpts2;
    end;
    new(actbord[1]);
    with actbord[1]^ do begin
	if OS2 = false then FrontPen := 1 else FrontPen := 2;
	Count := 5;
	XY := @actpts1;
	NextBorder := actbord[2];
    end;
    new(acttext);
    with acttext^ do begin
	if OS2 = false then FrontPen := 1 else FrontPen := 2;
	LeftEdge := 122;
	TopEdge := 3;
	ITextFont := myfont;
	IText := "About";
    end;
    new(actgadg[2]);
    with actgadg[2]^ do begin
	NextGadget := modegadg[1];
	LeftEdge := 12;
	TopEdge := 127;
	Width := 285;
	Height := 13;
	Flags := GADGHCOMP;
	Activation := RELVERIFY;
	GadgetType := BOOLGADGET;
	GadgetRender := actbord[1];
	GadgetText := acttext;
	GadgetID := 7;
    end;
    new(actgadg[1]);
    with actgadg[1]^ do begin
	NextGadget := actgadg[2];
	LeftEdge := 12;
	TopEdge := 91;
	Width := 285;
	Height := 30;
	Flags := GADGHCOMP+GADGIMAGE;
	Activation := RELVERIFY;
	GadgetType := BOOLGADGET;
	if OS2 = false then GadgetRender := Logo else
	    GadgetRender := Logo_2;
	GadgetID := 6;
    end;

    new(arpbord[2]);
    with arpbord[2]^ do begin
	if OS2 = false then FrontPen := 2 else FrontPen := 1;
	Count := 5;
	XY := @arppts2;
    end;
    new(arpbord[1]);
    with arpbord[1]^ do begin
	if OS2 = false then FrontPen := 1 else FrontPen := 2;
	Count := 5;
	XY := @arppts1;
	NextBorder := arpbord[2];
    end;
    new(arptext);
    with arptext^ do begin
	if OS2 = false then FrontPen := 1 else FrontPen := 2;
	LeftEdge := 11;
	TopEdge := 2;
	ITextFont := myfont;
	IText := "FileReq";
    end;
    new(arpgadg);
    with arpgadg^ do begin
	NextGadget := actgadg[1];
	LeftEdge := 219;
	TopEdge := 44;
	if arpdata = GADGHCOMP+SELECTED then begin
	    Width := 78;
	    Height := 12;
	end
	else begin
	    Width := 76;
	    Height := 11;
	end;
	Flags := arpdata;
	Activation := RELVERIFY+TOGGLESELECT;
	GadgetType := BOOLGADGET;
	GadgetRender := arpbord[1];
	GadgetText := arptext;
	GadgetID := 9;
    end;

    new(strbord[4]);
    with strbord[4]^ do begin
	LeftEdge := -4;
	TopEdge := -2;
	if OS2 = false then FrontPen := 2 else FrontPen := 1;
	Count := 5;
	XY := @strpts4;
    end;
    new(strbord[3]);
    with strbord[3]^ do begin
	LeftEdge := -4;
	TopEdge := -2;
	if OS2 = false then FrontPen := 1 else FrontPen := 2;
	Count := 5;
	XY := @strpts3;
	NextBorder := strbord[4];
    end;
    new(strbord[2]);
    with strbord[2]^ do begin
	LeftEdge := -4;
	TopEdge := -2;
	if OS2 = false then FrontPen := 2 else FrontPen := 1;
	Count := 5;
	XY := @strpts2;
    end;
    new(strbord[1]);
    with strbord[1]^ do begin
	LeftEdge := -4;
	TopEdge := -2;
	if OS2 = false then FrontPen := 1 else FrontPen := 2;
	Count := 5;
	XY := @strpts1;
	NextBorder := strbord[2];
    end;
    new(strptr[3]);
    with strptr[3]^ do begin
	Buffer := labelf;
	UndoBuffer := backf;
	MaxChars := 11;
    end;
    new(strgadg[3]);
    with strgadg[3]^ do begin
	NextGadget := arpgadg;
	LeftEdge := 117;
	TopEdge := 46;
	Width := 88;
	Height := 8;
	Flags := GADGHCOMP;
	Activation := RELVERIFY;
	GadgetType := STRGADGET;
	GadgetRender := strbord[3];
	SpecialInfo := strptr[3];
	GadgetID := 8;
    end;
    new(strptr[2]);
    with strptr[2]^ do begin
	Buffer := destf;
	UndoBuffer := backf;
	MaxChars := 80;
    end;
    new(strgadg[2]);
    with strgadg[2]^ do begin
	NextGadget := strgadg[3];
	LeftEdge := 117;
	TopEdge := 31;
	Width := 176;
	Height := 8;
	Flags := GADGHCOMP;
	Activation := RELVERIFY;
	GadgetType := STRGADGET;
	GadgetRender := strbord[1];
	SpecialInfo := strptr[2];
	GadgetID := 2;
    end;
    new(strptr[1]);
    with strptr[1]^ do begin
	Buffer := sourcef;
	UndoBuffer := backf;
	MaxChars := 80;
    end;
    new(strgadg[1]);
    with strgadg[1]^ do begin
	NextGadget := strgadg[2];
	LeftEdge := 117;
	TopEdge := 16;
	Width := 176;
	Height := 8;
	Flags := GADGHCOMP;
	Activation := RELVERIFY;
	GadgetType := STRGADGET;
	GadgetRender := strbord[1];
	SpecialInfo := strptr[1];
	GadgetID := 1;
    end;

    new(nw);
    with nw^ do begin
	LeftEdge := 120;
	TopEdge := 20;
	Width := 308;
	Height := 143;
	BlockPen := 1;
	IDCMPFlags := GADGETUP_f+GADGETDOWN_f+CLOSEWINDOW_f+ACTIVEWINDOW_f
	+REFRESHWINDOW_f;
	Flags := SMART_REFRESH+ACTIVATE+WINDOWDEPTH+WINDOWCLOSE+WINDOWDRAG
	+RMBTRAP;
	FirstGadget := strgadg[1];
	Title := ConvTitle;
	WType := WBENCHSCREEN_f;
    end;

    new(wbscr);
    if wbscr <> nil then begin
	if GetScreenData(wbscr,SizeOf(Screen),WBENCHSCREEN_f,nil) then begin
	    txtoff := (wbscr^.Font^.ta_YSize)-8;
	    nw^.Height := nw^.Height+txtoff+(wbscr^.WBorBottom);
	    tgadg := nw^.FirstGadget;
	    repeat
		tgadg^.TopEdge := tgadg^.TopEdge+txtoff;
		tgadg := tgadg^.NextGadget;
	    until tgadg = nil;
	end;
	dispose(wbscr);
    end;

    w := OpenWindow(NewWindowPtr(nw));
    if w = nil then begin
	nw^.TopEdge := 0;
	w := OpenWindow(NewWindowPtr(nw));
    end;
    dispose(nw);
    OpenMyWindow := w <> nil;
end;

procedure SetUp;
{ Do some setup routines that are needed after the window has opened. }

begin
    new(abttxt[9]);
    with abttxt[9]^ do begin
	LeftEdge := 7;
	TopEdge := 3;
	if OS2 = false then ITextFont := myfont;
	IText := "Continue";
    end;
    new(abttxt[8]);
    with abttxt[8]^ do begin
	FrontPen := 2;
	LeftEdge := 12;
	TopEdge := 71;
	ITextFont := myfont;
	IText := "information.";
    end;
    new(abttxt[7]);
    with abttxt[7]^ do begin
	FrontPen := 2;
	LeftEdge := 12;
	TopEdge := 62;
	ITextFont := myfont;
	IText := "See documentation for more";
	NextText := abttxt[8];
    end;
    new(abttxt[6]);
    with abttxt[6]^ do begin
	FrontPen := 2;
	LeftEdge := 12;
	TopEdge := 53;
	ITextFont := myfont;
	IText := "Intuition Image structure.";
	NextText := abttxt[7];
    end;
    new(abttxt[5]);
    with abttxt[5]^ do begin
	FrontPen := 2;
	LeftEdge := 12;
	TopEdge := 44;
	ITextFont := myfont;
	IText := "convert an IFF brush to an";
	NextText := abttxt[6];
    end;
    new(abttxt[4]);
    with abttxt[4]^ do begin
	FrontPen := 2;
	LeftEdge := 12;
	TopEdge := 35;
	ITextFont := myfont;
	IText := "ConvBrush - A utility to";
	NextText := abttxt[5];
    end;
    new(abttxt[3]);
    with abttxt[3]^ do begin
	LeftEdge := 12;
	TopEdge := 23;
	ITextFont := myfont;
	IText := "Written in PCQ Pascal";
	NextText := abttxt[4];
    end;
    new(abttxt[2]);
    with abttxt[2]^ do begin
	FrontPen := 2;
	LeftEdge := 12;
	TopEdge := 14;
	ITextFont := myfont;
	IText := "© 1991-94 David Kinder";
	NextText := abttxt[3];
    end;
    new(abttxt[1]);
    with abttxt[1]^ do begin
	FrontPen := 3;
	LeftEdge := 12;
	TopEdge := 5;
	ITextFont := boldfont;
	IText := "ConvBrush v1.1";
	NextText := abttxt[2];
    end;

    new(errtxt[4]);
    with errtxt[4]^ do begin
	LeftEdge := 7;
	TopEdge := 3;
	if OS2 = false then ITextFont := myfont;
	IText := "No";
    end;
    new(errtxt[3]);
    with errtxt[3]^ do begin
	LeftEdge := 7;
	TopEdge := 3;
	if OS2 = false then ITextFont := myfont;
	IText := "Yes";
    end;
    new(errtxt[2]);
    with errtxt[2]^ do begin
	LeftEdge := 7;
	TopEdge := 3;
	if OS2 = false then ITextFont := myfont;
	IText := "Abort";
    end;
    new(errtxt[1]);
    with errtxt[1]^ do begin
	LeftEdge := 12;
	TopEdge := 5;
	if OS2 = false then ITextFont := myfont;
    end;

    new(wtext[4]);
    with wtext[4]^ do begin
	FrontPen := 1;
	LeftEdge := 90;
	TopEdge := 46;
	ITextFont := myfont;
	IText := "Output format";
    end;
    new(wtext[3]);
    with wtext[3]^ do begin
	FrontPen := 1;
	TopEdge := 30;
	ITextFont := myfont;
	IText := "Image Label";
	NextText := wtext[4];
    end;
    new(wtext[2]);
    with wtext[2]^ do begin
	FrontPen := 1;
	TopEdge := 15;
	ITextFont := myfont;
	IText := "Destination";
	NextText := wtext[3];
    end;
    new(wtext[1]);
    with wtext[1]^ do begin
	FrontPen := 1;
	ITextFont := myfont;
	IText := "Source file";
	NextText := wtext[2];
    end;
    PrintIText(w^.RPort,wtext[1],12,16+txtoff);
    SetWindowTitles(w,ConvTitle,"ConvBrush v1.1 © 1991-94 David Kinder");
    if ActivateGadget(strgadg[3],w,nil) then;
end;

procedure StringOn(which : integer);
{ Wait for an IDCMP 'ActiveWindow' message then turn on required string
  gadget. }

var
    abort : boolean;
    class : integer;

begin
    abort := false;
    repeat
	msg := IntuiMessagePtr(WaitPort(w^.UserPort));
	repeat
	    msg := IntuiMessagePtr(GetMsg(w^.UserPort));
	    if msg <> nil then begin
		class := msg^.Class;
		ReplyMsg(MessagePtr(msg));
		if class = ACTIVEWINDOW_f then begin
		    abort := true;
		    if ActivateGadget(strgadg[which],w,nil) then;
		end;
	    end;
	until msg = nil;
    until abort = true;
end;

procedure TackOn(base,fname : string);
{ Tack a filename onto a base path. }

var
    last : char;

begin
    if strlen(base) > 0 then begin
	last := base[strlen(base)-1];
	if (last <> ':') and (last <> '/') then strcat(base,"/");
    end;
    strcat(base,fname);
end;

procedure UseFileReq(ahail,ffile,afile,adir : string; strno : integer;
		     savef : boolean);
{ Display a file requester. }

const
    reqtag : array [0..16] of integer =
	(ASLFR_TitleText,0,ASLFR_InitialDrawer,0,ASLFR_InitialFile,0,
	 ASLFR_Flags1,0,ASLFR_InitialPattern,0,ASLFR_Window,0,
	 ASLFR_SleepWindow,-1,ASLFR_RejectIcons,-1,TAG_DONE);

var
    arpreq : ArpFileReqPtr;
    aslreq : FileRequesterPtr;

begin
    if arpgadg^.Flags = GADGHCOMP+SELECTED then begin
	if AslBase = nil then begin
	    new(arpreq);
	    with arpreq^ do begin
		fr_Hail := ahail;
		fr_File := afile;
		fr_Dir := adir;
	    end;
	    if FileRequest(arpreq) <> nil then begin
		strcpy(ffile,adir);
		TackOn(ffile,afile);
		_RefreshGList(strgadg[strno],w,nil,1);
	    end;
	    dispose(arpreq);
	end else begin
	    reqtag[1] := integer(ahail);
	    reqtag[3] := integer(adir);
	    reqtag[5] := integer(afile);
	    if savef = true then reqtag[7] := FILF_SAVE else reqtag[7] := 0;
	    reqtag[9] := integer("~(#?.info)");
	    reqtag[11] := integer(w);
	    aslreq := AllocFileRequest;
	    if aslreq <> nil then begin
		if AslRequest(aslreq,@reqtag) <> nil then begin
		    strcpy(adir,aslreq^.fr_Drawer);
		    strcpy(afile,aslreq^.fr_File);
		    strcpy(ffile,adir);
		    TackOn(ffile,afile);
		    _RefreshGList(strgadg[strno],w,nil,1);
		end;
		FreeFileRequest(aslreq);
	    end;
	end;
    end;
end;

function TestBrush(id : string) : boolean;
{ Consider current IFF chunk name. }

var
    i : integer;

begin
    for i := 0 to 3 do read(brush,iff[i]);
    TestBrush := streq(iff,id);
end;

function ReadInt : integer;
{ Read in a 4-byte integer and evaluate. }

var
    i : integer;
    x : array [0..3] of char;

begin
    for i := 0 to 3 do read(brush,x[i]);
    i := (byte(x[0])*16777216)+(byte(x[1])*65536)+(byte(x[2])*256)
    +(byte(x[3]));
    if odd(i) then i := i+1;
    ReadInt := i;
end;

function ReadInt2 : integer;

var
    i : integer;
    x : array [0..3] of char;

begin
    for i := 0 to 3 do read(brush,x[i]);
    i := (byte(x[0])*16777216)+(byte(x[1])*65536)+(byte(x[2])*256)
    +(byte(x[3]));
    ReadInt2 := i;
end;

function ReadShort : short;
{ Read in a 2-byte short integer. }

var
    i,j : char;

begin
    read(brush,i);
    read(brush,j);
    ReadShort := (byte(i)*256)+byte(j)
end;

function ReadByte : byte;
{ Read in a byte. }

var
    i : char;

begin
    read(brush,i);
    ReadByte := byte(i);
end;

function ReadByte2 : byte;

var
    i : char;

begin
    read(brush,i);
    index := index+1;
    ReadByte2 := byte(i);
end;

function ExamBrush : boolean;
{ Is this a true IFF brush? }

var
    i : integer;

begin
    if TestBrush("FORM") = false then begin
	errtxt[1]^.IText := "Source is not an IFF file";
	if AutoRequest(w,errtxt[1],nil,errtxt[2],0,0,250,50) then;
	StringOn(1);
	ExamBrush := false;
    end
    else begin
	for i := 0 to 3 do read(brush,iff[i]);
	if TestBrush("ILBM") = false then begin
	    errtxt[1]^.IText := "Source IFF is not of ILBM format";
	    if AutoRequest(w,errtxt[1],nil,errtxt[2],0,0,305,50) then;
	    StringOn(1);
	    ExamBrush := false;
	end
	else begin
	    if TestBrush("BMHD") = false then begin
		errtxt[1]^.IText := "Cannot find source IFF BMHD chunk";
		if AutoRequest(w,errtxt[1],nil,errtxt[2],0,0,310,50) then;
		StringOn(1);
		ExamBrush := false;
	    end
	    else ExamBrush := true;
	end;
    end;
end;

function OpenBrush : boolean;
{ Open our IFF brush and check its integrity. }

begin
    UseFileReq("Select source file",sourcef,asfile,asdir,1,false);
    if reopen(sourcef,brush) then OpenBrush := true
    else begin
	errtxt[1]^.IText := "Could not open source file";
	if AutoRequest(w,errtxt[1],nil,errtxt[2],0,0,255,50) then;
	StringOn(1);
	OpenBrush := false;
    end;
end;

procedure ReadBMHD;
{ Analyse bitmap header of brush. }

var
    bsize,i : integer;
    x : char;

begin
    bsize := ReadInt;
    bwidth := integer(ReadShort);
    width := trunc(ceil(float(bwidth)/16.0))*2;
    height := ReadShort;
    for i := 1 to 4 do read(brush,x);
    planes := ReadByte;
    read(brush,x);
    comp := ReadByte;
    for i := 1 to bsize-11 do begin
	read(brush,x);
	if eof(brush) then i := bsize-11;
    end;
end;

function FindBODY : boolean;
{ Search IFF FORM for BODY chunk; ignore any other chunks found. }

var
    abort : boolean;
    i,length : integer;
    x : char;

begin
    abort := false;
    repeat
	for i := 0 to 3 do read(brush,iff[i]);
	if (isupper(iff[1]) = false) or streq(iff,"BODY") or eof(brush)
	then abort := true
	else begin
	    length := ReadInt;
	    for i := 1 to length do begin
		read(brush,x);
		if eof(brush) then i := length;
	    end;
	end;
    until abort = true;
    if streq(iff,"BODY") then FindBODY := true
    else begin
	errtxt[1]^.IText := "Cannot find source IFF BODY chunk";
	if AutoRequest(w,errtxt[1],nil,errtxt[2],0,0,310,50) then;
	StringOn(1);
	FindBODY := false;
    end;
end;

procedure GetByte0(loop : byte);
{ No compression subroutine }

var
    i : byte;

begin
    for i := 1 to loop do begin
	mem2^ := ReadByte2;
	inc(mem2);
    end;
end;

procedure GetByte1(loop : byte);
{ ByteRun1 compression subroutine }

var
    i,j : byte;

begin
    j := ReadByte2;
    for i := 1 to loop do begin
	mem2^ := j;
	inc(mem2);
    end;
end;

procedure Decode;
{ Analyse BODY; has ByteRun1 compression been used? }

var
    source : byte;
    i : integer;

begin
    index := 0;
    if comp = 0 then begin
	for i := 1 to bsize do begin
	    mem2^ := ReadByte2;
	    inc(mem2);
	end;
    end
    else begin
	bsize := bsize-1;
	repeat
	    source := ReadByte2;
	    case source of
		0..127	 : GetByte0(source+1);
		129..255 : GetByte1(257-source);
	    end;
	until index > bsize;
    end;
end;

procedure ReadBODY;
{ Read in BODY, ie. brush data. }

begin
    bsize := ReadInt2;
    mem := AllocMem(width*height*planes,MEMF_CLEAR);
    if mem = nil then begin
	errtxt[1]^.IText := "Not enough memory to load source file";
	if AutoRequest(w,errtxt[1],nil,errtxt[2],0,0,345,50) then;
	StringOn(1);
    end
    else begin
	mem2 := mem;
	Decode;
    end;
end;

function OpenDest : boolean;
{ Open destination source file. }

begin
    UseFileReq("Select destination file",destf,adfile,addir,2,true);
    if reopen(destf,dest) then begin
	close(dest);
	errtxt[1]^.IText := "Destination file exists. Overwrite?";
	if AutoRequest(w,errtxt[1],errtxt[3],errtxt[4],0,0,325,50) then
	begin
	    if open(destf,dest) then OpenDest := true
	    else begin
		StringOn(2);
		OpenDest := false;
	    end;
	end
	else begin
	    StringOn(2);
	    OpenDest := false;
	end;
    end
    else begin
	if open(destf,dest) then OpenDest := true
	else begin
	    errtxt[1]^.IText := "Could not open destination file";
	    if AutoRequest(w,errtxt[1],nil,errtxt[2],0,0,295,50) then;
	    StringOn(2);
	    OpenDest := false;
	end;
    end;
end;

function Pick : integer;
{ Calculate PlanePick [See RKM Ch.8] }

var
    i,ppick : integer;

begin
    ppick := 1;
    for i := 1 to planes do ppick := 2*ppick;
    Pick := ppick-1;
end;

procedure DataWord(lead : string);
{ Calculate and output actual data value for assembler code. }

var
    actdat : integer;

begin
    actdat := WordPtr(mem2)^;
    if actdat < 0 then actdat := actdat+65536;
    case actdat of
	0..9	   : write(dest,lead,"0000",actdat);
	10..99	   : write(dest,lead,"000",actdat);
	100..999   : write(dest,lead,"00",actdat);
	1000..9999 : write(dest,lead,"0",actdat);
	else write(dest,lead,actdat);
    end;
end;

procedure Assem;
{ Output assembler format image data. }

var
    i,j,k,l,n : integer;
    m : boolean;

begin
    write(dest,labelf,"\t");
    if strlen(labelf) < 8 then write(dest,"\t");
    writeln(dest,"dc.w\t0,0,",bwidth,",",height,",",planes);
    writeln(dest,"\t\tdc.l\t",labelf,"dat");
    writeln(dest,"\t\tdc.b\t",Pick,",0");
    writeln(dest,"\t\tdc.l\t0");
    write(dest,labelf,"dat\t");
    if strlen(labelf) < 5 then write(dest,"\t");
    write(dest,"dc.w");
    k := height*width;
    m := false;
    for l := 0 to planes-1 do begin
	j := 0;
	i := 0;
	mem2 := mem;
	inc(mem2,l*width);
	repeat
	    for n := 1 to (width shr 1) do begin
		if j <> 0 then DataWord(",")
		else begin
		    if m = true then DataWord("\n\t\tdc.w\t")
		    else begin
			DataWord("\t");
			m := true;
		    end;
		end;
		j := j+1;
		if j = 8 then j := 0;
		inc(mem2,2);
		i := i+2;
	    end;
	inc(mem2,(planes-1)*width);
	until i = k;
    end;
end;

function Hex(decimal : integer) : char;
{ Convert decimal to hex character. }

begin
    case decimal of
	0  : Hex := '0';
	1  : Hex := '1';
	2  : Hex := '2';
	3  : Hex := '3';
	4  : Hex := '4';
	5  : Hex := '5';
	6  : Hex := '6';
	7  : Hex := '7';
	8  : Hex := '8';
	9  : Hex := '9';
	10 : Hex := 'A';
	11 : Hex := 'B';
	12 : Hex := 'C';
	13 : Hex := 'D';
	14 : Hex := 'E';
	15 : Hex := 'F';
    end;
end;

procedure HexWord(lead : string);
{ Calculate and output actual data value for C code. }

var
    act : integer;

begin
    act := WordPtr(mem2)^;
    if act < 0 then act := act+65536;
    write(dest,lead,"0x",Hex((act shr 12) and 15),Hex((act shr 8) and 15),
	Hex((act shr 4) and 15),Hex(act and 15));
end;

procedure OutC;
{ Output C format image data. }

var
    i,j,k,l,n : integer;
    m : boolean;

begin
    writeln(dest,"USHORT ",labelf,"Data[] =\n{");
    k := height*width;
    m := false;
    for l := 0 to planes-1 do begin
	j := 0;
	i := 0;
	mem2 := mem;
	inc(mem2,l*width);
	repeat
	    for n := 1 to (width shr 1) do begin
		if j <> 0 then HexWord(", ")
		else begin
		    if m = true then HexWord(",\n   ")
		    else begin
			HexWord("   ");
			m := true;
		    end;
		end;
		j := j+1;
		if j = 8 then j := 0;
		inc(mem2,2);
		i := i+2;
	    end;
	inc(mem2,(planes-1)*width);
	until i = k;
    end;
    writeln(dest,"\n};\n\nstruct Image ",labelf," =");
    writeln(dest,"{\n   0, 0,");
    writeln(dest,"   ",bwidth,", ",height,", ",planes,",");
    writeln(dest,"   ",labelf,"Data,");
    writeln(dest,"   ",Pick,", 0,");
    writeln(dest,"   NULL\n};");
end;

procedure DoProcess;
{ Start of 'Process brush' code. }

begin
    if OpenBrush then begin
	if ExamBrush then begin
	    ReadBMHD;
	    if FindBODY then begin
		ReadBODY;
		if OpenDest then begin
		    case oldid of
			3 : Assem;
			4 : OutC;
		    end;
		    SetWindowTitles(w,ConvTitle,
			"IFF file successfully converted.");
		    title := true;
		    close(dest);
		end;
		if mem <> nil then FreeMem(mem,width*height*planes);
	    end;
	end;
	close(brush);
    end;
end;

procedure NoLabel;
{ No data label defined thus we cannot proceed! }

begin
    errtxt[1]^.IText := "No Image Label defined";
    if AutoRequest(w,errtxt[1],nil,errtxt[2],0,0,225,50) then;
    StringOn(3);
end;

procedure ExamTitle;
{ If the screen bar info was changed, then put it back. }

begin
    if title = true then begin
	SetWindowTitles(w,ConvTitle,"ConvBrush v1.1 © 1991-94 David Kinder");
	title := false;
    end;
end;

procedure Gadgets(id : short);
{ Handle RELVERIFY gadgets. }

begin
    ExamTitle;
    case id of
	7 : if AutoRequest(w,abttxt[1],nil,abttxt[9],0,0,262,112) then;
	1 : if ActivateGadget(strgadg[2],w,nil) then;
	2 : if ActivateGadget(strgadg[3],w,nil) then;
	8 : if ActivateGadget(strgadg[1],w,nil) then;
	6 : if strlen(labelf) = 0 then NoLabel else DoProcess;
    end;
end;

procedure PickA;
{ Toggle output to assembler. }

begin
    modegadg[1]^.Flags := GADGHCOMP+GADGIMAGE+SELECTED;
    modegadg[2]^.Flags := GADGHCOMP+GADGIMAGE;
end;

procedure PickC;
{ Toggle output to C. }

begin
    modegadg[1]^.Flags := GADGHCOMP+GADGIMAGE;
    modegadg[2]^.Flags := GADGHCOMP+GADGIMAGE+SELECTED;
end;

procedure ModeGadgets(id : short);
{ Handle mutual-exclude gadgets. }

var
    a : short;

begin
    ExamTitle;
    if id <> oldid then begin
	a := RemoveGadget(w,modegadg[2]);
	a := RemoveGadget(w,modegadg[1]);
	case id of
	    3 : PickA;
	    4 : PickC;
	end;
	_AddGadget(w,modegadg[1],-1);
	_AddGadget(w,modegadg[2],-1);
	RefreshGadgets(modegadg[1],w,nil);
	oldid := id;
    end;
end;

procedure HandleIDCMP;
{ Examine any IDCMP messages arriving at the window. }

var
    addr : GadgetPtr;

begin
    msg := IntuiMessagePtr(WaitPort(w^.UserPort));
    repeat
	msg := IntuiMessagePtr(GetMsg(w^.UserPort));
	if msg <> nil then begin
	    class := msg^.Class;
	    code := msg^.Code;
	    addr := msg^.IAddress;
	    ReplyMsg(MessagePtr(msg));
	    case class of
		CLOSEWINDOW_f : abort := true;
		GADGETUP_f : Gadgets(addr^.GadgetID);
		GADGETDOWN_f : ModeGadgets(addr^.GadgetID);
		REFRESHWINDOW_f : begin
		    BeginRefresh(w);
		    PrintIText(w^.RPort,wtext[1],12,16+txtoff);
		    EndRefresh(w,true);
		end;
	    end;
	end;
    until msg = nil;
end;

procedure StartUp;
{ Startup performed before window is opened. }

var
    lock : FileLock;
    wb : WBStartupPtr;

begin
    sourcef := AllocString(81);
    destf := AllocString(81);
    backf := AllocString(81);
    labelf := AllocString(12);
    iff := AllocString(5);
    asfile := AllocString(35);
    asdir := AllocString(35);
    adfile := AllocString(35);
    addir := AllocString(35);

    wb := GetStartupMsg;
    if wb <> nil then lock := CurrentDir(wb^.sm_ArgList^[1].wa_Lock);

    if AbsExecBase^.lib_Version >= 36 then begin
	OS2 := true;
        AslBase := OpenLibrary("asl.library",36);
    end;
    if AslBase = nil then begin
	ArpBase := OpenLibrary("arp.library",0);
	if ArpBase = nil then arpdata := GADGHCOMP+GADGDISABLED;
    end;
end;

{ Main code. Open what we need, then wait until user clicks a gadget. }

begin
    GfxBase := OpenLibrary("graphics.library",0);
    if GfxBase <> nil then begin
	StartUp;
	if OpenMyWindow then begin
	    SetUp;
	    repeat
		HandleIDCMP;
	    until abort = true;
	    CloseWindow(w);
	end;
	CloseLibrary(GfxBase);
    end;
    if ArpBase <> nil then CloseLibrary(ArpBase);
    if AslBase <> nil then CloseLibrary(AslBase);
end.

