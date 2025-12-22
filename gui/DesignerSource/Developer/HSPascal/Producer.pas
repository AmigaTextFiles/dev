unit Producer;

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
  
  tagtypelong    =0;
  tagtypeboolean =1;
  tagtypestring  =2;
  tagtypearraybyte =3;
  tagtypearrayword =4;
  tagtypearraylong =5;
  tagtypearraystring =6;
  tagtypestringlist = 7;
  tagtypeuser =8;
  tagtypeVisualInfo =9;
  tagtypeDrawInfo =10;
  tagtypeintuitext = 11;
  tagtypeimage = 12;
  tagtypeimagedata = 13;
  tagtypeleftcoord = 14;
  tagtypetopcoord = 15;
  tagtypewidthcoord = 16;
  tagtypeheightcoord = 17;
  tagtypegadgetid = 18;
  tagtypefont = 19;
  tagtypescreen = 20;
  tagtypeobject = 21;
  tagtypeuser2 = 22;
  
  mybool_kind = 227;
  myobject_kind = 198;
  
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
    mt_succ       : pmytag;
    mt_pred       : pmytag;
    mt_title      : pbyte;
    mt_value      : long;
    mt_buffersize : long;
    mt_data       : pointer;
    mt_tagtype    : word;
   end;
  
  pstringnode = ^tstringnode;
  tstringnode = record
    sn_succ   : pstringnode;
    sn_pred   : pstringnode;
    sn_string : pbyte;
   end;
  
  pgadgetnode = ^tgadgetnode;
  tgadgetnode = record
    gn_succ     : pgadgetnode;
    gn_pred     : pgadgetnode;
    gn_Label    : pbyte;
    gn_title    : pbyte;
    gn_TagList  : ptagitem;
    gn_flags    : long;
    gn_LeftEdge : long;
    gn_TopEdge  : long;
    gn_Width    : long;
    gn_Height   : long;
    gn_GadgetID : long;
    gn_Kind     : long;
    gn_Font     : ttextattr;
   end;
  
  ptextnode = ^ttextnode;
  ttextnode = record
    tn_succ       : ptextnode;
    tn_pred       : ptextnode;
    tn_title      : pbyte;
    tn_LeftEdge   : long;
    tn_TopEdge    : long;
    tn_Font       : ttextattr;
    tn_FrontPen   : byte;
    tn_BackPen    : byte;
    tn_DrawMode   : byte;
    tn_ScreenFont : boolean;
   end;
  
  pbevelboxnode = ^tbevelboxnode;
  tbevelboxnode = record
    bb_succ      : pbevelboxnode;
    bb_pred      : pbevelboxnode;
    bb_LeftEdge  : long;
    bb_TopEdge   : long;
    bb_Width     : long;
    bb_Height    : long;
    bb_BevelType : word;
   end;

  pimagenode = ^timagenode;
  
  psmallimagenode = ^tsmallimagenode;
  tsmallimagenode = record
    si_Succ        : psmallimagenode;
    si_Pred        : psmallimagenode;
    si_Graphic     : pimagenode;
    si_LeftEdge    : long;
    si_TopEdge     : long;
   end;
  
  pProducerNode = ^tProducerNode;
  tProducerNode = Record
    pn_windowlist  : tminlist;
    pn_menulist    : tminlist;
    pn_imagelist   : tminlist;
    pn_screenlist  : tminlist;
    pn_LocaleList  : tMinList;
    pn_LocaleCount : long;
    pn_basename    : pbyte;
    pn_getstring   : pbyte;
    pn_builtinlanguage  : pbyte;
    pn_localeversion    : long;
    pn_procedureoptions : array [0..49] of boolean;
    pn_codeoptions      : array [0..19] of boolean;
    pn_openlibs         : array [0..29] of boolean;
    pn_versionlibs      : array [0..29] of long;
    pn_abortonfaillibs  : array [0..29] of boolean;
    pn_pn_includes      : pbyte;
   end;

  timagenode = record
    in_succ          : pimagenode;
    in_pred          : pimagenode;
    in_label         : pbyte;
    in_Width         : integer;
	in_Height        : integer;
	in_Depth         : integer;
	in_PlanePick     : byte;
	in_PlaneOnOff    : byte;
	in_ImageData     : pbyte;
	in_sizeallocated : long;
	in_colourmap     : pword;
    in_mapsize       : long;
   end;

  pdesignermenunode = ^tdesignermenunode;
  tdesignermenunode = record
    mn_succ         : pdesignermenunode;
    mn_pred         : pdesignermenunode;
    mn_menulist     : tminlist;
    mn_label        : pbyte;
    mn_TagList      : ptagitem;
    mn_localemenu   : boolean;
   end;
  
  pmenutitlenode = ^tmenutitlenode;
  tmenutitlenode = record
    mt_succ     : pmenutitlenode;
    mt_pred     : pmenutitlenode;
    mt_itemlist : tminlist;
    mt_text     : pbyte;
    mt_label    : pbyte;
    mt_disabled : boolean;
   end;
  
  pmenuitemnode = ^tmenuitemnode;
  tmenuitemnode = record
    mi_succ       : pmenuitemnode;
    mi_pred       : pmenuitemnode;
    mi_subitems   : tminlist;
    mi_text       : pbyte;
    mi_label      : pbyte;
    mi_graphic    : pimagenode;
    mi_commkey    : byte;
    mi_disabled   : boolean;
    mi_checkit    : boolean;
    mi_menutoggle : boolean;
    mi_checked    : boolean;
    mi_barlabel   : boolean;
    mi_exclude    : long;
   end;
  
  pmenusubitemnode = ^tmenusubitemnode;
  tmenusubitemnode = record
    ms_succ       : pmenusubitemnode;
    ms_pred       : pmenusubitemnode;
    ms_text       : pbyte;
    ms_label      : pbyte;
    ms_graphic    : pimagenode;
    ms_commkey    : byte;
    ms_disabled   : boolean;
    ms_checkit    : boolean;
    ms_menutoggle : boolean;
    ms_checked    : boolean;
    ms_barlabel   : boolean;
    ms_exclude    : long;
   end;

  pdesignerscreennode = ^tdesignerscreennode;
  tdesignerscreennode = record
    sn_succ              : pdesignerscreennode;
    sn_prev              : pdesignerscreennode;
    sn_label             : pbyte;
    sn_TagList           : ptagitem;
    sn_localetitle       : boolean;
   end;

  pdesignerwindownode = ^tdesignerwindownode;
  tdesignerwindownode = record
    wn_Succ                 : pdesignerwindownode;
    wn_Pred                 : pdesignerwindownode;
    wn_GadgetList           : tminlist;
    wn_TextList             : tminlist;
    wn_ImageList            : tminlist;
    wn_BevelBoxList         : tminlist;
    wn_Label                : pbyte;
    wn_WinParams            : pbyte;
    wn_RendParams           : pbyte;
    wn_TagList              : ptagitem;
    wn_Menu                 : pdesignermenunode;
    wn_localeoptions        : array [0..5 ] of boolean;
    wn_codeoptions          : array [0..19] of boolean;
    wn_extracodeoptions     : array [0..19] of boolean;
    wn_offx                 : word;
    wn_offy                 : word;
    wn_Fontx                : word;
    wn_fonty                : word;
    wn_FirstID              : long;
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

function sfp(p : pbyte):string;  { Take a pointer to a C string and returns a Pascal string }
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
	move.l	d0,$10(sp)
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
	move.l	d0,$C(sp)
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
	move.l	d0,$10(sp)
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
	move.l	d0,$18(sp)
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
	move.l	d0,$C(sp)
	move.l	(sp)+,a6
end;

function WriteLocaleCD; xassembler;
asm
	move.l	a6,-(sp)
	move.l	8(sp),a0
	move.l	ProducerBase,a6
	jsr		-$72(a6)
	move.l	d0,$C(sp)
	move.l	(sp)+,a6
end;

end.
