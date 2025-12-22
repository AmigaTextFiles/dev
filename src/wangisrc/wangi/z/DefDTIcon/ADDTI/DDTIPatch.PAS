(*
 * An attempt to patch the default icons to display an icon based on file type.
 * Doomed by it being in Pascal... (and this baby was around longer before that
 * thing in NewIcons ;)
 *)

{ DDTIPatch ---- ©Lee Kindness }

{$F-,I+,R+,S+,V+,M 10,1,4,15}

USES Exec, Icon, AmigaDOS, Workbench, Amiga;

{$I IDPort.PAS }

VAR
	oldptr : LONG;
	
Function DDTIGetDiskObjectNew(name : STRPTR) : pDiskObject; Forward;
Function OldGetDiskObjectNew(name : STRPTR) : pDiskObject; Forward;
Procedure ProcessMessage(IDPort : pMsgPort); Forward;
Procedure Main; Forward;

function OldGetDiskObjectNew; ASSEMBLER;
ASM
	move.l	a6,-(sp)
					{move.l	8(sp),a0}
	move.l	IconBase,a6
	move.l  name,a0
					{jsr		-$84(a6)}
	move.l  (oldptr),a1
	jsr     (a1)
	move.l	d0,$C(sp)
	move.l	(sp)+,a6
					{move.l  d0,@result}
END;





Function DDTIGetDiskObjectNew;

VAR
	dobj : pDiskObject;
	loc  : BPTR;
	fib  : pFileInfoBlock;
	
begin
	dobj := NIL;
	{ copy A0 to variable }
	ASM
		move.l a0,name
	END;
	
	if name <> NIL then begin
		loc := Lock(name, ACCESS_READ);
		if loc <> NULL then begin
			fib := AllocDosObject(DOS_FIB, NIL);
			if fib <> NIL then begin
				if Examine(loc, fib) then begin
					Writeln('FIB : ',fib^.fib_DirEntryType);
					if fib^.fib_DirEntryType < 0 then begin
						Writeln('Object : ',PtrToPas(name));
						Writeln('Lock : ',LONG(loc));
					end;
				end;
				FreeDosObject(DOS_FIB, fib);
			end;
			UnLock(loc);
		end;
	end;
	if dobj = NIL then begin 
		write('** Result of OldGetDiskObjectNew = ');
		dobj := OldGetDiskObjectNew(name);
		Writeln(LONG(dobj));
	end;
		
	DDTIGetDiskObjectNew := dobj;
	{ copy result to d0 }
	ASM
		move.l @result,d0
	END;
end;

Procedure ProcessMessage;

VAR 
	Disable : Boolean;
	IDSig, sigrcvd, BitFlags : LONG;
	Finished : Boolean;
	mes : pMessage;
	
begin
	finished := false;
	
	IDSig := 1 shl IDPort^.mp_SigBit;
	
	BitFlags := SIGBREAKF_CTRL_C OR IDSig;
	While Not Finished do begin
		sigrcvd := Wait(BitFlags);
		if ((sigrcvd and IDSig)=IDSig) then begin
			mes := GetMsg(IDPort);
			ReplyMsg(mes);	
			Finished := True;
		end;
		if ((sigrcvd and SIGBREAKF_CTRL_C)=SIGBREAKF_CTRL_C) then begin
			Finished := True;
		end; 
	end;
end;



Procedure Main;
VAR 
	Ok : Boolean;
	IDPort : pMsgPort;
	
CONST
	PortName : String[13] = 'DDTIPatch_ID'#0;
	
begin
	if CheckIDPortOrSetup(IDPort, @portname[1]) then begin
		IconBase := OpenLibrary('icon.library',36);
		if IconBase <> NIL then begin
			oldptr := LONG(SetFunction(IconBase, -$84, @DDTIGetDiskObjectNew));
			
			Writeln('> OldGetDiskObjectNew : ',LONG(@OldGetDiskObjectNew));
			Writeln('> GetDiskObjectNew    : ',LONG(@GetDiskObjectNew));
			Writeln('> Old function        : ',LONG(oldptr));
			
			ProcessMessage(IDPort);
			
			{ restore function }
			OldPtr := LONG(SetFunction(IconBase, -$84, Pointer(OldPtr)));
			
			CloseLibrary(IconBase);
		end;
		CleanIDPort(IDPort);
	end;
end;

begin main end. 