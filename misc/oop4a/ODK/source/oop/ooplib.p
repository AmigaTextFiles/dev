
;   oop library Library
;   
;   Version:  1
;   Revision: 3
;
;   Autor: Marius Schwarz
;

	{* Delayaus *}

    {* KillFD new,del,domethode,checkstr*}

    moveq.l #0,d0
    RTS

    {* Error: RTS
 *}


; stringarray: dc.l string1,string2,0

; SignatureArray: dc.l "","long,Object","",0

checkstr:
    movem.l a0-a6,-(a7) ; A5= pointer to args as array of objects¹
    move.l a4,a0
    move.l a4,a6
    move.l a3,a1
    move.l #-1,d2

.l1:cmpi.l #0,(a2)
    beq.w .notfound
    addq.l #1,d2
    move.l a1,a3
    move.l (a2)+,a4
.l2:
    move.b (a4)+,d0
    move.b (a3)+,d1
    cmpi.b d0,d1
    bne.s .l1
    cmpi.b #0,d0
    bne.s .l2
.treffer:
    tst.l a5
    beq .treffer1
    move.l a5,a3        ; copy the argument_p 
    move.l a0,d1        ; pointer to signaturestring
.treffer0:
    move.l d1,a6
    addq.l #4,d1
    move.l (a6),a6
    cmpi.b #0,(a6)      ; no more args ! Skip
    beq.w .treffer1
    cmpi.l #"long",(a6)
    bne.s .argcheck
    cmpi.b #",",4(a6)
    beq.s .nextarg
    cmpi.b #0,4(a6)
    beq.s .nextarg
.argcheck:
    move.l (a3),a4      ; get Object
    beq.w .l1
    move.l 12(a4),a4    ; get LibraryBase
    move.l 74(a4),a4    ; get Pointer to classname
.ac1:
    move.b (a4)+,d0
    cmpi.b #0,d0
    bne.s .ac2
    cmpi.b #",",(a6)
    beq.s .ac3
    cmpi.b #0,(a6)
    bne.s .ac2
    bra.s .treffer1
.ac3:
    lea 1(a6),a6
    bra.s .nextarg
.ac2:
    cmpi.b (a6)+,d0
    beq.s .ac1
    bra.w .l1
.nextarg:
    lea 4(a3),a3
    bra.w .treffer0
.treffer1:
;    cmpi.l #0,(a3)
;    bne.w .l1
    move.l d2,d0
    movem.l (a7)+,a0-a6
    rts
.notfound:
    moveq.l #-1,d0
    movem.l (a7)+,a0-a6
    rts

; Structure Object(),funcarray,sizeofobject,sig,classbase,... 

