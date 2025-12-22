TYPE
	tCData = Record
		cd_Font,
		cd_SFont     : tTextAttr;
		cd_FontName,
		cd_SFontName : String[80];
		cd_ScrTit,
		cd_WinTit,
		cd_WitTxt,
		cd_DT        : String;
		cd_Pal       : Array[0..3] of Integer;
		cd_ScrT, {used to be cd_Backdrop (Boolean)}
		cd_Across,
		cd_Down,
		cd_Quals,
		cd_Wait,
		cd_ModeID,
		cd_ScrDepth,
		cd_ScrW,
		cd_ScrH,
		cd_App       : LongInt;
		cd_RexxCmd1,
		cd_RexxCmd2,
		cd_RexxCmd3  : String[180];
		cd_Rexxport1,
		cd_RexxPort2,
		cd_RexxPort3 : String[25];
		cd_Flush,
		cd_Test,
		cd_Rexx,
		cd_Wit,
		cd_NoClick,
		cd_WildStar,
		cd_Shanghai,
		cd_PopPubScr, 
		cd_DTImmed,
		cd_DTRepeat,
		cd_LogFile   : Boolean;
	end;
	
	{ constants for cd_ScrT }
CONST
	ST_RAM  = 0; (* Show RAM and Time *)
	ST_BACK = 1; (* Main window is backdrop *)
	ST_NONE = 2; (* 'Normal' *)
	ST_DT   = 3; (* Show image in the background *)
	{ for applicability of qualifiers }
	APP_ALL = 0;
	APP_ONE = 1;

VAR
	CD : tCData;
	
{$IFDEF PREFSEDITOR}

Procedure WriteString(VAR f : BPTR; s : String);
VAR
	err : LONG;
	
begin
	S := S+#10+#0; { add EOL and null term. }
	err := FPuts(f,@s[1]);
End;


Procedure WriteLong(VAR f : BPTR; n : LONG);
VAR
	err : LONG;
	s : String[50];
	
begin
	Str(n,s);
	S := S+#10+#0; { add EOL and null term. }
	err := FPuts(f,@s[1]);
End;

Procedure WriteBool(VAR f : BPTR; b : Boolean);
VAR
	err : LONG;
	S : String[5];
	
begin
	Str(Ord(b),s);
	S := S+#10+#0; { add EOL and null term. }
	err := FPuts(f,@s[1]);
End;

Function WriteConfigFile(FName : string) : Boolean;

VAR
	OutFile : BPTR; { Just save config as ascii, no need for iff }
	node    : pMyNode;
	OK : Boolean;
	
