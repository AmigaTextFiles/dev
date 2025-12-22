; 
; 
; (c) 2001 Cyborg 



IFND Konstanten_Flag
Konstanten_Flag=1
Endif

Mode_New=1006
Mode_Old=1005
Offset_Begin=-1
Offset_End=1
Offset_Current=0
Access_Read=-2
Access_Write=-1
DosTrue=-1
DosFalse=0
True=Dostrue
False=DosFalse
NM_Title=1
NM_Item=2
NM_SUB=3
NM_barlabel=-1
MENU_IMAGE=128
IM_ITEM=NM_ITEM!MENU_IMAGE
IM_SUB=NM_SUB!MENU_IMAGE
NM_END=0
NM_IGNORE=64
MENUENABLED=1
NM_MENUDISABLED=MENUENABLED
Itemenabled=$10
NM_ITEMDISABLED=ITEMENABLED
Commseq=$4
NM_COMMANDSTRING=COMMSEQ
Itemtext=$2
HighFlags=$c0
NM_FLAGMASK=~(COMMSEQ!ITEMTEXT!HIGHFLAGS)
NM_FLAGMASK_V39=~(ITEMTEXT!HIGHFLAGS)
Null=0
	IncDir 	"Sys:Coder/"
	Include     "Preass/Konstanten.inc"
	Include     "Preass/ASL_lib.inc"
    Include     "Preass/intuition.inc"
    Include     "Include/Guienv.i"
    Include     "Include/Libraries/gadtools.i"

Main:
	Include "preass/Startup.i"
	Jsr Openlibs
	Tst.l D0
	Beq Mainende
	Jsr START
	jsr freeremmalloc
Mainende:
	jsr Closelibs
	Move.l Error,d0
	tst.l d0
	beq .l1
	jmp ErrorHandling
.l1:	Rts




Start:
Move.l DOSBase,a6
Move.l #Templatestring,d1
Move.l #TemP_array,d2
Move.l #0,d3
Jsr Readargs(a6)
Move.l D0,Args
    Cmp.l #0,d0
    Beq .pre0000
    Bra .pre0001
.pre0000:
Move.l DOSBase,a6
Move.l #Usage__name000,d1
Move.l #pf000,d2
Jsr vpf(a6)
     RTS
.Pre0001:
    Lea    Temp_array,A0
    Move.l #0,D0
    Move.l (A0,D0*4),d0
    Move.l D0,Name_p
    Lea    Temp_array,A0
    Move.l #1,D0
    Move.l (A0,D0*4),d0
    Move.l D0,args_p
    Move.l name_P,d0
    Cmp.l #0,d0
    Bne .pre0002
    Bra .pre0003
.pre0002:

Move.l oopBase,a6
Move.l name_p,a0
Move.l #0,d0
Jsr new(a6)
Move.l D0,Object
        Cmp.l #0,d0
        Bne .pre0004
        Bra .pre0005
.pre0004:

lea Tag,a0
move.l  args_P,0000(a0)
           Move.l oopBase,a6
           Move.l Object,d0
           Move.l #Mainname001,a0
           Move.l #Tag,a1
           Jsr Domethode(a6)
           Move.l D0,res
           Move.l Res,d0
           Cmp.l #-1,d0
           Beq .pre0006
           Bra .pre0007
.pre0006:

lea pf002,a0
move.l  name_P,0000(a0)
Move.l DOSBase,a6
Move.l #name002,d1
Move.l #pf002,d2
Jsr vpf(a6)
.Pre0007:
           Move.l oopBase,a6
           Move.l object,d0
           Jsr del(a6)
.Pre0005:
        Move.l object,d0
        Cmp.l #0,d0
        Beq .pre0008
        Bra .pre0009
.pre0008:

lea pf003,a0
move.l  name_P,0000(a0)
move.l  args_p,0004(a0)
Move.l DOSBase,a6
Move.l #can_not_invoke_methodename003,d1
Move.l #pf003,d2
Jsr vpf(a6)
.Pre0009:
.Pre0003:
    Move.l DOSBase,a6
    Move.l Args,d1
    Jsr FreeArgs(a6)
    RTS
Errorhandling:
    Move.l Dosbase,d0
    Cmp.l #0,d0
    Beq .pre0000
    Bra .pre0001
.pre0000:

       Move.l ExecBase,a6
       Move.l #dosname000,a1
       Move.l #0,d0
       Jsr Openlibrary(a6)
       Move.l D0,Dosbase
       Move.l DosBase,a1
       Jsr CloseLibrary(a6)
.Pre0001:
    Move.l DOSBase,a6
    Jsr output(a6)
    Move.l D0,Ausgabe
    Move.l Error,d0
    Cmp.l #1,d0
    Beq .Pre0002
    Bra .pre0003
.pre0002:
Move.l DOSBase,a6
Move.l Ausgabe,d1
Move.l #Allgemeiner_Fehlerxnname001,d2
Moveq.l #$13,d3
Jsr Write(a6)
.pre0003:
    Move.l Error,d0
    Cmp.l #2,d0
    Beq .Pre0004
    Bra .pre0005
