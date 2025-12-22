pattern amigaguidePrivate1 is
	push a6;
	a6:=AmigaGuideBase; jsr [a6-30];
	pop a6;
endp;															# AMIGAGUIDEPRIVATE1

pattern LockAmigaGuideBase(_handle) is
	push a6;
	a0:=_handle;
	a6:=AmigaGuideBase; jsr [a6-36];
	pop a6;
endp;															# LOCKAMIGAGUIDEBASE

pattern UnlockAmigaGuideBase(_key) is
	push a6;
	d0.l:=_key;
	a6:=AmigaGuideBase; jsr [a6-42];
	pop a6;
endp;															# UNLOCKAMIGAGUIDEBASE

pattern amigaguidePrivate2 is
	push a6;
	a6:=AmigaGuideBase; jsr [a6-48];
	pop a6;
endp;															# AMIGAGUIDEPRIVATE2

pattern OpenAmigaGuideA(_nag,_attrs) is
	push a6;
	safe a0:=_nag; a1:=_attrs;;
	a6:=AmigaGuideBase; jsr [a6-54];
	pop a6;
endp;															# OPENAMIGAGUIDEA

pattern OpenAmigaGuideAsyncA(_nag,_attrs) is
	push a6;
	safe a0:=_nag; d0.l:=_attrs;;
	a6:=AmigaGuideBase; jsr [a6-60];
	pop a6;
endp;															# OPENAMIGAGUIDEASYNCA

pattern CloseAmigaGuide(_cl) is
	push a6;
	a0:=_cl;
	a6:=AmigaGuideBase; jsr [a6-66];
	pop a6;
endp;															# CLOSEAMIGAGUIDE

pattern AmigaGuideSignal(_cl) is
	push a6;
	a0:=_cl;
	a6:=AmigaGuideBase; jsr [a6-72];
	pop a6;
endp;															# AMIGAGUIDESIGNAL

pattern GetAmigaGuideMsg(_cl) is
	push a6;
	a0:=_cl;
	a6:=AmigaGuideBase; jsr [a6-78];
	pop a6;
endp;															# GETAMIGAGUIDEMSG

pattern ReplyAmigaGuideMsg(_amsg) is
	push a6;
	a0:=_amsg;
	a6:=AmigaGuideBase; jsr [a6-84];
	pop a6;
endp;															# REPLYAMIGAGUIDEMSG

pattern SetAmigaGuideContextA(_cl,_id,_attrs) is
	push a6;
	safe a0:=_cl; d0.l:=_id; d1.l:=_attrs;;
	a6:=AmigaGuideBase; jsr [a6-90];
	pop a6;
endp;															# SETAMIGAGUIDECONTEXTA

pattern SendAmigaGuideContextA(_cl,_attrs) is
	push a6;
	safe a0:=_cl; d0.l:=_attrs;;
	a6:=AmigaGuideBase; jsr [a6-96];
	pop a6;
endp;															# SENDAMIGAGUIDECONTEXTA

pattern SendAmigaGuideCmdA(_cl,_cmd,_attrs) is
	push a6;
	safe a0:=_cl; d0.l:=_cmd; d1.l:=_attrs;;
	a6:=AmigaGuideBase; jsr [a6-102];
	pop a6;
endp;															# SENDAMIGAGUIDECMDA

pattern SetAmigaGuideAttrsA(_cl,_attrs) is
	push a6;
	safe a0:=_cl; a1:=_attrs;;
	a6:=AmigaGuideBase; jsr [a6-108];
	pop a6;
endp;															# SETAMIGAGUIDEATTRSA

pattern GetAmigaGuideAttr(_tag,_cl,_storage) is
	push a6;
	safe d0.l:=_tag; a0:=_cl; a1:=_storage;;
	a6:=AmigaGuideBase; jsr [a6-114];
	pop a6;
endp;															# GETAMIGAGUIDEATTR

pattern amigaguidePrivate3 is
	push a6;
	a6:=AmigaGuideBase; jsr [a6-120];
	pop a6;
endp;															# AMIGAGUIDEPRIVATE3

pattern LoadXRef(_lock,_name) is
	push a6;
	safe a0:=_lock; a1:=_name;;
	a6:=AmigaGuideBase; jsr [a6-126];
	pop a6;
endp;															# LOADXREF

pattern ExpungeXRef is
	push a6;
	a6:=AmigaGuideBase; jsr [a6-132];
	pop a6;
endp;															# EXPUNGEXREF

pattern AddAmigaGuideHostA(_h,_name,_attrs) is
	push a6;
	safe a0:=_h; d0.l:=_name; a1:=_attrs;;
	a6:=AmigaGuideBase; jsr [a6-138];
	pop a6;
endp;															# ADDAMIGAGUIDEHOSTA

pattern RemoveAmigaGuideHostA(_hh,_attrs) is
	push a6;
	safe a0:=_hh; a1:=_attrs;;
	a6:=AmigaGuideBase; jsr [a6-144];
	pop a6;
endp;															# REMOVEAMIGAGUIDEHOSTA

pattern amigaguidePrivate4 is
	push a6;
	a6:=AmigaGuideBase; jsr [a6-150];
	pop a6;
endp;															# AMIGAGUIDEPRIVATE4

pattern amigaguidePrivate5 is
	push a6;
	a6:=AmigaGuideBase; jsr [a6-156];
	pop a6;
endp;															# AMIGAGUIDEPRIVATE5

pattern amigaguidePrivate6 is
	push a6;
	a6:=AmigaGuideBase; jsr [a6-162];
	pop a6;
endp;															# AMIGAGUIDEPRIVATE6

pattern amigaguidePrivate7 is
	push a6;
	a6:=AmigaGuideBase; jsr [a6-168];
	pop a6;
endp;															# AMIGAGUIDEPRIVATE7

pattern amigaguidePrivate8 is
	push a6;
	a6:=AmigaGuideBase; jsr [a6-174];
	pop a6;
endp;															# AMIGAGUIDEPRIVATE8

pattern amigaguidePrivate9 is
	push a6;
	a6:=AmigaGuideBase; jsr [a6-180];
	pop a6;
endp;															# AMIGAGUIDEPRIVATE9

pattern amigaguidePrivate10 is
	push a6;
	a6:=AmigaGuideBase; jsr [a6-186];
	pop a6;
endp;															# AMIGAGUIDEPRIVATE10

pattern amigaguidePrivate11 is
	push a6;
	a6:=AmigaGuideBase; jsr [a6-192];
	pop a6;
endp;															# AMIGAGUIDEPRIVATE11

pattern amigaguidePrivate12 is
	push a6;
	a6:=AmigaGuideBase; jsr [a6-198];
	pop a6;
endp;															# AMIGAGUIDEPRIVATE12

pattern amigaguidePrivate13 is
	push a6;
	a6:=AmigaGuideBase; jsr [a6-204];
	pop a6;
endp;															# AMIGAGUIDEPRIVATE13

pattern GetAmigaGuideString(_id) is
	push a6;
	d0.l:=_id;
	a6:=AmigaGuideBase; jsr [a6-210];
	pop a6;
endp;															# GETAMIGAGUIDESTRING

