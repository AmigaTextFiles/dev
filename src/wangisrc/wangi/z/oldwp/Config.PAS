TYPE
	tCData = Record
		cd_Font      : tTextAttr;
		cd_TFont     : pTextFont;
		cd_ScrTit,
		cd_WinTit,
		cd_PubScreen : STRPTR;
		cd_LeftEdge,
		cd_TopEdge,
		cd_Width,
		cd_Height,
		cd_Level,
		cd_SWid,
		cd_Selection : LongInt;
	end;
	
	pMyNode = ^tMyNode;
	tMyNode = record
		wi_Node     : tNode; { system node structure }
		wi_Cmd      : array[0..1] of STRPTR;
		wi_RexxCmd,
		wi_RexxPort,
		wi_OutPut,
		wi_HotKey   : STRPTR;
		wi_Stack,
		wi_Priority,
		wi_Type,
		wi_Flags    : LongInt;
	end;
	
	tLMode = (LM_APPEND,LM_LOAD);
	
CONST
	WIF_RESERVED = 1;
	WIF_TOOLMENU = 2;
	WIF_EDITCMD  = 4;
	
	LEV_FLOAT = 0;
	LEV_BACKD = 1;
	LEV_BACKM = 2;
	LEV_FRONT = 3;
	LEV_NOBOR = 4;
	
	TYPE_SHELL = 0;
	TYPE_WB    = 1;
	TYPE_AREXX = 2;
	TYPE_COMNT = 3;
	
	SEL_DOUBLE = 0;
	SEL_SINGLE = 1;
	
VAR
	CD : tCData;
	
{$IFDEF PREFSEDITOR}

Procedure WriteSTRPTR(VAR f : BPTR; s : STRPTR);
VAR
	err : LONG;
	s2  : String;
	
begin
	S2 := PtrToPas(S)+#10+#0; { add EOL and null term. }
	err := FPuts(f,@s2[1]);
End;

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
		WriteString(OutFile, 'WangiPrefs file v6 ©LSK 94-95.');
		WriteString(OutFile, '*** WARNING DONT EDIT BY HAND, THE GURU IS WAITING -- USE WANGIPREFS ***');
		node := pMyNode(currentlist^.lh_Head);
		while pMyNode(node^.wi_Node.ln_Succ) <> NIL do begin
			WriteSTRPTR(outfile, node^.wi_Node.ln_Name);
			WriteSTRPTR(outfile, node^.wi_Cmd[0]);
			WriteSTRPTR(outfile, node^.wi_Cmd[1]);
			WriteSTRPTR(outfile, node^.wi_RexxCmd);
			WriteSTRPTR(outfile, node^.wi_RexxPort);
			WriteLong(outfile, node^.wi_Priority);
			WriteLong(outfile, node^.wi_Stack);
			WriteSTRPTR(outfile, node^.wi_Output);
			WriteLong(outfile, node^.wi_Type);
			WriteSTRPTR(outfile, node^.wi_HotKey);
			WriteLong(outfile, node^.wi_Flags);
			node := pMyNode(node^.wi_Node.ln_Succ);
		end;
		WriteString(outfile,'*NODE END*');
		WriteString(OutFile, '');

		WriteSTRPTR(outfile, CD.cd_Font.ta_Name);
		WriteLong(OutFile, CD.cd_Font.ta_YSize);
		WriteLong(OutFile, CD.cd_Font.ta_Style);
		WriteLong(OutFile, CD.cd_Font.ta_Flags);
		WriteSTRPTR(OutFile, CD.cd_ScrTit);
		WriteSTRPTR(OutFile, CD.cd_WinTit);
		WriteSTRPTR(OutFile, CD.cd_PubScreen);
		WriteLong(OutFile, CD.cd_LeftEdge);
		WriteLong(OutFile, CD.cd_TopEdge);
		WriteLong(OutFile, CD.cd_Width);
		WriteLong(OutFile, CD.cd_Height);
		WriteLong(OutFile, CD.cd_Level);
		WriteLong(OutFile, CD.cd_SWid);
		WriteLong(OutFile, CD.cd_Selection);
		WriteString(outfile,'*DEF END*');
		OK := AmigaDOS.close_(outfile);
		WriteConfigFile := True;
	end;
end;

{$ENDIF}


Procedure ReadString(VAR f : BPTR; rk : ppRemember; VAR DS : STRPTR);

VAR
	buf : STRPTR;
	s   : String;

begin
	buf := FGets(f,@S,Sizeof(s));
	If buf <> NIL then begin
		S := PtrToPas(buf);
		if S[Length(S)] = #10 then
			S := Copy(S,1,Length(S)-1);
		DS := CStrConstPtrAR(rk, s);
	end;
end;

Procedure ReadLong(VAR f : BPTR; VAR n : LONG);

VAR
	s   : String[50];
	err : Integer;
	buf : STRPTR;

begin
	n := 0;
	buf := FGets(f,@S,Sizeof(s));
	If buf <> NIL then begin
		S := PtrToPas(buf);
		Val(s,n,err);
	End;
end;

Procedure ReadBool(VAR f : BPTR; VAR b : Boolean);

VAR
	s   : String[10];
	n   : LONG;
	err : Integer;
	buf : STRPTR;

