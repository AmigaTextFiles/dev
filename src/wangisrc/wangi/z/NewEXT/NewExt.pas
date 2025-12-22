PROGRAM NewExt;

{$F-,I-,R-,S-,V-,M 5,1,1,15}

USES DOS, AmigaDOS, Amiga, Exec, Intuition;   
				{ CLI utility to change multiple files extensions }

{ ================================ }

FUNCTION ParseArgs(VAR wldcrd, ext : string; VAR Front, Infos : Boolean) : BOOLEAN;

VAR
	Template : String;
	n        : Byte;
	RDArg    : pRDArgs;
	TmpInt   : ^LongInt;
	V2       : Boolean;
	
CONST
	RD_Array : Array[0..4] of LongInt = (0);
	INFO = 4;

BEGIN
	Template := 'WILDCARD/A,EXTENSION/A,FRONT/S,HELP/S,INFOS/S'#0;
	            
	If pExecBase(SysBase)^.LibNode.lib_Version >= 36 then V2 := True else V2 := False;
	
	If V2 then begin
		{ WB 2 or greater :-) }
		RDArg := AllocDosObject(DOS_RDARGS,NIL);
		If RDArg <> NIL then begin
			RDArg := ReadArgs(@Template[1],@RD_Array,RDArg);
			
			if RD_Array[0] <> 0 then
				wldcrd := PtrToPas(Pointer(RD_Array[0]));
				
			if RD_Array[1] <> 0 then
				ext := PtrToPas(Pointer(RD_Array[1]));
				
			if RD_Array[2] <> 0 then Front := True else Front := false;
			
			if RD_Array[INFO] <> 0 then Infos := True else Infos := false;
			
			if RD_Array[3] <> 0 then begin
				Writeln('NewEXT ©Lee Kindness'#10+
	                 ''#10+
	                 'Batch changes the extensions of files.'#10+
	                 'eg. NewEXT #?.PIC .ILBM will change the extension of all #?.PIC to .ILBM'#10+
	                 '    NewEXT mod.#? pt3. FRONT will change the front ext of all mod.#? to pt3.');
	         Writeln('    NewEXT (#?.samp|#?.sfx) .8SVX will change all #?.samp and #?.sfx to .8SVX'#10+
	                 ''#10+
	                 template);
	      end;
		
			FreeArgs(RDArg);
			FreeDosObject(DOS_RDARGS,RDArg);
		
		end;
	end;
	If (RD_Array[3] = 0) and (RD_Array[0] <> 0) and (RD_Array[1] <> 0) then 
		ParseArgs := True
	else
		ParseArgs := False; 
END;

{ ================================ }

PROCEDURE DoTheNaming(wldcrd,ext : String; Front, Infos : Boolean;
							VAR counter : INTEGER);
							
TYPE
	pNameNode = ^tNameNode;
	tNameNode = Record
		nn_Node : tMinNode;
		nn_Name : String[180];
	end;
	
CONST
	Header : String[13] = 'Can''t rename'#0;
	
VAR
	NewName,DirBit,NameBit,ExtBit,outinitialname,
	InfoName, NewInfoName : string;
	OK, renameok, nobreak : boolean;
	ap                    : pAnchorPath;
	rc, Signals           : Longint;
	list                  : pMinList;
	node                  : pNameNode;
	rk                    : pRemember;
	tmp                   : String[180];
	n                     : byte;
	MyIO                  : Integer;

