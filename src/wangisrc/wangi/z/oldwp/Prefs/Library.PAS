Function Open_Libs;

begin
	IntuitionBase := pIntuitionBase(OpenLibrary('intuition.library',36));
	UtilityBase  := pUtilityBase(Openlibrary('utility.library',36));
	GadToolsBase  := Openlibrary('gadtools.library',36);
	AslBase  := Openlibrary('asl.library',36);
	ReqToolsBase := pReqToolsBase(OpenLibrary(REQTOOLSNAME,38));
	GfxBase := pGfxBase(OpenLibrary('graphics.library',34));
	DatatypesBase  := Openlibrary('datatypes.library',39);
	DiskFontBase := Openlibrary('diskfont.library',0);
	IconBase := OpenLibrary('icon.library',0);
	WorkbenchBase := OpenLibrary('workbench.library', 36);

	if (IntuitionBase <> NIL) and (UtilityBase <> NIL) and (GadToolsBase <> NIL) 
		and (AslBase <> NIL) and (ReqToolsBase <> NIL) and (GfxBase <> NIL) 
		and (DiskFontBase <> NIL) and (IconBase <> NIL) and (WorkbenchBase <> NIL) then 
		Open_Libs := True
	else
		Open_Libs := False;
end;

Procedure Close_Libs;

begin
	if WorkbenchBase <> NIL then
		CloseLibrary(pLibrary(WorkbenchBase));
	if IconBase <> NIL then
		CloseLibrary(pLibrary(IconBase));
	if DiskFontBase <> NIL then
		CloseLibrary(pLibrary(DiskFontBase));
	if DataTypesBase <> NIL then
		CloseLibrary(pLibrary(DataTypesBase));
	if GfxBase <> NIL then
		CloseLibrary(pLibrary(GfxBase));
	if ReqToolsBase <> NIL then
		CloseLibrary(pLibrary(ReqToolsBase));
	if AslBase <> NIL then
		CloseLibrary(pLibrary(AslBase));
	if GadToolsBase <> NIL then
		CloseLibrary(pLibrary(GadToolsBase));
	if UtilityBase <> NIL then
		CloseLibrary(pLibrary(UtilityBase));
	if IntuitionBase <> NIL then
		CloseLibrary(pLibrary(IntuitionBase));
end;

function CStrConstPtrAR;
type a = packed array [0..255] of char;
var  p : ^a;
begin
  s := s + #0;                                    { Make "C" string }
  p := AllocRemember(rk, length(s), MEMF_CLEAR);  { Get some mem for it }
  move(s[1], p^, length(s));                      { Move s into newly alloc'd mem }
  CStrConstPtrAR := p                               { Return the pointer }
end;

Function Execsynch;

VAR
	newcd   : BPTR;
	oldcd   : BPTR;
	t       : Array[0..6] of tTagItem;
	outfile : BPTR;
	rc, ok  : Boolean;

CONST
	Out : String[5] = 'NIL:'#0;
	
Begin
	rc := False;
	{ open IO file }
	outfile := Open(@out[1], MODE_OLDFILE);
	{ Start program }
	t[0].ti_Tag  := SYS_Asynch;
	t[0].ti_Data := False_;
	t[1].ti_Tag  := SYS_Input;
	t[1].ti_Data := outfile;
	t[2].ti_Tag  := SYS_Output;
	t[2].ti_Data := 0;
	t[3].ti_Tag  := TAG_END;
	if SystemTagList(cmd,@t) = 0 then
		rc := TRUE; { Program started! }
	OK := AmigaDOS.Close_(outfile);
	Execsynch := rc;
End;

Function UpperStr;
Var
     X : Byte;
Begin
  For X := 1 To Length(S) Do
    S[X] := UpCase(S[X]);
  UpperStr := S;
End;

