unit wangi;

INTERFACE
uses Exec;


function wangi1: longint;
function wangi2 (a: longint): longint;
function wangi3 (a: longint): longint;


var
  WangiBase: pLibrary;


IMPLEMENTATION
function wangi1; xassembler;
asm
	movem.l	d3/d5/a6,-(sp)
	move.l	WangiBase,a6
	jsr		-$1E(a6)
	move.l	d0,$10(sp)
	movem.l	(sp)+,d3/d5/a6
end;

function wangi2; xassembler;
asm
	move.l	a6,-(sp)
	move.l	8(sp),d1
	move.l	WangiBase,a6
	jsr		-$24(a6)
	move.l	d0,$C(sp)
	move.l	(sp)+,a6
end;

function wangi3; xassembler;
asm
	move.l	a6,-(sp)
	move.l	8(sp),d1
	move.l	WangiBase,a6
	jsr		-$2A(a6)
	move.l	d0,$C(sp)
	move.l	(sp)+,a6
end;

end.
