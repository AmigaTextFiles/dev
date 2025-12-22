Function Open_Libs;

begin
	IntuitionBase := pIntuitionBase(OpenLibrary('intuition.library',37));
	GadToolsBase  := Openlibrary('gadtools.library',37);
	GfxBase  := pGfxBase(Openlibrary('graphics.library',37));
	DiskFontBase  := Openlibrary('diskfont.library',0);
	UtilityBase  := pUtilityBase(Openlibrary('utility.library',37));
	RexxSysBase := pRxsLib(Openlibrary('rexxsyslib.library',0));
	DataTypesBase := OpenLibrary('datatypes.library', 39);
	
	if (IntuitionBase <> NIL) and (GadToolsBase <> NIL) and (GfxBase <> NIL)
	and (DiskFontBase <> NIL) and (UtilityBase <> NIL) Then
		Open_Libs := True
	else
		Open_Libs := False;
end;

Procedure Close_Libs;

begin
	if RexxSysBase <> NIL then
		CloseLibrary(pLibrary(RexxSysBase));
	CloseLibrary(pLibrary(UtilityBase));
	CloseLibrary(pLibrary(DiskFontBase));
	CloseLibrary(pLibrary(GfxBase));
	CloseLibrary(pLibrary(GadToolsBase));
	CloseLibrary(pLibrary(IntuitionBase));
	if DataTypesBase <> NIL then
		CloseLibrary(DataTypesBase);
end;

Function UpperStr;
Var
     X : Byte;
Begin
  For X := 1 To Length(S) Do
    S[X] := UpCase(S[X]);
  UpperStr := S;
End;