unit PTReplay;
{ HSPascal support for ptreplay.library - version 1.0b	}
{ supports ptreplay.library V6.6 functions				}
{ written by Daniel Mealha Cabrita (dancab@polbox.com)	}
{ started in 10 november, 1997							}
{ finished 1.0 - 12 november, 1997						}

INTERFACE
uses Exec;

type
	pModule	= ^tModule;
	tModule = record
    	mod_Name	: pointer;
    end;

	pPTSample = ^tPTSample;
	tPTSample = record
    	Name		: array [1..22] of byte;
        Length		: word;
        FineTune	: byte;
        Volume		: byte;
        RepeatPos	: word;
        Replen		: word;
	end;

var
	PTReplayBase : pLibrary;
	
const
	PTREPLAYNAME = 'ptreplay.library';

function PTLoadModule (PTFilename: string): pModule;
procedure PTUnloadModule (PTModule: pModule);
procedure PTPlay (PTModule: pModule);
procedure PTStop (PTModule: pModule);
procedure PTPause (PTModule: pModule);
procedure PTResume (PTModule: pModule);

{ New in V2 }
procedure PTFade (PTModule: pModule; PTDado: byte);

{ New in V3 }
procedure PTSetVolume (PTModule: pModule; PTDado: byte);

{ New in V4 }
function PTSongPos (PTModule: pModule): byte;
function PTSongLen (PTModule: pModule): byte;
function PTSongPattern (PTModule: pModule; PTDado: word): byte;
function PTPatternPos (PTModule: pModule): byte;
function PTPatternData (PTModule: pModule; PTDado: byte; PTDado2: byte): pointer;
procedure PTInstallBits (PTModule: pModule; PTDado: byte; PTDado2: byte; PTDado3: byte; PTDado4: byte);
function PTSetupMod (PTEnder: pointer): pModule;
procedure PTFreeMod (PTModule: pModule);
procedure PTStartFade (PTModule: pModule; PTDado: byte);

{ New in V5 }
procedure PTOnChannel (PTModule: pModule; PTDado: byte);
procedure PTOffChannel (PTModule: pModule; PTDado: byte);
procedure PTSetPos (PTModule: pModule; PTDado: byte);
procedure PTSetPri (PTDado: byte);
function PTGetPri: byte;

{ New in V6 }
function PTGetChan: byte;
function PTGetSample (PTModule: pModule; PTDado: word):pPTSample;


IMPLEMENTATION

function PTLoadModule; assembler;
var c_PTFilename: string;
asm
	move.l	PTFilename,-(sp)
	pea		c_PTFilename
	jsr		PasToC
	move.l	a6,-(sp)
	lea		c_PTFilename,a0
	move.l	PTReplayBase,a6
	jsr		-$1e(a6)
	move.l	d0,$110(sp)
	move.l	(sp)+,a6
end;

procedure PTUnloadModule; xassembler;
asm
	move.l	a6,-(sp)
	move.l	8(sp),a0
	move.l	PTReplayBase,a6
	jsr		-$24(a6)
	move.l	(sp)+,a6
end;

procedure PTPlay; xassembler;
asm
	move.l	a6,-(sp)
	move.l	8(sp),a0
	move.l	PTReplayBase,a6
	jsr		-$2a(a6)
	move.l	(sp)+,a6
end;

procedure PTStop; xassembler;
asm
	move.l	a6,-(sp)
	move.l	8(sp),a0
	move.l	PTReplayBase,a6
	jsr		-$30(a6)
	move.l	(sp)+,a6
end;

procedure PTPause; xassembler;
asm
	move.l	a6,-(sp)
	move.l	8(sp),a0
	move.l	PTReplayBase,a6
	jsr		-$36(a6)
	move.l	(sp)+,a6
end;

procedure PTResume; xassembler;
asm
	move.l	a6,-(sp)
	move.l	8(sp),a0
	move.l	PTReplayBase,a6
	jsr		-$3c(a6)
	move.l	(sp)+,a6
end;

procedure PTFade; xassembler;
asm
	move.l	a6,-(sp)
	lea		$8(sp),a6
	move.b	(a6)+,d0
	addq.l	#1,a6
	move.l	(a6)+,a0
	move.l	PTReplayBase,a6
	jsr		-$42(a6)
	move.l	(sp)+,a6
end;

procedure PTSetVolume; xassembler;	{ **** ERROR in LIBRARY!!! only left channels changed	}
asm									{ right channels with maximum volume, always			}
	move.l	a6,-(sp)
	lea		$8(sp),a6
	move.b	(a6)+,d0
	addq.l	#1,a6
	move.l	(a6)+,a0
	move.l	PTReplayBase,a6
	jsr		-$48(a6)
	move.l	(sp)+,a6
end;

function PTSongPos; xassembler;
asm
	move.l	a6,-(sp)
	move.l	8(sp),a0
	move.l	PTReplayBase,a6
	jsr		-$4e(a6)
	move.b	d0,$C(sp)
	move.l	(sp)+,a6