.pre0004:
Move.l DOSBase,a6
Move.l Ausgabe,d1
Move.l #Konnte_File_nicht_findenxnname002,d2
Moveq.l #$19,d3
Jsr Write(a6)
.pre0005:
    Move.l Error,d0
    Cmp.l #3,d0
    Beq .Pre0006
    Bra .pre0007
.pre0006:
Move.l DOSBase,a6
Move.l Ausgabe,d1
Move.l #Window_Screen_Fehlerxnname003,d2
Moveq.l #$15,d3
Jsr Write(a6)
.pre0007:
    Move.l Error,d0
    Cmp.l #4,d0
    Beq .Pre0008
    Bra .pre0009
.pre0008:
lea PreassErrorTags,a0
move.l  d7,0000(a0)
Move.l DOSBase,a6
Move.l Ausgabe,d1
Move.l #Library_nicht_gefunden__name004,d2
Move.l #PreassErrorTags,d3
Jsr VFWriteF(a6)
.pre0009:
    Move.l Error,d0
    Cmp.l #5,d0
    Beq .Pre0010
    Bra .pre0011
.pre0010:
Move.l DOSBase,a6
Move.l Ausgabe,d1
Move.l #Fehlerhafte_Eingabexnname005,d2
Moveq.l #$14,d3
Jsr Write(a6)
.pre0011:
    Move.l Error,d0
    Cmp.l #6,d0
    Beq .Pre0012
    Bra .pre0013
.pre0012:
Move.l DOSBase,a6
Move.l Ausgabe,d1
Move.l #Speicherfehlerxnname006,d2
Moveq.l #$0F,d3
Jsr Write(a6)
.pre0013:
    RTS

Ausgabe:		dc.l 0
even
dosname000:	dc.b `dos.library`,0
even
Allgemeiner_Fehlerxnname001:
	dc.b `Allgemeiner Fehler`,$a,``,0
even
Konnte_File_nicht_findenxnname002:
	dc.b `Konnte File nicht finden`,$a,``,0
even
Window_Screen_Fehlerxnname003:
	dc.b `Window|Screen Fehler`,$a,``,0
even
Fehlerhafte_Eingabexnname005:
	dc.b `Fehlerhafte Eingabe`,$a,``,0
even
Speicherfehlerxnname006:	dc.b `Speicherfehler`,$a,``,0
even

even
Library_nicht_gefunden__name004:
	dc.b `Library nicht gefunden: %S`,$a,``,0
even
PreassErrorTags:
	dc.l 0,0
even

Even
Freeremmalloc:
rts 
Even
Openlibs:
	Move.l $4.w,a6
	Move.l #DOSname,a1
	Moveq.l #0,d0
	Jsr Openlibrary(a6) 
	Move.l d0,DOSbase
	Tst.l D0
	Beq.w .ende
	Move.l #oopname,a1
	Moveq.l #0,d0
	Jsr Openlibrary(a6) 
	Move.l d0,oopbase
	Tst.l D0
	Beq.w .ende
	rts
.ende:	Move.l #4,error
	Move.l a1,d7
	rts
Closelibs:
	Move.l $4.w,a6
	Tst.l DOSbase
	Beq.w .ende00
	Move.l DOSbase,a1
	Jsr Closelibrary(a6)
.ende00:Tst.l oopbase
	Beq.w .ende01
	Move.l oopbase,a1
	Jsr Closelibrary(a6)
.ende01:Rts
even
WBmessage:		dc.l 0
Laenge:		dc.l 0
Adresse:		dc.l 0
Error:		dc.l 0
Args:		dc.l 0
Name_p:		dc.l 0
args_p:		dc.l 0
Object:		dc.l 0
res:		dc.l 0
DOSBase:		dc.l 0
oopBase:		dc.l 0
even
Version:	dc.b `$VER: OOPA (C) CYBORG 2001`,0
even
Temp_Array:	dc.L 0,0,0,0,0,0,0
even
TemplateString:	dc.b `Name/A,args/K/F`,0
even
Usage__name000:
	dc.b `Usage: %s`,$a,``,0
even
pf000:
	dc.l Templatestring,0
Mainname001:	dc.b `Main`,0
even
Tag:
	dc.l args_P,0
name002:	dc.b `%s does not contain methode Main()`,$a,``,0
even
pf002:
	dc.l name_P,0
can_not_invoke_methodename003:
	dc.b `can not invoke methode %s.Main(`,$22,`%s`,$22,`)`,$a,`Object could not be created`,$a,``,0
even
pf003:
	dc.l name_P,args_p,0
DOSname: dc.b "dos.library",0
oopname: dc.b "oop.library",0
even
	Include "Preass:LVO3.0/Exec_lib.i"
	Include "Preass:LVO3.0/DOS_lib.i"
	Include "Preass:LVO3.0/oop_lib.i"

