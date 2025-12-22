unit producerlib;

INTERFACE
uses Exec,intuition,graphics,utility,gadtools;

const
  LoadError : array[0..9] of string[25] =
  (
  'No Error'#0,
  'No FileName'#0,
  'No File'#0,
  'No IFF Handle'#0,
  'No Memory'#0,
  'Read Error'#0,
  'Bad File'#0,
  'Not Designer File'#0,
  'File Version Too Small'#0,
  'File Version Too Large'#0
  );

type
  
  plocalenode = ^tlocalenode;
  tlocalenode = record
    ln_Succ     : plocalenode;
    ln_Pred     : plocalenode;
    ln_String   : pbyte;
    ln_Label    : pbyte;
    ln_Comment  : pbyte;
   end;
  
  pmytag = ^tmytag;
  tmytag = record
    ln_succ    : pmytag;
    ln_pred    : pmytag;
    mt_label   : pbyte;
    value      : long;
    sizebuffer : long;
    data       : pointer;
    tagtype    : word;
   	pos        : long;
   end;
  
  pstringnode = ^tstringnode;
  tstringnode = record
    ln_succ : pstringnode;
    ln_pred : pstringnode;
    sn_string : pbyte;
    
    st        : string;
   end;
  
  pgadgetnode = ^tgadgetnode;
  tgadgetnode = record
    ln_succ     : pgadgetnode;
    ln_pred     : pgadgetnode;
    gn_Label    : pbyte;
    gn_title    : pbyte;
    gn_gadgettags : ptagitem;
    flags       : long;
    x,y,w,h     : long;
    id          : long;
    kind        : long;
    font        : ttextattr;
    infolist    : tminlist;
    tags        : array[1..15] of ttagitem;
    pointers    : array [1..4] of pbyte;
    joined      : boolean;
    
    edithook    : string;
    fontname    : string;
    datas       : string;
    title       : string;
    labelid     : string;
    prevtagpos  : long;
    prevobject  : pgadgetnode;
    tagpos      : long;
   end;
  
  ptextnode = ^ttextnode;
  ttextnode = record
    ln_succ   : ptextnode;
    ln_pred   : ptextnode;
    tn_title  : pbyte;
    x         : long;
    y         : long;
    ta        : ttextattr;
    frontpen  : byte;
    backpen   : byte;
    drawmode  : byte;
    screenfont: boolean;
    
   end;
  
  pbevelboxnode = ^tbevelboxnode;
  tbevelboxnode = record
    ln_succ  : pbevelboxnode;
    ln_pred  : pbevelboxnode;
    x        : long;
    y        : long;
    w        : long;
    h        : long;
    beveltype: word;
   end;

  pimagenode = ^timagenode;
  
  psmallimagenode = ^tsmallimagenode;
  tsmallimagenode = record
    ln_succ        : psmallimagenode;
    ln_pred        : psmallimagenode;
    pin            : pimagenode;
    x,y            : long;
   end;
  
  pProducerNode = ^tProducerNode;
  tProducerNode = Record
    windowlist  : tminlist;
    menulist    : tminlist;
    imagelist   : tminlist;
    screenlist  : tminlist;
     
    LocaleList  : tMinList;
    LocaleCount : long;
    basename    : pbyte;
    getstring   : pbyte;
    builtinlanguage : pbyte;
    localeversion : long;
    
    procedureoptions : array [1..50] of boolean;
    codeoptions      : array [1..20] of boolean;
    openlibs         : array [1..30] of boolean;
    versionlibs      : array [1..30] of long;
    abortonfaillibs  : array [1..30] of boolean;
    includes         : pbyte;
   
   end;

  pwordarray2 = ^twordarray2;
  twordarray2 = array[0..10000000] of word;
  
  pbytearray = ^tbytearray;
  tbytearray = array [0..10000000] of byte;
  
  timagenode = record
    ln_succ       : pimagenode;
    ln_pred       : pimagenode;
    in_label      : pbyte;
    Width         : integer;
	Height        : integer;
	Depth         : integer;
	PlanePick     : byte;
	PlaneOnOff    : byte;
	ImageData     : pbytearray;
	sizeallocated : long;
	colourmap     : pwordarray2;
    mapsize       : long;
   end;

  pdesignermenunode = ^tdesignermenunode;
  tdesignermenunode = record
    ln_succ         : pdesignermenunode;
    ln_pred         : pdesignermenunode;
    tmenulist       : tminlist;
    mn_label        : pbyte;
    mn_TagList      : ptagitem;
    localmenu       : boolean;
    
    defaultfont     : boolean;
    frontpen        : long;
    font            : ttextattr;
    
   end;
  
  pmenutitlenode = ^tmenutitlenode;
  tmenutitlenode = record
    ln_succ   : pmenutitlenode;
    ln_pred   : pmenutitlenode;
    titemlist : tminlist;
    mt_text   : pbyte;
    mt_label  : pbyte;
    disabled  : boolean;
    pad       : boolean;
    
   end;
  
  pmenuitemnode = ^tmenuitemnode;
  tmenuitemnode = record
    ln_succ    : pmenuitemnode;
    ln_pred    : pmenuitemnode;
    tsubitems  : tminlist;
    mi_text    : pbyte;
    mi_label   : pbyte;
    graphic    : pimagenode;
    commkey    : byte;
    disabled   : boolean;
    checkit    : boolean;
    menutoggle : boolean;
    checked    : boolean;
    barlabel   : boolean;
    exclude    : long;
    
   end;
  
  pmenusubitemnode = ^tmenusubitemnode;
  tmenusubitemnode = record
    ln_succ    : pmenusubitemnode;
    ln_pred    : pmenusubitemnode;
    ms_text    : pbyte;
    ms_label   : pbyte;
    graphic    : pimagenode;
    commkey    : byte;
    disabled   : boolean;
    checkit    : boolean;
    menutoggle : boolean;
    checked    : boolean;
    barlabel   : boolean;
    exclude    : long;
    
   end;

  pdesignerscreennode = ^tdesignerscreennode;
  tdesignerscreennode = record
    ln_succ    : pdesignerscreennode;
    ln_prev    : pdesignerscreennode;
    sn_label             : pbyte;
    sn_TagList           : ptagitem;
    loctitle             : boolean;
   
    
    bitmap               : boolean;
    createbitmap         : boolean;
    dopubsig             : boolean;
    
    sn_title             : pbyte;
    sn_pubscreenname     : pbyte;

    left                 : word;
    top                  : word;
    width                : word;
    height               : word;
    depth                : word;
    overscan             : byte;  {text, standard, max , video}
    fonttype             : byte;
    behind               : boolean;
    quiet                : boolean;
    showtitle            : boolean;
    AutoScroll           : boolean;
    idnum                : long;
    screentype           : word;
    defpens              : boolean;
    fullpalette          : boolean;
    font                 : ttextattr;
    colorarray           : pwordarray2;
    sizecolorarray       : long;
    penarray             : array[0..30] of word;
    errorcode            : boolean;
    sharedpens           : boolean;
    draggable            : boolean;
    exclusive            : boolean;
    interleaved          : boolean;
    likeworkbench        : boolean;
   end;

  pdesignerwindownode = ^tdesignerwindownode;
  tdesignerwindownode = record
    ln_succ        : pdesignerwindownode;
    ln_pred        : pdesignerwindownode;
    gadgetlist     : tminlist;
    textlist       : tminlist;
    imagelist      : tminlist;
    bevelboxlist   : tminlist;
    wn_Label       : pbyte;
    wn_WinParams   : pbyte;
    wn_RendParams  : pbyte;
    wn_TagList     : ptagitem;
    wn_Menu        : pdesignermenunode;
    localeoptions  : array   [1..6 ] of boolean;
    codeoptions    : array   [1..20] of boolean;
    extracodeoptions : array [1..20] of boolean;
    offx           : word;
    offy           : word;
    fontx,fonty    : word;
    nextid         : long;
    
    
    spare          : array [1..4] of long;
    wn_DefaultPubScreenName : pbyte;
    wn_Title       : pbyte;
    wn_ScreenTitle : pbyte;
    moretags       : array   [1..6 ] of boolean;
    x,y,w,h        : long;                         {}
    minw,maxw      : long;
    minh,maxh      : long;
    innerw,innerh  : long;
    zoom           : array[1..4] of word;
    mousequeue     : long;
    rptqueue       : long;
    sizegad        : boolean;                      {}
    sizebright     : boolean;                      {}
    sizebbottom    : boolean;                      {}
    dragbar        : boolean;                      {}
    depthgad       : boolean;                      {}
    closegad       : boolean;                      {}
    reportmouse    : boolean;
    nocarerefresh  : boolean;
    borderless     : boolean;
    backdrop       : boolean;
    gimmezz        : boolean;
    activate       : boolean;                      {}
    rmbtrap        : boolean;
    simplerefresh  : boolean;
    smartrefresh   : boolean;                      {}
    autoadjust     : boolean;                      {}
    menuhelp       : boolean;                      {}
    usezoom        : boolean;
    customscreen   : boolean;
    pubscreen      : boolean;
    pubscreenname  : boolean;
    pubscreenfallback : boolean;
    idcmplist      : array [1..25] of boolean;
    idcmpvalues    : long;
    gadgetfont     : ttextattr;
    
    gadgetfontname : string;
    menutitle      : string;
    winparams      : string;
    defpubname     : string[80];
    rendparams     : string;
    title          : string; 
    screentitle    : string;
    labelid        : string;
   end;