Domethode[d0,a0,a1]             ;Domethode(object,#Methode,&Argarray)[d0,a0,a1]:
    tst.l d0                    ;skip call if object is  zero
    beq .alert                  
    cmpi.l #-1,d0               ;skip call if object is false
    beq .alert                  
    movem.l d1-a6,-(a7)         ; save regs to stack
    move.l a1,a5
    move.l a0,a3                ; copy methodestring to a3
    move.l d0,a0                ; copy object to a0
    move.l 12(a0),a2            ; get LibraryBase
    move.l ml_signature(a2),a4  ; get signaturesarray
    move.l ml_funcstr(a2),a2    ; get functionarraypointer
    jsr checkstr
    cmpi.l #-1,d0
    beq .alert2

    move.l 0(a0),a2
    mulu.l #4,d0
    add.l  d0,a2
    move.l (a2),a2
    move.l a2,-(a7)

    move.l a0,d0
    move.l 12(a0),a6            ; get classbase for jump
    tst.l a5
    beq .jsr
    move.l 0(a5),d1
    move.l 4(a5),d2
    move.l 8(a5),d3
    move.l 12(a5),d4
    move.l 16(a5),d5
    move.l 20(a5),d6
    move.l 24(a5),d7
    move.l 28(a5),a0
    move.l 32(a5),a1
    move.l 36(a5),a2
    move.l 40(a5),a3
    move.l 44(a5),a4
.jsr:
    move.l (a7)+,a5
    jsr (a5)                    ; call methode
    movem.l (a7)+,d1-a6         ; restore stack and regs
    RTS                         ; d0 has returnvalue from methode.
.alert: 
;    Displayalert(#$06000000,"WARNING: Task uses EMPTY Objectpointer!\n Exit this programm",200)
    move.l a6,-(a7)
    move.l Execbase,a6
    move.l #AG_openlib!AO_oopLib!$06000000,d7 
    jsr Alert(a6)
    move.l (a7)+,a6
    moveq.l #-1,d0
    RTS                         ; d0 has returnvalue from methode.


.alert2:
    movem.l (a7)+,d1-a6         ; restore stack and regs for A6
    movem.l d1-a6,-(a7)         ; save regs to stack

    {* Flush *}
    move.l Execbase,a6          
    move.l #AG_openlib!AO_oopLib!$06100000,d7   ; UNKOWN METHODE ALERT!
    jsr Alert(a6)

    moveq.l #-1,d0
    movem.l (a7)+,d1-a6         ; restore stack and regs
    RTS                         ; d0 has returnvalue from methode.


Stringfind[a0,a1]:
    movem.l d1-a6,-(sp)
    movea.l a0,a2
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
    move.l a0,a4
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

Strlen[a0]:
        move.l a1,-(Sp)
        move.l a0,a1
.l1:    cmpi.b #$00,(a1)+
        bne .l1
        lea -1(a1),a1
        sub.l a0,a1
        move.l a1,d0
        move.l (sp)+,a1
        RTS

new:                            ; new("nameof.class",Args)(a0,a1)
    movem.l d1-a6,-(a7)
    {* StackFrame signatur=A1,classname=a0,mem=#0,mem2=#0,Base,funcmem,object,signatures,funcsize,objectsize,funcs,funcsoffset,zeiger,len,len2,res*}
 
    if Stringfind(Classname,".library")=0
     {
       len=Strlen(Classname)
       If (mem=AllocMem(len+9,#MEMF_FAST!MEMF_CLEAR))#0
        {
          Copymem(Classname,Mem,len)
          Copymem(".library",Mem+len,?)
          Classname==Mem
        }
     }
    {* Flush *}
    if Stringfind(Classname,"libs:classes")=0
     {
       len2=Strlen(Classname)
       If (mem2=AllocMem(len2+14,#MEMF_FAST!MEMF_CLEAR))#0
        {
          Copymem("libs:classes/",mem2,?)
          Copymem(Classname,Mem2+13,len2)
          Freemem(mem,len)
          len==len2
          mem==mem2
          Classname==Mem2
        }
     }
    {* Flush *}
    if (base=Openlibrary(Classname,#0))#0
     {
       objectsize=.lml_sizeofobject(base)
       funcs=.lml_funcs(base)
       signatures=.lml_signature(base)
       if (object=Allocmem(objectsize,#MEMF_FAST!MEMF_CLEAR))#0
        {
          zeiger==Object
          (funcs,objectsize,signatures,base)->zeiger
          res=DoMethode(Object,"Constructor",Signatur)      ; Constructor call
          if mem#0
           {
             Freemem(mem,len)
           }
          if Res=-1
           {
             {* Flush *}
             CloseLibrary(base)
             Freemem(Object,Objectsize)
             {* UnFrame *}
             move.l #0,d0
             movem.l (a7)+,d1-a6
             RTS
           }
          move.l Object,d0
          {* UnFrame *}
          movem.l (a7)+,d1-a6
          RTS
        }
     }
    if mem#0
     {
       {* Flush *}
       Freemem(mem,len)
     }
    move.l #0,d0
    {* UnFrame *}
    movem.l (a7)+,d1-a6
    RTS


del:                            ; del(Object)(d0)
    tst.l d0
    bne .del1
    rts
.del1:
    cmpi.l #-1,d0
    bne .del2
    rts
.del2:
    movem.l d0-a6,-(a7)         ; save regs to stack
    move.l d0,a5                ; copy objectpointer to a5
    DoMethode(d0,"DeConstructor",0)       ; Destructor call
    move.l $4.w,a6              ; get EXECBASE( SYSBASE )
    move.l 12(a5),a1            ; get classbase 
    jsr Closelibrary(a6)        ; close class 
    move.l #0,0(a5)             ; kill functionarray pointer to prevent missuse
    move.l 4(a5),d0             ; get size of Object
    move.l a5,a1                ; get Objectmemoryadress
    jsr freemem(a6)             ; free objectmemory
    movem.l (a7)+,d0-a6         ; restore stack and regs
    moveq.l #0,d0               ; clear Objectvariable if User uses:
    RTS                         ; Object=del(Object)



; ASM-One - exec_lib.i
; (Release 3.0)
;
; by SCHWARZENEGGER/R.A.F


InitStruct	=	-78
MakeLibrary	=	-84
MakeFunctions	=	-90
FindResident	=	-96
InitResident	=	-102
Alert	=	-108
Disable	=	-120
Enable	=	-126
Forbid	=	-132
Permit	=	-138
AllocMem	=	-198
FreeMem	=	-210
AddLibrary	=	-396
RemLibrary	=	-402
OldOpenLibrary	=	-408
CloseLibrary	=	-414
SetFunction	=	-420
SumLibrary	=	-426
OpenLibrary	=	-552
SumKickData	=	-612
CopyMem	=	-624
Remove	=	-252
DisplayAlert=	-90



AG_OpenLib=	 $00030000
AO_oopLib=	 $00008006
AO_DOSLib=	 $00008007
NT_LIBRARY=9
RTF_AUTOINIT=  %10000000

LIBf_SUMMING=0
LIBf_CHANGED=1
LIBf_SUMUSED=2
LIBf_DELEXP= 3
LIBf_EXP0CNT=4

LN_SUCC=0
LN_PRED=4
LN_TYPE=8
LN_PRI=9
LN_NAME=10
LN_SIZE=14
LIB_FLAGS=14
LIB_pad=15
LIB_NEGSIZE=16
LIB_POSSIZE=18
LIB_VERSION=20
LIB_REVISION=22
LIB_IDSTRING=24
LIB_SUM=28
LIB_OPENCNT=32
LIB_SIZE=36
ml_Syslib=36
ml_intuilib=40
ml_SegList=44
ml_Flags=48
ml_pad=49
ml_sizeofobject=50
ml_signature=54
ml_funcs=58
ml_funcsoff=62
ml_funcstr=66
ml_ooplib=70
MyLib_Sizeof=74

Version=  1
Revision= 3
Pri=      1

MEMF_ANY	    = 0
MEMF_PUBLIC     = $00000001
MEMF_CHIP       = $00000002
MEMF_FAST       = $00000004
MEMF_CLEAR	    = %10000000000000000

CNOP 0,4
Resident:
    dc.w $4aFC
    dc.l Resident
    dc.l CodeEnde
    dc.b RTF_Autoinit
    dc.b Version
    dc.b NT_Library
    dc.b Pri
    dc.l LibName
    dc.l IDString
    dc.l Init

Libname:    dc.b "oop.library",0
cnop 0,2
idstring:   dc.b "oop.library 1.00 30.Oktober 2001",13,10,0
cnop 0,2
execbase:   dc.l 0
;Intuitionbase:   dc.l 0
CodeEnde:
CNOP 0,4
Init:   dc.l Mylib_Sizeof
        dc.l Functable
        dc.l DataTable
        dc.l InitRoutine

CNOP 0,4
FuncTable:
    dc.l OpenL
    dc.l CloseL
    dc.l Expunge
    dc.l nichts
    dc.l new
    dc.l del
    dc.l domethode
    dc.l -1


CNOP 0,4
DataTable:
    dc.b $e0,0
    dc.w LN_type
    dc.b NT_LIBRARY,0
    dc.b $c0,0
    dc.w ln_name
    dc.l libname
    dc.b $e0,0
    dc.w lib_Flags
    dc.b LIBF_SUMUSED!LIBF_CHANGED,0
    dc.b $d0,0
    dc.w lib_version,Version
    dc.b $d0,0
    dc.w LIB_REVISION,REVISION
    dc.b $c0,0
    dc.w Lib_idstring
    dc.l Idstring
    dc.l 0

CNOP 0,4
InitRoutine:
    move.l a5,-(a7)
    move.l d0,a5
    move.l a6,ml_syslib(a5)
    move.l a6,Execbase
    move.l a0,ml_seglist(a5)

;    lea intuiname(pc),a1
;    move.l #0,d0
;    jsr Openlibrary(a6)
;    move.l d0,ml_intuilib(a5)
;    move.l d0,Intuitionbase
;    beq.s .alert
    bra.s .skipalert
.alert:
    move.l #AG_openlib!AO_DOSLib,d7 
    jsr Alert(a6)
.skipalert:

    move.l a5,d0
    move.l (a7)+,a5
    rts

CNOP 0,4
OpenL:
    addq.w #1,LIB_OPENCNT(a6)
    bclr #LIBF_DELEXP,lib_Flags(a6)
    move.l a6,d0
    rts

CNOP 0,4
CloseL:
    clr.l d0
    subq.w #1,LIB_openCNT(a6)
    bne .label1
    btst #LIBF_DELEXP,lib_Flags(a6)              
    beq .label1
    jsr Expunge
.label1:       
    rts        
               
CNOP 0,4
Expunge:
    movem.l d2/a5-a6,-(a7)
    move.l a6,a5
    move.l ml_syslib(a5),a6
    bset #LIBF_DELEXP,lib_Flags(a5)      ; (a6)???
    tst.w lib_opencnt(a5)
    beq .label1
    clr.l d0
    bra.s Expunge_end
.label1:
    move.l a5,a1
    jsr Remove(a6)
;    move.l ml_intuilib(a5),a1
;    jsr closelibrary(a6)
.label2:
    move.l ml_seglist(a5),d2
    clr.l d0
    move.l a5,a1
    move.w Lib_negsize(a5),d0
    sub.l d0,a1
    add.w lib_possize(a5),d0
    jsr Freemem(a6)
    move.l d2,d0
Expunge_end:
    movem.l (a7)+,d2/A5-a6
    rts

CNOP 0,4
nichts:
    moveq.l #0,d0
    rts

cnop 0,2
;intuiname:  dc.b "intuition.library",0