begin
	WriteConfigFile := False;
	FName := FName + #0;
	OutFile := Open(@FName[1], MODE_NEWFILE);
	If OutFile <> NULL then begin
		WriteString(OutFile, 'SM.Prefs file v1.0l ©LSK 1994.');
		WriteString(OutFile, '*** WARNING DONT EDIT BY HAND, THE GURU IS WAITING -- USE SMPREFS ***');
		node := pMyNode(currentlist^.lh_Head);
		while pMyNode(node^.LSK_Node.ln_Succ) <> NIL do begin
			WriteString(outfile, PtrToPas(@node^.LSK_Name[1]));
			WriteString(outfile, node^.LSK_Cmd[0]);
			WriteString(outfile, node^.LSK_Cmd[1]);
			WriteString(outfile, node^.LSK_Key);
			WriteString(outfile, node^.LSK_RexxCmd);
			WriteString(outfile, node^.LSK_RexxPort);
			WriteLong(outfile, node^.LSK_Priority);
			WriteLong(outfile, node^.LSK_Stack);
			WriteBool(outfile, node^.LSK_ASynch);
			WriteString(outfile, node^.LSK_Output);
			WriteBool(outfile, node^.LSK_NewShell);
			WriteString(outfile, node^.LSK_ShellFrom);
			WriteBool(outfile, node^.LSK_Quit);
			WriteString(outfile, node^.LSK_ShellWin);
			node := pMyNode(node^.LSK_Node.ln_Succ);
		end;
		WriteString(outfile,'*NODE END*');
		WriteString(OutFile, '');

		WriteString(outfile, PtrToPas(CD.cd_Font.ta_Name));
		WriteLong(OutFile, CD.cd_Font.ta_YSize);
		WriteLong(OutFile, CD.cd_Font.ta_Style);
		WriteLong(OutFile, CD.cd_Font.ta_Flags);
		WriteLong(OutFile, CD.cd_ModeID);
		WriteLong(OutFile, CD.cd_Across); 
		WriteLong(OutFile, CD.cd_Down);
		WriteString(OutFile, CD.cd_ScrTit);
		WriteString(OutFile, CD.cd_WinTit);
		WriteLong(OutFile, CD.cd_Pal[0]);
		WriteLong(OutFile, CD.cd_Pal[1]);
		WriteLong(OutFile, CD.cd_Pal[2]);
		WriteLong(OutFile, CD.cd_Pal[3]);
		WriteLong(OutFile, CD.cd_ScrH);
		WriteLong(OutFile, CD.cd_ScrW);
		WriteString(OutFile, CD.cd_RexxCmd1);
		WriteString(OutFile, CD.cd_RexxPort1);
		WriteString(OutFile, CD.cd_RexxCmd2);
		WriteString(OutFile, CD.cd_RexxPort2);
		WriteBool(Outfile, CD.cd_Wit);
		WriteBool(Outfile, CD.cd_Rexx);
		WriteBool(Outfile, CD.cd_NoClick);
		WriteLong(Outfile, CD.cd_ScrT);
		WriteBool(Outfile, CD.cd_Wildstar);
		WriteBool(Outfile, CD.cd_Shanghai);
		WriteBool(Outfile, CD.cd_PopPubScr);	
		WriteString(Outfile, PtrToPas(CD.cd_SFont.ta_Name));
		WriteLong(OutFile, CD.cd_SFont.ta_YSize);
		WriteLong(OutFile, CD.cd_SFont.ta_Style);
		WriteLong(OutFile, CD.cd_SFont.ta_Flags);
		WriteLong(OutFile, CD.cd_Quals);
		WriteLong(OutFile, CD.cd_Wait);	
		if CD.cd_Flush = True then
			WriteString(OutFile, 'TRUE')
		else
			WriteString(OutFile, 'FALSE');
		if CD.cd_Test = True then
			WriteString(OutFile, 'TRUE')
		else
			WriteString(OutFile, 'FALSE');
		WriteString(OutFile, CD.cd_RexxCmd3);
		WriteString(OutFile, CD.cd_RexxPort3);
		WriteString(OutFile, CD.cd_DT);
		WriteLong(OutFile, CD.cd_ScrDepth);
		WriteBool(Outfile, CD.cd_DTImmed);
		WriteBool(Outfile, CD.cd_DTRepeat);
		WriteLong(OutFile, CD.cd_App);
		WriteBool(Outfile, CD.cd_LogFile);
		WriteString(outfile,'*DEF END*');
		OK := AmigaDOS.close_(outfile);
		WriteConfigFile := True;
	end;
end;

{$ENDIF}


Procedure ReadString(VAR f : BPTR; VAR S : String);

VAR
	buf : STRPTR;

begin
	buf := FGets(f,@S,Sizeof(s));
	If buf <> NIL then begin
		S := PtrToPas(buf);
		if S[Length(S)] = #10 then
			S := Copy(S,1,Length(S)-1);
	end;
end;

Procedure ReadLong(VAR f : BPTR; VAR n : LONG);

VAR
	s : String[50];
	err : Integer;
	
begin
	ReadString(f, s);
	Val(s,n,err);
end;

Procedure ReadBool(VAR f : BPTR; VAR b : Boolean);

VAR
	s : String[10];
	n : LONG;
	err : Integer;

begin
	ReadString(f, s);
	Val(s,n,err);
	if err = 0 then begin
		if n = 1 then
			b := True
		else
			b := False;
	end else 
		b := False;
end;

Function ReadConfigFile(FName : string) : Boolean;

TYPE
	FileV = (NONVALID, V100, V101, V102, V103, V104, V105, 
	         V106, V107, V108, V109, V10a, V10b, V10c, V10d, V10e, V10f,
	         V10g, V10h, V10i, V10j, V10k, V10l);
VAR
	INTextF : BPTR; { Just save config as ascii, no need for iff }
	node    : pMyNode;
	tmpStr  : String[190];
	err     : integer;
	rc, OK  : Boolean;
	FileVer : FileV;
	tmpbyte : byte;
	ti      : LONG;
	
