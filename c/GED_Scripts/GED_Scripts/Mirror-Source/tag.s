
            ;   TAG.ASM
            ;
            ;   Library tag.  This replaces the normal startup code, c.o,
            ;   but still must perform certain startup functions such as
            ;   the clearing of BSS and small-data model setup & auto
            ;   calls.  HOWEVER, we do not include any resident startup
            ;   code meaning you CANNOT compile the shared library -r
            ;   (which doesn't make sense to do anyway).
            ;
            ;   Further, no C startup or exit functions are included
            ;   since this is a library, not a normal program.  Refer
            ;   to the source code LIB/AMIGA/C.A for a fully operational
            ;   startup module.

;Prototype ALibExpunge(), ALibClose(), ALibOpen(), ALibReserved();

            section text,code

            xref    _LibInit
            xref    _LibOpen
            xref    _LibClose
            xref    _LibExpunge

            xref    __BSSLEN           ; (dlink), length of BSS
            xref    _LinkerDB          ; (dlink), base of initialized data
            xref    __DATALEN          ; (dlink), length of data

            xdef    _LibId
            xdef    _LibName

            xdef    _ALibOpen
            xdef    _ALibClose
            xdef    _ALibExpunge
            xdef    _ALibReserved

            clr.l   D0
            rts

InitDesc:   dc.w    $4AFC       ;RTC_MATCHWORD
            dc.l    InitDesc    ;Pointer to beginning
            dc.l    EndCode     ;Note sure it matters
            dc.b    0           ;flags (NO RTF_AUTOINIT)
            dc.b    37          ;version
            dc.b    9           ;NT_LIBRARY
            dc.b    0           ;priority (doesn't matter)
            dc.l    _LibName    ;Name of library
            dc.l    _LibId      ;ID string (note CR-LF at end)
            dc.l    Init        ;Pointer to init routine

            ;   Based on 'mirror.api 38.0 (5.2.1999)',13,10,0
            ds.w    0
_LibName:   dc.b    'NewMirror.api',0
_LibId:     dc.b    'NewMirror.api 1.0 (09.07.1999)',13,10,0
            ds.w    0
EndCode:

Init:       move.l  A0,-(sp)        ; save arg to Init

            movem.l D2-D7/A2-A6,-(sp)   ; blanket save
            move.l  4,A6                ; EXEC base

            ;   Not resident, BSS space has been allocated for us
            ;   beyond the specified data, just load the base ptr

snotres     lea     _LinkerDB+32766,A4
            sub.l   A3,A3

clrbss
            ;   CLEAR BSS   &-32766(A4) + __DATALEN*4

            lea     -32766(A4),A0
            move.l  #__DATALEN,D0
            asl.l   #2,D0
            add.l   D0,A0

            move.l  #__BSSLEN,D0       ; longwords of bss
            moveq.l #0,D1
            bra     clrent
clrlop      move.l  D1,(A0)+
clrent      dbf     D0,clrlop
            sub.l   #$10000,D0
            bcc     clrlop

            movem.l (sp)+,D2-D7/A2-A6   ; blanket restore
            move.l  (sp)+,D0            ; retrieve arg to Init to D0
            jmp     _LibInit(pc)

            ;   Assembly tags for other functions, assume a registered
            ;   C entry point

_ALibOpen
            move.l  A6,A0
            jmp     _LibOpen(pc)

_ALibClose
            move.l  A6,A0
            jmp     _LibClose(pc)

_ALibExpunge
            move.l  A6,A0
            jsr     _LibExpunge(pc)
            rts

_ALibReserved
            moveq.l #0,D0
            rts

            END
