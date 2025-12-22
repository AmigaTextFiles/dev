; Preass++ Präprozessor
;
; This software is freely copy&useable , but remains my propertie. 
;
; You are allowed to use this source to build other preprocessors 
; for the OOP4A Project. 
;
; http://www.geocities.com/SiliconValley/Bridge/5737
;
; You are not allowed to use the routines used within to build commercial
; products without my permission.
;
; I`m not responsible for any damage that's done to any piece of soft/hardware
; if you use any of this source or the resulting executable.
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

    Mode_NoCase= 100
    Mode_Case=   0


Stringfind:       
    movem.l d1-a6,-(sp)
    movea.l a0,a2
;    movea.l a0,a4
    movea.l a1,a3
.loop:
    move.b (a0)+,d1
    move.b (a1)+,d2
    cmpi.b #0,d2
    beq .ende2
    cmpi.b #0,d1
    beq .ende1
    bset #5,d1
    bset #5,d2
    cmp.b d1,d2
    beq.s .loop
    lea 1(a2),a2
    movea.l a0,a4
    movea.l a2,a0
    movea.l a3,a1
    bra.s .loop
.ende2:
    move.l a4,d0
    bra.s .ende
.ende1:
    moveq.l #0,d0
.ende:
    movem.l (sp)+,d1-a6
    rts

StrCmp:       
    movem.l d1-a6,-(sp)
    moveq.l #0,d3
    moveq.l #0,d0
.loop:
    move.b (a0)+,d1
    move.b (a1)+,d2
    cmpi.b #0,d2
    beq .ende
    cmpi.b #0,d1
    beq .ende
    cmpi.b #0,d3
    bne.s .weiter
    bset #5,d1
    bset #5,d2
    cmpi.b #$30,d2
    blt.s .keinezahl
    cmpi.b #$39,d2
    bgt.s .keinezahl
    cmpi.b #$30,d1
    blt.s .keinezahl
    cmpi.b #$39,d1
    bgt.s .keinezahl
    bra.s .weiter
.keinezahl:
    moveq.l #1,d3
.weiter:
    cmp.b d1,d2
    blt.s .kleiner
    bgt.s .groesser
    bra.s .loop
.groesser:
    moveq.l #1,d0
    bra.s .ende
.kleiner:
    moveq.l #-1,d0
.ende:
    movem.l (sp)+,d1-a6
    rts

CopyNextString:       
        cmpi.l #0,laenge
        beq .l13
        cmpi.l #1,laenge
        beq .l13
        suba.l a2,a2
        suba.l a1,a1
.l1:    cmpi.b #`"`,(a0)
        beq .l10
        cmpi.b #` `,(a0)+
        beq .l1
        lea -1(a0),a1
.l2:    cmpi.b #`"`,(a0)
        beq .l11
        cmpi.b #$0a,(a0)
        beq .l12
        cmpi.b #$00,(a0)
        beq .l12
        cmpi.b #` `,(a0)+
        bne .l2
        Lea -1(a0),a2
.l3:    suba.l a1,a2
        move.l A0,NextArg
        Move.l ExecBase,a6
        Move.l a1,a0
        Move.l a3,a1
        Move.l a2,d0
        Jsr Copymem(a6)
        Move.l a2,d0
        rts
.l10:   lea 1(a0),a1
        movea.l a1,a0
        bra .l22
.l11:   move.l a0,a2
        bra .l3
.l12:   move.l a0,a2
        bra .l3
.l13:   moveq.l #0,d0
        RTS
.l22:   cmpi.b #`"`,(a0)
        beq .l11
        cmpi.b #$0a,(a0)
        beq .l12
        cmpi.b #$00,(a0)
        beq .l12
        lea 1(a0),a0
        bra .l22

FileReq:
     Move.l A0,LokalScreen
     Move.l AslBase,a6
     Move.l #ASL_FileRequest,d0
     Move.l #0,a0
     Jsr AllocAslRequest(a6)
     Move.l D0,Requester
     Tst.l Requester
     Beq .Select2
     move.l #ASLFR_Taglist,a0
     move.l LokalScreen,4(a0)
     Move.l Requester,a0
     Move.l #ASLFR_Taglist,a1
     Jsr ASLRequest(a6)
     Move.l D0,Result
        Tst.l Result
        Beq .Select2
        Clr.l d0
        Move.l Requester,a0
        Move.l 4(a0),d0
        Move.l D0,Filename_Zeiger
        Clr.l d0
        Move.l Requester,a0
        Move.l 8(a0),d0
        Move.l D0,Dirname_zeiger
        Move.l ExecBase,a6
        Move.l Dirname_zeiger,a0
        Move.l #Dirname,a1
        Move.l #100,d0
        Jsr Copymem(a6)
        Move.l Filename_zeiger,a0
        Move.l #Name_spz,a1
        Move.l #100,d0
        Jsr Copymem(a6)
        move.l Dirname_zeiger,a1
        Lea Name_Bak,a0
        cmpi.b #$00,(a1)
        bne .Sel1
        move.l #"PROG",(a0)+
        move.l #"DIR:",(a0)+
        bra .sel12 
.Sel1:  move.b (a1)+,(a0)+
        cmpi.b #0,(a1)
        bne .sel1
        cmpi.b #":",-1(a0)
        beq .sel12
        move.b #"/",(a0)+
.sel12: move.l Filename_zeiger,a1
.Sel2:  move.b (a1)+,(a0)+
        cmpi.b #0,(a1)
        bne .sel2
        move.b #0,(a0)+
.Select2:
        Tst.l Requester
        Beq .lab1
        Move.l AslBase,a6
        Move.l Requester,a0
        Jsr FreeASLRequest(a6)
.lab1:  RTS

FillBuffer:
    subq.l #1,d1
.l1:move.b d0,(a0)+
    dbra  d1,.l1
    RTS

ConvertZahl:
    Move.l #"    ",Zusatz
    Move.l #"   0",Zahl
ConvertZahl1:
    Movem.l a0-a5,-(sp)
    Lea Zusatz,a0
    Cmpi.l #0,d7
    bpl .l0
    Neg.l d7
    move.b #"-",zahl
    Cmpi.l #9999,d7
    bgt .l0
    move.b #"-",zusatz
.l0:Move.l d7,d0
    MoveQ.l #-1,d1
.l1:AddQ.l #1,d1
    Subi.l #10000000,d0
    Bpl .l1
    Addi.l #10000000,d0
    addi.l #$30,d1
    cmpi.b #"0",d1
    Beq .l11
    move.b d1,0(a0)
.l11:MoveQ.l #-1,d1
.l2:AddQ.l #1,d1
    Subi.l #1000000,d0
    Bpl .l2
    Addi.l #1000000,d0
    addi.l #$30,d1
    cmpi.b #" ",0(a0)
    bne .l22
    cmpi.b #"0",d1
    Beq .l21
.l22:
    move.b d1,1(a0)
.l21:MoveQ.l #-1,d1
.l3:AddQ.l #1,d1
    Subi.l #100000,d0
    Bpl .l3
    Addi.l #100000,d0
    addi.l #$30,d1
    cmpi.b #" ",1(a0)
    bne .l32
    cmpi.b #"0",d1
    Beq .l31
.l32:
    move.b d1,2(a0)
.l31:MoveQ.l #-1,d1
.l4:AddQ.l #1,d1
    Subi.l #10000,d0
    Bpl .l4
    Addi.l #10000,d0
    addi.l #$30,d1
    cmpi.b #" ",2(a0)
    bne .l42
    cmpi.b #"0",d1
    Beq .l41
.l42:
    move.b d1,3(a0)
.l41:MoveQ.l #-1,d1
.l5:AddQ.l #1,d1
    Subi.l #1000,d0
    Bpl .l5
    Addi.l #1000,d0
    addi.l #$30,d1
    cmpi.b #" ",3(a0)
    bne .l52
    cmpi.b #"0",d1
    Beq .l51
.l52:
    move.b d1,4(a0)
.l51:MoveQ.l #-1,d1
.l6:AddQ.l #1,d1
    Subi.l #100,d0
    Bpl .l6
    Addi.l #100,d0
    addi.l #$30,d1
    cmpi.b #" ",4(a0)
    bne .l62
    cmpi.b #"0",d1
    Beq .l61
.l62:
    move.b d1,5(a0)
.l61:MoveQ.l #-1,d1
.l7:AddQ.l #1,d1
    Subi.l #10,d0
    Bpl .l7
    Addi.l #10,d0
    addi.l #$30,d1
    cmpi.b #" ",5(a0)
    bne .l72
    cmpi.b #"0",d1
    Beq .l71
.l72:
    move.b d1,6(a0)
.l71:
    addi.l #$30,d0
    move.b d0,7(a0)
    Movem.l (sp)+,a0-a5
    Tst.l D6
    Beq .ende   
    Move.l DOSBase,a6
    Move.l D6,d1
    Move.l #Zusatz,d2
    Move.l #8,d3
    Jsr Write(a6)
.ende:RTS

CompareString:
    movem.l d0-d7/a0-a6,-(sp)
    movem.l d0-d1/a0-a1,-(sp)
    Jsr CountString
    Move.l D0,Stringlaenge
    movem.l (sp)+,d0-d1/a0-a1
    movem.l d0-d1/a0-a1,-(sp)
Move.l a1,A0
Jsr CountString
    Cmp.l Stringlaenge,d0
    Beq .l0
    movem.l (sp)+,d0-d1/a0-a1
    bra .fehler
.l0:movem.l (sp)+,d0-d1/a0-a1
    cmpi.l #Mode_Nocase,d1
    beq .nocase
    move.l Stringlaenge,d1
    subq.l #1,d1
    addi.l d0,a1
.l1:move.b (a0)+,d0
    cmp.b (a1)+,d0
    bne .fehler
    dbra d1,.l1
    movem.l (a7)+,d0-d7/a0-a6
    moveq.l #-1,d0
    RTS
.NoCase:
    move.l Stringlaenge,d1
    subq.l #1,d1
    addi.l d0,a1
.l2:move.b (a0)+,d0
    move.b (a1)+,d2
    bclr #5,d0
    bclr #5,d2
    cmp.b d2,d0
    bne .fehler
    dbra d1,.l2
    movem.l (a7)+,d0-d7/a0-a6
    moveq.l #-1,d0
    RTS
.Fehler:
    movem.l (a7)+,d0-d7/a0-a6
    moveq.l #0,d0
    RTS

Strlen:
CountString:
        move.l a1,-(Sp)
        move.l a0,a1
.l1:    cmpi.b #$00,(a1)+
        bne .l1
        lea -1(a1),a1
        sub.l a0,a1
        move.l a1,d0
        move.l (sp)+,a1
        RTS

CountEOL:
        move.l a1,-(Sp)
        move.l a0,a1
.l1:    cmpi.b #$0a,(a1)
        beq .l2
        cmpi.b #$00,(a1)+
        bne .l1
        lea -1(a1),a1
.l2:    sub.l a0,a1
        move.l a1,d0
        addq.l #1,d0
        cmpi.b #$00,(a0)
        beq .null
        move.l (sp)+,a1
        RTS
.null:  clr.l d0
        move.l (sp)+,a1
        RTS

CD:
        Move.l DOSBase,a6
        Move.l a0,d1
        Move.l #Access_read,d2
        Jsr Lock(a6)
        Tst.l d0
        Beq .ende
        Move.l d0,d1
        Jsr Currentdir(a6)
        Move.l d0,d1
        Jsr Unlock(a6)
        moveq.l #-1,d0
.ende:  RTS

GetFilename:
        cmpi.l #0,laenge
        beq .l13
        cmpi.l #1,laenge
        beq .l13
        suba.l a2,a2
        suba.l a1,a1
        Move.l Adresse,a0
.l1:    cmpi.b #`"`,(a0)
        beq .l10
        cmpi.b #` `,(a0)+
        beq .l1
        lea -1(a0),a1
.l2:    cmpi.b #`"`,(a0)
        beq .l11
        cmpi.b #$0a,(a0)
        beq .l12
        cmpi.b #$00,(a0)
        beq .l12
        cmpi.b #` `,(a0)+
        bne .l2
        Lea -1(a0),a2
.l3:    suba.l a1,a2
        move.l A0,NextArg
        Move.l ExecBase,a6
        Move.l a1,a0
        Move.l #Filename,a1
        Move.l a2,d0
        Jsr Copymem(a6)
        cmpi.w #$2e00,Filename
        bne .l4
        lea filename,a1
        move.l #"Prog",(a1)+
        move.l #"Dir:",(a1)+
        move.b #0,(a1)+
.l4:    Move.l a2,d0
        rts
.l10:   lea 1(a0),a1
        movea.l a1,a0
        bra .l22
.l11:   move.l a0,a2
        bra .l3
.l12:   move.l a0,a2
        bra .l3
.l13:   moveq.l #0,d0
        RTS
.l22:   cmpi.b #`"`,(a0)
        beq .l11
        cmpi.b #$0a,(a0)
        beq .l12
        cmpi.b #$00,(a0)
        beq .l12
        lea 1(a0),a0
        bra .l22
; Compiler: PreAss 1.54
;
; Parameter: FormatString,SpeicherArray(Quelldaten),PutProc,Array(Ziel)
; Aufruf: SprintF(string,"%s",>DataTags:String*}
; 
; Datum : 13.6.2001


PutCFunktion:
    move.b d0,(a3)+
    rts


SprintF:          
    lea PutCFunktion,a2
    Move.l ExecBase,a6
    Move.l a0,a0
    Move.l a1,a1
    Move.l a2,a2
    Jsr RawDoFmt(a6)
    RTS



RDArgs.CS_Buffer=0
RDArgs.CS_Lenght=4
RDArgs.CS_CurChr=8
RDArgs.RDA_DAList=12
RDArgs.RDA_Buffer=16
RDArgs.RDA_BufSiz=20
RDArgs.RDA_ExtHelp=24
RDArgs.RDA_Flags=28


VarRoot.Name=0
VarRoot.type=4
VarRoot.ID=8
VarRoot.Public=12
VarRoot.next=16
MethodeRoot.Name=0
MethodeRoot.Invalid=4
MethodeRoot.Counter=8
MethodeRoot.sync=12
MethodeRoot.static=16
MethodeRoot.abstract=20
MethodeRoot.public=24
MethodeRoot.private=28
MethodeRoot.protected=32
MethodeRoot.next=36
LineRoot.Name=0
LineRoot.MethodeID=4
LineRoot.next=8
ObjectRoot.Name=0
ObjectRoot.Klasse=4
ObjectRoot.ID=8
ObjectRoot.next=12
ConstructorRoot.Name=0
ConstructorRoot.Klasse=4
ConstructorRoot.next=8
StringRoot.Name=0
StringRoot.next=4







; converts com.amiga.system.doswrapper -> com/amiga/system/doswrapper

BuildClassString:    
    cmpi.b #".",(a0)
    bne .l1
    move.b #"/",(a0)
.l1:cmpi.b #$00,(a0)+
    bne BuildClassString
    RTS

; converts com/amiga/system/doswrapper -> com.amiga.system.doswrapper 

ReBuildClassString:    
    cmpi.b #"/",(a0)
    bne .l1
    move.b #".",(a0)
.l1:cmpi.b #$00,(a0)+
    bne ReBuildClassString
    RTS

; removes LF at end of line 

RemoveLF:    
    cmpi.b #$00,(a0)+
    bne RemoveLF
    cmpi.b #$0a,-2(a0)
    bne .rts1
    move.b #$00,-2(a0)
.rts1:
    cmpi.b #$0a,-1(a0)
    bne .rts
    move.b #$00,-1(a0)
.rts:
    RTS

;  AddObject(RootEntry,ObjectName,ClassName,MethodeID)
;  
;  Structure ObjectRoot,Name(APTR),Klasse(APTR),ID(LONG),next(APTR)
; 
;  adds a new objectentry to the end of the chained list of
;  objectentries. 
;
;  Each entry looks like the rootentry.
;
;  This routine is *highly* recursible. 
;

addObject:             
    sub.l  #0036,a7
    Move.l  a0,0000(a7)
    Move.l  A1,0004(a7)
    Move.l  a2,0008(a7)
    Move.l  d0,0012(a7)
    Move.l  #0,0024(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l ObjectRoot.next(a0),d0
    Move.l D0,0016(a7)
    Move.l 0016(a7),d0
    Cmp.l #0,d0
    Beq .pre0000
    Bra .pre0001
.pre0000:

        Move.l 0004(a7),A0
        Jsr Strlen
        Move.l D0,0028(a7)
        Move.l 0028(a7),d0
        Addq.l #1,d0
        Move.l D0,lena
move.l IntuitionBase,a6
move.l #Rememberstruct,a0
move.l #16,d0
move.l  #MEMF_FAST!MEMF_CLEAR,d1
jsr -396(a6)
move.l d0,0016(a7)
move.l IntuitionBase,a6
move.l #Rememberstruct,a0
move.l lena,d0
move.l  #MEMF_FAST!MEMF_CLEAR,d1
jsr -396(a6)
move.l d0,0020(a7)
        Move.l ExecBase,a6
        Move.l 0004(a7),a0
        Move.l 0020(a7),a1
        Move.l 0028(a7),d0
        Jsr copymem(a6)

        Move.l 0008(a7),d0
        Cmp.l #0,d0
        Bne .pre0002
        Bra .pre0003
.pre0002:

            Move.l 0008(a7),A0
            Jsr Strlen
            Move.l D0,0028(a7)
            Move.l 0028(a7),d0
            Addq.l #1,d0
            Move.l D0,lena
move.l IntuitionBase,a6
move.l #Rememberstruct,a0
move.l lena,d0
move.l  #MEMF_FAST!MEMF_CLEAR,d1
jsr -396(a6)
move.l d0,0024(a7)
            Move.l ExecBase,a6
            Move.l 0008(a7),a0
            Move.l 0024(a7),a1
            Move.l 0028(a7),d0
            Jsr copymem(a6)
.Pre0003:

        Move.l  0016(a7),a0 

        Lea ObjectRoot.Name(a0),a0
        Move.l 0020(a7),(a0)
        Move.l  0016(a7),a0 

        Lea ObjectRoot.Klasse(a0),a0
        Move.l 0024(a7),(a0)
        Move.l  0016(a7),a0 

        Lea ObjectRoot.ID(a0),a0
        Move.l 0012(a7),(a0)
        Move.l  0016(a7),a0 

        Lea ObjectRoot.Next(a0),a0
        Move.l #0,(a0)
        Move.l  0000(a7),a0 

        Lea ObjectRoot.Next(a0),a0
        Move.l 0016(a7),(a0)
                Add.l  #0036,a7
        rts
.Pre0001:
    Move.l 0016(a7),a0
    Move.l 0004(a7),A1
    Move.l 0008(a7),a2
    Move.l 0012(a7),D0
    Jsr AddObject
        Add.l  #0036,a7
    rts

;  AddConstructor(RootEntry,ObjectName,ClassName)
;  
;  Structure ConstructorRoot,0004(a7)(APTR),Klasse(APTR),0016(a7)(APTR)
; 
;  adds a new constructorentry to the end of the chained list of
;  constructorentries. 
;
;  Each entry looks like the rootentry.
;
;  This routine is *highly* recursible. 
;

addConstructor:          
    sub.l  #0032,a7
    Move.l  a0,0000(a7)
    Move.l  A1,0004(a7)
    Move.l  a2,0008(a7)
    Move.l  #0,0020(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l ConstructorRoot.next(a0),d0
    Move.l D0,0012(a7)
    Move.l 0012(a7),d0
    Cmp.l #0,d0
    Beq .pre0004
    Bra .pre0005
.pre0004:

        Move.l 0004(a7),A0
        Jsr Strlen
        Move.l D0,0024(a7)
        Move.l 0024(a7),d0
        Addq.l #1,d0
        Move.l D0,lena
move.l IntuitionBase,a6
move.l #Rememberstruct,a0
move.l #12,d0
move.l  #MEMF_FAST!MEMF_CLEAR,d1
jsr -396(a6)
move.l d0,0012(a7)
move.l IntuitionBase,a6
move.l #Rememberstruct,a0
move.l lena,d0
move.l  #MEMF_FAST!MEMF_CLEAR,d1
jsr -396(a6)
move.l d0,0016(a7)
        Move.l ExecBase,a6
        Move.l 0004(a7),a0
        Move.l 0016(a7),a1
        Move.l 0024(a7),d0
        Jsr copymem(a6)

        Move.l 0008(a7),d0
        Cmp.l #0,d0
        Bne .pre0006
        Bra .pre0007
.pre0006:

            Move.l 0008(a7),A0
            Jsr Strlen
            Move.l D0,0024(a7)
            Move.l 0024(a7),d0
            Addq.l #1,d0
            Move.l D0,lena
move.l IntuitionBase,a6
move.l #Rememberstruct,a0
move.l lena,d0
move.l  #MEMF_FAST!MEMF_CLEAR,d1
jsr -396(a6)
move.l d0,0020(a7)
            Move.l ExecBase,a6
            Move.l 0008(a7),a0
            Move.l 0020(a7),a1
            Move.l 0024(a7),d0
            Jsr copymem(a6)
.Pre0007:

        Move.l  0012(a7),a0 

        Lea ConstructorRoot.Name(a0),a0
        Move.l 0016(a7),(a0)
        Move.l  0012(a7),a0 

        Lea ConstructorRoot.Klasse(a0),a0
        Move.l 0020(a7),(a0)
        Move.l  0012(a7),a0 

        Lea ConstructorRoot.Next(a0),a0
        Move.l #0,(a0)
        Move.l  0000(a7),a0 

        Lea ConstructorRoot.Next(a0),a0
        Move.l 0012(a7),(a0)
                Add.l  #0032,a7
        rts
.Pre0005:
    Move.l 0012(a7),a0
    Move.l 0004(a7),A1
    Move.l 0008(a7),a2
    Jsr AddConstructor
        Add.l  #0032,a7
    rts

;  makeSubString(from,to,length)
;
;  copies from to length bytes and adds a NULL at the end to make 
;  a Null-terminated-String out of it.

makeSubString:          
    sub.l  #0016,a7
    Move.l  a0,0000(a7)
    Move.l  a1,0004(a7)
    Move.l  d0,0008(a7)
    Move.l ExecBase,a6
    Move.l 0000(a7),a0
    Move.l 0004(a7),a1
    Move.l 0008(a7),d0
    Jsr copymem(a6)
    Move.l #x_00name015,a0
    Move.l 0004(a7),a1
     Add.l  0008(a7),a1
    Move.l #1,d0
    Jsr copymem(a6)
        Add.l  #0016,a7
    rts

;  CalcOBS(VarRoot)
;
;  calculates the size thats been used when this object is
;  constructed.
;
;  This routine is *highly* recursible. 