begin
	b := False;
	buf := FGets(f,@S,Sizeof(s));
	If buf <> NIL then begin
		S := PtrToPas(buf);
		Val(s[1],n,err);
		if err = 0 then begin
			if n = 1 then
				b := True
			else
				b := False;
		end;
	End;
end;

Function ReadConfigFile(FName : string; mode : tLMode; RK : pRemember) : Boolean;

TYPE
	FileV = (NONVALID, V0, V1, V2, V3, V4, V5, V6);
VAR
	INTextF : BPTR; { Just save config as ascii, no need for iff }
	node    : pMyNode;
	tmpStr  : String;
	ts      : STRPTR;
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
		ReadString(INTextF,@RK, ts);
		tmpstr := PtrToPas(ts);
		
		if copy(tmpstr, 1, 17) = 'WangiPrefs file v' then begin
			Case tmpstr[18] of
				'6' : FileVer := V6;
				'5' : FileVer := V5;
				'4' : FileVer := V4;
				'3' : FileVer := V3;
				'2' : FileVer := V2;
				'1' : FileVer := V1;
				'0' : FileVer := V0;
				else FileVer := NONVALID
			end;
			If fileVer <> NONVALID then begin
				If mode = LM_LOAD then
					CurrentList := AllocRemember(@RK, sizeof(tList), MEMF_CLEAR);
				if CurrentList <> NIL then begin
					If mode = LM_LOAD then
						newlist(currentlist);
					ReadString(INTextF, @RK, ts);
					ReadString(INTextF, @RK, ts);
					While PtrToPas(ts) <> '*NODE END*' do begin
						{ Get node mem }
						node := AllocRemember(@RK, Sizeof(tMyNode), MEMF_CLEAR);
						If node <> NIL then begin
							node^.wi_Node.ln_Name := ts;
							ReadString(INTextF, @RK, node^.wi_Cmd[0]);
							ReadString(INTextF, @RK, node^.wi_Cmd[1]);
							ReadString(INTextF, @RK, node^.wi_RexxCmd);
							ReadString(INTextF, @RK, node^.wi_RexxPort);
							ReadLong(INTextF, node^.wi_Priority);
							if node^.wi_Priority > 127 then 
								node^.wi_Priority := 127;
							if node^.wi_Priority < -128 then 
								node^.wi_Priority := -128;
							ReadLong(INTextF, node^.wi_Stack);
							ReadString(INTextF, @RK, node^.wi_Output);
							If FileVer >= V2 then 
								Readlong(INTextF, node^.wi_Type)
							else
								node^.wi_Type := TYPE_SHELL;
							If FileVer >= V4 then
								ReadString(INTextF, @RK, node^.wi_HotKey)
							else
								node^.wi_HotKey := CStrConstPtrAR(@RK, '');
							
							If FileVer >= V5 then Begin
								If FileVer >= V6 then
									Readlong(INTextF, node^.wi_Flags)
								else begin
									ReadBool(INTextF, ok);
									If ok then
										node^.wi_Flags := WIF_TOOLMENU
									else
										node^.wi_Flags := 0;
								End;
							End else
								node^.wi_Flags := 0;
							
							node^.wi_Node.ln_Type := NT_USER;
							node^.wi_Node.ln_Pri  := 0;
							AddTail(CurrentList, pNode(node));
						end;
						ReadString(INTextF, @RK, ts);
					end;
							
					If mode = LM_LOAD then Begin
						ReadString(INTextF, @RK, ts);
						ReadString(INTextF, @RK, CD.cd_Font.ta_Name);
						ReadLong(INTextF, ti);
						CD.cd_Font.ta_YSize := ti;
						ReadLong(INTextF, ti);
						CD.cd_Font.ta_Style := ti;
						ReadLong(INTextF, ti);
						CD.cd_Font.ta_Flags := ti;
						{ open font }
						CD.cd_TFont := OpenDiskFont(@CD.cd_Font);
						If CD.cd_TFont = NIL then begin
							{ fakus font, use topaz 8 }
							With CD.cd_Font do begin
								ta_Name := CStrConstPtrAR(@RK, 'topaz.font');
								ta_YSize := 8;
								ta_Flags := FPF_ROMFONT;
							End;
							CD.cd_TFont := OpenDiskFont(@CD.cd_Font);
						End;
						ReadString(INTextF, @RK, CD.cd_ScrTit);
						ReadString(INTextF, @RK, CD.cd_WinTit);
						ReadString(INTextF, @RK, CD.cd_PubScreen);
						ReadLong(INTextF, CD.cd_LeftEdge);
						ReadLong(INTextF, CD.cd_TopEdge);
						ReadLong(INTextF, CD.cd_Width);
						ReadLong(INTextF, CD.cd_Height);
						If FileVer >= V1 then 
							ReadLong(INTextF, CD.cd_Level)
						else
							cd.cd_Level := LEV_FLOAT;
						
						If FileVer >= V3 then 
							ReadLong(INTextF, CD.cd_SWid)
						else
							cd.cd_SWid := 16; 
						
						If FileVer >= V4 then
							ReadLong(INTextF, CD.cd_Selection)
						else
							CD.cd_Selection := SEL_DOUBLE;
						
						ReadString(INTextF, @RK, ts);
						tmpstr := PtrToPas(ts);
						If tmpstr = '*DEF END*' then
							rc := True
						else
							rc := False;
					End else
						rc := True;
										
					OK := AmigaDOS.Close_(INTextF);
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