function sfp(p : pbyte):string;

function  GetProducer: pProducerNode;
procedure FreeProducer (pn: pProducerNode);
function  LoadDesignerData
		   (pn : pProducerNode;
		    FileName: pbyte): longint;

procedure FreeDesignerData (pn: pProducerNode);
function  OpenProducerWindow
		   (pn : pProducerNode;
		    Title: pbyte): boolean;

procedure CloseProducerWindow (pn: pProducerNode);
procedure SetProducerWindowFileName
		   (pn : pProducerNode;
		    name: pbyte);

procedure SetProducerWindowAction
		   (pn : pProducerNode;
		    act: pbyte);

procedure SetProducerWindowLineNumber
		   (pn: pProducerNode;
		    num: longint);

function  ProducerWindowUserAbort (pn: pProducerNode): boolean;
function  ProducerWindowWriteMain
		   (pn : pProducerNode;
		    filename: pbyte): Boolean;

function  AddLocaleString
		   (pn : pProducerNode;
		    str : pbyte;
		    labelstring : pbyte;
		    commentstring : pbyte): Boolean;

procedure FreeLocaleStrings (pn: pProducerNode);
function WriteLocaleCT (pn: pProducerNode): Boolean;
function WriteLocaleCD (pn: pProducerNode): Boolean;

