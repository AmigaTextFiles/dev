unit nofrag;

INTERFACE
uses Exec;


{ ------------------------------------------------------------------------
  :Program.       NoFrag
  :Contents.      Interface to Jan van den Baard's Library
  :Author.        Richard Waspe
  :Address.       FIDO     :   2:255/72.2
  :Address.       INTERNET :   waspy@cix.compulink.co.uk
  :Address.       UUCP     :   rwaspe@hamlet.adsp.sub.org
  :History.       v1.0 28-Feb-93 (translated from C and Oberon)
  :Copyright.     Freely Distributable
  :Language.      PASCAL
  :Translator.    Hisoft HSPascal V1.1
  :Warning.			First translation, compiles OK, but untested
------------------------------------------------------------------------ }


TYPE

	tNoFragBase	=	RECORD
		LibNode	:	pLibrary;
	END;

CONST
	NOFRAG_VERSION		=	2;
	NOFRAG_REVISION	=	2;


	{	ALL structures following are PRIVATE! DO NOT USE THEM! }

TYPE

	pMemoryBlock	=	^tMemoryBlock;
	tMemoryBlock	=	RECORD
		Next				:	pMemoryBlock;
		Previous			:	pMemoryBlock;
		Requirements	:	LONGINT;
		BytesUsed		:	LONGINT;
	END;

	pMemoryItem		=	^tMemoryItem;
	tMemoryItem		=	RECORD
		Next		:	pMemoryItem;
		Previous	:	pMemoryItem;
		Block		:	pMemoryBlock;
		Size		:	LONGINT;
	END;

	pBlockList	=	^tBlockList;
	tBlockList	=	RECORD
		bl_First		:	pMemoryBlock;
		bl_End		:	pMemoryBlock;
		bl_Last		:	pMemoryBlock;
	END;

	pItemList	=	^tItemList;
	tItemList	=	RECORD
		il_First		:	pMemoryItem;
		il_End		:	pMemoryItem;
		il_Last		:	pMemoryItem;
	END;


	{ This structure may only be used to pass on to the library  }
	{ routines!                                                  }
 	{ It may ONLY be obtained by a call to "GetMemoryChain()"    }


	pMemoryChain	=	^tMemoryChain;
	tMemoryChain	=	RECORD
		Blocks		:	tBlockList;
		Items			:	tItemList;
		BlockSize	:	LONGINT;
	END;


CONST
	MINALLOC		=	16;




function GetMemoryChain (blocksize: longint): longint;
function AllocItem
		(chain: pointer;
		size,
		requirements: longint): longint;

function FreeItem
		(chain,
		memptr: pointer;
		size: longint): longint;

function FreeMemoryChain
		(chain: pointer;
		all: longint): longint;

function AllocVecItem
		(chain: pointer;
		size,
		requirements: longint): longint;

function FreeVecItem
		(chain,
		memptr: pointer): longint;



var
  NoFragBase: pLibrary;


IMPLEMENTATION
function GetMemoryChain; xassembler;
asm
	move.l	a6,-(sp)
	move.l	8(sp),d0
	move.l	NoFragBase,a6
	jsr		-$1E(a6)
	move.l	d0,$C(sp)
	move.l	(sp)+,a6
end;

function AllocItem; xassembler;
asm
	move.l	a6,-(sp)
	lea		8(sp),a6
	move.l	(a6)+,d1
	move.l	(a6)+,d0
	move.l	(a6)+,a0
	move.l	NoFragBase,a6
	jsr		-$24(a6)
	move.l	d0,$14(sp)
	move.l	(sp)+,a6
end;

function FreeItem; xassembler;
asm
	move.l	a6,-(sp)
	lea		8(sp),a6
	move.l	(a6)+,d0
	move.l	(a6)+,a1
	move.l	(a6)+,a0
	move.l	NoFragBase,a6
	jsr		-$2A(a6)
	move.l	d0,$14(sp)
	move.l	(sp)+,a6
end;

function FreeMemoryChain; xassembler;
asm
	move.l	a6,-(sp)
	movem.l	8(sp),d0/a0
	move.l	NoFragBase,a6
	jsr		-$30(a6)
	move.l	d0,$10(sp)
	move.l	(sp)+,a6
end;

function AllocVecItem; xassembler;
asm
	move.l	a6,-(sp)
	lea		8(sp),a6
	move.l	(a6)+,d1
	move.l	(a6)+,d0
	move.l	(a6)+,a0
	move.l	NoFragBase,a6
	jsr		-$36(a6)
	move.l	d0,$14(sp)
	move.l	(sp)+,a6
end;

function FreeVecItem; xassembler;
asm
	move.l	a6,-(sp)
	lea		8(sp),a6
	move.l	(a6)+,a1
	move.l	(a6)+,a0
	move.l	NoFragBase,a6
	jsr		-$3C(a6)
	move.l	d0,$10(sp)
	move.l	(sp)+,a6
end;

end.
