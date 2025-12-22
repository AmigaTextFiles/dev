(*
 * Shrub... HSPascal source
 *
 * ©Lee Kindness
 *
 * TreeIt.pas
 *
 *)

Function AllocTree;
	
Begin
	th := AllocVec(Sizeof(tTreeHandle), MEMF_CLEAR);
	If th <> NIL then begin
		th^.th_List := AllocRemember(@th^.th_RK, SizeOf(tList), MEMF_CLEAR);
		if th^.th_List <> NIL then begin
			NewList(th^.th_List);
		End else Begin
			FreeVec(th);
			th := NIL
		End;
	End;
	AllocTree := th;
End;

Procedure FreeTree;

Begin
	if th <> NIL then begin
		UnLock(th^.th_Loc);
		FreeRemember(@th^.th_RK, True);
		FreeVec(th);
		th := NIL;
	End;
End;


Procedure FormatName;

VAR 
	tmp : string;
	tns, numstxt, z : byte;
	n   : pmn;

begin		
	tmp := PtrToPas(th^.th_Name);
	tns := Byte(tmp[0]);
	
	if dt > 0 then begin
		Case dt of
			ST_SOFTLINK : tmp := tmp + ' (dir) <sl>';
			ST_LINKDIR : tmp := tmp + ' (dir) <hl>';
			Else tmp := tmp + ' (dir)';
		End;
	End;
	if dt < 0 then begin
		Case dt of
			ST_LINKFILE : tmp := tmp + ' <hl>';
			ST_PIPEFILE : tmp := tmp + ' <pipe>';
		End;
	End;
			
	numstxt := 0;
	for z := 2 to DirLevel do begin
		inc(numstxt); 
		tmp := Arg.arg_Stxt + tmp;
	End;
		
	if Pos('.info',tmp) <> 0 then begin
		if NOT arg.arg_ShowIcons then begin
			tmp := '';
		End;
	End;
	
	inc(tnumf);
	if tmp <> '' then begin
		inc(numf);
		n := AllocRemember(@th^.th_RK, Sizeof(tmn), MEMF_CLEAR);
		if n <> NIL then begin
			n^.ln_Name := CStrConstPtrAR(@th^.th_RK, tmp);
			n^.ln_AbsNameSize := tns;
			n^.ln_DirEntryType := dt;
			n^.ln_NumSTxt := numstxt;
			AddTail(th^.th_List, pNode(n));
		End;
	End;
end;


Procedure CreateTree; 


VAR
	olddir, l : BPTR;
	OKRes     : Boolean;
	fib       : pFileInfoBlock;
	tmpn      : byte;
	dn : integer;

CONST
	n : Byte = 0; { holds the current number of recurses }
	
Begin 
	if initial then begin
		empty := False;
		n := 0;
		tnumf := 0;
		numf := 0;
		numd := 0;
	End;
	inc(n);
	OldDir := CurrentDir(th^.th_Loc);
	Fib := AllocVec(sizeof(tFileInfoBlock),MEMF_CLEAR);
	if fib <> NIL then begin
		dn := 0;
		OKRes := Examine(th^.th_Loc,fib);
		While OKRes do begin
			inc(dn);
			if (fib^.fib_DirEntryType > 0) and (dn <> 1) then begin
				inc(numd);
				th^.th_Name := @fib^.fib_FileName;
				FormatName(n, fib^.fib_DirEntryType, th);
				
				if (fib^.fib_DirEntryType = ST_LINKDIR)|(fib^.fib_DirEntryType = ST_SOFTLINK) then
					OK := False
				else
					OK := True;
					
				If arg.arg_fld then
					OK := true;
					
				If Ok then begin
					tmpn := n;
					l := th^.th_Loc;
					th^.th_Loc := lock(@fib^.fib_FileName, ACCESS_READ);
					CreateTree(th, False); { recurse }
					n := tmpn;
					unlock(th^.th_Loc);
					th^.th_Loc := l;
				End;
			end;
			if (fib^.fib_DirEntryType < 0) then begin
				th^.th_Name := @fib^.fib_FileName;
				FormatName(n, fib^.fib_DirEntryType, th);
			end;
			
			OKRes := ExNext(th^.th_Loc,fib);
			
		end;
		FreeVec(fib);
	end;
	Olddir := Currentdir(olddir);
end;
