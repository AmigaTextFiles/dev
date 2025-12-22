Type
	tLogData = Record
		ld_fh : BPTR;
	End;
	
Var
	lf : tLogData;
	
Procedure InitLogFile(VAR lf : tLogData; really : Boolean);

Const
	LOGNAME : String[9] = 'S:SM_LOG'#0;
	
Var
	Ok  : Boolean;
	pos : LONG;
	
Begin
	lf.ld_fh := NULL;
	{ if user wants logfile... }
	If really then begin
		{ open file }
		lf.ld_fh := Open(@LOGNAME[1], MODE_READWRITE);
		if lf.ld_fh <> NULL then begin
			{ seek to end }
			Pos := Seek_(lf.ld_fh, 0, OFFSET_END);
		End;
	End;
End;

Procedure WriteLogFile(lf : tLogData; node : pMyNode; def : Boolean);

Const
	{ it's documented in the Autodocs but not in the includes }
	FORMAT_DEF = 4;
	
Var
	s, time, 
	date, day : String;
	ds        : tDateStamp;
	pds       : pDateStamp;
	dt        : tDateTime;
	ok        : Boolean;
	err       : LONG;
	
Begin
	{ does user want logfile }
	If lf.ld_fh <> NULL then begin
		{ command user launched }
		if def then 
			s := 'Default command exit'
		else
			s := node^.LSK_Name;
		{ remove any trailing nulls }
		s := s + #0;
		S := PtrToPas(@s[1]);
		{ time cmd was launched at }
		pds := @ds;
		pds := DateStamp(pds);
		With dt do begin
			dat_Stamp   := ds;
			dat_Format  := FORMAT_DEF;
			dat_Flags   := 0;
			dat_StrDay  := @day[1];
			dat_StrDate := @date[1];
			dat_StrTime := @time[1];
		End;
		Ok := DateToStr(@dt);
		With dt do
			s := PtrToPas(dat_StrDay) + ' ' + PtrToPas(dat_StrDate) + ' ' + 
			     PtrToPas(dat_StrTime) + ' ' + s + #10 + #0;
		{ write the string to the file }
		err := FPuts(lf.ld_fh,@s[1]);
	End;
End;

Procedure FreeLogFile(VAR lf : tLogData);

Var
	OK : Boolean;

Begin
	if lf.ld_fh <> NULL then begin
		Ok := Close_(lf.ld_fh);
		lf.ld_fh := NULL;
	End;
End;
		
		
			
			