calcOBS:    
    sub.l  #0024,a7
    Move.l  d0,0000(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l VarRoot.name(a0),d0
    Move.l D0,0008(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l VarRoot.ID(a0),d0
    Move.l D0,0012(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l VarRoot.next(a0),d0
    Move.l D0,0004(a7)
    Move.l 0004(a7),d0
    Cmp.l #0,d0
    Beq .pre0008
    Bra .pre0009
.pre0008:

       Move.l #4,d0
       Add.l  #0024,a7
       rts
.Pre0009:
    Move.l 0004(a7),d0
    Cmp.l #0,d0
    Bne .pre0010
    Bra .pre0011
.pre0010:

       Move.l 0004(a7),d0
       Jsr calcOBS
       Move.l D0,0016(a7)
       Move.l 0012(a7),d0
       Cmp.l #0,d0
       Beq .pre0012
       Bra .pre0013
.pre0012:

          Move.l 0016(a7),d0
          Addq.l #4,d0
          Move.l D0,0016(a7)
.Pre0013:
.Pre0011:
    Move.l 0016(a7),d0
    Add.l  #0024,a7
    rts

; Stringfind2(String)
;
; seek "," , ")" , "\$00" in the String
;
;


Stringfind2:    
    move.l #0,d2
.l0:cmpi.b #$22,(a0)
    beq .klammer
    cmpi.b #",",(a0)
    beq .ok
    cmpi.b #")",(a0)
    beq .ok
    cmpi.b #0,(a0)
    beq .ok2
    cmpi.b #"+",(a0)
    beq .l3
    cmpi.b #"-",(a0)
    beq .l3
    cmpi.b #"*",(a0)
    beq .l3
    cmpi.b #"/",(a0)
    beq .l3
.l2:lea 1(a0),a0
    bra .l0
.l3:move.b (a0),d2
    bra.s .l2
.ok:move.l a0,d0
    clr.l d1
    move.b (a0),d1
    rts
.ok2:move.l #0,d0
     move.l d0,d1
     rts
.klammer:
    lea 1(a0),a0
.l1:cmpi.b #$22,(a0)+
    bne .l1
    bra .l0

; SeekClosingbracket(String)
;
; seek ")" in the String
;
;


SeekClosingbracket:    
    move.l #0,d2
.l0:cmpi.b #$22,(a0)
    beq .klammer
    cmpi.b #")",(a0)
    beq .ok
    cmpi.b #$00,(a0)
    beq .ok2
    lea 1(a0),a0
    bra .l0
.ok:move.l a0,d0
    clr.l d1
    move.b (a0),d1
    rts
.ok2:move.l #0,d0
     move.l d0,d1
     rts
.klammer:
    lea 1(a0),a0
.l1:cmpi.b #$22,(a0)+
    bne .l1
    bra .l0


;  PrintPublicMethoden(MethodeRoot,OutputMode)
; 
;  generates the jumptableentries for the librarypart in Mode = 0,
;  the functionnames in the PublicFunctionStringArray in Mode = 1
;                           and the MethodeSignatures in Mode = 2.
;
;  This routine is *highly* recursible. 


PrintPublicMethoden:       
    sub.l  #0040,a7
    Move.l  d0,0000(a7)
    Move.l  d1,0004(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l MethodeRoot.name(a0),d0
    Move.l D0,0012(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l MethodeRoot.public(a0),d0
    Move.l D0,0016(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l MethodeRoot.next(a0),d0
    Move.l D0,0008(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l MethodeRoot.Counter(a0),d0
    Move.l D0,0032(a7)
    Move.l 0016(a7),d0
    Cmp.l #0,d0
    Bne .pre0014
    Bra .pre0015
.pre0014:

        Move.l 0012(a7),a0
        Move.l #_name016,a1
        Jsr Stringfind
        Move.l D0,0020(a7)
        Move.l 0012(a7),a0
        lea buffer,a1
        Move.l 0020(a7),d0
         Sub.l  0012(a7),d0
        Jsr makeSubString
        Move.l 0004(a7),d0
        Cmp.l #0,d0
        Beq .pre0016
        Bra .pre0017
.pre0016:

lea pf017,a0
move.l  0032(a7),0004(a0)
Move.l DOSBase,a6
Move.l #___name017,d1
Move.l #pf017,d2
Jsr vpf(a6)
.Pre0017:
        Move.l 0004(a7),d0
        Cmp.l #1,d0
        Beq .pre0018
        Bra .pre0019
.pre0018:

Move.l DOSBase,a6
Move.l #_x_22name018,d1
Move.l #pf018,d2
Jsr vpf(a6)
.Pre0019:
        Move.l 0004(a7),d0
        Cmp.l #2,d0
        Beq .pre0020
        Bra .pre0021
.pre0020:

           Move.l 0020(a7),d0
           Addq.l #1,d0
           Move.l D0,0020(a7)
           Clr.l d0
           Move.l 0020(a7),a0
           Move.b 0(a0),d0
           Move.l D0,0028(a7)
Move.l DOSBase,a6
Move.l #_x_22name019,d1
Move.l #nullt,d2
Jsr vpf(a6)
.While0000:
         Move.l 0028(a7),d0
         Cmp.l #$29,d0
         Bne .pre0022
         Bra .pre0023
.pre0022:
Move.l 0020(a7),a0
Move.l #_name020,a1
Jsr Stringfind
Move.l D0,0024(a7)
                Cmp.l #0,d0
                Beq .While0001
                Move.l 0020(a7),a0
                lea buffer,a1
                Move.l 0024(a7),d0
                 Sub.l  0020(a7),d0
                Jsr makeSubString
Move.l DOSBase,a6
Move.l #name021,d1
Move.l #pf021,d2
Jsr vpf(a6)
Move.l 0024(a7),a0
Move.l #_name022,a1
Jsr Stringfind
Move.l D0,0020(a7)
              Cmp.l #0,d0
              Beq .While0001
Bra .While0000
.Pre0023:
.While0001:
Move.l DOSBase,a6
Move.l #x_22name023,d1
Move.l #nullt,d2
Jsr vpf(a6)
.Pre0021:
.Pre0015:
    Move.l 0008(a7),d0
    Cmp.l #0,d0
    Bne .pre0024
    Bra .pre0025
.pre0024:

       Move.l 0008(a7),d0
       Move.l 0004(a7),d1
       Jsr PrintPublicMethoden
.Pre0025:
        Add.l  #0040,a7
    rts

;  PrintAbstractMethoden(MethodeRoot)
;
;  prints out all abstract methodes, which are left after compiling
;  the source, to let the programmer know WHY he couldn`t compile 
;  the class. 
;
;  This routine is *highly* recursible


PrintAbstractMethoden:    
    sub.l  #0036,a7
    Move.l  d0,0000(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l MethodeRoot.next(a0),d0
    Move.l D0,0004(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l MethodeRoot.name(a0),d0
    Move.l D0,0008(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l MethodeRoot.static(a0),d0
    Move.l D0,0028(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l MethodeRoot.public(a0),d0
    Move.l D0,0012(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l MethodeRoot.private(a0),d0
    Move.l D0,0024(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l MethodeRoot.abstract(a0),d0
    Move.l D0,0016(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l MethodeRoot.protected(a0),d0
    Move.l D0,0020(a7)
    Move.l 0016(a7),d0
    Cmp.l #0,d0
    Bne .pre0026
    Bra .pre0027
.pre0026:

Move.l DOSBase,a6
Move.l #abstract_name024,d1
Move.l #nullt,d2
Jsr vpf(a6)
      Move.l 0028(a7),d0
      Cmp.l #0,d0
      Bne .pre0028
      Bra .pre0029
.pre0028:

Move.l DOSBase,a6
Move.l #static_name025,d1
Move.l #nullt,d2
Jsr vpf(a6)
.Pre0029:
        Move.l 0012(a7),d0
        Cmp.l #0,d0
        Bne .pre0030
        Bra .pre0031
.pre0030:

Move.l DOSBase,a6
Move.l #public_name026,d1
Move.l #nullt,d2
Jsr vpf(a6)
.Pre0031:
        Move.l 0020(a7),d0
        Cmp.l #0,d0
        Bne .pre0032
        Bra .pre0033
.pre0032:

Move.l DOSBase,a6
Move.l #protected_name027,d1
Move.l #nullt,d2
Jsr vpf(a6)
.Pre0033:
        Move.l 0024(a7),d0
        Cmp.l #0,d0
        Bne .pre0034
        Bra .pre0035
.pre0034:

Move.l DOSBase,a6
Move.l #private_name028,d1
Move.l #nullt,d2
Jsr vpf(a6)
.Pre0035:
lea pf029,a0
move.l  0008(a7),0000(a0)
Move.l #name029,d1
Move.l #pf029,d2
Jsr vpf(a6)
.Pre0027:
    Move.l 0004(a7),d0
    Cmp.l #0,d0
    Bne .pre0036
    Bra .pre0037
.pre0036:

       Move.l 0004(a7),d0
       Jsr PrintAbstractMethoden
.Pre0037:
        Add.l  #0036,a7
    rts

PrintVar:             
    sub.l  #0040,a7
    Move.l  d0,0000(a7)
    Move.l  d1,0004(a7)
    Move.l  d2,0008(a7)
    Move.l  d3,0012(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l VarRoot.next(a0),d0
    Move.l D0,0020(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l VarRoot.name(a0),d0
    Move.l D0,0024(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l VarRoot.type(a0),d0
    Move.l D0,0028(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l varRoot.id(a0),d0
    Move.l D0,0032(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l varRoot.Public(a0),d0
    Move.l D0,0016(a7)

    Move.l 0016(a7),d0
    Cmp.l #0,d0
    Bne .pre0038
    Bra .pre0039
.pre0038:

       Move.l 0032(a7),d0
       Cmp.l 0008(a7),d0
       Beq .pre0040
       Bra .pre0041
.pre0040:

           Move.l 0012(a7),d0
           Cmp.l #0,d0
           Beq .pre0042
           Bra .pre0043
.pre0042:

              Move.l DOSBase,a6
              Move.l 0004(a7),d1
              Move.l #_name030,d2
              Jsr Fputs(a6)
.Pre0043:
           Move.l 0012(a7),d0
           Cmp.l #1,d0
           Beq .pre0044
           Bra .pre0045
.pre0044:

              Move.l DOSBase,a6
              Move.l 0004(a7),d1
              Move.l #x_09name031,d2
              Jsr Fputs(a6)
.Pre0045:
           Move.l 0028(a7),d0
           Cmp.l #1,d0
           Beq .pre0046
           Bra .pre0047
.pre0046:

               Move.l DOSBase,a6
               Move.l 0004(a7),d1
               Move.l #long_name032,d2
               Jsr Fputs(a6)
.Pre0047:
           Move.l 0028(a7),d0
           Cmp.l #2,d0
           Beq .pre0048
           Bra .pre0049
.pre0048:

               Move.l DOSBase,a6
               Move.l 0004(a7),d1
               Move.l #long_p_name033,d2
               Jsr Fputs(a6)
.Pre0049:
           Move.l 0004(a7),d1
           Move.l 0024(a7),d2
           Jsr Fputs(a6)
           Move.l 0012(a7),d0
           Cmp.l #1,d0
           Beq .pre0050
           Bra .pre0051
.pre0050:

              Move.l DOSBase,a6
              Move.l 0004(a7),d1
              Move.l #xnname034,d2
              Jsr Fputs(a6)
.Pre0051:
.Pre0041:
.Pre0039:

    Move.l 0020(a7),d0
    Cmp.l #0,d0
    Bne .pre0052
    Bra .pre0053
.pre0052:

       Move.l 0020(a7),d0
       Move.l 0004(a7),d1
       Move.l 0008(a7),d2
       Move.l 0012(a7),d3
       Jsr PrintVar
.Pre0053:
        Add.l  #0040,a7
    rts

PrintObject:             
    sub.l  #0036,a7
    Move.l  d0,0000(a7)
    Move.l  d1,0004(a7)
    Move.l  d2,0008(a7)
    Move.l  d3,0012(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l ObjectRoot.next(a0),d0
    Move.l D0,0016(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l ObjectRoot.name(a0),d0
    Move.l D0,0020(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l ObjectRoot.Klasse(a0),d0
    Move.l D0,0024(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l ObjectRoot.id(a0),d0
    Move.l D0,0028(a7)

    Move.l 0028(a7),d0
    Cmp.l 0008(a7),d0
    Beq .pre0054
    Bra .pre0055
.pre0054:

       Move.l 0024(a7),d0
       Cmp.l #0,d0
       Bne .pre0056
       Bra .pre0057
.pre0056:

          Move.l 0012(a7),d0
          Cmp.l #0,d0
          Beq .pre0058
          Bra .pre0059
.pre0058:

               Move.l DOSBase,a6
               Move.l 0004(a7),d1
               Move.l #_Object_name035,d2
               Jsr Fputs(a6)
               Move.l 0024(a7),a0
               Jsr ReBuildClassString
               Move.l DOSBase,a6
               Move.l 0004(a7),d1
               Move.l 0024(a7),d2
               Jsr Fputs(a6)
               Move.l 0004(a7),d1
               Move.l #_name036,d2
               Jsr Fputs(a6)
               Move.l 0004(a7),d1
               Move.l 0020(a7),d2
               Jsr Fputs(a6)
.Pre0059:
          Move.l 0012(a7),d0
          Cmp.l #1,d0
          Beq .pre0060
          Bra .pre0061
.pre0060:

               Move.l DOSBase,a6
               Move.l 0004(a7),d1
               Move.l #x_09Object_name037,d2
               Jsr Fputs(a6)
               Move.l 0024(a7),a0
               Jsr ReBuildClassString
               Move.l DOSBase,a6
               Move.l 0004(a7),d1
               Move.l 0024(a7),d2
               Jsr Fputs(a6)
               Move.l 0004(a7),d1
               Move.l #_name038,d2
               Jsr Fputs(a6)
               Move.l 0004(a7),d1
               Move.l 0020(a7),d2
               Jsr Fputs(a6)
               Move.l 0004(a7),d1
               Move.l #xnname039,d2
               Jsr Fputs(a6)
.Pre0061:
.Pre0057:
.Pre0055:

    Move.l 0016(a7),d0
    Cmp.l #0,d0
    Bne .pre0062
    Bra .pre0063
.pre0062:

       Move.l 0016(a7),d0
       Move.l 0004(a7),d1
       Move.l 0008(a7),d2
       Move.l 0012(a7),d3
       Jsr PrintObject
.Pre0063:
        Add.l  #0036,a7
    rts

PrintMethoden:       
    sub.l  #0040,a7
    Move.l  d0,0000(a7)
    Move.l  d1,0004(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l MethodeRoot.next(a0),d0
    Move.l D0,0008(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l MethodeRoot.name(a0),d0
    Move.l D0,0012(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l MethodeRoot.static(a0),d0
    Move.l D0,0032(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l MethodeRoot.public(a0),d0
    Move.l D0,0016(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l MethodeRoot.private(a0),d0
    Move.l D0,0028(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l MethodeRoot.abstract(a0),d0
    Move.l D0,0020(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l MethodeRoot.protected(a0),d0
    Move.l D0,0024(a7)
    Move.l 0012(a7),d0
    Cmp.l #0,d0
    Bne .pre0064
    Bra .pre0065
.pre0064:

        Move.l 0032(a7),d0
        Cmp.l #0,d0
        Bne .pre0066
        Bra .pre0067
.pre0066:

            Move.l DOSBase,a6
            Move.l 0004(a7),d1
            Move.l #static_name040,d2
            Jsr Fputs(a6)
.Pre0067:
        Move.l 0020(a7),d0
        Cmp.l #0,d0
        Bne .pre0068
        Bra .pre0069
.pre0068:

            Move.l DOSBase,a6
            Move.l 0004(a7),d1
            Move.l #abstract_name041,d2
            Jsr Fputs(a6)
.Pre0069:
        Move.l 0016(a7),d0
        Cmp.l #0,d0
        Bne .pre0070
        Bra .pre0071
.pre0070:

            Move.l DOSBase,a6
            Move.l 0004(a7),d1
            Move.l #public_name042,d2
            Jsr Fputs(a6)
.Pre0071:
        Move.l 0024(a7),d0
        Cmp.l #0,d0
        Bne .pre0072
        Bra .pre0073
.pre0072:

            Move.l DOSBase,a6
            Move.l 0004(a7),d1
            Move.l #protected_name043,d2
            Jsr Fputs(a6)
.Pre0073:
        Move.l 0028(a7),d0
        Cmp.l #0,d0
        Bne .pre0074
        Bra .pre0075
.pre0074:

            Move.l DOSBase,a6
            Move.l 0004(a7),d1
            Move.l #private_name044,d2
            Jsr Fputs(a6)
.Pre0075:
        Move.l 0004(a7),d1
        Move.l 0012(a7),d2
        Jsr Fputs(a6)
        Move.l 0004(a7),d1
        Move.l #x_09___Object_Thisname045,d2
        Jsr Fputs(a6)
        Move.l ObjectRoot,d0
        Move.l 0004(a7),d1
        Move.l 0000(a7),d2
        Move.l #0,d3
        Jsr printObject
        Move.l VarRoot,d0
        Move.l 0004(a7),d1
        Move.l 0000(a7),d2
        Move.l #0,d3
        Jsr printVar
        Move.l DOSBase,a6
        Move.l 0004(a7),d1
        Move.l #_name046,d2
        Jsr Fputs(a6)
.Pre0065:
    Move.l 0008(a7),d0
    Cmp.l #0,d0
    Bne .pre0076
    Bra .pre0077
.pre0076:

       Move.l 0008(a7),d0
       Move.l 0004(a7),d1
       Jsr PrintMethoden
.Pre0077:
        Add.l  #0040,a7
    rts


findAbstractMethoden:    
    sub.l  #0020,a7
    Move.l  d0,0000(a7)
    Move.l  #0,0012(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l MethodeRoot.next(a0),d0
    Move.l D0,0004(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l MethodeRoot.abstract(a0),d0
    Move.l D0,0008(a7)
    Move.l 0004(a7),d0
    Cmp.l #0,d0
    Bne .pre0078
    Bra .pre0079
.pre0078:

       Move.l 0004(a7),d0
       Jsr FindAbstractMethoden
       Move.l D0,0012(a7)
.Pre0079:
    Move.l 0008(a7),d0
    Cmp.l #0,d0
    Bne .pre0080
    Bra .pre0081
.pre0080:

       Move.l 0012(a7),d0
       Addq.l #1,d0
       Move.l D0,0012(a7)
.Pre0081:
    Move.l 0012(a7),d0
    Add.l  #0020,a7
    rts


addLine2:          
    sub.l  #0028,a7
    Move.l  a0,0000(a7)
    Move.l  A1,0004(a7)
    Move.l  d0,0008(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l LineRoot.next(a0),d0
    Move.l D0,0012(a7)
    Move.l 0012(a7),d0
    Cmp.l #0,d0
    Beq .pre0082
    Bra .pre0083
.pre0082:

        Move.l 0004(a7),a0
        Jsr removeLF
        Move.l 0004(a7),A0
        Jsr Strlen
        Move.l D0,0020(a7)
        Move.l 0020(a7),d0
        Addq.l #1,d0
        Move.l D0,lena
move.l IntuitionBase,a6
move.l #Rememberstruct,a0
move.l #12,d0
move.l  #MEMF_FAST!MEMF_CLEAR,d1
jsr -396(a6)
move.l d0,0012(a7)
move.l IntuitionBase,a6
move.l #Rememberstruct,a0
move.l lena,d0
move.l  #MEMF_FAST!MEMF_CLEAR,d1
jsr -396(a6)
move.l d0,0016(a7)
        Move.l ExecBase,a6
        Move.l 0004(a7),a0
        Move.l 0016(a7),a1
        Move.l 0020(a7),d0
        Jsr copymem(a6)

        Move.l  0012(a7),a0 

        Lea LineRoot.Name(a0),a0
        Move.l 0016(a7),(a0)
        Move.l  0012(a7),a0 

        Lea LineRoot.MethodeID(a0),a0
        Move.l 0008(a7),(a0)
        Move.l  0012(a7),a0 

        Lea LineRoot.Next(a0),a0
        Move.l #0,(a0)
        Move.l  0000(a7),a0 

        Lea LineRoot.Next(a0),a0
        Move.l 0012(a7),(a0)
                Add.l  #0028,a7
        rts
.Pre0083:
    Move.l 0012(a7),a0
    Move.l 0004(a7),A1
    Move.l 0008(a7),D0
    Jsr AddLine2
        Add.l  #0028,a7
    rts

isSync:       
    sub.l  #0028,a7
    Move.l  d1,0000(a7)
    Move.l  d0,0016(a7)
    Clr.l d0
    Move.l 0016(a7),a0
    Move.l MethodeRoot.sync(a0),d0
    Move.l D0,0004(a7)
    Clr.l d0
    Move.l 0016(a7),a0
    Move.l MethodeRoot.next(a0),d0
    Move.l D0,0020(a7)
    Move.l 0016(a7),d0
    Cmp.l 0000(a7),d0
    Beq .pre0084
    Bra .pre0085
.pre0084:
Move.l 0004(a7),d0
Cmp.l #0,d0
Bne .pre0086
Bra .pre0087
.pre0086:

        Move.l #1,d0
        Add.l  #0028,a7
        rts
.Pre0087:
.Pre0085:
    Move.l 0020(a7),d0
    Cmp.l #0,d0
    Bne .pre0088
    Bra .pre0089
.pre0088:

        Move.l 0020(a7),d0
        Move.l 0000(a7),d1
        Jsr isSync
        Move.l D0,0008(a7)
        Move.l 0008(a7),d0
        Add.l  #0028,a7
        rts
.Pre0089:
    Move.l #0,d0
    Add.l  #0028,a7
    rts


SpeichereInstanzVariablen:    
    sub.l  #0020,a7
    Move.l  a0,0000(a7)
    Move.l 0000(a7),d0
    Cmp.l #0,d0
    Beq .pre0090
    Bra .pre0091
.pre0090:

                Add.l  #0020,a7
        rts
.Pre0091:
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l VarRoot.Name(a0),d0
    Move.l D0,0012(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l VarRoot.ID(a0),d0
    Move.l D0,0004(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l VarRoot.Next(a0),d0
    Move.l D0,0008(a7)
    Move.l 0004(a7),d0
    Cmp.l #0,d0
    Beq .pre0092
    Bra .pre0093
.pre0092:

       Move.l 0012(a7),d0
       Cmp.l #0,d0
       Bne .pre0094
       Bra .pre0095
.pre0094:
Move.l 0012(a7),A0
Jsr strlen
Cmp.l #0,d0
Bne .pre0096
Bra .pre0097
.pre0096:

lea spfSIV,a0
move.l  0012(a7),0000(a0)
move.l  0012(a7),0008(a0)
           lea store,a3
           Move.l #x_09name047,a0
           Move.l #spfSIV,a1
           Jsr Sprintf
           Move.l LineRoot,a0
           lea Store,A1
           Move.l MethodeID,D0
           Jsr AddLine2
.Pre0097:
.Pre0095:
.Pre0093:
    Move.l 0008(a7),d0
    Cmp.l #0,d0
    Beq .pre0098
    Bra .pre0099
.pre0098:
Move.l MethodeRoot,d0
Move.l methodeID,d1
Jsr isSync
Cmp.l #0,d0
Bne .pre0100
Bra .pre0101
.pre0100:

           Move.l LineRoot,a0
           Move.l #x_09ReleaseSemaphore_name048,A1
           Move.l MethodeID,D0
           Jsr AddLine2
.Pre0101:
.Pre0099:
    Move.l 0008(a7),d0
    Cmp.l #0,d0
    Bne .pre0102
    Bra .pre0103
.pre0102:

       Move.l 0008(a7),a0
       Jsr SpeichereInstanzVariablen
.Pre0103:
        Add.l  #0020,a7
    rts

PrintInstanzVariablen:       
    sub.l  #0024,a7
    Move.l  a0,0000(a7)
    Move.l  d0,0004(a7)
    Move.l 0000(a7),d0
    Cmp.l #0,d0
    Beq .pre0104
    Bra .pre0105
.pre0104:

                Add.l  #0024,a7
        rts
.Pre0105:
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l VarRoot.Name(a0),d0
    Move.l D0,0016(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l VarRoot.ID(a0),d0
    Move.l D0,0008(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l VarRoot.Next(a0),d0
    Move.l D0,0012(a7)
    Move.l 0008(a7),d0
    Cmp.l #0,d0
    Beq .pre0106
    Bra .pre0107
.pre0106:

       Move.l 0016(a7),d0
       Cmp.l #0,d0
       Bne .pre0108
       Bra .pre0109
.pre0108:
Move.l 0016(a7),A0
Jsr strlen
Cmp.l #0,d0
Bne .pre0110
Bra .pre0111
.pre0110:

lea pf049,a0
move.l  0016(a7),0000(a0)
move.l  0016(a7),0008(a0)
Move.l DOSBase,a6
Move.l #x_09name049,d1
Move.l #pf049,d2
Jsr vpf(a6)
.Pre0111:
.Pre0109:
.Pre0107:
    Move.l 0012(a7),d0
    Cmp.l #0,d0
    Bne .pre0112
    Bra .pre0113
.pre0112:

       Move.l 0012(a7),a0
       Move.l 0004(a7),d0
       Jsr PrintInstanzVariablen
.Pre0113:
        Add.l  #0024,a7
    rts

getInstanzVariablen:    
    sub.l  #0016,a7
    Move.l  a0,0000(a7)
    Move.l 0000(a7),d0
    Cmp.l #0,d0
    Beq .pre0114
    Bra .pre0115
.pre0114:

                Add.l  #0016,a7
        rts
.Pre0115:
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l VarRoot.Name(a0),d0
    Move.l D0,0008(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l VarRoot.ID(a0),d0
    Move.l D0,id
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l VarRoot.Next(a0),d0
    Move.l D0,0004(a7)
    Move.l id,d0
    Cmp.l #0,d0
    Beq .pre0116
    Bra .pre0117
.pre0116:

       Move.l 0008(a7),d0
       Cmp.l #0,d0
       Bne .pre0118
       Bra .pre0119
.pre0118:
Move.l 0008(a7),A0
Jsr strlen
Cmp.l #0,d0
Bne .pre0120
Bra .pre0121
.pre0120:

lea pf050,a0
move.l  0008(a7),0000(a0)
Move.l DOSBase,a6
Move.l #_name050,d1
Move.l #pf050,d2
Jsr vpf(a6)
.Pre0121:
.Pre0119:
.Pre0117:
    Move.l 0004(a7),d0
    Cmp.l #0,d0
    Bne .pre0122
    Bra .pre0123
.pre0122:

       Move.l 0004(a7),a0
       Jsr getInstanzVariablen
.Pre0123:
        Add.l  #0016,a7
    rts

LadeInstanzVariablen:       
    sub.l  #0024,a7
    Move.l  a0,0000(a7)
    Move.l  d0,0004(a7)
    Move.l 0000(a7),d0
    Cmp.l #0,d0
    Beq .pre0124
    Bra .pre0125
.pre0124:

                Add.l  #0024,a7
        rts
.Pre0125:
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l VarRoot.Name(a0),d0
    Move.l D0,0012(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l VarRoot.ID(a0),d0
    Move.l D0,0016(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l VarRoot.Next(a0),d0
    Move.l D0,0008(a7)
    Move.l 0016(a7),d0
    Cmp.l #0,d0
    Beq .pre0126
    Bra .pre0127
.pre0126:

       Move.l 0012(a7),d0
       Cmp.l #0,d0
       Bne .pre0128
       Bra .pre0129
.pre0128:
Move.l 0012(a7),A0
Jsr strlen
Cmp.l #0,d0
Bne .pre0130
Bra .pre0131
.pre0130:

lea pf051,a0
move.l  0012(a7),0000(a0)
move.l  0012(a7),0008(a0)
Move.l DOSBase,a6
Move.l #x_09name051,d1
Move.l #pf051,d2
Jsr vpf(a6)
.Pre0131:
.Pre0129:
.Pre0127:
    Move.l 0008(a7),d0
    Cmp.l #0,d0
    Beq .pre0132
    Bra .pre0133
.pre0132:
Move.l MethodeRoot,d0
Move.l 0004(a7),d1
Jsr isSync
Cmp.l #0,d0
Bne .pre0134
Bra .pre0135
.pre0134:

Move.l DOSBase,a6
Move.l #x_09ObtainSemaphore_name052,d1
Move.l #nullt,d2
Jsr vpf(a6)
.Pre0135:
.Pre0133:

    Move.l 0008(a7),d0
    Cmp.l #0,d0
    Bne .pre0136
    Bra .pre0137
.pre0136:

       Move.l 0008(a7),a0
       Move.l 0004(a7),d0
       Jsr LadeInstanzVariablen
.Pre0137:
        Add.l  #0024,a7
    rts


checkvar:          
    sub.l  #0032,a7
    Move.l  a0,0000(a7)
    Move.l  A1,0004(a7)
    Move.l  d1,0008(a7)

    Clr.l d0
    Move.l 0000(a7),a0
    Move.l VarRoot.name(a0),d0
    Move.l D0,0016(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l VarRoot.id(a0),d0
    Move.l D0,0024(a7)
    Move.l 0016(a7),d0
    Cmp.l #0,d0
    Bne .pre0138
    Bra .pre0139
.pre0138:

        Move.l 0004(a7),a0
        Move.l 0016(a7),a1
        Move.l #0,d0
        Move.l #Mode_NoCase,d1
        Jsr CompareString
        Move.l D0,0020(a7)
        Move.l 0020(a7),d0
        Cmp.l #0,d0
        Beq .pre0140
        Move.l 0024(a7),d0
        Cmp.l 0008(a7),d0
        Bne .pre0140
        Bra .pre0141
.pre0140:

            Clr.l d0
            Move.l 0000(a7),a0
            Move.l varRoot.next(a0),d0
            Move.l D0,0012(a7)
            Move.l 0012(a7),d0
            Cmp.l #0,d0
            Beq .pre0142
            Bra .pre0143
.pre0142:

                Move.l #0,d0
                Add.l  #0032,a7
                rts
.Pre0143:
            Move.l 0012(a7),a0
            Move.l 0004(a7),A1
            Move.l 0008(a7),d1
            Jsr CheckVar
            Move.l D0,0020(a7)
            Move.l 0020(a7),d0
            Add.l  #0032,a7
            rts
.Pre0141:
.Pre0139:
    Move.l #1,d0
    Add.l  #0032,a7
    rts


istZahl:    
	clr.l d0
	move.b (a0),d1			; Check ob es eine Zahl
	cmpi.b #`$`,d1			; ist(kann auch mit $xxx anfangen)
	beq.b .label1b			; wenn ja automatisch ein # setzen!
	cmpi.b #`-`,d1
	beq.b .label1b
	cmpi.b #`#`,d1
	beq.b .label1b
	subi.b #$30,d1
	cmpi.b #9,d1
	bgt.b .label2
	cmpi.b #0,d1
	blt.b .label2
.label1b:
	move.l #1,d0
.label2:
    rts


addString:          
    sub.l  #0032,a7
    Move.l  a0,0000(a7)
    Move.l  d0,0004(a7)
    Move.l  d1,0008(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l StringRoot.next(a0),d0
    Move.l D0,0012(a7)
    Move.l 0012(a7),d0
    Cmp.l #0,d0
    Beq .pre0144
    Bra .pre0145
.pre0144:

        Move.l 0008(a7),d0
        Sub.l 0004(a7),d0
        Move.l D0,0020(a7)
        Move.l 0020(a7),d0
        Addq.l #1,d0
        Move.l D0,lena
move.l IntuitionBase,a6
move.l #Rememberstruct,a0
move.l #8,d0
move.l  #MEMF_FAST!MEMF_CLEAR,d1
jsr -396(a6)
move.l d0,0012(a7)
move.l IntuitionBase,a6
move.l #Rememberstruct,a0
move.l lena,d0
move.l  #MEMF_FAST!MEMF_CLEAR,d1
jsr -396(a6)
move.l d0,0016(a7)
        Move.l ExecBase,a6
        Move.l 0004(a7),a0
        Move.l 0016(a7),a1
        Move.l 0020(a7),d0
        Jsr copymem(a6)

        Move.l  0012(a7),a0 

        Lea StringRoot.Name(a0),a0
        Move.l 0016(a7),(a0)
        Move.l  0012(a7),a0 

        Lea StringRoot.Next(a0),a0
        Move.l #0,(a0)
        Move.l  0000(a7),a0 

        Lea StringRoot.Next(a0),a0
        Move.l 0012(a7),(a0)
        Move.l #1,d0
        Add.l  #0032,a7
        rts
.Pre0145:
    Move.l 0012(a7),a0
    Move.l 0004(a7),d0
    Move.l 0008(a7),d1
    Jsr AddString
    Move.l D0,0020(a7)
    Move.l 0020(a7),d0
    Addq.l #1,d0
    Move.l D0,0020(a7)
    Move.l 0020(a7),d0
    Add.l  #0032,a7
    rts

addvar:                
    sub.l  #0036,a7
    Move.l  a0,0000(a7)
    Move.l  A1,0004(a7)
    Move.l  d0,0008(a7)
    Move.l  d1,0012(a7)
    Move.l  d2,0016(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l varRoot.next(a0),d0
    Move.l D0,0020(a7)
    Move.l 0020(a7),d0
    Cmp.l #0,d0
    Beq .pre0146
    Bra .pre0147
.pre0146:

        Move.l 0004(a7),A0
        Jsr Strlen
        Move.l D0,0028(a7)
        Move.l 0028(a7),d0
        Addq.l #1,d0
        Move.l D0,lena
move.l IntuitionBase,a6
move.l #Rememberstruct,a0
move.l #20,d0
move.l  #MEMF_FAST!MEMF_CLEAR,d1
jsr -396(a6)
move.l d0,0020(a7)
move.l IntuitionBase,a6
move.l #Rememberstruct,a0
move.l lena,d0
move.l  #MEMF_FAST!MEMF_CLEAR,d1
jsr -396(a6)
move.l d0,0024(a7)
        Move.l ExecBase,a6
        Move.l 0004(a7),a0
        Move.l 0024(a7),a1
        Move.l 0028(a7),d0
        Jsr copymem(a6)

        Move.l  0020(a7),a0 

        Lea varRoot.Name(a0),a0
        Move.l 0024(a7),(a0)
        Move.l  0020(a7),a0 

        Lea varRoot.Type(a0),a0
        Move.l 0008(a7),(a0)
        Move.l  0020(a7),a0 

        Lea varRoot.ID(a0),a0
        Move.l 0012(a7),(a0)
        Move.l  0020(a7),a0 

        Lea varRoot.Public(a0),a0
        Move.l 0016(a7),(a0)
        Move.l  0020(a7),a0 

        Lea varRoot.Next(a0),a0
        Move.l #0,(a0)
        Move.l  0000(a7),a0 

        Lea varRoot.Next(a0),a0
        Move.l 0020(a7),(a0)
                Add.l  #0036,a7
        rts
.Pre0147:
    Move.l 0020(a7),a0
    Move.l 0004(a7),A1
    Move.l 0008(a7),D0
    Move.l 0012(a7),d1
    Move.l 0016(a7),d2
    Jsr AddVar
        Add.l  #0036,a7
    rts

GetObjectArgs:                
    sub.l  #0036,a7
    Move.l  a0,0000(a7)
    Move.l  a1,0004(a7)
    Move.l  d0,0008(a7)
    Move.l  d2,0012(a7)
    Move.l  d1,0028(a7)

Move.l 0000(a7),a0
Move.l #xnname053,a1
Jsr Stringfind
Move.l D0,0016(a7)
    Cmp.l #0,d0
    Bne .pre0148
    Bra .pre0149
.pre0148:

        Move.l ExecBase,a6
        Move.l #x_00name054,a0
        Move.l 0016(a7),a1
        Move.l #1,d0
        Jsr copymem(a6)
.Pre0149:
    lea StoreArgs,A0
    Move.l #0,D0
    Move.l 0008(a7),D1
     Add.l  #2,D1
    Jsr fillbuffer
    Move.l ExecBase,a6
    Move.l 0000(a7),a0
    lea storeArgs,a1
    Move.l 0008(a7),d0
     Add.l  #1,d0
    Jsr copymem(a6)
    Move.l #StoreArgs,d0
    Move.l D0,0000(a7)
.While0002:
Move.l 0000(a7),A0
Jsr Strlen
    Cmp.l #0,d0
    Bgt .pre0150
    Bra .pre0151
.pre0150:
        Clr.l d0
        Move.l 0000(a7),a0
        Move.b 0(a0),d0
        Move.l D0,0020(a7)
        Move.l 0020(a7),d0
        Cmp.l #$22,d0
        Beq .pre0152
        Bra .pre0153
.pre0152:

           lea store,A0
           Move.l #0,D0
           Move.l #200,D1
           Jsr Fillbuffer
           Move.l 0000(a7),a0
            Add.l  #1,a0
           Move.l #x_22name055,a1
           Jsr Stringfind
           Move.l D0,0016(a7)
           Move.l Stringroot,a0
           Move.l 0000(a7),d0
            Add.l  #1,d0
           Move.l 0016(a7),d1
            Sub.l  #1,d1
           Jsr AddString
           Move.l D0,0024(a7)
           Move.l ExecBase,a6
           Move.l 0000(a7),a0
            Add.l  #1,a0
           lea store,a1
           Move.l 0016(a7),d0
            Sub.l  0000(a7),d0
            Sub.l  #1,d0
           Jsr Copymem(a6)
lea pf056,a0
move.l  0024(a7),0000(a0)
Move.l DOSBase,a6
Move.l #x_09___String__Preassxxname056,d1
Move.l #pf056,d2
Jsr vpf(a6)
         Move.l 0012(a7),d0
         Cmp.l #0,d0
         Beq .pre0154
         Bra .pre0155
.pre0154:

              Move.l LineRoot,a0
              lea ObjectPuffer,A1
              Move.l 0028(a7),D0
              Jsr AddLine2
.Pre0155:
lea spfgoa2,a0
move.l  0024(a7),0000(a0)
           Move.l 0004(a7),a3
           Move.l #Preassxxname057,a0
           Move.l #spfgoa2,a1
           Jsr sprintf
           Move.l 0004(a7),A0
           Jsr strlen
           Move.l D0,0024(a7)
           Move.l 0004(a7),d0
           Add.l 0024(a7),d0
           Move.l D0,0004(a7)
           Move.l 0016(a7),d0
           Addq.l #2,d0
           Move.l D0,0000(a7)
           bra.l .While0002
.Pre0153:
Move.l 0000(a7),a0
Move.l #_name058,a1
Jsr stringfind
Move.l D0,0016(a7)
        Cmp.l #0,d0
        Beq .pre0156
        Bra .pre0157
.pre0156:

Move.l 0000(a7),a0
Move.l #x_29name059,a1
Jsr stringfind
Move.l D0,0016(a7)
           Cmp.l #0,d0
           Beq .pre0158
           Bra .pre0159
.pre0158:

                        Move.l #0,d0
                        Add.l  #0036,a7
                        rts
.Pre0159:
.Pre0157:

Move.l 0000(a7),a0
Jsr IstZahl
        Cmp.l #1,d0
        Beq .pre0160
        Bra .pre0161
.pre0160:

           Clr.l d0
           Move.l 0000(a7),a0
           Move.b 0(a0),d0
           Move.l D0,0020(a7)
           Move.l 0020(a7),d0
           Cmp.l #"#",d0
           Beq .pre0162
           Bra .pre0163
.pre0162:

              Move.l 0000(a7),d0
              Addq.l #1,d0
              Move.l D0,0000(a7)
.Pre0163:
           Move.l ExecBase,a6
           Move.l 0000(a7),a0
           Move.l 0004(a7),a1
           Move.l 0016(a7),d0
            Sub.l  0000(a7),d0
           Jsr Copymem(a6)
           Move.l 0004(a7),d0
           Add.l 0016(a7),d0
           Sub.l 0000(a7),d0
           Move.l D0,0004(a7)
           Move.l 0016(a7),d0
           Addq.l #1,d0
           Move.l D0,0000(a7)
Move.l 0000(a7),A0
Jsr strlen
           Cmp.l #0,d0
           Bgt .pre0164
           Bra .pre0165
.pre0164:

              Move.l ExecBase,a6
              Move.l #_name060,a0
              Move.l 0004(a7),a1
              Move.l #1,d0
              Jsr Copymem(a6)
              Move.l 0004(a7),d0
              Addq.l #1,d0
              Move.l D0,0004(a7)
.Pre0165:
           bra.l .While0002
.Pre0161:
        Move.l #_name061,a0
        Move.l 0004(a7),a1
        Move.l #1,d0
        Jsr Copymem(a6)
        Move.l 0000(a7),a0
        Move.l 0004(a7),a1
         Add.l  #1,a1
        Move.l 0016(a7),d0
         Sub.l  0000(a7),d0
        Jsr Copymem(a6)
        Move.l 0004(a7),d0
        Add.l 0016(a7),d0
        Sub.l 0000(a7),d0
        Addq.l #1,d0
        Move.l D0,0004(a7)
        Move.l 0016(a7),d0
        Addq.l #1,d0
        Move.l D0,0000(a7)
Move.l 0000(a7),A0
Jsr strlen
        Cmp.l #0,d0
        Bgt .pre0166
        Bra .pre0167
.pre0166:

           Move.l ExecBase,a6
           Move.l #_name062,a0
           Move.l 0004(a7),a1
           Move.l #1,d0
           Jsr Copymem(a6)
           Move.l 0004(a7),d0
           Addq.l #1,d0
           Move.l D0,0004(a7)
.Pre0167:
Bra .While0002
.Pre0151:
.While0003:

    Clr.l d0
    Move.l 0004(a7),a0
    Move.b -1(a0),d0
    Move.l D0,0020(a7)
    Move.l 0020(a7),d0
    Cmp.l #$2c,d0
    Beq .pre0168
    Bra .pre0169
.pre0168:

       Move.l 0004(a7),d0
       Subq.l #1,d0
       Move.l D0,0004(a7)
Move.l 0004(a7),a0
Move.l #0,(a0)+
Move.l a0,0004(a7)
.Pre0169:
    Move.l #-1,d0
    Add.l  #0036,a7
    rts

CopyOverlay:       
    move.l a1,d7
    sub.l a0,d7
    subq.l #1,d7
    move.l a0,a2
.l0:cmpi.b #$0,(a2)+
    bne .l0
    move.l a2,d6
    sub.l a0,d6
    add.l d6,a1
.l2:move.b (a2),d0
    move.b d0,(a1)
    lea -1(a2),a2
    lea -1(a1),a1
    cmpa.l a0,a2
    bne .l2
    RTS

PreProcessDoMethode:             
    sub.l  #0056,a7
    Move.l  d0,0000(a7)
    Move.l  a1,0032(a7)
    Move.l  a2,0036(a7)
    Move.l  a3,0040(a7)

.While0004:
Move.l 0040(a7),a0
Move.l #name063,a1
Jsr Stringfind
    Cmp.l #0,d0
    Bne .pre0170
    Bra .pre0171
.pre0170:

       Move.l 0036(a7),d0
       Add.l #1,d0
       Cmp.l 0040(a7),d0
       Bne .pre0172
       Bra .pre0173
.pre0172:

          Moveq.l #$1,d0
          Move.l D0,0044(a7)
.While0006:
          Move.l 0044(a7),d0
          Cmp.l #0,d0
          Bne .pre0174
          Bra .pre0175
.pre0174:
           Move.l 0036(a7),a0
            Add.l  #1,a0
           Jsr Stringfind2
           Move.l D0,0044(a7)
           Move.l D1,0028(a7)
           Move.l D2,0024(a7)
           Move.l 0028(a7),d0
           Cmp.l #0,d0
           Bne .pre0176
           Bra .pre0177
.pre0176:

              Move.l 0024(a7),d0
              Cmp.l #0,d0
              Bne .pre0178
              Bra .pre0179
.pre0178:

                 Move.l 0044(a7),d0
                 Sub.l 0036(a7),d0
                 Subq.l #1,d0
                 Move.l D0,0008(a7)

                 Move.l 0036(a7),a0
                  Add.l  #1,a0
                 lea Store,a1
                 Move.l 0008(a7),d0
                 Jsr makeSubString
lea spfPPDM1,a0
move.l  TaglistenNr,0000(a0)
                 lea Objectpuffer,a3
                 Move.l #x_09varname064,a0
                 Move.l #spfPPDM1,a1
                 Jsr Sprintf
                 Move.l LineRoot,a0
                 lea ObjectPuffer,A1
                 Move.l 0000(a7),D0
                 Jsr AddLine2
lea spfPPDM2,a0
move.l  TaglistenNr,0000(a0)
                 lea Store,a3
                 Move.l #varname065,a0
                 Move.l #spfPPDM2,a1
                 Jsr Sprintf
                 lea Store,A0
                 Jsr Strlen
                 Move.l D0,0012(a7)
                 Move.l 0044(a7),A0
                 Jsr Strlen
                 Move.l D0,0016(a7)
                 Move.l 0012(a7),d0
                 Cmp.l 0008(a7),d0
                 Bgt .pre0180
                 Bra .pre0181a
.pre0180:

                    Move.l 0044(a7),a0
                    Move.l 0044(a7),a1
                     Add.l  0012(a7),a1
                     Sub.l  0008(a7),a1
                    Jsr CopyOverlay
bra.l .Pre0181
.Pre0181a:

                    Move.l ExecBase,a6
                    Move.l 0044(a7),a0
                    Move.l 0036(a7),a1
                     Add.l  #1,a1
                     Add.l  0012(a7),a1
                    Move.l 0016(a7),d0
                    Jsr Copymem(a6)
                    Move.l 0036(a7),d0
                    Move.l D0,0044(a7)
.Pre0181:
                 lea Store,a0
                 Move.l 0036(a7),a1
                  Add.l  #1,a1
                 Move.l 0012(a7),d0
                 Jsr Copymem(a6)
                 Move.l Taglistennr,d0
                 Addq.l #1,d0
                 Move.l D0,Taglistennr
                 Move.l VarRoot,a0
                 lea Store,A1
                 Move.l #1,D0
                 Move.l 0000(a7),d1
                 Move.l #0,d2
                 Jsr AddVar
.Pre0179:
              Move.l 0044(a7),d0
              Move.l D0,0036(a7)
              Move.l 0028(a7),d0
              Cmp.l #$29,d0
              Beq .pre0182
              Bra .pre0183
.pre0182:

                         Moveq.l #$0,d0
                         Move.l D0,0044(a7)
.Pre0183:
.Pre0177:
Bra .While0006
.Pre0175:
.While0007:
.Pre0173:
        Move.l 0040(a7),a0
        Move.l #name066,a1
        Jsr Stringfind
        Move.l D0,0032(a7)
        Move.l 0040(a7),a0
        Move.l #_name067,a1
        Jsr Stringfind
        Move.l D0,0036(a7)
        Move.l 0036(a7),a0
        Jsr seekClosingBracket
        Move.l D0,0040(a7)
Bra .While0004
.Pre0171:
.While0005:
     Move.l 0036(a7),d0
     Add.l #1,d0
     Cmp.l 0040(a7),d0
     Bne .pre0184
     Bra .pre0185
.pre0184:

          Moveq.l #$1,d0
          Move.l D0,0044(a7)
.While0008:
          Move.l 0044(a7),d0
          Cmp.l #0,d0
          Bne .pre0186
          Bra .pre0187
.pre0186:
           Move.l 0036(a7),a0
            Add.l  #1,a0
           Jsr Stringfind2
           Move.l D0,0044(a7)
           Move.l D1,0028(a7)
           Move.l D2,0024(a7)
           Move.l 0028(a7),d0
           Cmp.l #0,d0
           Bne .pre0188
           Bra .pre0189
.pre0188:

              Move.l 0024(a7),d0
              Cmp.l #0,d0
              Bne .pre0190
              Bra .pre0191
.pre0190:

                 Move.l 0044(a7),d0
                 Sub.l 0036(a7),d0
                 Subq.l #1,d0
                 Move.l D0,0008(a7)

                 Move.l 0036(a7),a0
                  Add.l  #1,a0
                 lea Store,a1
                 Move.l 0008(a7),d0
                 Jsr makeSubString
lea spfPPDM3,a0
move.l  TaglistenNr,0000(a0)
                 lea Objectpuffer,a3
                 Move.l #x_09varname068,a0
                 Move.l #spfPPDM3,a1
                 Jsr Sprintf
                 Move.l LineRoot,a0
                 lea ObjectPuffer,A1
                 Move.l 0000(a7),D0
                 Jsr AddLine2
lea spfPPDM4,a0
move.l  TaglistenNr,0000(a0)
                 lea Store,a3
                 Move.l #varname069,a0
                 Move.l #spfPPDM4,a1
                 Jsr Sprintf
                 lea Store,A0
                 Jsr Strlen
                 Move.l D0,0012(a7)
                 Move.l 0044(a7),A0
                 Jsr Strlen
                 Move.l D0,0016(a7)
                 Move.l 0012(a7),d0
                 Cmp.l 0008(a7),d0
                 Bgt .pre0192
                 Bra .pre0193a
.pre0192:

                    Move.l 0044(a7),a0
                    Move.l 0044(a7),a1
                     Add.l  0012(a7),a1
                     Sub.l  0008(a7),a1
                    Jsr CopyOverlay
bra.l .Pre0193
.Pre0193a:

                    Move.l ExecBase,a6
                    Move.l 0044(a7),a0
                    Move.l 0036(a7),a1
                     Add.l  #1,a1
                     Add.l  0012(a7),a1
                    Move.l 0016(a7),d0
                    Jsr Copymem(a6)
                    Move.l 0036(a7),d0
                    Move.l D0,0044(a7)
.Pre0193:
                 lea Store,a0
                 Move.l 0036(a7),a1
                  Add.l  #1,a1
                 Move.l 0012(a7),d0
                 Jsr Copymem(a6)
                 Move.l Taglistennr,d0
                 Addq.l #1,d0
                 Move.l D0,Taglistennr
                 Move.l VarRoot,a0
                 lea Store,A1
                 Move.l #1,D0
                 Move.l 0000(a7),d1
                 Move.l #0,d2
                 Jsr AddVar
.Pre0191:
              Move.l 0044(a7),d0
              Move.l D0,0036(a7)
              Move.l 0028(a7),d0
              Cmp.l #$29,d0
              Beq .pre0194
              Bra .pre0195
.pre0194:

                 Moveq.l #$0,d0
                 Move.l D0,0044(a7)
.Pre0195:
.Pre0189:
Bra .While0008
.Pre0187:
.While0009:
.Pre0185:

        Add.l  #0056,a7
    rts

Praeprozessor:       
    sub.l  #0060,a7
    Move.l  a0,0000(a7)
    Move.l  d0,0004(a7)
    Move.l #Store,d0
    Move.l D0,0044(a7)

    Move.l 0044(a7),A0
    Move.l #0,D0
    Move.l #1000,D1
    Jsr Fillbuffer

    lea Buffer,a0
    Move.l #return_K_Aname070,a1
    Jsr LineAnalyse
    Move.l D0,0008(a7)
    Move.l D1,0012(a7)
    Move.l 0008(a7),d0
    Cmp.l #0,d0
    Bne .pre0196
    Bra .pre0197
.pre0196:

       Move.l 0012(a7),d0
       Cmp.l #0,d0
       Bne .pre0198
       Bra .pre0199
.pre0198:

          Clr.l d0
          Move.l SecondvarRoot,a0
          Move.l VarRoot.next(a0),d0
          Move.l D0,0048(a7)
          Move.l 0048(a7),a0
          Jsr SpeichereInstanzVariablen
lea spft2,a0
move.l  0012(a7),0000(a0)
          Move.l 0044(a7),a3
          Move.l #x_09___UnFrameReturn_name071,a0
          Move.l #spft2,a1
          Jsr Sprintf
          Move.l DOSBase,a6
          Move.l 0008(a7),d1
          Jsr FreeArgs(a6)
          Move.l 0044(a7),d0
          Add.l  #0060,a7
          rts
.Pre0199:
       Move.l 0008(a7),d1
       Jsr FreeArgs(a6)
.Pre0197:
    Clr.l d0
    Move.l ObjectRoot,a0
    Move.l ObjectRoot.next(a0),d0
    Move.l D0,0052(a7)
.While0010:
    Move.l 0052(a7),d0
    Cmp.l #0,d0
    Bne .pre0200
    Bra .pre0201
.pre0200:

       Clr.l d0
       Move.l 0052(a7),a0
       Move.l ObjectRoot.name(a0),d0
       Move.l D0,name
lea spfot1,a0
move.l  name,0000(a0)
       lea ObjectPuffer,a3
       Move.l #_name072,a0
       Move.l #spfot1,a1
       Jsr Sprintf
       lea Buffer,a0
       lea ObjectPuffer,a1
       Jsr StringFind
       Move.l D0,0028(a7)
       lea ObjectPuffer,a3
       Move.l #_name073,a0
       Move.l #spfot1,a1
       Jsr Sprintf
       lea Buffer,a0
       lea ObjectPuffer,a1
       Jsr StringFind
       Move.l D0,0032(a7)
       lea ObjectPuffer,a3
       Move.l #x_09name074,a0
       Move.l #spfot1,a1
       Jsr Sprintf
       lea Buffer,a0
       lea ObjectPuffer,a1
       Jsr StringFind
       Move.l D0,0036(a7)

       Move.l 0028(a7),d0
       or.l 0032(a7),d0
       or.l 0036(a7),d0
       Cmp.l #0,d0
       Bne .pre0202
       Bra .pre0203
.pre0202:

          lea Buffer,a0
          Move.l #name075,a1
          Jsr Stringfind
          Move.l D0,0016(a7)
          lea Buffer,a0
          Move.l #_name076,a1
          Jsr Stringfind
          Move.l D0,0020(a7)
          lea Buffer,a0
          Jsr SeekClosingbracket
          Move.l D0,0024(a7)

          Move.l 0004(a7),d0
          Move.l 0016(a7),a1
          Move.l 0020(a7),a2
          Move.l 0024(a7),a3
          Jsr PreProcessDoMethode

lea spfmethods1,a0
move.l  name,0000(a0)
          lea Objectpuffer,a3
          Move.l #x_09movename077,a0
          Move.l #spfmethods1,a1
          Jsr Sprintf
          Move.l LineRoot,a0
          lea ObjectPuffer,A1
          Move.l 0004(a7),D0
          Jsr Addline2
          lea Objectmethode,A0
          Move.l #0,D0
          Move.l #200,D1
          Jsr Fillbuffer
          lea Objectargs,A0
          Move.l #0,D0
          Move.l #200,D1
          Jsr Fillbuffer
          lea Objectpre,A0
          Move.l #0,D0
          Move.l #200,D1
          Jsr Fillbuffer

.While0012:
Move.l 0024(a7),a0
Move.l #name078,a1
Jsr Stringfind
          Cmp.l #0,d0
          Bne .pre0204
          Bra .pre0205
.pre0204:

              lea Objectmethode,A0
              Move.l #0,D0
              Move.l #200,D1
              Jsr Fillbuffer
              lea Objectargs,A0
              Move.l #0,D0
              Move.l #200,D1
              Jsr Fillbuffer
              Move.l ExecBase,a6
              Move.l 0016(a7),a0
               Add.l  #1,a0
              lea Objectmethode,a1
              Move.l 0020(a7),d0
               Sub.l  0016(a7),d0
               Sub.l  #1,d0
              Jsr Copymem(a6)
              Move.l 0020(a7),d0
              Add.l #1,d0
              Cmp.l 0024(a7),d0
              Beq .pre0206
              Bra .pre0207
.pre0206:

                 lea Objectpuffer,a3
                 Move.l #x_09Domethode_d0_x_22name079,a0
                 Move.l #spfmethods2,a1
                 Jsr Sprintf
.Pre0207:
              Move.l 0020(a7),d0
              Add.l #1,d0
              Cmp.l 0024(a7),d0
              Bne .pre0208
              Bra .pre0209
.pre0208:

                 Move.l 0020(a7),a0
                  Add.l  #1,a0
                 lea Objectargs,a1
                 Move.l 0024(a7),d0
                  Sub.l  0020(a7),d0
                  Sub.l  #1,d0
                 Move.l 0004(a7),d1
                 Move.l #0,d2
                 Jsr getObjectArgs
lea spfmethods3,a0
move.l  TaglistenNr,0004(a0)
                 lea Objectpuffer,a3
                 Move.l #x_09Domethode_d0_x_22name080,a0
                 Move.l #spfmethods3,a1
                 Jsr Sprintf
                 Move.l Taglistennr,d0
                 Addq.l #1,d0
                 Move.l D0,Taglistennr
.Pre0209:
              Move.l LineRoot,a0
              lea ObjectPuffer,A1
              Move.l 0004(a7),D0
              Jsr AddLine2
              Move.l 0024(a7),a0
              Move.l #name081,a1
              Jsr Stringfind
              Move.l D0,0016(a7)
              Move.l 0024(a7),a0
              Move.l #_name082,a1
              Jsr Stringfind
              Move.l D0,0020(a7)
              Move.l 0020(a7),a0
              Jsr SeekClosingbracket
              Move.l D0,0024(a7)
Bra .While0012
.Pre0205:
.While0013:
           lea Objectmethode,A0
           Move.l #0,D0
           Move.l #200,D1
           Jsr Fillbuffer
           lea Objectargs,A0
           Move.l #0,D0
           Move.l #200,D1
           Jsr Fillbuffer
           Move.l ExecBase,a6
           Move.l 0016(a7),a0
            Add.l  #1,a0
           lea Objectmethode,a1
           Move.l 0020(a7),d0
            Sub.l  0016(a7),d0
            Sub.l  #1,d0
           Jsr Copymem(a6)
           Move.l 0028(a7),d0
           Cmp.l #0,d0
           Bne .pre0210
           Bra .pre0211
.pre0210:

              Move.l ExecBase,a6
              lea buffer,a0
              lea ObjectPre,a1
              Move.l 0028(a7),d0
               Sub.l  #buffer,d0
               Add.l  #1,d0
              Jsr Copymem(a6)
.Pre0211:
           Move.l 0020(a7),d0
           Add.l #1,d0
           Cmp.l 0024(a7),d0
           Beq .pre0212
           Bra .pre0213
.pre0212:

              lea Objectpuffer,a3
              Move.l #x_09name083,a0
              Move.l #spfmethods4,a1
              Jsr Sprintf
.Pre0213:
           Move.l 0020(a7),d0
           Add.l #1,d0
           Cmp.l 0024(a7),d0
           Bne .pre0214
           Bra .pre0215
.pre0214:

              Move.l 0020(a7),a0
               Add.l  #1,a0
              lea Objectargs,a1
              Move.l 0024(a7),d0
               Sub.l  0020(a7),d0
               Sub.l  #1,d0
              Move.l 0004(a7),d1
              Move.l #0,d2
              Jsr getObjectArgs
lea spfmethods5,a0
move.l  TaglistenNr,0008(a0)
              lea Objectpuffer,a3
              Move.l #x_09name084,a0
              Move.l #spfmethods5,a1
              Jsr Sprintf
              Move.l Taglistennr,d0
              Addq.l #1,d0
              Move.l D0,Taglistennr
.Pre0215:
           Move.l LineRoot,a0
           lea ObjectPuffer,A1
           Move.l 0004(a7),D0
           Jsr AddLine2
           Move.l #LeerZeile,d0
           Move.l D0,0000(a7)
.Pre0203:

       Clr.l d0
       Move.l 0052(a7),a0
       Move.l ObjectRoot.next(a0),d0
       Move.l D0,0052(a7)
Bra .While0010
.Pre0201:
.While0011:

    Move.l 0000(a7),d0
    Add.l  #0060,a7
    rts

addLine:          
    sub.l  #0032,a7
    Move.l  a0,0000(a7)
    Move.l  A1,0004(a7)
    Move.l  d0,0008(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l LineRoot.next(a0),d0
    Move.l D0,0012(a7)
    Move.l 0012(a7),d0
    Cmp.l #0,d0
    Beq .pre0216
    Bra .pre0217
.pre0216:

        Move.l 0004(a7),a0
        Move.l 0008(a7),d0
        Jsr Praeprozessor
        Move.l D0,0024(a7)
        Move.l 0024(a7),d0
        Cmp.l 0004(a7),d0
        Bne .pre0218
        Bra .pre0219
.pre0218:

           Clr.l d0
           Move.l 0000(a7),a0
           Move.l LineRoot.next(a0),d0
           Move.l D0,0012(a7)
.While0014:
           Move.l 0012(a7),d0
           Cmp.l #0,d0
           Bne .pre0220
           Bra .pre0221
.pre0220:

              Move.l 0012(a7),d0
              Move.l D0,0000(a7)
              Clr.l d0
              Move.l 0012(a7),a0
              Move.l LineRoot.next(a0),d0
              Move.l D0,0012(a7)
Bra .While0014
.Pre0221:
.While0015:
           Move.l 0024(a7),d0
           Move.l D0,0004(a7)
.Pre0219:
        Move.l 0004(a7),a0
        Jsr removeLF
        Move.l 0004(a7),A0
        Jsr Strlen
        Move.l D0,0020(a7)
        Move.l 0020(a7),d0
        Addq.l #1,d0
        Move.l D0,lena
move.l IntuitionBase,a6
move.l #Rememberstruct,a0
move.l #12,d0
move.l  #MEMF_FAST!MEMF_CLEAR,d1
jsr -396(a6)
move.l d0,0012(a7)
move.l IntuitionBase,a6
move.l #Rememberstruct,a0
move.l lena,d0
move.l  #MEMF_FAST!MEMF_CLEAR,d1
jsr -396(a6)
move.l d0,0016(a7)
        Move.l ExecBase,a6
        Move.l 0004(a7),a0
        Move.l 0016(a7),a1
        Move.l 0020(a7),d0
        Jsr copymem(a6)

        Move.l  0012(a7),a0 

        Lea LineRoot.Name(a0),a0
        Move.l 0016(a7),(a0)
        Move.l  0012(a7),a0 

        Lea LineRoot.MethodeID(a0),a0
        Move.l 0008(a7),(a0)
        Move.l  0012(a7),a0 

        Lea LineRoot.Next(a0),a0
        Move.l #0,(a0)
        Move.l  0000(a7),a0 

        Lea LineRoot.Next(a0),a0
        Move.l 0012(a7),(a0)
                Add.l  #0032,a7
        rts
.Pre0217:
    Move.l 0012(a7),a0
    Move.l 0004(a7),A1
    Move.l 0008(a7),D0
    Jsr AddLine
        Add.l  #0032,a7
    rts

AddConstructoren:       
    sub.l  #0036,a7
    Move.l  a0,0000(a7)
    Move.l  d0,0024(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l ConstructorRoot.name(a0),d0
    Move.l D0,0004(a7)
    Move.l 0004(a7),d0
    Cmp.l #0,d0
    Bne .pre0222
    Bra .pre0223
.pre0222:

        Clr.l d0
        Move.l 0000(a7),a0
        Move.l ConstructorRoot.Klasse(a0),d0
        Move.l D0,0008(a7)
lea spfac1,a0
move.l  0004(a7),0000(a0)
move.l  0008(a7),0004(a0)
        lea Objectpuffer,a3
        Move.l #x_09name085,a0
        Move.l #spfac1,a1
        Jsr Sprintf
        Move.l LineRoot,a0
        lea Objectpuffer,A1
        Move.l 0024(a7),D0
        Jsr AddLine2
.Pre0223:
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l ConstructorRoot.next(a0),d0
    Move.l D0,0012(a7)
    Move.l 0012(a7),d0
    Cmp.l #0,d0
    Bne .pre0224
    Bra .pre0225
.pre0224:

        Move.l 0012(a7),a0
        Move.l 0024(a7),d0
        Jsr AddConstructoren
.Pre0225:
        Add.l  #0036,a7
    rts

PrintConstructoren:       
    sub.l  #0040,a7
    Move.l  a0,0000(a7)
    Move.l  d0,0024(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l ConstructorRoot.next(a0),d0
    Move.l D0,0012(a7)
    Move.l 0012(a7),d0
    Cmp.l #0,d0
    Beq .pre0226
    Bra .pre0227
.pre0226:

              Add.l  #0040,a7
       rts
.Pre0227:
    Clr.l d0
    Move.l 0012(a7),a0
    Move.l ConstructorRoot.name(a0),d0
    Move.l D0,0004(a7)
    Move.l #ObjectPuffer,d0
    Move.l D0,0032(a7)
    lea Objectpuffer,a3
    Move.l #x_09if_name086,a0
    Move.l #0,a1
    Jsr SPrintf
    lea ObjectPuffer,A0
    Jsr Strlen
    Move.l D0,0028(a7)
    Move.l 0028(a7),d0
    Add.l #ObjectPuffer,d0
    Move.l D0,0032(a7)
.While0016:
    Move.l 0012(a7),d0
    Cmp.l #0,d0
    Bne .pre0228
    Bra .pre0229
.pre0228:
        Clr.l d0
        Move.l 0012(a7),a0
        Move.l ConstructorRoot.name(a0),d0
        Move.l D0,0004(a7)
        Clr.l d0
        Move.l 0012(a7),a0
        Move.l ConstructorRoot.Klasse(a0),d0
        Move.l D0,0008(a7)
lea spfpc1,a0
move.l  0004(a7),0000(a0)
        Move.l 0032(a7),a3
        Move.l #name087,a0
        Move.l #spfpc1,a1
        Jsr SPrintf
        lea ObjectPuffer,A0
        Jsr Strlen
        Move.l D0,0028(a7)
        Move.l 0028(a7),d0
        Add.l #ObjectPuffer,d0
        Move.l D0,0032(a7)
        Clr.l d0
        Move.l 0012(a7),a0
        Move.l ConstructorRoot.next(a0),d0
        Move.l D0,0012(a7)
Bra .While0016
.Pre0229:
.While0017:
    Move.l 0032(a7),d0
    Subq.l #1,d0
    Move.l D0,0032(a7)
    Move.l 0032(a7),a3
    Move.l #_0xnx_09_name088,a0
    Move.l #0,a1
    Jsr SPrintf

    Move.l LineRoot,a0
    lea Objectpuffer,A1
    Move.l 0024(a7),D0
    Jsr AddLine2
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l ConstructorRoot.next(a0),d0
    Move.l D0,0012(a7)
.While0018:
    Move.l 0012(a7),d0
    Cmp.l #0,d0
    Bne .pre0230
    Bra .pre0231
.pre0230:
        Clr.l d0
        Move.l 0012(a7),a0
        Move.l ConstructorRoot.name(a0),d0
        Move.l D0,0004(a7)
        Clr.l d0
        Move.l 0012(a7),a0
        Move.l ConstructorRoot.Klasse(a0),d0
        Move.l D0,0008(a7)
lea spfpc3,a0
move.l  0004(a7),0000(a0)
        lea Objectpuffer,a3
        Move.l #x_09__del_name089,a0
        Move.l #spfpc3,a1
        Jsr SPrintf
        Clr.l d0
        Move.l 0012(a7),a0
        Move.l ConstructorRoot.next(a0),d0
        Move.l D0,0012(a7)
        Move.l LineRoot,a0
        lea Objectpuffer,A1
        Move.l 0024(a7),D0
        Jsr AddLine2
Bra .While0018
.Pre0231:
.While0019:
lea spfpc4,a0
move.l  0004(a7),0000(a0)
    lea ObjectPuffer,a3
    Move.l #x_09x_7b__UnFrameReturn__1_x_7dxnname090,a0
    Move.l #spfpc4,a1
    Jsr SPrintf
    Move.l LineRoot,a0
    lea Objectpuffer,A1
    Move.l 0024(a7),D0
    Jsr AddLine2
    Move.l LineRoot,a0
    Move.l #x_09name091,A1
    Move.l 0024(a7),D0
    Jsr AddLine2
        Add.l  #0040,a7
    rts

AddDeConstructoren:       
    sub.l  #0036,a7
    Move.l  a0,0000(a7)
    Move.l  d0,0024(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l ConstructorRoot.name(a0),d0
    Move.l D0,0004(a7)
    Move.l 0004(a7),d0
    Cmp.l #0,d0
    Bne .pre0232
    Bra .pre0233
.pre0232:

        Clr.l d0
        Move.l 0000(a7),a0
        Move.l ConstructorRoot.Klasse(a0),d0
        Move.l D0,0008(a7)
lea spfad1,a0
move.l  0004(a7),0000(a0)
move.l  0004(a7),0004(a0)
        lea Objectpuffer,a3
        Move.l #x_09__name092,a0
        Move.l #spfad1,a1
        Jsr Sprintf
        Move.l LineRoot,a0
        lea Objectpuffer,A1
        Move.l 0024(a7),D0
        Jsr AddLine2
.Pre0233:
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l ConstructorRoot.next(a0),d0
    Move.l D0,0012(a7)
    Move.l 0012(a7),d0
    Cmp.l #0,d0
    Bne .pre0234
    Bra .pre0235
.pre0234:

        Move.l 0012(a7),a0
        Move.l 0024(a7),d0
        Jsr AddDeConstructoren
.Pre0235:
        Add.l  #0036,a7
    rts

CompareStringKlammerauf:       
    clr.l d0
    clr.l d1
    tst.l a0
    beq .error
    tst.l a1
    beq .error
.l1:
    move.b (a0)+,d0
    move.b (a1)+,d1
    cmpi.b d0,d1
    bne .error
    cmpi.b #"(",d0
    beq .ende
    cmpi.b #$00,d0
    beq .error
    bra.s .l1
.error:
    moveq.l #0,d0
    rts
.ende:
    moveq.l #-1,d0
    rts


addMethode:                            
    sub.l  #0060,a7
    Move.l  a0,0000(a7)
    Move.l  A1,0004(a7)
    Move.l  d0,0008(a7)
    Move.l  d1,0012(a7)
    Move.l  d2,0016(a7)
    Move.l  d3,0020(a7)
    Move.l  d4,0024(a7)
    Move.l  d5,0028(a7)
    Move.l  d6,0032(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l MethodeRoot.Name(a0),d0
    Move.l D0,0040(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l MethodeRoot.abstract(a0),d0
    Move.l D0,0052(a7)
    Move.l 0052(a7),d0
    Cmp.l #0,d0
    Bne .pre0236
    Bra .pre0237
.pre0236:
Move.l 0020(a7),d0
Cmp.l #0,d0
Beq .pre0238
Bra .pre0239
.pre0238:

Move.l 0004(a7),a0
Move.l 0040(a7),a1
Move.l #0,d0
Move.l #MODE_CASE,d1
Jsr comparestring
       Cmp.l #0,d0
       Bne .pre0240
       Bra .pre0241
.pre0240:

          Move.l  0000(a7),a0 

          Lea MethodeRoot.abstract(a0),a0
          Move.l #0,(a0)
          Move.l 0000(a7),d0
          Add.l  #0060,a7
          rts
.Pre0241:
.Pre0239:
.Pre0237:
Move.l 0004(a7),a0
Move.l 0040(a7),a1
Jsr comparestringKlammerauf
    Cmp.l #0,d0
    Bne .pre0242
    Bra .pre0243
.pre0242:

        Move.l 0032(a7),d0
        Addq.l #1,d0
        Move.l D0,0032(a7)
.Pre0243:
Move.l 0004(a7),a0
Move.l 0040(a7),a1
Move.l #0,d0
Move.l #MODE_CASE,d1
Jsr CompareString
    Cmp.l #0,d0
    Bne .pre0244
    Bra .pre0245
.pre0244:

        Move.l  0000(a7),a0 

        Lea MethodeRoot.invalid(a0),a0
        Move.l #1,(a0)
.Pre0245:
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l MethodeRoot.next(a0),d0
    Move.l D0,0036(a7)
    Move.l 0036(a7),d0
    Cmp.l #0,d0
    Beq .pre0246
    Bra .pre0247
.pre0246:

        Move.l 0004(a7),A0
        Jsr Strlen
        Move.l D0,0044(a7)
        Move.l 0044(a7),d0
        Addq.l #1,d0
        Move.l D0,lena
move.l IntuitionBase,a6
move.l #Rememberstruct,a0
move.l #40,d0
move.l  #MEMF_FAST!MEMF_CLEAR,d1
jsr -396(a6)
move.l d0,0036(a7)
move.l IntuitionBase,a6
move.l #Rememberstruct,a0
move.l lena,d0
move.l  #MEMF_FAST!MEMF_CLEAR,d1
jsr -396(a6)
move.l d0,0040(a7)
        Move.l ExecBase,a6
        Move.l 0004(a7),a0
        Move.l 0040(a7),a1
        Move.l 0044(a7),d0
        Jsr copymem(a6)

        Move.l  0036(a7),a0 

        Lea MethodeRoot.invalid(a0),a0
        Move.l #0,(a0)
        Move.l  0036(a7),a0 

        Lea MethodeRoot.sync(a0),a0
        Move.l 0028(a7),(a0)
        Move.l  0036(a7),a0 

        Lea MethodeRoot.Name(a0),a0
        Move.l 0040(a7),(a0)
        Move.l  0036(a7),a0 

        Lea MethodeRoot.public(a0),a0
        Move.l 0008(a7),(a0)
        Move.l  0036(a7),a0 

        Lea MethodeRoot.static(a0),a0
        Move.l 0024(a7),(a0)
        Move.l  0036(a7),a0 

        Lea MethodeRoot.Counter(a0),a0
        Move.l 0032(a7),(a0)
        Move.l  0036(a7),a0 

        Lea MethodeRoot.private(a0),a0
        Move.l 0012(a7),(a0)
        Move.l  0036(a7),a0 

        Lea MethodeRoot.abstract(a0),a0
        Move.l 0020(a7),(a0)
        Move.l  0036(a7),a0 

        Lea MethodeRoot.protected(a0),a0
        Move.l 0016(a7),(a0)
        Move.l  0036(a7),a0 

        Lea MethodeRoot.Next(a0),a0
        Move.l #0,(a0)
        Move.l  0000(a7),a0 

        Lea MethodeRoot.Next(a0),a0
        Move.l 0036(a7),(a0)

        Move.l 0036(a7),d0
        Add.l  #0060,a7
        rts
.Pre0247:
    Move.l 0036(a7),a0
    Move.l 0004(a7),A1
    Move.l 0008(a7),D0
    Move.l 0012(a7),d1
    Move.l 0016(a7),d2
    Move.l 0020(a7),d3
    Move.l 0024(a7),d4
    Move.l 0028(a7),d5
    Move.l 0032(a7),d6
    Jsr AddMethode
    Move.l D0,0048(a7)
    Move.l 0048(a7),d0
    Add.l  #0060,a7
    rts

FoundMethode:       
    sub.l  #0024,a7
    Move.l  a0,0000(a7)
    Move.l  A1,0004(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l MethodeRoot.next(a0),d0
    Move.l D0,0008(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l MethodeRoot.name(a0),d0
    Move.l D0,0012(a7)
    Move.l 0012(a7),d0
    Cmp.l #0,d0
    Bne .pre0248
    Bra .pre0249
.pre0248:

Move.l 0012(a7),a0
Move.l 0004(a7),a1
Jsr StrCmp
        Cmp.l #0,d0
        Beq .pre0250
        Bra .pre0251
.pre0250:

           Move.l 0000(a7),d0
           Add.l  #0024,a7
           rts
.Pre0251:
.Pre0249:
    Move.l 0008(a7),d0
    Cmp.l #0,d0
    Beq .pre0252
    Bra .pre0253
.pre0252:

        Move.l #0,d0
        Add.l  #0024,a7
        rts
.Pre0253:
    Move.l 0008(a7),a0
    Move.l 0004(a7),A1
    Jsr FoundMethode
    Move.l D0,0016(a7)
    Move.l 0016(a7),d0
    Add.l  #0024,a7
    rts

myStringfind:          
    sub.l  #0020,a7
    Move.l  a0,0000(a7)
    Move.l  a1,0004(a7)
    Move.l  d0,0008(a7)
    Move.l 0000(a7),a0
    Move.l 0004(a7),a1
    Jsr Stringfind
    Move.l D0,0012(a7)
    Move.l 0012(a7),d0
    Cmp.l #0,d0
    Beq .pre0254
    Bra .pre0255
.pre0254:

           Move.l #0,d0
           Add.l  #0020,a7
           rts
.Pre0255:
    Move.l 0008(a7),d0
    Cmp.l #0,d0
    Bgt .pre0256
    Bra .pre0257
.pre0256:

           Move.l #0,d0
           Add.l  #0020,a7
           rts
.Pre0257:
    Move.l #1,d0
    Add.l  #0020,a7
    rts

DeComment:       
    nop
.l0:cmpi.w #"//",(a0)
    beq .treffer
    cmpi.w #"/*",(a0)
    bne .l1
    add.l #1,d1
.l1:cmpi.w #"*/",(a0)
    bne .l2
    sub.l #1,d1
    move.w #$2020,(a0)
.l2:
    cmpi.b #$22,(a0)
    beq .hacken
    cmpi.b #$00,(a0)
    beq .ende
    cmpi.b #$0a,(a0)
    beq .l3
    cmpi.l #0,d1
    beq .l3
    move.b #$20,(a0)
.l3:lea 1(a0),a0
    bra .l0
.ende:
    move.l d1,d0
    RTS    
.hacken:
    cmpi.l #0,d1
    beq .l4
    move.b #$20,(a0)
.l4:lea 1(a0),a0
    cmpi.b #$22,(a0)
    bne .hacken
    cmpi.l #0,d1
    beq .l5
    move.b #$20,(a0)
.l5:lea 1(a0),a0
    bra .l0
.treffer:
    cmpi.b #$0,(a0)
    beq .ende
    cmpi.b #$A,(a0)
    beq .ende
    move.b #$20,(a0)+
    bra.s .treffer

ClassBodyAnalyse:    
    sub.l  #0048,a7
    Move.l  d0,0000(a7)
    Move.l  #1,0032(a7)
    Move.l  #0,0036(a7)

Move.l DOSBase,a6
Move.l 0000(a7),d1
Move.l #Buffer,d2
Move.l #1024,d3
Jsr Fgets(a6)
    Cmp.l #0,d0
    Bne .pre0258
    Bra .pre0259
.pre0258:

       lea Buffer,a0
       Move.l IsComment,d1
       Jsr DeComment
       Move.l D0,IsComment
lea Buffer,a0
Move.l #x_7bname093,a1
Jsr stringfind
       Cmp.l #0,d0
       Beq .pre0260
       Bra .pre0261
.pre0260:

          Move.l #1,d0
          Add.l  #0048,a7
          rts
.Pre0261:

.While0020:
       Move.l 0036(a7),d0
       Cmp.l #0,d0
       Beq .pre0262
       Bra .pre0263
.pre0262:

Move.l DOSBase,a6
Move.l 0000(a7),d1
Move.l #Buffer,d2
Move.l #1024,d3
Jsr FGets(a6)
          Cmp.l #0,d0
          Beq .While0021
          lea Buffer,a0
          Move.l IsComment,d1
          Jsr DeComment
          Move.l D0,IsComment

          lea Buffer,a0
          Move.l #variablen_M_long_S_public_S_static_Sname094,a1
          Jsr LineAnalyse
          Move.l D0,0004(a7)
          Move.l D1,variablen
          Move.l D2,Array
          Move.l D3,Public
          Move.l D4,0024(a7)
          Move.l 0004(a7),d0
          Cmp.l #0,d0
          Bne .pre0264
          Bra .pre0265
.pre0264:

             Move.l array,d0
             Cmp.l #0,d0
             Bne .pre0266
             Bra .pre0267
.pre0266:

                Move.l 0024(a7),d0
                Cmp.l #0,d0
                Bne .pre0268
                Bra .pre0269
.pre0268:

Move.l DOSBase,a6
Move.l #x_09x_7b__incvar__name095,d1
Move.l #nullt,d2
Jsr vpf(a6)
.Pre0269:

Move.l variablen,a0
Move.l (a0)+,zeiger
Move.l a0,variablen
.repeat0000:
                    Move.l 0024(a7),d0
                    Cmp.l #0,d0
                    Bne .pre0270
                    Bra .pre0271a
.pre0270:

lea pf096,a0
move.l  zeiger,0000(a0)
Move.l DOSBase,a6
Move.l #name096,d1
Move.l #pf096,d2
Jsr vpf(a6)
bra.l .Pre0271
.Pre0271a:

                       Move.l VarRoot,a0
                       Move.l zeiger,A1
                       Move.l #1,D0
                       Move.l MethodeID,d1
                       Move.l public,d2
                       Jsr AddVar
.Pre0271:
Move.l variablen,a0
Move.l (a0)+,zeiger
Move.l a0,variablen
                     Move.l zeiger,d0
                     Cmp.l #0,d0
                     Bne.l .repeat0000
                Move.l DOSBase,a6
                Move.l 0004(a7),d1
                Jsr FreeArgs(a6)
                Move.l 0024(a7),d0
                Cmp.l #0,d0
                Bne .pre0272
                Bra .pre0273
.pre0272:

Move.l DOSBase,a6
Move.l #xcyxxdzzyzx__x_7dxnname097,d1
Move.l #nullt,d2
Jsr vpf(a6)
.Pre0273:
                bra.l .While0020
.Pre0267:
             Move.l 0004(a7),d1
             Jsr FreeArgs(a6)
.Pre0265:
          lea Buffer,a0
          Move.l #string_K_static_S_variablen_Fname098,a1
          Jsr LineAnalyse
          Move.l D0,0004(a7)
          Move.l D1,0016(a7)
          Move.l D2,0024(a7)
          Move.l D3,variablen
          Move.l 0004(a7),d0
          Cmp.l #0,d0
          Bne .pre0274
          Bra .pre0275
.pre0274:

             Move.l 0016(a7),d0
             Cmp.l #0,d0
             Bne .pre0276
             Bra .pre0277
.pre0276:

                Move.l 0024(a7),d0
                Cmp.l #0,d0
                Bne .pre0278
                Bra .pre0279
.pre0278:

lea pf099,a0
move.l  0016(a7),0000(a0)
move.l  variablen,0004(a0)
Move.l DOSBase,a6
Move.l #x_09x_7b__String__name099,d1
Move.l #pf099,d2
Jsr vpf(a6)
.Pre0279:
                Move.l 0024(a7),d0
                Cmp.l #0,d0
                Beq .pre0280
                Bra .pre0281
.pre0280:

                    Move.l VarRoot,a0
                    Move.l 0016(a7),A1
                    Move.l #1,D0
                    Move.l MethodeID,d1
                    Move.l #0,d2
                    Jsr AddVar
                    Move.l ObjectRoot,a0
                    Move.l 0016(a7),A1
                    Move.l #system_stringname100,a2
                    Move.l MethodeID,D0
                    Jsr AddObject
                    Move.l ConstructorRoot,a0
                    Move.l 0016(a7),A1
                    Move.l #system_stringname101,a2
                    Jsr AddConstructor

                    Move.l Variablen,A0
                    Jsr strlen
                    Move.l D0,len
                    Move.l Stringroot,a0
                    Move.l Variablen,d0
                    Move.l Variablen,d1
                     Add.l  len,d1
                    Jsr AddString
                    Move.l D0,0008(a7)
lea pf102,a0
move.l  0008(a7),0000(a0)
move.l  Variablen,0004(a0)
Move.l DOSBase,a6
Move.l #x_09___String__Preassxxname102,d1
Move.l #pf102,d2
Jsr vpf(a6)
lea spfmethodsf1,a0
move.l  0016(a7),0000(a0)
move.l  TaglistenNr,0004(a0)
move.l  0008(a7),0008(a0)
                  lea Objectpuffer,a3
                  Move.l #x_09Domethode_name103,a0
                  Move.l #spfmethodsf1,a1
                  Jsr Sprintf
                    Move.l Taglistennr,d0
                    Addq.l #1,d0
                    Move.l D0,Taglistennr
                    Move.l CID,d0
                    Cmp.l #0,d0
                    Beq .pre0282
                    Bra .pre0283
.pre0282:

                       Move.l MethodeRoot,a0
                       Move.l #Constructor__name104,A1
                       Move.l #1,D0
                       Move.l #0,d1
                       Move.l #0,d2
                       Move.l #0,d3
                       Move.l #0,d4
                       Move.l #0,d5
                       Move.l #0,d6
                       Jsr AddMethode
                       Move.l D0,CID
.Pre0283:
                    Move.l LineRoot,a0
                    lea ObjectPuffer,A1
                    Move.l CID,D0
                    Jsr AddLine2
.Pre0281:
                Move.l DOSBase,a6
                Move.l 0004(a7),d1
                Jsr FreeArgs(a6)
                bra.l .While0020
.Pre0277:
             Move.l 0004(a7),d1
             Jsr FreeArgs(a6)
.Pre0275:
          lea Buffer,a0
          Move.l #class_K_variablen_M_Object_Sname105,a1
          Jsr LineAnalyse
          Move.l D0,0004(a7)
          Move.l D1,0012(a7)
          Move.l D2,0028(a7)
          Move.l D3,Array
          Move.l 0004(a7),d0
          Cmp.l #0,d0
          Bne .pre0284
          Bra .pre0285
.pre0284:

             Move.l array,d0
             Cmp.l #0,d0
             Bne .pre0286
             Bra .pre0287
.pre0286:

                Move.l 0012(a7),a0
                Jsr BuildClassString
Move.l 0028(a7),a0
Move.l (a0)+,zeiger
Move.l a0,0028(a7)
.repeat0001:
                    Move.l VarRoot,a0
                    Move.l zeiger,A1
                    Move.l #1,D0
                    Move.l MethodeID,d1
                    Move.l #0,d2
                    Jsr AddVar
                    Move.l ObjectRoot,a0
                    Move.l zeiger,A1
                    Move.l 0012(a7),a2
                    Move.l MethodeID,D0
                    Jsr AddObject
                    Move.l 0012(a7),d0
                    Cmp.l #0,d0
                    Bne .pre0288
                    Bra .pre0289
.pre0288:

lea spfacmain,a0
move.l  0012(a7),0000(a0)
                       lea objectpuffer,a3
                       Move.l #name106,a0
                       Move.l #spfacmain,a1
                       Jsr Sprintf
                       Move.l ConstructorRoot,a0
                       Move.l zeiger,A1
                       lea Objectpuffer,a2
                       Jsr AddConstructor
.Pre0289:
Move.l 0028(a7),a0
Move.l (a0)+,zeiger
Move.l a0,0028(a7)
                     Move.l zeiger,d0
                     Cmp.l #0,d0
                     Bne.l .repeat0001
                Move.l DOSBase,a6
                Move.l 0004(a7),d1
                Jsr FreeArgs(a6)
                bra.l .While0020
.Pre0287:
             Move.l 0004(a7),d1
             Jsr FreeArgs(a6)
.Pre0285:
          lea Buffer,a0
          Move.l #new_K_variablen_Mname107,a1
          Jsr LineAnalyse
          Move.l D0,0004(a7)
          Move.l D1,0012(a7)
          Move.l D2,0028(a7)
          Move.l 0004(a7),d0
          Cmp.l #0,d0
          Bne .pre0290
          Bra .pre0291
.pre0290:

             Move.l 0028(a7),d0
             Cmp.l #0,d0
             Bne .pre0292
             Bra .pre0293
.pre0292:
Move.l 0012(a7),d0
Cmp.l #0,d0
Bne .pre0294
Bra .pre0295
.pre0294:

Move.l 0012(a7),a0
Move.l #_name108,a1
Jsr Stringfind
Move.l D0,pos
                Cmp.l #0,d0
                Bne .pre0296
                Bra .pre0297
.pre0296:

                    Move.l pos,a0
                    Jsr seekClosingBracket
                    Move.l D0,myPos
                    Move.l pos,a0
                     Add.l  #1,a0
                    lea Objectargs,a1
                    Move.l myPos,d0
                     Sub.l  Pos,d0
                     Sub.l  #1,d0
                    Move.l MethodeID,d1
                    Move.l #1,d2
                    Jsr getObjectArgs
                    Move.l pos,d0
                    Sub.l 0012(a7),d0
                    Addq.l #1,d0
                    Move.l D0,len
move.l IntuitionBase,a6
move.l #Rememberstruct,a0
move.l Len,d0
move.l  #MEMF_CLEAR!MEMF_FAST,d1
jsr -396(a6)
move.l d0,0040(a7)
                    Move.l ExecBase,a6
                    Move.l 0012(a7),a0
                    Move.l 0040(a7),a1
                    Move.l len,d0
                     Sub.l  #1,d0
                    Jsr Copymem(a6)
                    Move.l 0040(a7),d0
                    Move.l D0,0012(a7)
.Pre0297:
                Move.l 0012(a7),a0
                Jsr BuildClassString
Move.l 0028(a7),a0
Move.l (a0)+,zeiger
Move.l a0,0028(a7)
.repeat0002:
                    Move.l VarRoot,a0
                    Move.l zeiger,A1
                    Move.l #1,D0
                    Move.l MethodeID,d1
                    Move.l #0,d2
                    Jsr AddVar
                    Move.l ObjectRoot,a0
                    Move.l zeiger,A1
                    Move.l 0012(a7),a2
                    Move.l MethodeID,D0
                    Jsr AddObject
                    Move.l pos,d0
                    Cmp.l #0,d0
                    Bne .pre0298
                    Bra .pre0299a
.pre0298:

lea spfmain1a,a0
move.l  zeiger,0000(a0)
move.l  0012(a7),0004(a0)
move.l  TaglistenNr,0008(a0)
                       lea Objectpuffer,a3
                       Move.l #x_09name109,a0
                       Move.l #spfmain1a,a1
                       Jsr Sprintf
                       Move.l Taglistennr,d0
                       Addq.l #1,d0
                       Move.l D0,Taglistennr
bra.l .Pre0299
.Pre0299a:
lea spfacmain1,a0
move.l  zeiger,0000(a0)
move.l  0012(a7),0004(a0)
                       lea objectpuffer,a3
                       Move.l #x_09name110,a0
                       Move.l #spfacmain1,a1
                       Jsr Sprintf
.Pre0299:
                    Move.l LineRoot,a0
                    lea ObjectPuffer,A1
                    Move.l MethodeID,D0
                    Jsr AddLine2
Move.l 0028(a7),a0
Move.l (a0)+,zeiger
Move.l a0,0028(a7)
                     Move.l zeiger,d0
                     Cmp.l #0,d0
                     Bne.l .repeat0002
                Move.l DOSBase,a6
                Move.l 0004(a7),d1
                Jsr FreeArgs(a6)
                bra.l .While0020
.Pre0295:
.Pre0293:
             Move.l 0004(a7),d1
             Jsr FreeArgs(a6)
.Pre0291:
          lea Buffer,a0
          Move.l #syncronized_S_static_S_abstract_S_public_S_private_S_protected_S_name_Fname111,a1
          Jsr LineAnalyse
          Move.l D0,0004(a7)
          Move.l D1,0020(a7)
          Move.l D2,0024(a7)
          Move.l D3,abstract
          Move.l D4,public
          Move.l D5,private
          Move.l D6,protected
          Move.l D7,Methode
          Move.l 0004(a7),d0
          Cmp.l #0,d0
          Bne .pre0300
          Bra .pre0301
.pre0300:

             Move.l abstract,d0
             or.l private,d0
             or.l protected,d0
             or.l public,d0
             Cmp.l #0,d0
             Bne .pre0302
             Bra .pre0303
.pre0302:
                 Move.l methodeRoot,a0
                 Move.l Methode,A1
                 Move.l public,D0
                 Move.l private,d1
                 Move.l protected,d2
                 Move.l abstract,d3
                 Move.l 0024(a7),d4
                 Move.l 0020(a7),d5
                 Move.l #0,d6
                 Jsr AddMethode
                 Move.l D0,MethodeID
                 Move.l DOSBase,a6
                 Move.l 0004(a7),d1
                 Jsr FreeArgs(a6)
                 Move.l Abstract,d0
                 Cmp.l #0,d0
                 Beq .pre0304
                 Bra .pre0305
.pre0304:

                    Move.l 0000(a7),d0
                    Jsr ClassBodyAnalyse
.Pre0305:
Move.l DOSBase,a6
Move.l 0000(a7),d1
Move.l #Buffer,d2
Move.l #1024,d3
Jsr FGets(a6)
                 Cmp.l #0,d0
                 Beq .While0021
                 lea Buffer,a0
                 Move.l IsComment,d1
                 Jsr DeComment
                 Move.l D0,IsComment
                 bra.l .While0020
.Pre0303:
             Move.l DOSBase,a6
             Move.l 0004(a7),d1
             Jsr FreeArgs(a6)
.Pre0301:
lea Buffer,a0
Move.l #x_7bname112,a1
Jsr stringfind
          Cmp.l #0,d0
          Bne .pre0306
          Bra .pre0307
.pre0306:

              Move.l 0032(a7),d0
              Addq.l #1,d0
              Move.l D0,0032(a7)
.Pre0307:

lea Buffer,a0
Move.l #x_7dname113,a1
Jsr stringfind
          Cmp.l #0,d0
          Bne .pre0308
          Bra .pre0309
.pre0308:

              Move.l 0032(a7),d0
              Cmp.l #0,d0
              Bgt .pre0310
              Bra .pre0311
.pre0310:

                 Move.l 0032(a7),d0
                 Subq.l #1,d0
                 Move.l D0,0032(a7)
                 Move.l 0032(a7),d0
                 Cmp.l #0,d0
                 Bne .pre0312
                 Bra .pre0313
.pre0312:

                    Move.l LineRoot,a0
                    lea Buffer,A1
                    Move.l MethodeID,D0
                    Jsr AddLine
                    Move.l LineRoot,a0
                    Move.l #x_09x_7b__Flush__x_7dname114,A1
                    Move.l MethodeID,D0
                    Jsr AddLine
.Pre0313:
                 bra.l .While0020
.Pre0311:
              Moveq.l #$2,d0
              Move.l D0,0036(a7)
              Move.l #0,d0
              Add.l  #0048,a7
              rts
.Pre0309:
          Move.l LineRoot,a0
          lea Buffer,A1
          Move.l MethodeID,D0
          Jsr AddLine
Bra .While0020
.Pre0263:
.While0021:

.Pre0259:
    Move.l #0,d0
    Add.l  #0048,a7
    rts

countchars:       
    moveq.l #0,d0
.l1:cmpi.b #0,(a0)
    beq .ende
    cmpi.b (a0),d1
    bne .l2
    addq.l #1,d0
.l2:lea 1(a0),a0
    bra .l1
.ende:
    rts    


LowerCase:    
    clr.l d0
.l1:move.b (a0),d0
    cmpi.b #"A",d0
    blt .skip
    cmpi.b #"z",d0
    bgt .skip
    bset.l #5,d0
.skip:
    move.b d0,(a0)+
    bne .l1
    rts

NeueKlasse:    
    sub.l  #0032,a7
    Move.l  a0,0000(a7)
    Move.l Incarnations,d0
    Addq.l #1,d0
    Move.l D0,Incarnations
    Moveq.l #$0,d0
    Move.l D0,MethodeID
Move.l DOSBase,a6
Move.l 0000(a7),d1
Move.l #Mode_Old,d2
Jsr Open(a6)
Move.l D0,0004(a7)
    Cmp.l #0,d0
    Bne .pre0314
    Bra .pre0315
.pre0314:

.While0022:
Move.l DOSBase,a6
Move.l 0004(a7),d1
Move.l #Buffer,d2
Move.l #1024,d3
Jsr Fgets(a6)
      Cmp.l #0,d0
      Bne .pre0316
      Bra .pre0317
.pre0316:

       lea Buffer,a0
       Move.l IsComment,d1
       Jsr DeComment
       Move.l D0,IsComment
       lea Buffer,a0
       Move.l #include_K_Aname115,a1
       Jsr LineAnalyse
       Move.l D0,0008(a7)
       Move.l D1,ext_p
       Move.l 0008(a7),d0
       Cmp.l #0,d0
       Bne .pre0318
       Bra .pre0319
.pre0318:

lea pf116,a0
move.l  ext_p,0000(a0)
Move.l DOSBase,a6
Move.l #name116,d1
Move.l #pf116,d2
Jsr vpf(a6)
           Move.l 0008(a7),d1
           Jsr FreeArgs(a6)
.Pre0319:
       lea Buffer,a0
       Move.l #include_p_K_Aname117,a1
       Jsr LineAnalyse
       Move.l D0,0008(a7)
       Move.l D1,ext_p
       Move.l 0008(a7),d0
       Cmp.l #0,d0
       Bne .pre0320
       Bra .pre0321
.pre0320:

lea pf118,a0
move.l  ext_p,0000(a0)
Move.l DOSBase,a6
Move.l #___include_name118,d1
Move.l #pf118,d2
Jsr vpf(a6)
           Move.l 0008(a7),d1
           Jsr FreeArgs(a6)
.Pre0321:
       lea Buffer,a0
       Move.l #usefd_K_Aname119,a1
       Jsr LineAnalyse
       Move.l D0,0008(a7)
       Move.l D1,ext_p
       Move.l 0008(a7),d0
       Cmp.l #0,d0
       Bne .pre0322
       Bra .pre0323
.pre0322:

lea pf120,a0
move.l  ext_p,0000(a0)
Move.l DOSBase,a6
Move.l #_____usefd_name120,d1
Move.l #pf120,d2
Jsr vpf(a6)
           Move.l 0008(a7),d1
           Jsr FreeArgs(a6)
.Pre0323:
       lea Buffer,a0
       Move.l #abstract_S_Class_K_A_extends_Kname121,a1
       Jsr LineAnalyse
       Move.l D0,0008(a7)
       Move.l D1,abstract
       Move.l D2,0012(a7)
       Move.l D3,ext_p
       Move.l 0008(a7),d0
       Cmp.l #0,d0
       Bne .pre0324
       Bra .pre0325
.pre0324:

          Move.l abstract,d0
          Cmp.l #0,d0
          Bne .pre0326
          Bra .pre0327
.pre0326:
Move.l Incarnations,d0
Cmp.l #1,d0
Beq .pre0328
Bra .pre0329
.pre0328:

             Move.l DOSBase,a6
             Move.l 0004(a7),d1
             Jsr Close(a6)
             Move.l 0008(a7),d1
             Jsr FreeArgs(a6)
Move.l #Abstracted_Classes_can_notname122,d1
Move.l #nullt,d2
Jsr vpf(a6)
           Move.l #-1,d0
           Add.l  #0032,a7
           rts
.Pre0329:
.Pre0327:

          Move.l 0012(a7),d0
          Cmp.l #0,d0
          Bne .pre0330
          Bra .pre0331
.pre0330:
Move.l Incarnations,d0
Cmp.l #1,d0
Beq .pre0332
Bra .pre0333
.pre0332:

             lea Classname,A0
             Move.l #0,D0
             Move.l #100,D1
             Jsr Fillbuffer
             lea Classname_2,A0
             Move.l #0,D0
             Move.l #100,D1
             Jsr Fillbuffer
             Move.l ExecBase,a6
             Move.l 0012(a7),a0
             lea Classname_2,a1
             Move.l #100,d0
             Jsr copymem(a6)
             Move.l 0012(a7),a0
             Jsr LowerCase
             Move.l 0012(a7),A0
             Jsr strlen
             Move.l D0,len
             Move.l ExecBase,a6
             Move.l 0012(a7),a0
             lea Classname,a1
             Move.l len,d0
             Jsr Copymem(a6)
             lea ClassStoreMem,a3
             Move.l #Class_name123,a0
             Move.l #csm0,a1
             Jsr Sprintf
             lea ClassStoreMem,A0
             Jsr strlen
             Move.l D0,len
             Move.l len,d0
             Add.l #ClassStoreMem,d0
             Move.l D0,CSMem_p
.Pre0333:
.Pre0331:
          Move.l ext_P,d0
          Cmp.l #0,d0
          Bne .pre0334
          Bra .pre0335
.pre0334:

lea csm1,a0
move.l  ext_p,0000(a0)
             Move.l CSMem_p,a3
             Move.l #__name124,a0
             Move.l #csm1,a1
             Jsr Sprintf
             Move.l CSMem_p,A0
             Jsr strlen
             Move.l D0,len
             Move.l CSMem_p,d0
             Add.l len,d0
             Move.l D0,CSMem_p

             Move.l ext_P,a0
             Jsr BuildClassString
Move.l ext_p,a0
Move.l #name125,a1
Jsr Stringfind
             Cmp.l #0,d0
             Beq .pre0336
             Bra .pre0337
.pre0336:

                Move.l ext_p,A0
                Jsr strlen
                Move.l D0,Len
                Move.l len,d0
                Addq.l #7,d0
                Move.l D0,len
move.l IntuitionBase,a6
move.l #Rememberstruct,a0
move.l len,d0
move.l  #MEMF_FAST!MEMF_CLEAR,d1
jsr -396(a6)
move.l d0,ext_PP
                Move.l len,d0
                Subq.l #7,d0
                Move.l D0,len
                Move.l ExecBase,a6
                Move.l ext_P,a0
                Move.l ext_PP,a1
                Move.l len,d0
                Jsr Copymem(a6)
                Move.l #name126,a0
                Move.l ext_PP,a1
                 Add.l  len,a1
                Moveq.l #$06,d0
                Jsr Copymem(a6)
                Move.l Ext_PP,d0
                Move.l D0,ext_p
.Pre0337:
Move.l ext_p,a0
Move.l #classes_name127,a1
Jsr Stringfind
             Cmp.l #0,d0
             Beq .pre0338
             Bra .pre0339
.pre0338:

                Move.l ext_p,A0
                Jsr strlen
                Move.l D0,Len
                Move.l len,d0
                Add.l #13,d0
                Move.l D0,len
move.l IntuitionBase,a6
move.l #Rememberstruct,a0
move.l len,d0
move.l  #MEMF_FAST!MEMF_CLEAR,d1
jsr -396(a6)
move.l d0,ext_PP
                Move.l len,d0
                Sub.l #13,d0
                Move.l D0,len
                Move.l ExecBase,a6
                Move.l #odk_classes_name128,a0
                Move.l ext_PP,a1
                Moveq.l #$0C,d0
                Jsr Copymem(a6)
                Move.l ext_P,a0
                Move.l ext_PP,a1
                 Add.l  #12,a1
                Move.l len,d0
                Jsr Copymem(a6)
                Move.l Ext_PP,d0
                Move.l D0,ext_p
.Pre0339:

             Move.l 0012(a7),A0
             Jsr strlen
             Move.l D0,len
             Move.l len,d0
             Addq.l #1,d0
             Move.l D0,len
move.l IntuitionBase,a6
move.l #Rememberstruct,a0
move.l len,d0
move.l #MEMF_Fast,d1
jsr -396(a6)
move.l d0,0016(a7)
             Move.l ExecBase,a6
             Move.l 0012(a7),a0
             Move.l 0016(a7),a1
             Move.l len,d0
             Jsr Copymem(a6)
             Move.l 0016(a7),-(a7)
             Move.l len,-(a7)
             Move.l ext_p,a0
             Jsr NeueKlasse
             Move.l D0,0024(a7)
             Move.l NK_Return,d0
             Or.l 0024(a7),d0
             Move.l D0,NK_Return
             Move.l (a7)+,len
             Move.l (a7)+,0016(a7)
             Move.l ExecBase,a6
             Move.l 0016(a7),a0
             lea Classname,a1
             Move.l len,d0
             Jsr Copymem(a6)
             Moveq.l #$0,d0
             Move.l D0,MethodeID

.Pre0335:
          Move.l DOSBase,a6
          Move.l 0008(a7),d1
          Jsr FreeArgs(a6)
          Move.l 0004(a7),d0
          Jsr ClassBodyAnalyse
.Pre0325:
Bra .While0022
.Pre0317:
.While0023:
     Move.l DOSBase,a6
     Move.l 0004(a7),d1
     Jsr Close(a6)
.Pre0315:
    Move.l NK_Return,d0
    Or.l 0004(a7),d0
    Move.l D0,NK_Return
    Move.l NK_Return,d0
    Add.l  #0032,a7
    rts

Chain:       
    sub.l  #0016,a7
    Move.l  a0,0000(a7)
    Move.l  A1,0004(a7)
    Clr.l d0
    Move.l 0000(a7),a0
    Move.l LineRoot.next(a0),d0
    Move.l D0,0008(a7)
    Move.l 0008(a7),d0
    Cmp.l #0,d0
    Beq .pre0340
    Bra .pre0341
.pre0340:

        Move.l  0000(a7),a0 

        Lea LineRoot.next(a0),a0
        Move.l 0004(a7),(a0)
                Add.l  #0016,a7
        rts
.Pre0341:
    Move.l 0008(a7),A0
    Move.l 0004(a7),A1
    Jsr Chain
        Add.l  #0016,a7
    rts

SkipLine:    
    cmpi.b #$00,(a0)
    beq .ende
    cmpi.b #$0A,(a0)
    beq .ok
    cmpi.b #$09,(a0)
    beq .ok
    cmpi.b #$20,(a0)
    beq .ok
    cmpi.b #";",(a0)
    beq .ok
    moveq.l #0,d0
    RTS
.ende:
    moveq.l #-1,d0
    RTS
.ok:lea 1(a0),a0
    bra.w SkipLine



BuildBody:              

    Clr.l d0
    Move.l methodeRoot,a0
    Move.l MethodeRoot.next(a0),d0
    Move.l D0,MethodeID
.While0024:
    Move.l MethodeID,d0
    Cmp.l #0,d0
    Bne .pre0342
    Bra .pre0343
.pre0342:

        lea Store,A0
        Move.l #0,D0
        Move.l #1000,D1
        Jsr fillbuffer

        Clr.l d0
        Move.l MethodeID,a0
        Move.l MethodeRoot.name(a0),d0
        Move.l D0,name
        Clr.l d0
        Move.l MethodeID,a0
        Move.l MethodeRoot.static(a0),d0
        Move.l D0,static
        Clr.l d0
        Move.l MethodeID,a0
        Move.l MethodeRoot.Counter(a0),d0
        Move.l D0,Counter
        Clr.l d0
        Move.l MethodeID,a0
        Move.l MethodeRoot.Invalid(a0),d0
        Move.l D0,invalid
        Move.l Invalid,d0
        Cmp.l #1,d0
        Beq .pre0344
        Bra .pre0345
.pre0344:

           Clr.l d0
           Move.l MethodeID,a0
           Move.l MethodeRoot.next(a0),d0
           Move.l D0,MethodeID
           bra.l .While0024
.Pre0345:

        Move.l static,d0
        Cmp.l #0,d0
        Bne .pre0346
        Bra .pre0347
.pre0346:

           Moveq.l #$1,d0
           Move.l D0,static
.Pre0347:

        Move.l static,d0
        Cmp.l staticStatus,d0
        Beq .pre0348
        Bra .pre0349
.pre0348:


            Moveq.l #$0,d0
            Move.l D0,char
            Moveq.l #$0,d0
            Move.l D0,anz
            Move.l name,a0
            Move.l #_name129,a1
            Jsr Stringfind
            Move.l D0,pos
            Move.l pos,d0
            Cmp.l #0,d0
            Bne .pre0350
            Bra .pre0351
.pre0350:

               Move.l pos,d0
               Sub.l name,d0
               Move.l D0,len
               Move.l ExecBase,a6
               Move.l name,a0
               lea store,a1
               Move.l len,d0
               Jsr copymem(a6)
lea pf130,a0
move.l  Counter,0004(a0)
Move.l DOSBase,a6
Move.l #name130,d1
Move.l #pf130,d2
Jsr vpf(a6)
             Clr.l d0
             Move.l pos,a0
             Move.w 0(a0),d0
             Move.l D0,char
               Move.l pos,a0
               Move.l #$2c,d1
               Jsr countchars
               Move.l D0,anz
               Moveq.l #$1,d0
               Move.l D0,begin
               Move.l static,d0
               Cmp.l #0,d0
               Bne .pre0352
               Bra .pre0353
.pre0352:

                  Moveq.l #$2,d0
                  Move.l D0,begin
.Pre0353:
               Move.l begin,d0
               Move.l D0,i
               Move.l char,d0
               Cmp.l #$2829,d0
               Bne .pre0354
               Bra .pre0355
.pre0354:

                   Move.l anz,d0
                   Addq.l #1,d0
                   Move.l D0,anz
                   Move.l Begin,I
                   Move.l anz,I_bis
                   Move.l #1,I_step
.I_Label:
                     Lea    Registers,A0
                     Move.l i,D0
                     Move.l (A0,D0*4),d0
                     Move.l D0,Register
lea pf131,a0
move.l  register,0000(a0)
Move.l DOSBase,a6
Move.l #name131,d1
Move.l #pf131,d2
Jsr vpf(a6)
                 Move.l I,d0
                 Add.l I_step,d0
                 Move.l D0,I
                 Cmp.l I_bis,d0
                 Ble .I_Label
.Pre0355:
               Lea    Registers,A0
               Move.l i,D0
               Move.l (A0,D0*4),d0
               Move.l D0,Register
lea pf132,a0
move.l  register,0000(a0)
Move.l #name132,d1
Move.l #pf132,d2
Jsr vpf(a6)
.Pre0351:
            Move.l static,d0
            Cmp.l #0,d0
            Bne .pre0356
            Bra .pre0357
.pre0356:
Move.l DOSBase,a6
Move.l #x_09x_7b__Stackframe_this__0name133,d1
Move.l #nullt,d2
Jsr vpf(a6)
.Pre0357:
            Move.l static,d0
            Cmp.l #0,d0
            Beq .pre0358
            Bra .pre0359
.pre0358:
Move.l DOSBase,a6
Move.l #x_09x_7b__Stackframe_this_d0name134,d1
Move.l #nullt,d2
Jsr vpf(a6)
.Pre0359:
            Move.l pos,d0
            Addq.l #1,d0
            Move.l D0,oldpos
            Clr.l d0
            Move.l VarRoot,a0
            Move.l VarRoot.next(a0),d0
            Move.l D0,next
            Move.l anz,d0
            Cmp.l #0,d0
            Bne .pre0360
            Bra .pre0361
.pre0360:

                Move.l anz,d0
                Addq.l #1,d0
                Move.l D0,anz
                Move.l #2,I1
                Move.l anz,I1_bis
                Move.l #1,I1_step
.I1_Label:
                  Lea    Registers,A0
                  Move.l i1,D0
                  Move.l (A0,D0*4),d0
                  Move.l D0,Register
Move.l oldpos,a0
Move.l #_name135,a1
Jsr Stringfind
Move.l D0,pos
                  Cmp.l #0,d0
                  Beq .pre0362
                  Bra .pre0363
.pre0362:

                      Move.l oldpos,a0
                      Move.l #_name136,a1
                      Jsr Stringfind
                      Move.l D0,pos
.Pre0363:
                  Move.l pos,d0
                  Cmp.l #0,d0
                  Bne .pre0364
                  Bra .pre0365
.pre0364:

Move.l oldpos,a0
Move.l #_name137,a1
Jsr Stringfind
Move.l D0,mypos
                      Cmp.l #0,d0
                      Bne .pre0366
                      Bra .pre0367
.pre0366:

                          Move.l mypos,d0
                          Addq.l #1,d0
                          Move.l D0,oldpos
.Pre0367:
                      Move.l oldpos,a0
                      lea buffer,a1
                      Move.l pos,d0
                       Sub.l  oldpos,d0
                      Jsr makeSubString
lea pf138,a0
move.l  register,0004(a0)
Move.l DOSBase,a6
Move.l #_name138,d1
Move.l #pf138,d2
Jsr vpf(a6)
.Pre0365:
                  Move.l pos,d0
                  Addq.l #1,d0
                  Move.l D0,oldpos
                Move.l I1,d0
                Add.l I1_step,d0
                Move.l D0,I1
                Cmp.l I1_bis,d0
                Ble .I1_Label
.Pre0361:
.While0026:
            Move.l next,d0
            Cmp.l #0,d0
            Bne .pre0368
            Bra .pre0369
.pre0368:

                 Clr.l d0
                 Move.l next,a0
                 Move.l VarRoot.id(a0),d0
                 Move.l D0,Id
                 Clr.l d0
                 Move.l Next,a0
                 Move.l VarRoot.name(a0),d0
                 Move.l D0,name
                 Clr.l d0
                 Move.l Next,a0
                 Move.l VarRoot.next(a0),d0
                 Move.l D0,next
                 Move.l id,d0
                 Cmp.l MethodeID,d0
                 Beq .pre0370
                 Bra .pre0371
.pre0370:

                    Move.l name,d0
                    Cmp.l #0,d0
                    Bne .pre0372
                    Bra .pre0373
.pre0372:
Move.l name,A0
Jsr strlen
Cmp.l #0,d0
Bne .pre0374
Bra .pre0375
.pre0374:

lea pf139,a0
move.l  name,0000(a0)
Move.l DOSBase,a6
Move.l #_name139,d1
Move.l #pf139,d2
Jsr vpf(a6)
.Pre0375:
.Pre0373:
.Pre0371:
Bra .While0026
.Pre0369:
.While0027:
            Move.l SecondVarRoot,a0
            Jsr GetInstanzVariablen
Move.l DOSBase,a6
Move.l #_x_7dxnname140,d1
Move.l #nullt,d2
Jsr vpf(a6)
          Move.l SecondVarRoot,a0
          Move.l MethodeID,d0
          Jsr LadeInstanzVariablen
            Clr.l d0
            Move.l LineRoot,a0
            Move.l LineRoot.next(a0),d0
            Move.l D0,next
.While0028:
            Move.l next,d0
            Cmp.l #0,d0
            Bne .pre0376
            Bra .pre0377
.pre0376:

                 Clr.l d0
                 Move.l next,a0
                 Move.l LineRoot.Methodeid(a0),d0
                 Move.l D0,Id
                 Clr.l d0
                 Move.l Next,a0
                 Move.l LineRoot.name(a0),d0
                 Move.l D0,name
                 Clr.l d0
                 Move.l Next,a0
                 Move.l LineRoot.next(a0),d0
                 Move.l D0,next
                 Move.l id,d0
                 Cmp.l MethodeID,d0
                 Beq .pre0378
                 Bra .pre0379
.pre0378:

Move.l name,a0
Jsr skipLine
                    Cmp.l #0,d0
                    Beq .pre0380
                    Bra .pre0381
.pre0380:

                        Moveq.l #$0,d0
                        Move.l D0,returnwert
                        Move.l name,a0
                        Move.l #return_K_Aname141,a1
                        Jsr LineAnalyse
                        Move.l D0,args
                        Move.l D1,returnbefehl
                        Move.l args,d0
                        Cmp.l #0,d0
                        Bne .pre0382
                        Bra .pre0383
.pre0382:

                            Move.l returnbefehl,d0
                            Move.l D0,returnwert
                            Move.l DOSBase,a6
                            Move.l args,d1
                            Jsr FreeArgs(a6)
.Pre0383:
                        Move.l name,a0
                        Move.l #x_7b__UnFrameReturnname142,a1
                        Jsr Stringfind
                        Move.l D0,returnbefehl
                        Move.l returnbefehl,d0
                        Cmp.l #-1,d0
                        Bne .pre0384
                        Bra .pre0385
.pre0384:

                            Move.l returnwert,d0
                            Or.l returnbefehl,d0
                            Move.l D0,returnwert
.Pre0385:
.Pre0381:
                    Move.l name,a0
                    Move.l MethodeID,d0
                    Jsr PraeProzessor
                    Move.l D0,name
lea pf143,a0
move.l  name,0000(a0)
Move.l DOSBase,a6
Move.l #name143,d1
Move.l #pf143,d2
Jsr vpf(a6)
.Pre0379:
                 Move.l next,d0
                 Cmp.l #0,d0
                 Beq .pre0386
                 Bra .pre0387
.pre0386:
Move.l returnwert,d0
Cmp.l #0,d0
Beq .pre0388
Bra .pre0389
.pre0388:

                    Move.l SecondVarRoot,a0
                    Jsr PrintInstanzVariablen
Move.l DOSBase,a6
Move.l #x_09x_7b__UnFrameReturn__x_7dxnxnname144,d1
Move.l #nullt,d2
Jsr vpf(a6)
.Pre0389:
.Pre0387:
Bra .While0028
.Pre0377:
.While0029:
.Pre0349:
       Clr.l d0
       Move.l MethodeID,a0
       Move.l MethodeRoot.next(a0),d0
       Move.l D0,MethodeID
Bra .While0024
.Pre0343:
.While0025:
    RTS

Start:
move.l IntuitionBase,a6
move.l #Rememberstruct,a0
move.l #100000,d0
move.l  #MEMF_FAST!MEMF_CLEAR,d1
jsr -396(a6)
move.l d0,Stackmem
    move.l a7,oldstack
    move.l Stackmem,a7
    add.l #100000,a7

move.l IntuitionBase,a6
move.l #Rememberstruct,a0
move.l #20,d0
move.l  #MEMF_FAST!MEMF_CLEAR,d1
jsr -396(a6)
move.l d0,VarRoot
move.l IntuitionBase,a6
move.l #Rememberstruct,a0
move.l #40,d0
move.l  #MEMF_FAST!MEMF_CLEAR,d1
jsr -396(a6)
move.l d0,MethodeRoot
move.l IntuitionBase,a6
move.l #Rememberstruct,a0
move.l #12,d0
move.l  #MEMF_FAST!MEMF_CLEAR,d1
jsr -396(a6)
move.l d0,LineRoot
move.l IntuitionBase,a6
move.l #Rememberstruct,a0
move.l #16,d0
move.l  #MEMF_FAST!MEMF_CLEAR,d1
jsr -396(a6)
move.l d0,ObjectRoot
move.l IntuitionBase,a6
move.l #Rememberstruct,a0
move.l #12,d0
move.l  #MEMF_FAST!MEMF_CLEAR,d1
jsr -396(a6)
move.l d0,ConstructorRoot
move.l IntuitionBase,a6
move.l #Rememberstruct,a0
move.l #8,d0
move.l  #MEMF_FAST!MEMF_CLEAR,d1
jsr -396(a6)
move.l d0,StringRoot

    Move.l VarRoot,a0
    Move.l #FuncArrayname145,A1
    Move.l #2,D0
    Move.l #0,d1
    Move.l #0,d2
    Jsr AddVar
    Move.l VarRoot,a0
    Move.l #SizeofObjectname146,A1
    Move.l #1,D0
    Move.l #0,d1
    Move.l #0,d2
    Jsr AddVar
    Move.l VarRoot,a0
    Move.l #SIGname147,A1
    Move.l #1,D0
    Move.l #0,d1
    Move.l #0,d2
    Jsr AddVar
    Move.l VarRoot,a0
    Move.l #LibraryBasename148,A1
    Move.l #1,D0
    Move.l #0,d1
    Move.l #0,d2
    Jsr AddVar

    Move.l ObjectRoot,a0
    Move.l #thisname149,A1
    Move.l #thisname150,a2
    Move.l #-1,D0
    Jsr AddObject

    Clr.l d0
    Move.l VarRoot,a0
    Move.l VarRoot.Next(a0),d0
    Move.l D0,SecondVarRoot
    Clr.l d0
    Move.l SecondVarRoot,a0
    Move.l VarRoot.Next(a0),d0
    Move.l D0,SecondVarRoot
    Clr.l d0
    Move.l SecondVarRoot,a0
    Move.l VarRoot.Next(a0),d0
    Move.l D0,SecondVarRoot
    Clr.l d0
    Move.l SecondVarRoot,a0
    Move.l VarRoot.Next(a0),d0
    Move.l D0,SecondVarRoot

Move.l DOSBase,a6
Move.l #filename_Aname151,d1
Move.l #RDArgs_array,d2
Move.l #RDArgs,d3
Jsr Readargs(a6)
Move.l D0,Args
    Cmp.l #0,d0
    Beq .pre0390
    Bra .pre0391
.pre0390:

Move.l DOSBase,a6
Move.l #Preassname152,d1
Move.l #nullt,d2
Jsr vpf(a6)
     move.l oldstack,a7
       Move.l #10,d0
       Move.l D0,error
       RTS
.Pre0391:
    Lea    RDArgs_array,A0
    Move.l #0,D0
    Move.l (A0,D0*4),d0
    Move.l D0,res
    Move.l ExecBase,a6
    Move.l res,a0
    lea Filename,a1
    Move.l #200,d0
    Jsr copymem(a6)
    Move.l DOSBase,a6
    Move.l args,d1
    Jsr FreeArgs(a6)
lea filename,a0
Jsr NeueKlasse
Move.l D0,res
    Cmp.l #0,d0
    Beq .pre0392
    Bra .pre0393
.pre0392:

Move.l DOSBase,a6
Move.l #Class_errorxnname153,d1
Move.l #nullt,d2
Jsr vpf(a6)
     move.l oldstack,a7
       Move.l #20,d0
       Move.l D0,error
       Move.l #20,d0
	RTS
.Pre0393:
    Move.l Res,d0
    Cmp.l #-1,d0
    Beq .pre0394
    Bra .pre0395
.pre0394:

Move.l DOSBase,a6
Move.l #Class_processing_returned_anname154,d1
Move.l #nullt,d2
Jsr vpf(a6)
     move.l oldstack,a7
       Move.l #20,d0
       Move.l D0,error
       Move.l #20,d0
	RTS
.Pre0395:

Move.l MethodeRoot,d0
Jsr findAbstractMethoden
Move.l D0,res
    Cmp.l #0,d0
    Bne .pre0396
    Bra .pre0397
.pre0396:

lea pf155,a0
move.l  res,0000(a0)
Move.l DOSBase,a6
Move.l #oh_oh__name155,d1
Move.l #pf155,d2
Jsr vpf(a6)
     Move.l methodeRoot,d0
     Jsr PrintAbstractMethoden
       Move.l #20,d0
       Move.l D0,error
       Move.l #20,d0
	RTS
.Pre0397:

Move.l DOSBase,a6
Move.l #x_09x_7b__Include_odk_misc_Konstanten_newname156,d1
Move.l #nullt,d2
Jsr vpf(a6)
Move.l #x_09x_7b__Delayaus__x_7dxnname157,d1
Move.l #nullt,d2
Jsr vpf(a6)
Move.l #x_09x_7b__KillFD_name158,d1
Move.l #nullt,d2
Jsr vpf(a6)
  Clr.l d0
  Move.l MethodeRoot,a0
  Move.l MethodeRoot.next(a0),d0
  Move.l D0,next
.While0030:
    Move.l next,d0
    Cmp.l #0,d0
    Bne .pre0398
    Bra .pre0399
.pre0398:

       Clr.l d0
       Move.l next,a0
       Move.l MethodeRoot.name(a0),d0
       Move.l D0,name
       Move.l name,a0
       Move.l #_name159,a1
       Jsr Stringfind
       Move.l D0,pos
       Move.l name,a0
       lea buffer,a1
       Move.l pos,d0
        Sub.l  name,d0
       Jsr makeSubString
Move.l DOSBase,a6
Move.l #name160,d1
Move.l #pf160,d2
Jsr vpf(a6)
     Clr.l d0
     Move.l next,a0
     Move.l MethodeRoot.next(a0),d0
     Move.l D0,next
       Move.l next,d0
       Cmp.l #0,d0
       Bne .pre0400
       Bra .pre0401
.pre0400:

Move.l DOSBase,a6
Move.l #_name161,d1
Move.l #nullt,d2
Jsr vpf(a6)
.Pre0401:
Bra .While0030
.Pre0399:
.While0031:

Move.l #_x_7dxnxnx_09moveqname162,d1
Move.l #nullt,d2
Jsr vpf(a6)
Move.l #x_7b__structure_name163,d1
Move.l #pf163,d2
Jsr vpf(a6)
   Clr.l d0
   Move.l SecondvarRoot,a0
   Move.l VarRoot.next(a0),d0
   Move.l D0,next

.While0032:
    Move.l next,d0
    Cmp.l #0,d0
    Bne .pre0402
    Bra .pre0403
.pre0402:

       Clr.l d0
       Move.l Next,a0
       Move.l VarRoot.name(a0),d0
       Move.l D0,name
       Clr.l d0
       Move.l Next,a0
       Move.l VarRoot.type(a0),d0
       Move.l D0,type
       Clr.l d0
       Move.l Next,a0
       Move.l varRoot.id(a0),d0
       Move.l D0,id
       Clr.l d0
       Move.l Next,a0
       Move.l VarRoot.Public(a0),d0
       Move.l D0,public
       Move.l ID,d0
       Cmp.l #0,d0
       Beq .pre0404
       Bra .pre0405
.pre0404:
Move.l public,d0
Cmp.l #0,d0
Bne .pre0406
Bra .pre0407
.pre0406:

           Move.l type,d0
           Cmp.l #1,d0
           Beq .pre0408
           Bra .pre0409
.pre0408:

lea pf164,a0
move.l  name,0000(a0)
Move.l DOSBase,a6
Move.l #_name164,d1
Move.l #pf164,d2
Jsr vpf(a6)
.Pre0409:
           Move.l type,d0
           Cmp.l #2,d0
           Beq .pre0410
           Bra .pre0411
.pre0410:

lea pf165,a0
move.l  name,0000(a0)
Move.l DOSBase,a6
Move.l #_name165,d1
Move.l #pf165,d2
Jsr vpf(a6)
.Pre0411:
.Pre0407:
.Pre0405:
       Clr.l d0
       Move.l Next,a0
       Move.l VarRoot.next(a0),d0
       Move.l D0,next
Bra .While0032
.Pre0403:
.While0033:

    Clr.l d0
    Move.l SecondvarRoot,a0
    Move.l VarRoot.next(a0),d0
    Move.l D0,next

.While0034:
    Move.l next,d0
    Cmp.l #0,d0
    Bne .pre0412
    Bra .pre0413
.pre0412:

       Clr.l d0
       Move.l Next,a0
       Move.l VarRoot.name(a0),d0
       Move.l D0,name
       Clr.l d0
       Move.l Next,a0
       Move.l VarRoot.type(a0),d0
       Move.l D0,type
       Clr.l d0
       Move.l Next,a0
       Move.l varRoot.id(a0),d0
       Move.l D0,id
       Clr.l d0
       Move.l Next,a0
       Move.l VarRoot.Public(a0),d0
       Move.l D0,public
       Move.l ID,d0
       Cmp.l #0,d0
       Beq .pre0414
       Bra .pre0415
.pre0414:
Move.l public,d0
Cmp.l #0,d0
Beq .pre0416
Bra .pre0417
.pre0416:

           Move.l type,d0
           Cmp.l #1,d0
           Beq .pre0418
           Bra .pre0419
.pre0418:

lea pf166,a0
move.l  name,0000(a0)
Move.l DOSBase,a6
Move.l #_name166,d1
Move.l #pf166,d2
Jsr vpf(a6)
.Pre0419:
           Move.l type,d0
           Cmp.l #2,d0
           Beq .pre0420
           Bra .pre0421
.pre0420:

lea pf167,a0
move.l  name,0000(a0)
Move.l DOSBase,a6
Move.l #_name167,d1
Move.l #pf167,d2
Jsr vpf(a6)
.Pre0421:
.Pre0417:
.Pre0415:
       Clr.l d0
       Move.l Next,a0
       Move.l VarRoot.next(a0),d0
       Move.l D0,next
Bra .While0034
.Pre0413:
.While0035:
Move.l #_x_7dxnxnname168,d1
Move.l #nullt,d2
Jsr vpf(a6)
  Clr.l d0
  Move.l SecondVarRoot,a0
  Move.l VarRoot.Next(a0),d0
  Move.l D0,SecondVarRoot

    Move.l MethodeRoot,a0
    Move.l #Constructor__name169,A1
    Jsr foundMethode
    Move.l D0,CID
    Move.l CID,d0
    Cmp.l #0,d0
    Beq .pre0422
    Bra .pre0423a
.pre0422:

       Move.l MethodeRoot,a0
       Move.l #Constructor__name170,A1
       Move.l #1,D0
       Move.l #0,d1
       Move.l #0,d2
       Move.l #0,d3
       Move.l #0,d4
       Move.l #0,d5
       Move.l #0,d6
       Jsr AddMethode
       Move.l D0,CID
       Move.l ConstructorRoot,a0
       Move.l CID,d0
       Jsr AddConstructoren
       Move.l ConstructorRoot,a0
       Move.l CID,d0
       Jsr PrintConstructoren
bra.l .Pre0423
.Pre0423a:

       Move.l LineRoot,d0
       Move.l D0,OldLineRoot
move.l IntuitionBase,a6
move.l #Rememberstruct,a0
move.l #12,d0
move.l  #MEMF_FAST!MEMF_CLEAR,d1
jsr -396(a6)
move.l d0,LineRoot
       Move.l ConstructorRoot,a0
       Move.l CID,d0
       Jsr AddConstructoren
       Move.l ConstructorRoot,a0
       Move.l CID,d0
       Jsr PrintConstructoren
       Move.l LineRoot,A0
       Move.l OldLineRoot,A1
       Jsr Chain
.Pre0423:
    Move.l MethodeRoot,a0
    Move.l #DeConstructor__name171,A1
    Jsr foundMethode
    Move.l D0,DID
    Move.l DID,d0
    Cmp.l #0,d0
    Beq .pre0424
    Bra .pre0425
.pre0424:

       Move.l methodeRoot,a0
       Move.l #DeConstructor__name172,A1
       Move.l #1,D0
       Move.l #0,d1
       Move.l #0,d2
       Move.l #0,d3
       Move.l #0,d4
       Move.l #0,d5
       Move.l #0,d6
       Jsr AddMethode
       Move.l D0,DID
.Pre0425:

    Move.l ConstructorRoot,a0
    Move.l DID,d0
    Jsr AddDeConstructoren

; Build Static Routines first

    Move.l #1,staticstatus
    Jsr BuildBody
    Move.l #0,staticstatus
    Jsr BuildBody
Move.l DOSBase,a6
Move.l #name173,d1
Move.l #pf173,d2
Jsr vpf(a6)
  lea Buffer,a3
  Move.l #classname___dcname174,a0
  Move.l #spficl1a,a1
  Jsr sprintf
Move.l DOSBase,a6
Move.l #buffer,d1
Move.l #nullt,d2
Jsr vpf(a6)
   lea Buffer,a3
   Move.l #Libname____name175,a0
   Move.l #spficl1,a1
   Jsr sprintf
Move.l DOSBase,a6
Move.l #buffer,d1
Move.l #nullt,d2
Jsr vpf(a6)
    lea Buffer,a3
    Move.l #idstring____dcname176,a0
    Move.l #spficl2,a1
    Jsr sprintf

Move.l DOSBase,a6
Move.l #buffer,d1
Move.l #nullt,d2
Jsr vpf(a6)
Move.l #name177,d1
Move.l #pf177,d2
Jsr vpf(a6)
  Move.l MethodeRoot,d0
  Move.l #0,d1
  Jsr PrintPublicMethoden
Move.l DOSBase,a6
Move.l #___name178,d1
Move.l #nullt,d2
Jsr vpf(a6)
  Move.l MethodeRoot,d0
  Move.l #0,d1
  Jsr PrintPublicMethoden
Move.l DOSBase,a6
Move.l #___name179,d1
Move.l #nullt,d2
Jsr vpf(a6)
  Move.l MethodeRoot,d0
  Move.l #1,d1
  Jsr PrintPublicMethoden
Move.l DOSBase,a6
Move.l #_name180,d1
Move.l #nullt,d2
Jsr vpf(a6)
Move.l #xn___name181,d1
Move.l #nullt,d2
Jsr vpf(a6)
  Move.l MethodeRoot,d0
  Move.l #2,d1
  Jsr PrintPublicMethoden
Move.l DOSBase,a6
Move.l #_name182,d1
Move.l #nullt,d2
Jsr vpf(a6)
Move.l #name183,d1
Move.l #pf183,d2
Jsr vpf(a6)
   Move.l VarRoot,d0
   Jsr calcOBS
   Move.l D0,sizeofObject
lea pf184,a0
move.l  sizeofobject,0000(a0)
Move.l DOSBase,a6
Move.l #___name184,d1
Move.l #pf184,d2
Jsr vpf(a6)
Move.l #___name185,d1
Move.l #nullt,d2
Jsr vpf(a6)
Move.l #___name186,d1
Move.l #nullt,d2
Jsr vpf(a6)
Move.l #name187,d1
Move.l #pf187,d2
Jsr vpf(a6)
    lea Filename,a3
    Move.l #odk_docs_classes_name188,a0
    Move.l #spfpm1,a1
    Jsr Sprintf
Move.l DOSBase,a6
Move.l #Filename,d1
Move.l #Mode_new,d2
Jsr open(a6)
Move.l D0,mh
    Cmp.l #0,d0
    Bne .pre0426
    Bra .pre0427
.pre0426:

        Move.l DOSBase,a6
        Move.l mh,d1
        Move.l #ClassStoreMem,d2
        Jsr Fputs(a6)
        Move.l mh,d1
        Move.l #xnxnname189,d2
        Jsr Fputs(a6)
        Clr.l d0
        Move.l ObjectRoot,a0
        Move.l ObjectRoot.Next(a0),d0
        Move.l D0,ObjectRoot
        Move.l ObjectRoot,d0
        Move.l mh,d1
        Move.l #0,d2
        Move.l #1,d3
        Jsr PrintObject
        Move.l SecondVarRoot,d0
        Move.l mh,d1
        Move.l #0,d2
        Move.l #1,d3
        Jsr printVar
        Move.l DOSBase,a6
        Move.l mh,d1
        Move.l #xnname190,d2
        Jsr Fputs(a6)
        Move.l methodeRoot,d0
        Move.l mh,d1
        Jsr PrintMethoden
        Move.l DOSBase,a6
        Move.l MH,d1
        Jsr close(a6)
.Pre0427:

    move.l oldstack,a7
    RTS

LineAnalyse:       
    sub.l  #0064,a7
    Move.l  a0,0000(a7)
    Move.l  a1,0012(a7)

       lea RdArgs_array,A0
       Move.l #0,D0
       Move.l #40,D1
       Jsr fillbuffer
       Clr.l d0
       Move.l 0000(a7),a0
       Move.b 0(a0),d0
       Move.l D0,0004(a7)
       Move.l 0004(a7),d0
       Cmp.l #`#`,d0
       Beq .pre0428
       Bra .pre0429
.pre0428:

          Move.l #0,d0
          Add.l  #0064,a7
          rts
.Pre0429:
       Move.l 0004(a7),d0
       Cmp.l #`;`,d0
       Beq .pre0430
       Bra .pre0431
.pre0430:

          Move.l #0,d0
          Add.l  #0064,a7
          rts
.Pre0431:

       Move.l 0000(a7),A0
       Jsr strlen
       Move.l D0,0008(a7)
       lea RDArgs,A0
       Lea RDArgs.CS_Buffer(a0),a0
       Move.l 0000(a7),(a0)
          lea RDArgs,A0
          Lea RDArgs.CS_Lenght(a0),a0
          Move.l 0008(a7),(a0)
            lea RDArgs,A0
            Lea RDArgs.CS_CurChr(a0),a0
            Move.l #0,(a0)
            lea RDArgs,A0
            Lea RDArgs.RDA_DAList(a0),a0
            Move.l #0,(a0)
            lea RDArgs,A0
            Lea RDArgs.RDA_Buffer(a0),a0
            Move.l #0,(a0)
            lea RDArgs,A0
            Lea RDArgs.RDA_BufSiz(a0),a0
            Move.l #0,(a0)
            lea RDArgs,A0
            Lea RDArgs.RDA_ExtHelp(a0),a0
            Move.l #0,(a0)
            lea RDArgs,A0
            Lea RDArgs.RDA_Flags(a0),a0
            Move.l #0,(a0)

Move.l DOSBase,a6
Move.l 0012(a7),d1
Move.l #RDArgs_array,d2
Move.l #RDArgs,d3
Jsr Readargs(a6)
Move.l D0,0056(a7)
       Cmp.l #0,d0
       Beq .pre0432
       Bra .pre0433
.pre0432:

           Move.l #0,d0
           Add.l  #0064,a7
           rts
.Pre0433:

       Lea    RDArgs_array,A0
       Move.l #0,D0
       Move.l (A0,D0*4),d0
       Move.l D0,0016(a7)
       Lea    RDArgs_array,A0
       Move.l #1,D0
       Move.l (A0,D0*4),d0
       Move.l D0,0020(a7)
       Lea    RDArgs_array,A0
       Move.l #2,D0
       Move.l (A0,D0*4),d0
       Move.l D0,0024(a7)
       Lea    RDArgs_array,A0
       Move.l #3,D0
       Move.l (A0,D0*4),d0
       Move.l D0,0028(a7)
       Lea    RDArgs_array,A0
       Move.l #4,D0
       Move.l (A0,D0*4),d0
       Move.l D0,0032(a7)
       Lea    RDArgs_array,A0
       Move.l #5,D0
       Move.l (A0,D0*4),d0
       Move.l D0,0036(a7)
       Lea    RDArgs_array,A0
       Move.l #6,D0
       Move.l (A0,D0*4),d0
       Move.l D0,0040(a7)
       Lea    RDArgs_array,A0
       Move.l #7,D0
       Move.l (A0,D0*4),d0
       Move.l D0,0044(a7)
       Lea    RDArgs_array,A0
       Move.l #8,D0
       Move.l (A0,D0*4),d0
       Move.l D0,0048(a7)
       Lea    RDArgs_array,A0
       Move.l #9,D0
       Move.l (A0,D0*4),d0
       Move.l D0,0052(a7)

    Move.l 0056(a7),D0
	Move.l 0016(a7),D1
	Move.l 0020(a7),D2
	Move.l 0024(a7),D3
	Move.l 0028(a7),D4
	Move.l 0032(a7),D5
	Move.l 0036(a7),D6
	Move.l 0040(a7),D7
	Move.l 0044(a7),A0
	Move.l 0048(a7),A1
	Move.l 0052(a7),A2
    Add.l  #0064,a7
    rts


include1:   incbin odk:source/preassxx.incl1
            dc.b 0

include2:   incbin odk:source/preassxx.incl2
            dc.b 0

include3:   incbin odk:source/preassxx.incl3
            dc.b 0

include4:   incbin odk:source/preassxx.incl4
            dc.b 0
cnop 0,4


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
Move.l Intuitionbase,a6 
Move.l #Rememberstruct,a0
Move.l #1,d0
jsr -408(a6)
rts 
even
Rememberstruct: dc.l 0,0,0,0
Even
Openlibs:
	Move.l $4.w,a6
	Move.l #Aslname,a1
	Moveq.l #0,d0
	Jsr Openlibrary(a6) 
	Move.l d0,Aslbase
	Tst.l D0
	Beq.w .ende
	Move.l #DOSname,a1
	Moveq.l #0,d0
	Jsr Openlibrary(a6) 
	Move.l d0,DOSbase
	Tst.l D0
	Beq.w .ende
	Move.l #Intuitionname,a1
	Moveq.l #0,d0
	Jsr Openlibrary(a6) 
	Move.l d0,Intuitionbase
	Tst.l D0
	Beq.w .ende
	rts
.ende:	Move.l #4,error
	Move.l a1,d7
	rts
Closelibs:
	Move.l $4.w,a6
	Tst.l Aslbase
	Beq.w .ende00
	Move.l Aslbase,a1
	Jsr Closelibrary(a6)
.ende00:Tst.l DOSbase
	Beq.w .ende01
	Move.l DOSbase,a1
	Jsr Closelibrary(a6)
.ende01:Tst.l Intuitionbase
	Beq.w .ende02
	Move.l Intuitionbase,a1
	Jsr Closelibrary(a6)
.ende02:Rts
even
WBmessage:		dc.l 0
Laenge:		dc.l 0
Adresse:		dc.l 0
Error:		dc.l 0
LokalScreen:		dc.l 0
Requester:		dc.l 0
Result:		dc.l 0
Filename_Zeiger:		dc.l 0
Dirname_zeiger:		dc.l 0
Zusatz:		dc.l 0
Zahl:		dc.l 0
Zahlyyy:		dc.l 0
Stringlaenge:		dc.l 0
NextArg:		dc.l 0
returnbefehl:		dc.l 0
IsComment:		dc.l 0
OldStack:		dc.l 0
Taglistennr:		dc.l 0
Variablen:		dc.l 0
Extense:		dc.l 0
Char:		dc.l 0
lena:		dc.l 0
Array:		dc.l 0
zeiger:		dc.l 0
abstract:		dc.l 0
public:		dc.l 0
private:		dc.l 0
protected:		dc.l 0
Methode:		dc.l 0
StaticStatus:		dc.l 0
ext_p:		dc.l 0
ext_pp:		dc.l 0
Incarnations:		dc.l 0
CSMem_p:		dc.l 0
NK_Return:		dc.l 0
MethodeID:		dc.l 0
name:		dc.l 0
static:		dc.l 0
Counter:		dc.l 0
invalid:		dc.l 0
anz:		dc.l 0
pos:		dc.l 0
len:		dc.l 0
begin:		dc.l 0
i:		dc.l 0
I_bis:		dc.l 0
I_step:		dc.l 0
Register:		dc.l 0
oldpos:		dc.l 0
next:		dc.l 0
I1:		dc.l 0
I1_bis:		dc.l 0
I1_step:		dc.l 0
mypos:		dc.l 0
Id:		dc.l 0
returnwert:		dc.l 0
Stackmem:		dc.l 0
VarRoot:		dc.l 0
MethodeRoot:		dc.l 0
LineRoot:		dc.l 0
ObjectRoot:		dc.l 0
ConstructorRoot:		dc.l 0
StringRoot:		dc.l 0
SecondVarRoot:		dc.l 0
Args:		dc.l 0
res:		dc.l 0
type:		dc.l 0
CID:		dc.l 0
OldLineRoot:		dc.l 0
DID:		dc.l 0
sizeofObject:		dc.l 0
mh:		dc.l 0
AslBase:		dc.l 0
DOSBase:		dc.l 0
NONE:		dc.l 0
Intuitionbase:		dc.l 0
even
DirName:	blk.b 256,0
even
Name_spz:	blk.b 256,0
even
Name_bak:	blk.b 256,0
even
ASLTitletext:	dc.b `Wähle Filenamen                               `,0
even
ASLFR_Taglist:
	dc.l ASLFR_screen,0
	dc.l ASLFR_PrivateIDCMP,Dostrue
	dc.l ASLFR_TextAttr,Dosfalse
	dc.l ASLFR_InitialLeftEdge,20
	dc.l ASLFR_InitialTopEdge,24
	dc.l ASLFR_TitleText,ASLTitletext
	dc.l ASLFR_InitialWidth,300
	dc.l ASLFR_Initialheight,210
	dc.l ASLFR_InitialDrawer,Dirname
	dc.l ASLFR_InitialFile,Name_spz
	dc.l Tag_end,0
Filename:	blk.b 256,0
even
Version:	dc.b `$VER: Preass++ 0.4 1 Dezember (C) CYBORG 2001`,0
even
Leerzeile:	dc.b ` `,0
even
RDArgs:	blk.b 32,0
even
Buffer:	blk.b 1025,0
even
Classname:	blk.b 100,0
even
Classname_2:	blk.b 100,0
even
Extensename:	blk.b 100,0
even
Store:	blk.b 1000,0
even
StoreArgs:	blk.b 1000,0
even
ClassStoreMem:	blk.b 1000,0
even
RDArgs_Array:	dc.L 0,0,0,0,0,0,0,0,0,0,0,0
even
Registers:	dc.l name000,name001,name002,name003,name004,name005,name006,name007,name008,name009,name010,name011,name012,name013,name014,0,0
even
x_00name015:
	dc.b $00,``,0
even
_name016:
	dc.b `(`,0
even
___name017:
	dc.b `    dc.l %s_%ld`,$a,``,0
even
pf017:
	dc.l Buffer, 0,0
_x_22name018:
	dc.b `,`,$22,`%s`,$22,``,0
even
pf018:
	dc.l Buffer,0
_x_22name019:
	dc.b `,`,$22,``,0
even
_name020:
	dc.b ` `,0
even
name021:	dc.b `%s`,0
even
pf021:
	dc.l Buffer,0
_name022:
	dc.b `,`,0
even
x_22name023:
	dc.b $22,``,0
even
abstract_name024:
	dc.b `abstract `,0
even
static_name025:
	dc.b `static `,0
even
public_name026:
	dc.b `public `,0
even
protected_name027:
	dc.b `protected `,0
even
private_name028:
	dc.b `private `,0
even
name029:	dc.b `%s`,$a,``,0
even
pf029:
	dc.l  0,0
_name030:
	dc.b `,`,0
even
x_09name031:
	dc.b $09,``,0
even
long_name032:
	dc.b `long `,0
even
long_p_name033:
	dc.b `long_p `,0
even
xnname034:	dc.b $a,``,0
even
_Object_name035:
	dc.b `,Object `,0
even
_name036:
	dc.b ` `,0
even
x_09Object_name037:
	dc.b $09,`Object `,0
even
_name038:
	dc.b ` `,0
even
xnname039:	dc.b $a,``,0
even
static_name040:
	dc.b `static `,0
even
abstract_name041:
	dc.b `abstract `,0
even
public_name042:
	dc.b `public `,0
even
protected_name043:
	dc.b `protected `,0
even
private_name044:
	dc.b `private `,0
even
x_09___Object_Thisname045:
	dc.b $09,` { Object This`,0
even
_name046:
	dc.b ` }`,$a,``,0
even
x_09name047:
	dc.b $09,`%s=>this.%s.%s`,0
even
spfSIV:
	dc.l  0,Classname, 0,0
x_09ReleaseSemaphore_name048:
	dc.b $09,`ReleaseSemaphore(&syncronizationstruct)`,$a,``,0
even
x_09name049:
	dc.b $09,`%s=>this.%s.%s`,$a,``,0
even
pf049:
	dc.l  0,Classname, 0,0
_name050:
	dc.b `,%s`,0
even
pf050:
	dc.l  0,0
x_09name051:
	dc.b $09,`%s=.l%s.%s(this)`,$a,``,0
even
pf051:
	dc.l  0,Classname, 0,0
x_09ObtainSemaphore_name052:
	dc.b $09,`ObtainSemaphore(&syncronizationstruct)`,$a,``,0
even
xnname053:	dc.b $a,``,0
even
x_00name054:
	dc.b $00,``,0
even
x_22name055:
	dc.b $22,``,0
even
x_09___String__Preassxxname056:
	dc.b $09,`{* String: Preassxx%ld=`,$22,`%s`,$22,`*}`,$a,``,0
even
pf056:
	dc.l  0,store,0
Preassxxname057:	dc.b `Preassxx%ld,`,0
even
spfgoa2:
	dc.l  0,0
_name058:
	dc.b `,`,0
even
x_29name059:
	dc.b $29,``,0
even
_name060:
	dc.b `,`,0
even
_name061:
	dc.b `*`,0
even
_name062:
	dc.b `,`,0
even
name063:	dc.b `.`,0
even
x_09varname064:
	dc.b $09,`var%ld==%s`,0
even
spfPPDM1:
	dc.l TaglistenNr,Store,0
varname065:	dc.b `var%ld`,0
even
spfPPDM2:
	dc.l TaglistenNr,0
name066:	dc.b `.`,0
even
_name067:
	dc.b `(`,0
even
x_09varname068:
	dc.b $09,`var%ld==%s`,0
even
spfPPDM3:
	dc.l TaglistenNr,Store,0
varname069:	dc.b `var%ld`,0
even
spfPPDM4:
	dc.l TaglistenNr,0
Objectpuffer:	blk.b 1000,0
even
Objectmethode:	blk.b 200,0
even
Objectargs:	blk.b 200,0
even
ObjectPre:	blk.b 200,0
even
return_K_Aname070:
	dc.b `return/K/A`,0
even
x_09___UnFrameReturn_name071:
	dc.b $09,`{* UnFrameReturn %s *}`,0
even
spft2:
	dc.l  0,0
_name072:
	dc.b `=%s.`,0
even
spfot1:
	dc.l name,0
_name073:
	dc.b ` %s.`,0
even
x_09name074:
	dc.b $09,`%s.`,0
even
name075:	dc.b `.`,0
even
_name076:
	dc.b `(`,0
even
x_09movename077:
	dc.b $09,`move.l %s,d0`,0
even
spfmethods1:
	dc.l name,0
name078:	dc.b `.`,0
even
x_09Domethode_d0_x_22name079:
	dc.b $09,`Domethode(d0,`,$22,`%s`,$22,`,0)`,0
even
spfmethods2:
	dc.l ObjectMethode,0
x_09Domethode_d0_x_22name080:
	dc.b $09,`Domethode(d0,`,$22,`%s`,$22,`,>obtl%ld:%s,0)`,0
even
spfmethods3:
	dc.l ObjectMethode,TaglistenNr,Objectargs
name081:	dc.b `.`,0
even
_name082:
	dc.b `(`,0
even
x_09name083:
	dc.b $09,`%sDomethode(d0,`,$22,`%s`,$22,`,0)`,0
even
spfmethods4:
	dc.l ObjectPre,ObjectMethode
x_09name084:
	dc.b $09,`%sDomethode(d0,`,$22,`%s`,$22,`,>obtl%ld:%s,0)`,0
even
spfmethods5:
	dc.l ObjectPre,ObjectMethode,TaglistenNr,Objectargs
x_09name085:
	dc.b $09,`%s=new(`,$22,`%s`,$22,`,0)`,0
even
spfac1:
	dc.l  0, 0,0
x_09if_name086:
	dc.b $09,`if `,0
even
name087:	dc.b `%s&`,0
even
spfpc1:
	dc.l  0,0
_0xnx_09_name088:
	dc.b `=0`,$a,$09,`{`,0
even
x_09__del_name089:
	dc.b $09,`  del(%s)   `,0
even
spfpc3:
	dc.l  0,0
x_09x_7b__UnFrameReturn__1_x_7dxnname090:
	dc.b $09,$7b,`* UnFrameReturn -1*`,$7d,$a,``,0
even
spfpc4:
	dc.l  0,0
x_09name091:
	dc.b $09,`}`,$a,``,0
even
x_09__name092:
	dc.b $09,`  %s=del(%s)    `,0
even
spfad1:
	dc.l  0, 0,0
x_7bname093:
	dc.b $7b,``,0
even
variablen_M_long_S_public_S_static_Sname094:
	dc.b `variablen/M,long/S,public/S,static/S`,0
even
x_09x_7b__incvar__name095:
	dc.b $09,$7b,`* incvar: `,0
even
name096:	dc.b `%s,`,0
even
pf096:
	dc.l zeiger,0
xcyxxdzzyzx__x_7dxnname097:
	dc.b `xcyxxdzzyzx *`,$7d,$a,``,0
even
string_K_static_S_variablen_Fname098:
	dc.b `string/K,static/S,variablen/F`,0
even
x_09x_7b__String__name099:
	dc.b $09,$7b,`* String: %s=`,$22,`%s`,$22,`*`,$7d,$a,``,0
even
pf099:
	dc.l  0,variablen,0
system_stringname100:
	dc.b `system/string`,0
even
system_stringname101:
	dc.b `system/string`,0
even
x_09___String__Preassxxname102:
	dc.b $09,`{* String: Preassxx%ld=`,$22,`%s`,$22,`*}`,$a,``,0
even
pf102:
	dc.l  0,Variablen,0
x_09Domethode_name103:
	dc.b $09,`Domethode(%s,`,$22,`addString`,$22,`,>obtl%ld:Preassxx%ld,0)`,0
even
spfmethodsf1:
	dc.l  0,TaglistenNr, 0,0
Constructor__name104:
	dc.b `Constructor()`,0
even
class_K_variablen_M_Object_Sname105:
	dc.b `class/K,variablen/M,Object/S`,0
even
name106:	dc.b `%s`,0
even
spfacmain:
	dc.l  0,0
new_K_variablen_Mname107:
	dc.b `new/K,variablen/M`,0
even
_name108:
	dc.b `(`,0
even
x_09name109:
	dc.b $09,`%s=new(`,$22,`%s`,$22,`,>obtl%ld:%s,0)`,0
even
spfmain1a:
	dc.l zeiger, 0,TaglistenNr,Objectargs
x_09name110:
	dc.b $09,`%s=new(`,$22,`%s`,$22,`,0)`,0
even
spfacmain1:
	dc.l zeiger, 0,0
syncronized_S_static_S_abstract_S_public_S_private_S_protected_S_name_Fname111:
	dc.b `syncronized/S,static/S,abstract/S,public/S,private/S,protected/S,name/F`,0
even
x_7bname112:
	dc.b $7b,``,0
even
x_7dname113:
	dc.b $7d,``,0
even
x_09x_7b__Flush__x_7dname114:
	dc.b $09,$7b,`* Flush *`,$7d,``,0
even
include_K_Aname115:
	dc.b `include/K/A`,0
even
name116:	dc.b `%s`,$a,``,0
even
pf116:
	dc.l ext_p,0
include_p_K_Aname117:
	dc.b `include_p/K/A`,0
even
___include_name118:
	dc.b `{* include %s *}`,$a,``,0
even
pf118:
	dc.l ext_p,0
usefd_K_Aname119:
	dc.b `usefd/K/A`,0
even
_____usefd_name120:
	dc.b `  {* usefd:%s *}`,$a,``,0
even
pf120:
	dc.l ext_p,0
abstract_S_Class_K_A_extends_Kname121:
	dc.b `abstract/S,Class/K/A,extends/K`,0
even
Abstracted_Classes_can_notname122:
	dc.b `Abstracted Classes can not be compiled, they have to be extended!`,$a,``,0
even
Class_name123:
	dc.b `Class %s `,0
even
csm0:
	dc.l classname,0
__name124:
	dc.b `--> %s `,0
even
csm1:
	dc.l ext_p,0
name125:	dc.b `.class`,0
even
name126:	dc.b `.class`,0
even
classes_name127:
	dc.b `classes/`,0
even
odk_classes_name128:
	dc.b `odk:classes/`,0
even
_name129:
	dc.b `(`,0
even
name130:	dc.b `%s_%ld[`,0
even
pf130:
	dc.l store,Counter,0
name131:	dc.b `%s,`,0
even
pf131:
	dc.l register,0
name132:	dc.b `%s]:`,$a,``,0
even
pf132:
	dc.l register,0
x_09x_7b__Stackframe_this__0name133:
	dc.b $09,$7b,`* Stackframe this=#0`,0
even
x_09x_7b__Stackframe_this_d0name134:
	dc.b $09,$7b,`* Stackframe this=d0`,0
even
_name135:
	dc.b `,`,0
even
_name136:
	dc.b `)`,0
even
_name137:
	dc.b ` `,0
even
_name138:
	dc.b `,%s=%s`,0
even
pf138:
	dc.l buffer,register,0
_name139:
	dc.b `,%s`,0
even
pf139:
	dc.l name,0
_x_7dxnname140:
	dc.b `*`,$7d,$a,``,0
even
return_K_Aname141:
	dc.b `return/K/A`,0
even
x_7b__UnFrameReturnname142:
	dc.b $7b,`* UnFrameReturn`,0
even
name143:	dc.b `%s`,$a,``,0
even
pf143:
	dc.l name,0
x_09x_7b__UnFrameReturn__x_7dxnxnname144:
	dc.b $09,$7b,`* UnFrameReturn *`,$7d,$a,$a,``,0
even
FuncArrayname145:	dc.b `FuncArray`,0
even
SizeofObjectname146:	dc.b `SizeofObject`,0
even
SIGname147:	dc.b `SIG`,0
even
LibraryBasename148:	dc.b `LibraryBase`,0
even
thisname149:	dc.b `this`,0
even
thisname150:	dc.b `this`,0
even
filename_Aname151:
	dc.b `filename/A`,0
even
Preassname152:	dc.b `Preass++ : no filename given`,$a,``,0
even
Class_errorxnname153:
	dc.b `Class error`,$a,``,0
even
Class_processing_returned_anname154:
	dc.b `Class processing returned an error`,$a,``,0
even
oh_oh__name155:
	dc.b `oh oh, %ld Methode(s) left abstract. I can not compile this!`,$a,``,0
even
pf155:
	dc.l res,0
x_09x_7b__Include_odk_misc_Konstanten_newname156:
	dc.b $09,$7b,`* Include odk:misc/Konstanten_new.inc *`,$7d,$a,``,0
even
x_09x_7b__Delayaus__x_7dxnname157:
	dc.b $09,$7b,`* Delayaus *`,$7d,$a,``,0
even
x_09x_7b__KillFD_name158:
	dc.b $09,$7b,`* KillFD `,0
even
_name159:
	dc.b `(`,0
even
name160:	dc.b `%s`,0
even
pf160:
	dc.l Buffer,0
_name161:
	dc.b `,`,0
even
_x_7dxnxnx_09moveqname162:
	dc.b `*`,$7d,$a,$a,$09,`moveq.l #0,d0`,$a,$09,`rts`,$a,$a,$09,`{* Error: RTS`,$a,` *}`,$a,$a,``,0
even
x_7b__structure_name163:
	dc.b $7b,`* structure %s,FuncArray(APTR),SizeofObject(LONG),SIG(LONG),LibraryBase(LONG)`,0
even
pf163:
	dc.l Classname,0
_name164:
	dc.b `,%s(LONG)`,0
even
pf164:
	dc.l name,0
_name165:
	dc.b `,%s(APTR)`,0
even
pf165:
	dc.l name,0
_name166:
	dc.b `,%s(LONG)`,0
even
pf166:
	dc.l name,0
_name167:
	dc.b `,%s(APTR)`,0
even
pf167:
	dc.l name,0
_x_7dxnxnname168:
	dc.b `*`,$7d,$a,$a,``,0
even
Constructor__name169:
	dc.b `Constructor()`,0
even
Constructor__name170:
	dc.b `Constructor()`,0
even
DeConstructor__name171:
	dc.b `DeConstructor()`,0
even
DeConstructor__name172:
	dc.b `DeConstructor()`,0
even
name173:	dc.b `%s`,0
even
pf173:
	dc.l include1,0
classname___dcname174:
	dc.b `classname:  dc.b `,$22,`%s`,$22,`,0`,$a,`cnop 0,2`,$a,``,0
even
spficl1a:
	dc.l classname_2,0
Libname____name175:
	dc.b `Libname:    dc.b `,$22,`%s.library`,$22,`,0`,$a,`cnop 0,2`,$a,``,0
even
spficl1:
	dc.l classname,0
idstring____dcname176:
	dc.b `idstring:   dc.b `,$22,`oop runtime %s.library`,$22,`,13,10,0`,$a,`cnop 0,2`,$a,``,0
even
spficl2:
	dc.l classname,0
name177:	dc.b `%s`,0
even
pf177:
	dc.l include2,0
___name178:
	dc.b `    dc.l -1`,$a,$a,`Pubfuncarray:`,$a,``,0
even
___name179:
	dc.b `    dc.l 0`,$a,$a,`    {* Array[String]: StringfuncArray`,0
even
_name180:
	dc.b `*}`,$a,`     `,0
even
xn___name181:
	dc.b $a,`    {* Array[String]: Signaturen`,0
even
_name182:
	dc.b `*}`,$a,`     `,0
even
name183:	dc.b `%s`,0
even
pf183:
	dc.l include3,0
___name184:
	dc.b `    move.l #%ld,ml_sizeofobject(a5)`,$a,``,0
even
pf184:
	dc.l sizeofobject,0
___name185:
	dc.b `    move.l #PubFuncarray,ml_funcs(a5)`,$a,``,0
even
___name186:
	dc.b `    move.l #StringFuncarray,ml_funcsStr(a5)`,$a,``,0
even
name187:	dc.b `%s`,0
even
pf187:
	dc.l include4,0
odk_docs_classes_name188:
	dc.b `odk:docs/classes/%s.desc`,0
even
spfpm1:
	dc.l Classname,0
xnxnname189:	dc.b $a,$a,``,0
even
xnname190:	dc.b $a,``,0
even
Nullt: dc.b 0
Aslname: dc.b "asl.library",0
DOSname: dc.b "dos.library",0
Intuitionname: dc.b "intuition.library",0
even
name000: dc.b "keins",0
name001: dc.b "d0",0
name002: dc.b "d1",0
name003: dc.b "d2",0
name004: dc.b "d3",0
name005: dc.b "d4",0
name006: dc.b "d5",0
name007: dc.b "d6",0
name008: dc.b "d7",0
name009: dc.b "a0",0
name010: dc.b "a1",0
name011: dc.b "a2",0
name012: dc.b "a3",0
name013: dc.b "a4",0
name014: dc.b "a5",0
	Include "Preass:LVO3.0/Exec_lib.i"
	Include "Preass:LVO3.0/Asl_lib.i"
	Include "Preass:LVO3.0/DOS_lib.i"
	Include "Preass:LVO3.0/Intuition_lib.i"