var
  ProducerBase: pLibrary;

implementation

function sfp(p : pbyte):string;
var
  temp : string;
begin
  temp:='';
  if p<>nil then
    ctopas(p^,temp);
  sfp:=temp;
end;

function GetProducer; xassembler;
asm
	movem.l	d4-d5/a6,-(sp)
	move.l	ProducerBase,a6
	jsr		-$1E(a6)
	move.l	d0,$10(sp)
	movem.l	(sp)+,d4-d5/a6
end;

procedure FreeProducer; xassembler;
asm
	move.l	a6,-(sp)
	move.l	8(sp),a0
	move.l	ProducerBase,a6
	jsr		-$24(a6)
	move.l	(sp)+,a6
end;

function LoadDesignerData; xassembler;
asm
	move.l	a6,-(sp)
	lea		8(sp),a6
	move.l	(a6)+,a1
	move.l	(a6)+,a0
	move.l	ProducerBase,a6
	jsr		-$2A(a6)
	move.l	d0,$10(sp)
	move.l	(sp)+,a6
end;

procedure FreeDesignerData; xassembler;
asm
	move.l	a6,-(sp)
	move.l	8(sp),a0
	move.l	ProducerBase,a6
	jsr		-$30(a6)
	move.l	(sp)+,a6
end;

