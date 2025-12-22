
    Mode_NoCase= 100
    Mode_Case=   0

    {* NewProc=CompareString[Source,with,offset,Mode][a0,a1,d0,d1]*}
    {* NewProc=ConvertZahl[Zahl,Handle][D7,D6]*}
    {* NewProc=ConvertZahl1[Zahl,Handle][D7,D6]*}
    {* NewProc=CountString[String][A0]*}
    {* NewProc=CD[Dirname][A0]*}
    {* NewProc=CountEOL[String][A0]*}
    {* NewProc=FillBuffer[Buffer,Inhalt,Laenge][A0,D0,D1]*}
    {* NewProc=GetFilename[][]*}
    {* NewProc=FileReq[Screen][A0]*}

FileReq:
    {* IncBlock: DirName,256*}
    {* IncBlock: Name,256*}
    {* IncBlock: Name_bak,256*}
    {* IncVar: LokalScreen*}
    {* STRING: ASLTitletext="Wähle Filenamen                               "*}
     Move.l A0,LokalScreen
     Requester=AllocAslRequest(#ASL_FileRequest,0)
     CheckF Requester,.Select2
     move.l #ASLFR_Taglist,a0
     move.l LokalScreen,4(a0)
     Result=ASLRequest(Requester,>ASLFR_Taglist:ASLFR_screen,0|
                                  ASLFR_PrivateIDCMP,Dostrue|ASLFR_TextAttr,Dosfalse|
                                  ASLFR_InitialLeftEdge,20|ASLFR_InitialTopEdge,24|
                                  ASLFR_TitleText,ASLTitletext|
                                  ASLFR_InitialWidth,300|ASLFR_Initialheight,210|
                                  ASLFR_InitialDrawer,Dirname|ASLFR_InitialFile,Name|
                                  Tag_end,0)
        CheckF Result,.Select2
        Filename_Zeiger=.l4(Requester)
        Dirname_zeiger=.l8(Requester)
        Copymem(Dirname_zeiger,#Dirname,100)
        Copymem(Filename_zeiger,#Name,100)
        Lea Name_Bak,a0
        move.l Dirname_zeiger,a1
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
        CheckF Requester,.lab1
        FreeASLRequest(Requester)
.lab1:  RTS

FillBuffer:
    subq.l #1,d1
.l1:move.b d0,(a0)+
    dbra  d1,.l1
    RTS

ConvertZahl:
    {* IncVar: Zusatz,Zahl,Zahlyyy*}
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
    Checkf D6,.ende   
    Write(D6,#Zusatz,8)
.ende:RTS

CompareString:
    movem.l d0-d7/a0-a6,-(sp)
    movem.l d0-d1/a0-a1,-(sp)
    Stringlaenge=CountString(a0)
    movem.l (sp)+,d0-d1/a0-a1
    movem.l d0-d1/a0-a1,-(sp)
    If CountString(a1)=Stringlaenge --> .l0
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
        Lock(a0,#Access_read)
        Checkf d0,.ende
            Currentdir(d0)
            Unlock(d0)
            moveq.l #-1,d0
.ende:  RTS

GetFilename:
    {* IncBlock: Filename,256*}
    {* IncVar: NextArg*}
        cmpi.l #0,laenge
        beq .l13
        cmpi.l #1,laenge
        beq .l13
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
        Copymem(a1,#Filename,a2)
        Move.l a2,d0
        rts
.l10:   lea 1(a0),a1
        bra .l2
.l11:   lea 1(a0),a1
        bra .l3
.l12:   move.l a0,a2
        bra .l3
.l13:   moveq.l #0,d0
        RTS