begin
	rc := False; { Set default exit }
	FName := FName+#0; { null term. }
	INTextF := Open(@FName[1], MODE_OLDFILE);
	if INTextF <> 0 then begin
		ReadString(INTextF, TmpStr);
		if copy(tmpstr, 1, 18) = 'SM.Prefs file v1.0' then begin
			Case tmpstr[19] of
				'l' : FileVer := V10l;
				'k' : FileVer := V10k;
				'j' : FileVer := V10j;
				'i' : FileVer := V10i;
				'h' : FileVer := V10h;
				'g' : FileVer := V10g; 
				'f' : FileVer := V10f;
				'e' : FileVer := V10e;
				'd' : FileVer := V10d;
				'c' : FileVer := V10c;
				'b' : FileVer := V10b;
				'a' : FileVer := V10a;
				'9' : FileVer := V109;
				'8' : FileVer := V108;
				'7' : FileVer := V107;
				'6' : FileVer := V106;
				'5' : FileVer := V105;
				'4' : FileVer := V104;
				'3' : FileVer := V103;
				'2' : FileVer := V102;
				'1' : FileVer := V101;
				'0' : FileVer := V100;
				else FileVer := NONVALID
			end;
			If fileVer <> NONVALID then begin
				CurrentList := AllocRemember(@RememberKey, sizeof(tList), MEMF_CLEAR);
				if CurrentList <> NIL then begin
					newlist(currentlist);
					if FileVer >= V10a then
						ReadString(INTextF, TmpStr);
					ReadString(INTextF, TmpStr);
					While TmpStr <> '*NODE END*' do begin
						{ Get node mem }
						node := AllocRemember(@RememberKey, Sizeof(tMyNode), MEMF_CLEAR OR MEMF_PUBLIC);
						If node <> NIL then begin
							node^.LSK_Name := TmpStr+#0;
							if FileVer > V101 then begin
								ReadString(INTextF, node^.LSK_Cmd[0]);
								ReadString(INTextF, node^.LSK_Cmd[1]);
							end else begin
								node^.LSK_Cmd[0] := ''#0;
								ReadString(INTextF, node^.LSK_Cmd[1]);
							end;
							if UpperStr(node^.LSK_Cmd[1]) = 'NONE' then
								node^.LSK_Cmd[1] := 'COMMENT';
								
							ReadString(INTextF, node^.LSK_Key);
				
							if FileVer >= V103 then begin
								ReadString(INTextF, node^.LSK_RexxCmd);
								ReadString(INTextF, node^.LSK_RexxPort);
							end else begin
								node^.LSK_RexxCmd := ''; 
								node^.LSK_RexxPort := ''; 
							end; 
							if FileVer >= V105 then begin
								ReadLong(INTextF, node^.LSK_Priority);
								if node^.LSK_Priority > 127 then node^.LSK_Priority := 127;
								if node^.LSK_Priority < -128 then node^.LSK_Priority := -128;
								ReadLong(INTextF, node^.LSK_Stack);
								ReadBool(INTextF, node^.LSK_ASynch);
							end else begin
								node^.LSK_Priority := 0;
								node^.LSK_Stack := 4096;
								node^.LSK_ASynch := False;
							end;
				
							if FileVer >= V106 then
								ReadString(INTextF, node^.LSK_Output)
							else
								node^.LSK_Output := 'CON:0/11/640/150/Startup-Menu Command/AUTO/CLOSE/WAIT/ALT0/11/80/50';
					

							if FileVer >= V10c then begin
								ReadBool(INTextF, node^.LSK_NewShell);
								ReadString(INTextF, node^.LSK_ShellFrom);
								ReadBool(INTextF, node^.LSK_Quit);
							end else begin
								node^.LSK_NewShell := False;
								node^.LSK_ShellFrom := '';
								node^.LSK_Quit := True;
							end;
			 	
							If FileVer >= V10g then
								ReadString(INTextF, node^.LSK_ShellWin)
							else
								node^.LSK_ShellWin := '';
			 				 		
							node^.LSK_Node.ln_Name := @node^.LSK_Name[1];
							node^.LSK_Node.ln_Type := NT_USER;
							node^.LSK_Node.ln_Pri  := 0;
							AddTail(CurrentList, pNode(node));
						end;
						ReadString(INTextF, TmpStr);
					end;
		
					ReadString(INTextF, tmpstr);
					ReadString(INTextF, tmpStr);
					CD.cd_FontName := tmpstr + #0;
					CD.cd_Font.ta_Name := @CD.cd_FontName[1];
					ReadLong(INTextF, ti);
					CD.cd_Font.ta_YSize := ti;
					ReadLong(INTextF, ti);
					CD.cd_Font.ta_Style := ti;
					ReadLong(INTextF, ti);
					CD.cd_Font.ta_Flags := ti;
					ReadLong(INTextF, CD.cd_ModeID);
					ReadLong(INTextF, CD.cd_Across);
					ReadLong(INTextF, CD.cd_Down); 
					ReadString(INTextF, CD.cd_ScrTit);
					ReadString(INTextF, CD.cd_WinTit);
					ReadLong(INTextF, ti);
					CD.cd_Pal[0] := ti;
					ReadLong(INTextF, ti);
					CD.cd_Pal[1] := ti;
					ReadLong(INTextF, ti);
					CD.cd_Pal[2] := ti;
					ReadLong(INTextF, ti);
					CD.cd_Pal[3] := ti;
					if FileVer >= V102 then begin
						ReadLong(INTextF, CD.cd_ScrH);
						ReadLong(INTextF, CD.cd_ScrW);
					end else begin
						CD.cd_ScrH := 200;
						CD.cd_ScrW := 640;
					end;
					if FileVer >= V103 then begin
						ReadString(INTextF, CD.cd_RexxCmd1);
						ReadString(INTextF, CD.cd_RexxPort1);
						ReadString(INTextF, CD.cd_RexxCmd2);
						ReadString(INTextF, CD.cd_RexxPort2);
					end else begin
						CD.cd_RexxCmd1  := 'id SM_INITIAL';
						CD.cd_RexxPort1 := 'PLAY';
						CD.cd_RexxCmd2  := 'id SM_EXIT';
						CD.cd_RexxPort2 := 'PLAY';
					end;
					if FileVer >= V104 then begin
						ReadBool(INTextF, CD.cd_Wit);
						ReadBool(INTextF, CD.cd_Rexx);
					end else begin
						CD.cd_Wit := True;
						CD.cd_Rexx := True;
					end;
					if FileVer >= V107 then
						ReadBool(INTextF, CD.cd_NoClick)
					else
						CD.cd_NoClick := True;
					
					if FileVer >= V108 then
						ReadLong(INTextF, CD.cd_ScrT)
					else
						CD.cd_ScrT := 0;
								 	
					if FileVer >= V109 then begin
						ReadBool(INTextF, CD.cd_WildStar);		
						ReadBool(INTextF, CD.cd_Shanghai); 	
						ReadBool(INTextF, CD.cd_PopPubScr);	
					end else begin
						CD.cd_WildStar := False;
						CD.cd_Shanghai := True;
						CD.cd_PopPubScr := True;
					end;
							    
					If FileVer >= V10b then begin
						ReadString(INTextF, tmpStr);
						CD.cd_SFontName := tmpstr + #0;
						CD.cd_SFont.ta_Name := @CD.cd_SFontName[1];
						ReadLong(INTextF, ti);
						CD.cd_SFont.ta_YSize := ti;
						ReadLong(INTextF, ti);
						CD.cd_SFont.ta_Style := ti;
						ReadLong(INTextF, ti);
						CD.cd_SFont.ta_Flags := ti;
					end else begin
						CD.cd_SFontName := 'topaz.font'#0;
						CD.cd_SFont.ta_Name := @CD.cd_SFontName[1];
						CD.cd_SFont.ta_YSize := 8;
						CD.cd_SFont.ta_Style := FS_NORMAL;
						CD.cd_SFont.ta_Flags := FPF_ROMFONT;
					end;
					If FileVer >= V10c then
						ReadLong(INTextF, CD.cd_Quals)
					else
						CD.cd_Quals := 0;
								 	
					If FileVer >= V10d then begin
						ReadLong(INTextF, CD.cd_Wait);
						if CD.cd_Wait < 0 then
							CD.cd_Wait := 0;
					end else
						CD.cd_Wait := 0;
								 		
					CD.cd_Flush := True; 
					CD.cd_Test := False;
					If FileVer >= V10e then begin
						ReadString(INTextF, tmpStr);
						if TmpStr = 'FALSE' then
							CD.cd_Flush := False;
						ReadString(INTextF, tmpStr);
						if TmpStr = 'TRUE' then 
							CD.cd_Test := True;
					end;
					    
					if FileVer >= V10f then begin
						ReadString(INTextF, CD.cd_RexxCmd3);
						ReadString(INTextF, CD.cd_RexxPort3);
					end else begin
						CD.cd_RexxCmd3  := 'id SM_PRECMD';
						CD.cd_RexxPort3 := 'PLAY';
					end;
					
					if FileVer >= V10h then
						ReadString(INTextF, CD.cd_DT)
					else
						CD.cd_DT := '';
					
					if FileVer >= V10i then
						ReadLong(INTextF, CD.cd_ScrDepth)
					else
						CD.cd_ScrDepth := 2;
						
					if FileVer >= V10j then begin
						ReadBool(INTextF, CD.cd_DTImmed);
						ReadBool(INTextF, CD.cd_DTRepeat);
					end else begin
						CD.cd_DTImmed := True;
						CD.cd_DTRepeat := True;
					end;
					
					if FileVer >= V10k then begin
						ReadLong(INTextF, CD.cd_App);
					end else begin
						CD.cd_App := APP_ALL;
					end;
					
					if FileVer >= V10l then begin
						ReadBool(INTextF, CD.cd_LogFile);
					end else begin
						CD.cd_LogFile := False;
					end;
					
					OK := AmigaDOS.Close_(INTextF);
					rc := True;
				end;
			end else begin
				OK := AmigaDOS.Close_(INTextF);
			End;
		end else begin
			OK := AmigaDOS.Close_(INTextF);
		End;
	end;
	ReadConfigFile := rc;
end;