function OpenProducerWindow; xassembler;
asm
	move.l	a6,-(sp)
	lea		8(sp),a6
	move.l	(a6)+,a1
	move.l	(a6)+,a0
	move.l	ProducerBase,a6
	jsr		-$36(a6)
	move.b	d0,$10(sp)
	move.l	(sp)+,a6
end;

procedure CloseProducerWindow; xassembler;
asm
	move.l	a6,-(sp)
	move.l	8(sp),a0
	move.l	ProducerBase,a6
	jsr		-$3C(a6)
	move.l	(sp)+,a6
end;

procedure SetProducerWindowFileName; xassembler;
asm
	move.l	a6,-(sp)
	lea		8(sp),a6
	move.l	(a6)+,a1
	move.l	(a6)+,a0
	move.l	ProducerBase,a6
	jsr		-$42(a6)
	move.l	(sp)+,a6
end;

procedure SetProducerWindowAction; xassembler;
asm
	move.l	a6,-(sp)
	lea		8(sp),a6
	move.l	(a6)+,a1
	move.l	(a6)+,a0
	move.l	ProducerBase,a6
	jsr		-$48(a6)
	move.l	(sp)+,a6
end;

procedure SetProducerWindowLineNumber; xassembler;
asm
	move.l	a6,-(sp)
	movem.l	8(sp),d0/a0
	move.l	ProducerBase,a6
	jsr		-$4E(a6)
	move.l	(sp)+,a6
end;

function ProducerWindowUserAbort; xassembler;
asm
	move.l	a6,-(sp)
	move.l	8(sp),a0
	move.l	ProducerBase,a6
	jsr		-$54(a6)
	move.b	d0,$C(sp)
	move.l	(sp)+,a6
end;

function ProducerWindowWriteMain; xassembler;
asm
	move.l	a6,-(sp)
	lea		8(sp),a6
	move.l	(a6)+,a1
	move.l	(a6)+,a0
	move.l	ProducerBase,a6
	jsr		-$5A(a6)
	move.b	d0,$10(sp)
	move.l	(sp)+,a6
end;

function AddLocaleString; xassembler;
asm
	move.l	a6,-(sp)
	lea		8(sp),a6
	move.l	(a6)+,d1
	move.l	(a6)+,d0
	move.l	(a6)+,a1
	move.l	(a6)+,a0
	move.l	ProducerBase,a6
	jsr		-$60(a6)
	move.b	d0,$18(sp)
	move.l	(sp)+,a6
end;

procedure FreeLocaleStrings; xassembler;
asm
	move.l	a6,-(sp)
	move.l	8(sp),a0
	move.l	ProducerBase,a6
	jsr		-$66(a6)
	move.l	(sp)+,a6
end;

function WriteLocaleCT; xassembler;
asm
	move.l	a6,-(sp)
	move.l	8(sp),a0
	move.l	ProducerBase,a6
	jsr		-$6C(a6)
	move.b	d0,$C(sp)
	move.l	(sp)+,a6
end;

function WriteLocaleCD; xassembler;
asm
	move.l	a6,-(sp)
	move.l	8(sp),a0
	move.l	ProducerBase,a6
	jsr		-$72(a6)
	move.b	d0,$C(sp)
	move.l	(sp)+,a6
end;

end.
