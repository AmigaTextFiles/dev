;:ts=8
;#include "multidesktop.h"
;
;struct MultiDesktopBase *MultiDesktopBase;
	global	_MultiDesktopBase,4
;extern struct ExecBase  *SysBase;
;APTR IntuitionBase,GfxBase;
	global	_IntuitionBase,4
	global	_GfxBase,4
;
;/* ---- Text einer ID-Nummer ermitteln */
;/*
;  ID-Nummer:
;
;  "Text"       für keine Umwandlung, Ergebnis = "Text"
;  "xxx:Text"   für ID xxx aus dem angegebenen Katalog
;  "xxx§Text"   für ID xxx aus dem MultiDesktop-Katalog (System-
;ID)
;*/
;
;ULONG Catalog=7466L;
	dseg
	ds	0
	public	_Catalog
_Catalog:
	dc.l	$1d2a
	cseg
;
;UBYTE *FindIt(cat,id)
; struct Catalog *cat;
	public	_FindIt
_FindIt:
	link	a5,#.2
	movem.l	.3,-(sp)
; UBYTE           *id;
;{
; UBYTE num[30];
; BOOL  hasNum,sysID;
; ULONG catID;
; int   i;
;
; if(id==NULL) return(NULL);
	tst.l	12(a5)
	bne	.4
	move.l	#0,d0
.5
	movem.l	(sp)+,.3
	unlk	a5
	rts
;
; hasNum=sysID=FALSE;
.4
	clr.w	-34(a5)
	clr.w	-32(a5)
; i=0;
	clr.l	-42(a5)
; printf("<%c>\n",'§');
	pea	-89
	pea	.1+0
	jsr	_printf
	add.w	#8,sp
; printf("Scan=");
	pea	.1+6
	jsr	_printf
	add.w	#4,sp
; while((id[i]!=0x00)&&(i<20))
.6
	move.l	-42(a5),d0
	move.l	12(a5),a0
	tst.b	(a0,d0.l)
	beq	.7
	cmp.l	#20,-42(a5)
	bge	.7
;  {
;   if(id[i]==':')
;    {
	move.l	-42(a5),d0
	move.l	12(a5),a0
	cmp.b	#58,(a0,d0.l)
	bne	.8
;     num[i]=0x00;
	move.l	-42(a5),d0
	lea	-30(a5),a0
	clr.b	(a0,d0.l)
;     hasNum=TRUE;
	move.w	#1,-32(a5)
;     break;
	bra	.7
;    }
;   else if(id[i]=='§')
.8
;    {
	move.l	-42(a5),d0
	move.l	12(a5),a0
	move.l	#0,d1
	move.b	(a0,d0.l),d1
	cmp.l	#-89,d1
	bne	.9
;     num[i]=0x00;
	move.l	-42(a5),d0
	lea	-30(a5),a0
	clr.b	(a0,d0.l)
;     hasNum=TRUE;
	move.w	#1,-32(a5)
;     sysID=TRUE;
	move.w	#1,-34(a5)
;     printf("<STOP>");
	pea	.1+12
	jsr	_printf
	add.w	#4,sp
;     break;
	bra	.7
;    }
;   else
.9
;    {  num[i]=id[i]; printf("%c  %ld\n",num[i],num[i]=='§'); }
	move.l	-42(a5),d0
	move.l	12(a5),a0
	move.l	-42(a5),d1
	lea	-30(a5),a1
	move.b	(a0,d0.l),(a1,d1.l)
	move.l	-42(a5),d0
	lea	-30(a5),a0
	move.l	#0,d1
	move.b	(a0,d0.l),d1
	cmp.l	#-89,d1
	bne	.10
	move.l	#1,d2
	bra	.11
.10
	move.l	#0,d2
.11
	move.l	d2,-(sp)
	move.l	-42(a5),d3
	lea	-30(a5),a1
	move.l	#0,d2
	move.b	(a1,d3.l),d2
	move.l	d2,-(sp)
	pea	.1+19
	jsr	_printf
	lea	12(sp),sp
;   i++;
	add.l	#1,-42(a5)
;  }
	bra	.6
.7
;
; puts("\n---------");
	pea	.1+28
	jsr	_puts
	add.w	#4,sp
;
; if(!hasNum)
;   return(id);
	tst.w	-32(a5)
	bne	.12
	move.l	12(a5),d0
	bra	.5
;
; printf("Num=%s\n",&num);
.12
	pea	-30(a5)
	pea	.1+39
	jsr	_printf
	add.w	#8,sp
;
; catID=atol(&num);
	pea	-30(a5)
	jsr	_atol
	add.w	#4,sp
	move.l	d0,-38(a5)
; if(catID==0)
;   return(id);
	tst.l	-38(a5)
	bne	.13
	move.l	12(a5),d0
	bra	.5
;
; if(sysID)
.13
;   cat=Catalog;
	tst.w	-34(a5)
	beq	.14
	move.l	_Catalog,8(a5)
;
; printf("Num=%ld\n",catID);
.14
	move.l	-38(a5),-(sp)
	pea	.1+47
	jsr	_printf
	add.w	#8,sp
; printf("Cat=%ld\n",cat);
	move.l	8(a5),-(sp)
	pea	.1+56
	jsr	_printf
	add.w	#8,sp
;}
	bra	.5
