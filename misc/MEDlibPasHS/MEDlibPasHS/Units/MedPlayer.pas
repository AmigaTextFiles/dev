unit MedPlayer;
{ version 1.1 -- many bugs fixed						}
{ written by Daniel Mealha Cabrita (dancab@base.com.br)	}
{ original: 16 october, 1997							}
{ v1.1: 22 october, 1997								}

INTERFACE
uses Exec;

var
	MedPlayerBase : pLibrary;


function GetPlayer (midi: longint): longint;
procedure FreePlayer;
procedure PlayModule (module: pointer);
procedure ContModule (module: pointer);
procedure StopPlayer;
procedure SetTempo (tempo: longint);
function LoadModule (medName: string): pointer;
procedure UnLoadModule (module: pointer);
function GetCurrentModule: pointer;
procedure ResetMIDI;
procedure SetModnum (modnum: longint);
procedure RelocModule (module: pointer);


IMPLEMENTATION

function GetPlayer; xassembler;
asm
	move.l	a6,-(sp)
	move.l	8(sp),d0
	move.l	MedPlayerBase,a6
	jsr		-$1e(a6)
	move.l	d0,$C(sp)
	move.l	(sp)+,a6
end;

procedure FreePlayer; xassembler;
asm
	move.l	a6,-(sp)
	move.l	MedPlayerBase,a6
	jsr		-$24(a6)
	move.l	(sp)+,a6
end;

procedure PlayModule; xassembler;
asm
	move.l	a6,-(sp)
	move.l	8(sp),a0
	move.l	MedPlayerBase,a6
	jsr		-$2a(a6)
	move.l	(sp)+,a6
end;

procedure ContModule; xassembler;
asm
	move.l	a6,-(sp)
	move.l	8(sp),a0
	move.l	MedPlayerBase,a6
	jsr		-$30(a6)
	move.l	(sp)+,a6
end;

procedure StopPlayer; xassembler;
asm
	move.l	a6,-(sp)
	move.l	MedPlayerBase,a6
	jsr		-$36(a6)
	move.l	(sp)+,a6
end;

procedure SetTempo; xassembler;
asm
	move.l	a6,-(sp)
	move.l	8(sp),d0
	move.l	MedPlayerBase,a6
	jsr		-$42(a6)
	move.l	(sp)+,a6
end;

function LoadModule; assembler;
var c_medName: string;
asm
	move.l	medName,-(sp)
	pea		c_medName
	jsr		PasToC
	move.l	a6,-(sp)
	lea		c_medName,a0
	move.l	MedPlayerBase,a6
	jsr		-$48(a6)
	move.l	d0,$110(sp)
	move.l	(sp)+,a6
end;

procedure UnLoadModule; xassembler;
asm
	move.l	a6,-(sp)
	move.l	8(sp),a0
	move.l	MedPlayerBase,a6
	jsr		-$4e(a6)
	move.l	(sp)+,a6
end;

function GetCurrentModule; xassembler;
asm
	move.l	a6,-(sp)
	move.l	MedPlayerBase,a6
	jsr		-$54(a6)
	move.l	d0,$C(sp)
	move.l	(sp)+,a6
end;

procedure ResetMIDI; xassembler;
asm
	move.l	a6,-(sp)
	move.l	MedPlayerBase,a6
	jsr		-$5a(a6)
	move.l	(sp)+,a6
end;

procedure SetModnum; xassembler;
asm
	move.l	a6,-(sp)
	move.l	8(sp),d0
	move.l	MedPlayerBase,a6
	jsr		-$60(a6)
	move.l	(sp)+,a6
end;

procedure RelocModule; xassembler;
asm
	move.l	a6,-(sp)
	move.l	8(sp),a0
	move.l	MedPlayerBase,a6
	jsr		-$66(a6)
	move.l	(sp)+,a6
end;

end.