end;

function PTSongLen; xassembler;
asm
	move.l	a6,-(sp)
	move.l	8(sp),a0
	move.l	PTReplayBase,a6
	jsr		-$54(a6)
	move.b	d0,$C(sp)
	move.l	(sp)+,a6
end;

function PTSongPattern; xassembler;
asm
	move.l	a6,-(sp)
	lea		$8(sp),a6
	move.w	(a6)+,d0
	move.l	(a6)+,a0
	move.l	PTReplayBase,a6
	jsr		-$5a(a6)
	move.b	d0,$E(sp)
	move.l	(sp)+,a6
end;

function PTPatternPos; xassembler;
asm
	move.l	a6,-(sp)
	move.l	8(sp),a0
	move.l	PTReplayBase,a6
	jsr		-$60(a6)
	move.b	d0,$C(sp)
	move.l	(sp)+,a6
end;

function PTPatternData; xassembler;	{ *** DOESN'T WORK *** (seems a library error..)	}
asm
	move.l	a6,-(sp)
	lea		$8(sp),a6
	move.b	(a6)+,d1
	addq.l	#1,a6
	move.b	(a6)+,d0
	addq.l	#1,a6
	move.l	(a6)+,a0
	move.l	PTReplayBase,a6
	jsr		-$66(a6)
	move.l	d0,$10(sp)
	move.l	(sp)+,a6
end;

procedure PTInstallBits; xassembler;
asm
	move.l	a6,-(sp)
	lea		$8(sp),a6
	move.b	(a6)+,d3
	addq.l	#1,a6
	move.b	(a6)+,d2
	addq.l	#1,a6
	move.b	(a6)+,d1
	addq.l	#1,a6
	move.b	(a6)+,d0
	addq.l	#1,a6
	move.l	(a6)+,a0
	move.l	PTReplayBase,a6
	jsr		-$6c(a6)
	move.l	(sp)+,a6
end;

function PTSetupMod; xassembler;
asm
	move.l	a6,-(sp)
	move.l	8(sp),a0
	move.l	PTReplayBase,a6
	jsr		-$72(a6)
	move.l	d0,$C(sp)
	move.l	(sp)+,a6
end;

procedure PTFreeMod; xassembler;
asm
	move.l	a6,-(sp)
	move.l	8(sp),a0
	move.l	PTReplayBase,a6
	jsr		-$78(a6)
	move.l	(sp)+,a6
end;

procedure PTStartFade; xassembler;
asm
	move.l	a6,-(sp)
	lea		$8(sp),a6
	move.b	(a6)+,d0
	addq.l	#1,a6
	move.l	(a6)+,a0
	move.l	PTReplayBase,a6
	jsr		-$7e(a6)
	move.l	(sp)+,a6
end;

procedure PTOnChannel; xassembler;
asm
	move.l	a6,-(sp)
	lea		$8(sp),a6
	move.b	(a6)+,d0
	addq.l	#1,a6
	move.l	(a6)+,a0
	move.l	PTReplayBase,a6
	jsr		-$84(a6)
	move.l	(sp)+,a6
end;

procedure PTOffChannel; xassembler;
asm
	move.l	a6,-(sp)
	lea		$8(sp),a6
	move.b	(a6)+,d0
	addq.l	#1,a6
	move.l	(a6)+,a0
	move.l	PTReplayBase,a6
	jsr		-$8a(a6)
	move.l	(sp)+,a6
end;

procedure PTSetPos; xassembler;
asm
	move.l	a6,-(sp)
	lea		$8(sp),a6
	move.b	(a6)+,d0
	addq.l	#1,a6
	move.l	(a6)+,a0
	move.l	PTReplayBase,a6
	jsr		-$90(a6)
	move.l	(sp)+,a6
end;

procedure PTSetPri; xassembler;	{ *** DOESN'T WORK!!! seems a library error	}
asm
	move.l	a6,-(sp)
	move.b	$8(sp),d0
	move.l	PTReplayBase,a6
	jsr		-$96(a6)
	move.l	(sp)+,a6
end;

function PTGetPri; xassembler;
asm
	move.l	a6,-(sp)
	move.l	PTReplayBase,a6
	jsr		-$9c(a6)
	move.b	d0,$8(sp)
	move.l	(sp)+,a6
end;

function PTGetChan; xassembler;
asm
	move.l	a6,-(sp)
	move.l	PTReplayBase,a6
	jsr		-$a2(a6)
	move.b	d0,$8(sp)
	move.l	(sp)+,a6
end;

function PTGetSample; xassembler;
asm
	move.l	a6,-(sp)
	lea		$8(sp),a6
	move.w	(a6)+,d0
	move.l	(a6)+,a0
	move.l	PTReplayBase,a6
	jsr		-$a8(a6)
	move.l	d0,$E(sp)
	move.l	(sp)+,a6
end;

end.