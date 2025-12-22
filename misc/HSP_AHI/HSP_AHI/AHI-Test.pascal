program AHITest;
uses Exec, AHI;

{ **************************************************************	}
{ 1. READ the program comments and adjust code before compiling		}
{ 2. BE SURE the AHI preferences are correctly set up				}
{ 3. this program needs AHI v4 at least, which has the hi-level API	}
{ by Daniel Mealha Cabrita (dancab@polbox.com)						}
{ November 1997														}

procedure AnyKey;
var
	erty	: string;

begin
	writeln ('Press [enter]..');
	readln (erty);
end;

{ adjusts PC byte-format (0, 255) to Amiga (-128, +127)	}
procedure Adjust8bitSample (Oinic: pointer; Taman: longint);
begin
	asm
		move.l Oinic, a0
		move.l Taman, d1
		
		@reppx:
		move.b (a0), d0
		add.b #126, d0
		move.b d0, (a0)+
		sub.l #1, d1
		bnz @reppx
	end;
end;

procedure RotPrinc;
var
	{ChupaC	: array [0..1000000] of byte;}
	pChupaC : pointer;
	chupafile	: file;
	TamCC	: longint;

	ArqRep	: longint;
	OutroP	: pointer;	

	pAHI_MP	: pMsgPort;
	pAHIReq	: pAHIRequest;

const
	nomewav	= 'dh1:this_is_my_sample.wav';	{ ***** SET SAMPLENAME HERE!!!!	}
											{ MUST BE 8-bit MONO	}

begin
	assign  (chupafile, nomewav);
	reset (chupafile);
	writeln ('allocating memory..');
	TamCC := filesize (chupafile);
	pChupaC := AllocVec (TamCC, MEMF_PUBLIC);
	if (pChupaC = NIL) then
	begin
		writeln ('could not allocate memory..');
		close (chupafile);
		exit;
	end;
	writeln ('position: ', longint (pChupaC));
	writeln ('size: ', TamCC);

	ArqRep := TamCC;
	OutroP := pChupaC;
	while (ArqRep > 32000) do
	begin
		blockread (chupafile, OutroP^, 32000);
		ArqRep := ArqRep - 32000;
		asm
			add.l #32000, OutroP		
		end;
	end;
	blockread (chupafile, OutroP^, ArqRep);

	close (chupafile);
	writeln ('sample loaded in memory.');

	{ ******* UNcomment these following two lines is sample is WAV format	}

	{Adjust8bitSample (pChupaC, TamCC);}
	{writeln ('sample byte-style adjusted to Amiga format.');}

	pAHI_MP := CreateMsgPort;
	if (pAHI_MP <> NIL) then
	begin
		writeln ('msgport.. ');
		pAHIReq := pAHIRequest (CreateIORequest (pAHI_MP, sizeof (tAHIRequest)));
		if (pAHIReq <> NIL) then
		begin
			writeln ('iorequest created..');
			pAHIReq^.ahir_Version := 4;
			if (OpenDevice ('ahi.device', 0, pIORequest (pAHIReq), 0) = 0) then
			begin
				{ conseguiu alocar !!!	}
				writeln ('ahi allocated!');
				AHIBase := pLibrary (pAHIReq^.ahir_Std.io_Device);
			end
			else
			begin
				DeleteIORequest (pIORequest (pAHIReq));
				DeleteMsgPort (pAHI_MP);		
				FreeVec (pChupaC);
				exit;	
			end;		
		end
		else
		begin
			DeleteMsgPort (pAHI_MP);		
			FreeVec (pChupaC);
			exit;	
		end;
	end
	else
	begin
		FreeVec (pChupaC);
		exit;
	end;

    pAHIReq^.ahir_Std.io_Message.mn_Node.ln_Pri := 0;
    pAHIReq^.ahir_Std.io_Command  := CMD_WRITE;
    pAHIReq^.ahir_Std.io_Data     := pChupaC;		{ pointer	}
    pAHIReq^.ahir_Std.io_Length   := TamCC;		{ length	}
    pAHIReq^.ahir_Std.io_Offset   := 0;
    pAHIReq^.ahir_Frequency       := 8000;	{ frequency	}
    pAHIReq^.ahir_Type            := AHIST_M8S;
    pAHIReq^.ahir_Volume          := $10000;	{ $10000 is the max	}
    pAHIReq^.ahir_Position        := $8000;	{ $8000 for same level on L&R channels }
    pAHIReq^.ahir_Link            := NIL;

    SendIO (pIORequest (pAHIReq));
                                

	AnyKey;



	AbortIO (pIORequest (pAHIReq));
	CloseDevice (pIORequest (pAHIReq));
	DeleteIORequest (pIORequest (pAHIReq));
	DeleteMsgPort (pAHI_MP);		
	FreeVec (pChupaC);
end;

begin
	writeln ('started..');
	RotPrinc;

end.