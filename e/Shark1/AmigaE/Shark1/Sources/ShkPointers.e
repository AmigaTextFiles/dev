OPT MODULE
OPT EXPORT

CONST NEWPOINTER=1,
      WAITPOINTER=2,
      OLDPOINTER=3,
      DEATIVEPOINTER=4,
      HIDEPOINTER=5,
      SIZEPOINTER=256
DEF hotx,hoty

PROC mSetHotPointer(x,y)
hoty:=y
hotx:=x
ENDPROC

PROC mAllocPointer(dummy=0)
RETURN AllocMem(SIZEPOINTER,2)
ENDPROC

PROC mChangePointer(pchip,win,numer=1)
DEF pointer
IF numer=1
pointer:=[$0000,$0000,
	  $0000,$0000,
	  $4000,$0000,
	  $6000,$0000,
	  $5000,$2000,
	  $4800,$3000,
	  $4400,$3800,
	  $4200,$3c00,
	  $4100,$3e00,
	  $4080,$3f00,
	  $7bc0,$0400,
	  $0a00,$0400,
	  $0500,$0200,
	  $0700,$0000,
	  $0000,$0000,
	  $0000,$0000,
	  $0000,$0000,
	  $0000,$0000]:INT
ENDIF
IF numer=2
pointer:=[$0000,$0000,
          $07c0,$0000,
	  $0280,$0000,
	  $07c0,$0000,
	  $1830,$07c0,
	  $3018,$0fe0,
	  $2028,$1ff0,
	  $4044,$3ff8,
	  $4084,$3ff8,
	  $4104,$3ff8,
	  $4004,$3ff8,
	  $4004,$3ff8,
	  $2008,$1ff0,
	  $3018,$0fe0,
	  $1830,$07c0,
	  $07c0,$0000,
	  $0000,$0000,
	  $0000,$0000]:INT
ENDIF
IF numer=3
pointer:=[$0000,$0000,
	  $7c00,$0000,
	  $8200,$7c00,
	  $fa00,$7c00,
	  $f400,$7800,
	  $fa00,$7c00,
	  $fd00,$6e00,
	  $6e80,$0700,
	  $0740,$0380,
	  $03a0,$01c0,
	  $01c0,$0080,
	  $0080,$0000,
	  $0000,$0000,
	  $0000,$0000,
	  $0000,$0000,
	  $0000,$0000,
	  $0000,$0000,
	  $0000,$0000]:INT
ENDIF
IF numer=4
pointer:=[$0000,$0000,
	  $0000,$0000,
	  $0100,$0100,
	  $0100,$0000,
	  $0100,$0100,
	  $0100,$0000,
	  $0100,$0100,
	  $0100,$0000,
	  $7efc,$5454,
	  $0100,$0000,
	  $0100,$0100,
	  $0100,$0000,
	  $0100,$0100,
	  $0100,$0000,
	  $0100,$0100,
	  $0000,$0000,
	  $0000,$0000,
	  $0000,$0000]:INT
ENDIF
IF numer=5
pointer:=[$0000,$0000,
	  $0000,$0000,
	  $0000,$0000,
	  $0000,$0000,
	  $0000,$0000,
	  $0000,$0000,
	  $0000,$0000,
	  $0000,$0000,
	  $0000,$0000,
	  $0000,$0000,
	  $0000,$0000,
	  $0000,$0000,
	  $0000,$0000,
	  $0000,$0000,
	  $0000,$0000,
	  $0000,$0000,
	  $0000,$0000,
	  $0000,$0000]:INT
ENDIF
CopyMemQuick(pointer,pchip,SIZEPOINTER)

SetPointer(win,pchip,16,16,hotx,hoty)
ENDPROC

PROC mFreePointer(pchip,win=NIL)
FreeMem(pchip,SIZEPOINTER)
IF win<>NIL THEN ClearPointer(win)
ENDPROC
