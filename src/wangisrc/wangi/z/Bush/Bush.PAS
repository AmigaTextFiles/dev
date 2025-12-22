{============================================================================+
||	Bush - A clone of DOS tree.                                              ||
||	The bush-wacker-man prints those branches real fast                      ||
||	                                                                         ||
||	(c)Lee Kindness                                                          ||
||                                                                           ||
||	                                                                         ||
+============================================================================}

PROGRAM Bush(Input,Output);

{$F-,I-,R-,S-,V-,M 10,1,2,15}

{ Units used by the program }
USES
	AmigaDOS, DOS, Exec, Amiga;
	
{----------------------------------------------------------------------------}
{ Tranlates the given string into uppercase }

Function UpperStr(S : String) : String;

Var
     X : Byte;
     
Begin
  For X := 1 To Length(S) Do
    S[X] := UpCase(S[X]);
  UpperStr := S;
End;

{----------------------------------------------------------------------------}
{ Uses Str to convert an integer to a string. More useful Function format }

Function IntToStr(VAR int : LongInt):String;

VAR	
	tmp : String;
	
begin
	Str(int,tmp);
	IntToStr := tmp;
end;

{----------------------------------------------------------------------------}
{ Get options from the command line, print help message if '?' }

Function ParseArgs(VAR l : BPTR; VAR size, flags, dir : Boolean):Boolean;

VAR
	n          : Byte;
	RDArg      : pRDArgs;
	TmpInt     : ^LongInt;
	Template,s : String;
	V2         : Boolean;

CONST
	RD_Array : Array[0..3] of LongInt = (0);
	OurDir   : String[1] = ''#0;
	