BEGIN
	nobreak := true;
	rk := NIL;
	wldcrd := wldcrd+#0;
	ap := AllocRemember(@rk, Sizeof(tAnchorPath)+255,MEMF_PUBLIC|MEMF_CLEAR);
	list := AllocRemember(@rk, Sizeof(tList),MEMF_PUBLIC|MEMF_CLEAR);
	if (ap <> NIL) and (list <> NIL) then begin
		NewList(pList(list));
		AP^.ap_BreakBits := SIGBREAKF_CTRL_C;
		AP^.ap_Strlen := 255;
		rc := MatchFirst(@wldcrd[1], ap);
		While rc = 0 do begin
			{ Problem : we cant just rename files in the match loop, they may be }
			{ rematched by MatchNext(), creating a neverending loop! Read them   }
			{ into a list instead                                                }
			if ap^.ap_Info.fib_DirEntryType < 0 then begin
				node := allocRemember(@rk, sizeof(tNameNode),MEMF_CLEAR|MEMF_PUBLIC);
				if node <> NIL then begin
				
					tmp := PtrToPAs(@ap^.ap_buf);
					node^.nn_Name := tmp;
				
					AddTail(pList(list),pNode(node));
				end else
					DisplayBeep(NIL);
			end;
						
			rc := MatchNext(Ap);
		end;
		{read files from list}
		node := pNameNode(list^.mlh_Head);
		While (node^.nn_Node.mln_Succ <> NIL) and (nobreak) do begin
			renameok := false;
			
			outInitialName := node^.nn_Name + ' ';
			
			FOR n := (length(outinitialname)+1) TO 30 DO 
				outinitialname := outinitialname + '.'; { pad to make output nicer }
			
			if Front then begin
				{ find first . }
				n := pos('.',node^.nn_Name);
				if n <> 0 then begin
					renameok := true;
					extbit := copy(node^.nn_Name,1,n);
					namebit := copy(node^.nn_Name,n+1,length(node^.nn_Name)-n);
					newname := ext+namebit+#0;
					NewInfoName := ext+namebit+'.info'+#0;
				end;
			end else begin
				FSPLIT(node^.nn_Name,DirBit,NameBit,ExtBit); { split name into individual bits }
				NewName := DirBit+NameBit+ext+#0; { and glue new name together }
				NewInfoName := DirBit+NameBit+ext+'.info'+#0;
				renameok := true; 
			end;
			
			if renameok then begin
				InfoName := node^.nn_Name+'.info'#0;
				node^.nn_Name := node^.nn_Name+#0;
				WRITE(' ',outinitialname,' ');
				OK := RENAME_(@node^.nn_Name[1], @NewName[1]);
				
				myIO := IOErr;
				if myIO = 0 then begin
			 	 	WRITELN(newname);
				 	counter := counter + 1; { changed the name of 1 more file }
				end else begin
					Delay(30);
					If NOT PrintFault(myIO, @Header[1]) then Writeln; 
				end;
				If Infos then
					if NOT Rename_(@InfoName[1], @NewInfoName[1]) then 
						Ok := PrintFault(IOErr, NIL);
			end;

			signals := SetSignal(0,0);
			{ check for Ctrl-C break by user }
			If (Signals and SIGBREAKF_CTRL_C) <> 0 then begin
				Writeln('***Break');
				NoBreak := False;
				Signals := SetSignal(0,SIGBREAKF_CTRL_C);
			end;
	
			node := pNameNode(node^.nn_Node.mln_Succ);
		end;
		FreeRemember(@rk,true);
	end;
end;

{ ================================ }
{ ================================ }	 	

PROCEDURE Main;

CONST 
	ver    : string[28] = '$VER: NewExt 1.5 (13.11.95)'#0;
	 	                { string to be given by version command }
VAR 
	wldcrd, ext  : String;
	Front, infos : Boolean;
	counter      : INTEGER;


BEGIN
	counter := 0;
	IntuitionBase := pIntuitionBase(OpenLibrary('intuition.library',0));
	if (IntuitionBase <> NIL) and (pLibrary(DOSBase)^.lib_Version >= 36) then begin
		IF ParseArgs(wldcrd,ext,Front, Infos) THEN BEGIN
			DoTheNaming(wldcrd,ext,front,infos,counter); { rename and find next matches }
			CASE Counter OF
				0  : WRITELN('No File extensions changed.');
				1  : WRITELN('1 file extension changed.');
				ELSE WRITELN(counter,' file extensions changed.');
			END; {case} { print out some crap at the end }
		END ELSE begin
			if NOT PrintFault(IOErr, NIL) then begin end;
			HALT(10); { exit if the parameters were invalid }
		end;
		CloseLibrary(pLibrary(IntuitionBase));
	end;
END; {main}
{ ================================ }
BEGIN main END.
{ ================================ }