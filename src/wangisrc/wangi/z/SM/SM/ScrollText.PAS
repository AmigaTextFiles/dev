{ get some strings from a file }
Function GetWitComment;
	
VAR
	ap          : pAnchorPath;
	filenames   : Array[0..10] of string[180];
	pf          : string[180];
	s, ts       : string;
	seekin, n, 
	oldpos      : longint;
	witf        : BPTR;
	fib         : pFileInfoBlock;
	pBuf        : STRPTR;
	buf         : String;
	OK          : Boolean;
	err         : integer;

	
begin
	ap := AllocMem(sizeof(tAnchorPath)+256, MEMF_CLEAR);
	if ap <> NIL then begin
		ap^.ap_StrLen := 255;
		err := MatchFirst(CSCPAR(@RememberKey, 'S:SM/#?.WIT'), ap);
		n := 0;
		While (err = 0) and (n <= 10) do begin
			filenames[n] := PtrToPas(@ap^.ap_buf);
			inc(n);
			err := MatchNext(ap);
		end;
		MatchEnd(ap);
		FreeMem_(ap, sizeof(tAnchorPath)+256);

		S := '';
		If n <> 0 then begin
			{ get a random file name }
			Randomize;
			pf := filenames[Random(n)] + #0;
		
			witf := Open(@pf[1], MODE_OLDFILE);
			if witf <> NULL then begin
				{ examine FH }
				fib := AllocMem(sizeof(tFileInfoBlock), MEMF_CLEAR);
				if fib <>NIL then begin
					if ExamineFH(witf, fib) then begin;
					
						seekin := Random(fib^.fib_Size);
						oldpos := Seek_(witf, seekin, OFFSET_BEGINNING);
						{ goto next line }
						pBuf := FGets(witf, @buf, 255);
			
						OK := True;
						while OK do begin
							pBuf := FGets(witf, @buf, 255);
							if pBuf <> NIL then begin
								ts := PtrToPas(pbuf);
								if NOT ((ts[1] = ';') or ((ts[1] = '#') and (ts[2] = '#'))) then begin
									if ts[length(ts)] = #10 then 
										ts := Copy(ts, 0, length(ts)-1);
									if NOT (length(s) + 6 + length(ts) > 254) then
										s := s + ' -!- ' + ts
									else
										OK := False;
								end;
							end else begin
								oldpos := Seek_(witf, 0, OFFSET_BEGINNING);
								pBuf := FGets(witf, @buf, 255);
								ts := PtrToPas(pbuf);
								if NOT ((ts[1] = ';') or ((ts[1] = '#') and (ts[2] = '#'))) then begin
									if ts[length(ts)] = #10 then 
										ts := Copy(ts, 0, length(ts)-1);
									if NOT (length(s) + 6 + length(ts) > 254) then
							 			s := s + ' -!- ' + ts
							 		else
										OK := False;
								end;
							end;
						end;
						s:= s + ' -!- ';
					end;
					FreeMem_(fib,sizeof(tFileInfoBlock));
				end;
				OK := Close_(WitF);
			end else s := 'No .WIT files found -!- '+SMVer;
		end;
		{ return string }
		getwitcomment := s;
	end;
end;

{ scroll the text within given rectangle }
Procedure ScrollText;

VAR 
	te : tTextExtent;
	t  : long;
								
Begin
	{ Erase the area that text will currently be displayed in }
 	EraseRect(RPort, L, B-H, L+W, B+1);
 	If NOT (count > W) then begin
{                                  *----------*
  text is scrolling from the right |       <--|
                                   *----------*
}
 		Move_(RPort, L+W-count, B);
		t := TextFit(RPort, @txt[1], length(txt), @te, NIL, 1, W-(L+W-count-L), H);
		Text_(RPort, @txt[1], t);
		if count+RPort^.Font^.tf_XSize >= W then count := W+1
		 else	count := count+RPort^.Font^.tf_XSize;
	end else begin
{                                   *----------*
  Text is scrolling off to the left |---<      |
                                    *----------*
}
		Move_(RPort, L, B);
		t := TextFit(RPort, @txt[count-W], length(txt)-(count-W)+1, @te, NIL, 1, W, H);
		Text_(RPort, @txt[count-W], t);
		count := count+1;
	end;
	if count > W+length(txt)+1 then count := 1;
{ NOTE: there may be a slight jump or speed decrease 
  during the transition between the two states.}
end;
  
	
	 
