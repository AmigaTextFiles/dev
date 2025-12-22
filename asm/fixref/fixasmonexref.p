; Konvertiert XREF Anweisungen in Linkobjects von ASMOne 
; 
; (c) 1999 Cyborg 

    {* Include sys:coder/preass/Options.p *}
    {* Include sys:coder/preass/Prozeduren.p *}

    {* String: Version="$VER: Fix Asmone LinkObjects (C) CYBORG 99"*}

Doit[a0,d7]:
    subq.l #1,d7
.l0:cmpi.l #$000003ef,(a0)
    beq.s .found
.l1:lea 1(a0),a0
    dbra d7,.l0
    RTS
.l2:lea -6(a0),a0
    bra.s .l1
.found:
    lea 4(a0),a0
.Loop:
    cmpi.w #$8100,(a0)+
    bne.s .l2
    move.w (a0)+,d6
    andi.l #$FFFF,d6
    add.l d6,d6
    add.l d6,d6
    sub.l #8,d7

    move.l a0,a1
.l4:move.b (a1),d0
    cmpi.b #"_",d0
    beq.s .l3
    cmpi.b #$00,d0
    beq.s .Loop1
    bset #5,d0
.l3:move.b d0,(a1)+
    bra.s .l4
.Loop1:
    add.l d6,a0
    sub.l d6,d7
    lea 8(a0),a0
    sub.l #8,d7
    cmpi.l #$0,(a0)
    bne .Loop
    bra .l1   


Start:
    OH=Output()
    If Getfilename()##0 {
        If (In=Open(&Filename,Mode_Old))##0 {
            Write(Oh,"Suche Filenende...",?)
            Seek(In,0,Offset_end)
            anz=Seek(In,0,Offset_begin)
            Write(Oh,"allokiere Speicher...",?)
            If (memblock=Allocmem(anz,#MEMF_Fast))##0 {
                Write(Oh,"geschafft!\nLese ",?)
                Convertzahl(Anz,OH)
                Write(Oh," Bytes ein ...",?)
                Read(In,Memblock,anz)
                Close(IN)
                IN==0
                Write(Oh," fertig!\nKonvertiere Daten...",?)
                doit(Memblock,anz)
                Write(Oh," fertig!\n Speicher Daten...",?)
                If (Out=Open(&Filename,Mode_new))##0 {
                        Write(Out,Memblock,anz)
                        Close(Out)
                        Write(Oh,"Geschafft!",?)
                                                     }
                Write(Oh,"\nBeende Programm.\n",?)
                Freemem(Memblock,anz)
                                                     }
            If IN##0 { 
                       Close(IN)
                     }
            
                                            }
                       }
    {* Return *}