.2	equ	-42
.3	reg	
.1
	dc.b	60,37,99,62,10,0,83,99,97,110,61,0,60,83,84
	dc.b	79,80,62,0,37,99,32,32,37,108,100,10,0,10,45
	dc.b	45,45,45,45,45,45,45,45,0,78,117,109,61,37,115
	dc.b	10,0,78,117,109,61,37,108,100,10,0,67,97,116,61
	dc.b	37,108,100,10,0
	ds	0
;
;main()
;{
	public	_main
_main:
	link	a5,#.16
	movem.l	.17,-(sp)
; struct Node *node;
; struct List  list;
; BOOL         b1,b2;
; long i,j;
;
; IntuitionBase=OpenLibrary("intuition.library",0L);
	clr.l	-(sp)
	pea	.15+0
	jsr	_OpenLibrary
	add.w	#8,sp
	move.l	d0,_IntuitionBase
; GfxBase=OpenLibrary("graphics.library",0L);
	clr.l	-(sp)
	pea	.15+18
	jsr	_OpenLibrary
	add.w	#8,sp
	move.l	d0,_GfxBase
; MultiDesktopBase=OpenLibrary("multidesktop.library",0L);
	clr.l	-(sp)
	pea	.15+35
	jsr	_OpenLibrary
	add.w	#8,sp
	move.l	d0,_MultiDesktopBase
; if(MultiDesktopBase)
;  {
	tst.l	_MultiDesktopBase
	beq	.18
;   DesktopStartup(0L,STARTUP_ALERTHANDLER|STARTUP_TRAPHANDLER);
;
	pea	3
	clr.l	-(sp)
	jsr	_DesktopStartup
	add.w	#8,sp
;   puts("Programm gestartet!");
	pea	.15+56
	jsr	_puts
	add.w	#4,sp
;
;   FindIt(345L,"3§Test!");
	pea	.15+76
	pea	345
	jsr	_FindIt
	add.w	#8,sp
;
;   DesktopExit();
	jsr	_DesktopExit
;   CloseLibrary(MultiDesktopBase);
	move.l	_MultiDesktopBase,-(sp)
	jsr	_CloseLibrary
	add.w	#4,sp
;   printf("Avail=%ld\n",AvailMem(MEMF_ANY));
	clr.l	-(sp)
	jsr	_AvailMem
	add.w	#4,sp
	move.l	d0,-(sp)
	pea	.15+84
	jsr	_printf
	add.w	#8,sp
;  }
; else
	bra	.19
.18
;   puts("No Libs!");
	pea	.15+95
	jsr	_puts
	add.w	#4,sp
.19
;}
.20
	movem.l	(sp)+,.17
	unlk	a5
	rts
.16	equ	-30
.17	reg	
.15
	dc.b	105,110,116,117,105,116,105,111,110,46,108,105,98,114,97
	dc.b	114,121,0,103,114,97,112,104,105,99,115,46,108,105,98
	dc.b	114,97,114,121,0,109,117,108,116,105,100,101,115,107,116
	dc.b	111,112,46,108,105,98,114,97,114,121,0,80,114,111,103
	dc.b	114,97,109,109,32,103,101,115,116,97,114,116,101,116,33
	dc.b	0,51,-89,84,101,115,116,33,0,65,118,97,105,108,61
	dc.b	37,108,100,10,0,78,111,32,76,105,98,115,33,0
	ds	0
;
	public	_AvailMem
	public	_CloseLibrary
	public	_DesktopExit
	public	_DesktopStartup
	public	_OpenLibrary
	public	_atol
	public	_puts
	public	_printf
	public	.begin
	dseg
	end
