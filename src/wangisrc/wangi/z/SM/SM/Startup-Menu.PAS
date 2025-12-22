{$F-,I-,R-,S-,V-,M 7,1,5,15}

{$I SM.h }

Procedure Main;

CONST
	rc        : shortint = 10;
	RD_Array  : Array[1..2] of LongInt = (0,0);
	Template  : String[19] = 'PREFSFILE,NOQUAL/S'#0;
	PREFSFILE = 1;
	NOQUAL = 2;
	waitpointerdata : tPointerArray = ($0000, $0000,

                                      $0400, $07c0,
                                      $0000, $07c0,
                                      $0100, $0380,
                                      $0000, $07e0,
                                      $07c0, $1ff8,
                                      $1ff0, $3fec,
                                      $3ff8, $7fde,
                                      $3ff8, $7fbe,
                                      $7ffc, $ff7f,
                                      $7efc, $ffff,
                                      $7ffc, $ffff,
                                      $3ff8, $7ffe,
                                      $3ff8, $7ffe,
                                      $1ff0, $3ffc,
                                      $07c0, $1ff8,
                                      $0000, $07e0,

                                      $0000, $0000); 
VAR
	s     : String;
	ok    : boolean;
	n     : integer;
	RDArg : pRDArgs;
	tn    : pMyNode;
	port  : pMsgPort;
	ior   : PIORequest;
	
	pq : LONG;
	
Begin
	{ open libraries }
	if Open_Libs then begin
		begin
			{ alloc chip mem for waitpointer }
			waitpointer := AllocRemember(@RememberKey, sizeof(tPointerArray), MEMF_CHIP);
			if waitpointer <> NIL then begin
				{ copy data into memory }
				WaitPointer^ := WaitpointerData;
				OK := false;

				s := PREFSDIRH+PREFSNAME;
				FORCEQ := false;
				RDArg := NIL;
				If CmdLinePtr.Len >= 1 then begin
					RDArg := ReadArgs(@Template[1],@RD_Array,NIL);
					If RDArg <> NIL then begin
						if RD_Array[PREFSFILE] <> 0 then 
							s := PtrToPas(Pointer(RD_Array[PREFSFILE]));
					
						if RD_Array[NOQUAL] <> 0 then FORCEQ := True;
					End;
				End;

				if ReadConfigFile(s) then begin
				
					if (CD.cd_Test = False) then begin
						ToggleClick(CD.cd_NoClick);
						ToggleWildStar(CD.cd_WildStar);
						TogglePubFlags(CD.cd_Shanghai, CD.cd_PopPubScr);
					end;
				
					OK := False;
					If NOT FORCEQ then begin
						port := CreateMsgPort;
						if port <> NIL then begin
							ior := CreateIORequest(port, Sizeof(tIORequest));
							if ior <> NIL then begin
								if OpenDevice('input.device', 0, ior, 0) = 0 then begin
									InputBase := pLibrary(ior^.io_Device);
									pq := PeekQualifier;
									if CD.cd_Quals <> 0 then begin
										Case CD.cd_App of
											APP_ALL : begin
												if pq and CD.cd_Quals = CD.cd_Quals then
												OK := True;
											End;
											APP_ONE : begin
												if pq and CD.cd_Quals <> 0 then
												OK := True;
											End;
											Else OK := True;
										End;
									end else
										OK := True;
									CloseDevice(ior);
								end;
								DeleteIORequest(ior);
							end;
							DeleteMsgPort(port);
						end;
					end else OK := True;
				
					FreeArgs(RDArg);
				
					InitLogFile(lf, CD.cd_LogFIle);
					
					if OK then begin
						if CurrentList^.lh_Head^.ln_Succ <> NIL then begin
							
							InitRequester(@DummyReq);
							If CD.cd_Test then begin
								ReqToolsBase := pReqToolsBase(OpenLibrary(REQTOOLSNAME,REQTOOLSVERSION));
								If ReqToolsBase = NIL Then 
									CD.cd_Test := False;
							end;
							if CD.cd_Wit then
								CD.cd_WitTxt := GetWitComment
							else
								CD.cd_WitTxt := '';
						
							TheScreen := Open_Screen;
							if TheScreen <> NIL then begin
								if CD.cd_Rexx then
									SendARexxCommand(CD.cd_RexxCmd1, CD.cd_RexxPort1);
								TheWindow := Open_Window;
								if TheWindow <> NIL then begin
									rc := HandleIDCMP;
									Close_window;
								end;
								if CD.cd_Rexx then
									SendARexxCommand(CD.cd_RexxCmd2, CD.cd_RexxPort2);
								Close_Screen;
							end;
							if CD.cd_Test then CloseLibrary(pLibrary(ReqtoolsBase));
						end;{ else writeln('list empty');}
					end else WriteLogFile(lf, NIL, True);
					FreeLogFile(lf);
				end;
			end;
		end;
		If CD.cd_Flush then begin
			tn := AllocRemember(@RememberKey, sizeof(tMyNode), MEMF_CLEAR);
			if tn <> NIL then begin
				tn^.LSK_Cmd[0] := 'C:';
				tn^.LSK_Cmd[1] := 'Avail FLUSH';
				tn^.LSK_Output := 'NIL:';
				tn^.LSK_Asynch := False;
				
				ok := StartCLIProgram(tn);
			end;
		end;
		FreeRemember(@RememberKey, True);
		Close_Libs;
	end;
	halt(rc);
end;
 
begin main end.