begin
	Template := 'DIRECTORY,SIZE/S,FLAGS/S,DIR/S'#0;
					
	If pExecBase(SysBase)^.LibNode.lib_Version >= 36 then V2 := True else V2 := False;
	
	If V2 then begin
		{ WB 2 or greater :-) }
		RDArg := NIL;
		RDArg := ReadArgs(@Template[1],@RD_Array,RDArg);
		
		if NOT (RD_Array[0] = 0) then
			l := lock(Pointer(RD_Array[0]), ACCESS_READ)
		else
			l := lock(@OurDir[1], ACCESS_READ);
		
		if RD_Array[1] <> 0 then Size := True else size := false;
		if RD_Array[2] <> 0 then Flags := True else Flags := false;
		if RD_Array[3] <> 0 then Dir := True else Dir := false;
		
		FreeArgs(RDArg);
		ParseArgs := True;
			
	end else begin
		{ not WB 2 :-( Lets be compatible :-|}
		if (ParamStr(1)='?') then begin
			Writeln(template);
			ParseArgs := False;
		end else begin
			if (UpperStr(ParamStr(1)) = 'SIZE') OR (UpperStr(ParamStr(1)) = 'FLAGS')
				OR (ParamCount = 0) OR (UpperStr(ParamStr(1)) = 'DIR') then
				l := lock(NIL, ACCESS_READ)
			else begin
				s := ParamStr(1)+#0;
				l := lock(@s[1], ACCESS_READ);
			End;
			For n := 1 to ParamCount do begin
				If UpperStr(ParamStr(n)) = 'SIZE' then 
					Size := True;
				If UpperStr(ParamStr(n)) = 'FLAGS' then 
					flags := True;
				If UpperStr(ParamStr(n)) = 'DIR' then 
					Dir := True;
			end;
			ParseArgs := True;
		end;
	end;
end;
		
Function MakeFlags(protection : LongInt):String;
{ create a string representing the protection of a file }

VAR 
	tmpstr : String;
	
Begin
	tmpStr := '';
	if (Protection and FIBF_SCRIPT)<> 0 then
		tmpstr := 's'
	else 
		tmpstr := '-';
	if (Protection and FIBF_PURE) <> 0 then
		tmpstr := tmpstr + 'p'
	else 
		tmpstr := tmpstr + '-';
	if (Protection and FIBF_ARCHIVE) <> 0 then
		tmpstr := tmpstr + 'a'
	else 
		tmpstr := tmpstr + '-';
	if (Protection and FIBF_READ) = 0 then
		tmpstr := tmpstr + 'r'
	else 
		tmpstr := tmpstr + '-';
	if (Protection and FIBF_WRITE) = 0 then
		tmpstr := tmpstr + 'w'
	else 
		tmpstr := tmpstr + '-'; 
	if (Protection and FIBF_EXECUTE) = 0 then
		tmpstr := tmpstr + 'e'
	else 
		tmpstr := tmpstr + '-';
	if (Protection and FIBF_DELETE) = 0 then
		tmpstr := tmpstr + 'd'
	else 
		tmpstr := tmpstr + '-';
	MakeFlags := '('+TmpStr+')';
end;
		
Function FormatName(DirLevel : Byte; Directory : Boolean; 
						Name, dirStr : String; I_Size, I_Protection : LongInt;
						B_Size, B_Flags : Boolean):String;
{ Create the string to be displayed }

VAR 
	tmp : string;
	z   : byte;

begin
	If Directory then
		tmp := ' |-'+Name + dirstr
	else begin
		tmp := ' | '+Name;
		if B_Size then
			tmp := tmp + ' (' + IntToStr(I_Size) + ' bytes)';
		if B_Flags then
			tmp := tmp + ' ' + MakeFlags(I_Protection);
	end;
			
	for z := 2 to DirLevel do 
		tmp := ' | ' + tmp;
		
	FormatName := tmp;
end;

{----------------------------------------------------------------------------}
{ Print tree to std_out, This procedure calls itself in order to handle      }
{ sub-directories. }

Function CreateTree(VAR loc : BPTR; initial, Size, Flags, Dir : Boolean;
							DirStr : String):Boolean;


VAR
	olddir, l : BPTR;
	OKRes, noBreak : Boolean;
	fib       : pFileInfoBlock;
	filenum, dirnum   : integer;
	tmpn      : byte;
	Signals   : LongInt;

CONST
	n : Byte = 0; { holds the current number of recurses }
	
Begin 
	NoBreak := True;
	If Initial then n := 0;
	filenum := 0;
	dirnum := 0;
	inc(n);
	OldDir := CurrentDir(loc);
	Fib := AllocMem(sizeof(tFileInfoBlock),MEMF_PUBLIC);
	if fib <> NIL then begin
		OKRes := Examine(loc,fib);
		While OKRes and NoBreak do begin
			inc(filenum);
			if Filenum <> 1 then begin
				if (fib^.fib_DirEntryType > 0) then begin
					inc(dirnum);
					writeln(FormatName(n,true,PtrToPas(@fib^.fib_FileName),
							dirstr,0,0,false,false));
					tmpn := n;
					l := lock(@fib^.fib_FileName, ACCESS_READ);
					NoBreak := CreateTree(l, false,size,flags,dir,DirStr); { recurse }
					n := tmpn;
					unlock(l);
				end else
					if Not dir then
					writeln(FormatName(n,false,PtrToPas(@fib^.fib_FileName),
							dirstr,fib^.fib_Size,fib^.fib_Protection,Size,Flags));
			end;
			OKRes := ExNext(loc,fib);
			signals := SetSignal(0,0);
			{ check for Ctrl-C break by user }
			If (Signals and SIGBREAKF_CTRL_C) <> 0 then begin
				Writeln('***Break');
				NoBreak := False;
				Signals := SetSignal(0,SIGBREAKF_CTRL_C);
			end;
		end;
		If NoBreak then begin
			If (NOT Initial) and (NOT Dir) then
				writeln(FormatName(n-1,false,' °',dirstr,0,0,false,false))
			else
				if (DIR and (dirnum > 0)) then
					writeln(FormatName(n-1,false,' °',dirstr,0,0,false,false));
		end else
			if NoBreak and (DirNum > 0) then
				writeln(' °');
		FreeMem_(fib, Sizeof(tFileInfoBlock));
	end;
	Olddir := Currentdir(olddir);
	CreateTree := NoBreak;
end;

{----------------------------------------------------------------------------}

Procedure Main;

VAR
	loc : BPTR;
	OK  : Boolean;
	
CONST
	V_Size  : Boolean = False;
	V_Flags : Boolean = False;
	V_Dir   : Boolean = False;
{ Version string for C:Version to Find }
	Version : String[41] = '$VER: Bush v1.4 (27.09.94) ©Lee Kindness'#0;
	DirStr : String[6] = ' <dir>';
	rc : Byte = 0;
	
begin
	OK := ParseArgs(loc, V_Size, V_Flags, V_Dir);
	if OK then begin
		If Loc <> 0 then begin
			If V_Dir then DirStr := '';
			Writeln(' ',FExpandLock(loc),''#10+
				  ' |');
			OK := CreateTree(loc, true, V_Size, V_Flags, V_Dir, DirStr);
			UnLock(loc);
		end;
	end;
	OK := PrintFault(IOErr,NIL);
end;

{----------------------------------------------------------------------------}

begin
main;
end.

{----------------------------------------------------------------------------}