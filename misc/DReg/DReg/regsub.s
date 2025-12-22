
*   Module:     regsub.s
*
*                xref    reg_cycle,one_only,set_bits
*                xref    gad_refrsh,dat_disp,displ_val
*                xref    activ_bits,hex_Cnv,conv_disp
*                xref    stuffChar,disp_flag
*                xref    processit,do_about


*****************************************************************************
*
*       Cycle through operator and operand registers
*       inputs:     a3  <-holds pointer to gadget structure
*                   d6  <-number of registers accessible in list


reg_cycle:  movea.l intuitionBase,a6        a6<-using intuition library
            lea.l   regselect,a0            a0<-list of text pointers
            moveq.w #0,d4
            movea.l gg_GadgetText(a3),a2
            movea.l it_IText(a2),a2
.cycle:     cmpa.l  (a0,d4),a2                  last used selection
            beq.s   .foundit
            addq.w  #4,d4                   point to next selector
            bra.s   .cycle
.foundit:   addq.w  #4,d4
            mulu.w  #4,d6
            cmp.w   d4,d6                   check for end of list
            bpl.s   .picksel
            moveq.w #0,d4
.picksel:   move.l  (a0,d4),d0              d0 - selected text
            move.l  gg_GadgetText(a3),a2
            move.l  d0,it_IText(a2)
            move.l  regoff(a0,d4),d0        offset depends on no of regs

            cmpi.w  #80,d7                  which register selector ?
            beq.s   .destreg
            move.l  d0,sourcinput           store the active register
            lea.l   srchexdn1,a1            a1<-points to LS digit
            bra.s   .display
.destreg:   move.l  d0,destinput
            lea.l   dsthexdn1,a1
.display:   move.l  d0,a2
            move.l  (a2),d6                 get register contents...
            moveq.l #1,d0                      refresh the one...
            bsr     gad_refrsh

            cmpi.w  #80,d7                  which register selector ?
            beq.s   .destbits
            lea.l   SrcRGdg00,a3
            bra.s   .activ
.destbits:  lea.l   DstRGdg00,a3
.activ:     moveq.l #32,d0                      ...refresh the gadgets
            bsr     activ_bits              set up bit-display
            bsr     gad_refrsh
            bsr     conv_disp               convert bits into hex
            bsr     displ_val               put up hex display
.rc_ex:     move.l  _SysBase,a6             a6 <- SysBase for Mesg
            rts


*****************************************************************************
*
*       Change the mutual exclusive toggles ( .b .w .l )
*       inputs:     a3 <- pointer to gadget structure
*                   d7  <-should still hold GadgetID


one_only:   movea.l intuitionBase,a6        a6<-using intuition library
            move.w  #SELECTED,d5
            lea.l   OpSizByte,a1
            lea.l   OpSizWord,a2
            move.w  d7,d0
            subi.w  #91,d0
            move.b  d0,op_size
            bmi.s   .isbyte
            bne.s   .sel_gad                    this is the .L = +1
.isword:    lea.l   OpSizLong,a2                this is the .W = 0
            bra.s   .sel_gad
.isbyte:    lea.l   OpSizLong,a1                this is the .B = -1
.sel_gad:   or.w    d5,gg_Flags(a3)             selected
            not.w   d5
            and.w   d5,gg_Flags(a1)             deselected
            and.w   d5,gg_Flags(a2)             deselected
.refrsh:    lea.l   OpSizByte,a3            start with first in list
            moveq.l #3,d0                       and refresh all three...
            bsr.s   gad_refrsh
            bsr     processit               just to get things displayed
.oo_ex:     move.l  _SysBase,a6             a6 <- SysBase for Mesg
            rts


*****************************************************************************
*
*       Select/deselect bits according to flags (condition codes)
*       input:      a0 <- points to the text-string
*                   d3 <- number of bits
*                   d6 <- register value


set_bits:   movem.l d4-d6,-(sp)
.onebit:    move.w  d3,d4
            asl.w   #1,d4                   d4<-index for textstrings
            btst.l  d3,d6
            beq.s   .zerobit
            move.b  #'1',(a0,d4)            set individual bit and...
            bra.s   .getnxt
.zerobit:   move.b  #'0',(a0,d4)
.getnxt:    dbra    d3,.onebit                    ...go 'till finished
.sb_ex:     movem.l (sp)+,d4-d6
            rts


*****************************************************************************
*
*       Refresh a specified number of gadgets
*       Inputs:     a3 <- pointer to gadget structure
*                   a4 <- window pointer
*                   d0 <- number of gads to refresh


gad_refrsh: movem.l a0-a2/d4,-(sp)
            moveq.l #0,d4
            movea.l a3,a0                   pointer to gadget struct
            movea.l a4,a1                   the window's pointer
            move.l  d4,a2                   no requester yet...
            jsr     _LVORefreshGList(a6)
.gr_ex:     movem.l (sp)+,a0-a2/d4
            rts


*****************************************************************************
*
*       Process the bitwise input and display hex
*       inputs:     a3 <- pointer to gadget structure
*                   d7 <- holds gadget ID


dat_disp:   movea.l intuitionBase,a6        a6<-using intuition library
            move.l  d7,d4                   d4<-gadget ID
            cmpi.w  #40,d7
            bgt.s   .destreg
            movea.l sourcinput,a2           a2<-holds register address
            lea.l   srchexdn1,a1            a1<-points to LS hex digit
            bra.s   .addbit
.destreg:   movea.l destinput,a2
            lea.l   dsthexdn1,a1
            subi.w  #40,d4
.addbit:    moveq.l #0,d5
            subi.w  #1,d4
            bset.l  d4,d5                   d5<-bit changed by user
            lsl.w   #1,d4                   d4<-index for textstrings
            move.l  (a2),d6                 get the register contents
            eor.l   d5,d6                       change the bit
            move.l  d6,(a2)                         then replace
            moveq.l #1,d0                       and refresh one gadget
            bsr.s   gad_refrsh
            bsr     conv_disp               convert bits into hex

            cmpa.l  sourcinput,a2
            bne.s   .noteq                  check if both displays equal
            cmpa.l  destinput,a2
            bne.s   .noteq

            cmpi.w  #39,d7                  we have changed one set...
            bgt.s   .isdest
            lea.l   dsthexdn1,a1
            lea.l   DstRGdg00,a3                ...now we do the other
            bra.s   .dobits
.isdest:    lea.l   srchexdn1,a1            a1<-points to LS hex digit
            lea.l   SrcRGdg00,a3
.dobits:    moveq.l #32,d0                  refresh these gadgets
            bsr.s   activ_bits              put up bit-gadgets (a3,d0,d6)
            bsr     gad_refrsh
            bsr     conv_disp               convert bits into hex
.noteq:     bsr.s   displ_val               put up hex display

.dd_ex:     move.l  _SysBase,a6             a6 <- SysBase for Mesg
            rts


*****************************************************************************
*
*       Display the hex values and their borders
*       inputs:     a4 <- window pointer


displ_val:  movem.l a0-a2/d4-d5,-(sp)
            tst.w   dispsel
            bne.s   .dec_val
            lea.l   BordrHexa,a1            use the hex nibbles border
            lea.l   ITxSNib0,a2
            bra.s   .val_ex
.dec_val:   lea.l   BordDBack,a1            use the hex background border
            lea.l   ITxtSDec,a2
.val_ex:    exg.l   a1,d4
            exg.l   a2,d5
            movea.l wd_RPort(a4),a0         get the window's rastport
            move.l  d4,a1                       and the borders
            move.l  #359,d0                 relative X pos in window
            moveq.l #14,d1                     "     Y pos
            jsr     _LVODrawBorder(a6)
            movea.l wd_RPort(a4),a0
            move.l  d4,a1                   and again for destination
            move.l  #359,d0
            moveq.l #26,d1
            jsr     _LVODrawBorder(a6)
            movea.l wd_RPort(a4),a0         this will do all hex text...
            move.l  d5,a1
            move.l  #359,d0                 source/dest decimal strings
            moveq.l #14,d1                           are connected
            jsr     _LVOPrintIText(a6)
.dv_ex:     movem.l (sp)+,a0-a2/d4-d5
            rts


*****************************************************************************
*
*       Activate bit-gadgets according to input register
*       inputs:     a3 <- pointer to gadget structure
*                   d0 <- number of bits +1
*                   d6 <- register value


activ_bits: movem.l a3/d1-d4,-(sp)
            move.w  d0,d3
            subq.w  #1,d3                   d3<-counter
            move.w  #SELECTED,d1
            move.w  d1,d2
            not.w   d2                      d2<-!SELECTED
.loop:      moveq.w #31,d4
            sub.w   d3,d4                   reverse counter
            btst.l  d4,d6
            beq.s   .desel
            or.w    d1,gg_Flags(a3)         Flags & SELECTED
            bra.s   .tonext
.desel:     and.w   d2,gg_Flags(a3)         Flags deselected
.tonext:    suba.w  #44,a3
            dbra    d3,.loop
.ab_ex:     movem.l (sp)+,a3/d1-d4
            rts


*****************************************************************************
*
*       Convert register values to hex and decimal to display them
*       inputs:     a1 <- points to the hex text-string
*                   a2 <- points to the input reg value
*                   d6 <- register value


hex_Cnv:    move.b  (a0,d4),d1
            lsl.w   d2,d1
            move.w  d1,(a1)+
            rts

conv_disp:  movem.l a0-a3/d4-d6,-(sp)
            lea.l   hex_array,a0
            moveq.l #8,d2                   d2<-constant 8 for shift
            moveq.w #3,d3                   d3<-this many bytes -1
            moveq.l #0,d4                   wipe it first
.getnib:    move.b  d6,d4
            andi.b  #$0f,d4
            bsr.s   hex_Cnv                 convert a nibble to hex
            move.b  d6,d4
            lsr.b   #4,d4                       and again...
            bsr.s   hex_Cnv
            lsr.l   d2,d6                   go to next byte up
            dbra    d3,.getnib


*       here a1 points to the decimal display string and a2 to input reg

            exg.l   a1,a3                   a3<-output string pointer
            move.l  (a2),d5
            lea.l   rawstuff,a1             a1<-pointer to input value
            lea.l   FormLSign,a0
            tst.b   op_size                 check display size
            bmi.s   .dibyt
            beq.s   .diwrd
            bra.s   .dilng
.dibyt:     ext.w   d5                      sign extend byte to word
.diwrd:     swap    d5                      a1 points to int now
            lea.l   FormISign,a0
.dilng:     move.l  d5,(a1)
            lea.l   stuffChar,a2            the routine to...
            move.l  _SysBase,a6
            jsr     _LVORawDoFmt(a6)
            adda.w  #15,a3                  point to end of fmt string
            movea.l a3,a1
            movea.l a3,a2
            adda.w  #16,a1                      and end of disp string
            moveq.b #',',d2                 thousands divider
            moveq.b #' ',d5                 space
            moveq.b #'-',d1                 minus sign
            moveq.w #3,d4                   four commas's...
.conlp:     moveq.w #2,d3                       ...one every three chars
.conki:     move.b  -(a3),d0
            move.b  d0,-(a1)
            move.b  -1(a3),d0
            dbra    d3,.conki
            cmp.b   d5,d0                   is it a space ?
            beq.s   .nodot
            cmp.b   d1,d0                   is it a minus sign ?
            bne.s   .doone
            move.b  d0,-(a1)
            bra.s   .nodot
.doone:     move.b  d2,-(a1)
            dbra    d4,.conlp
.nodot:     cmpa.l  a1,a2
            bpl.s   .doint
            move.b  d5,-(a1)                yes - we fill it with spaces
            bra.s   .nodot
.doint:     movea.l intuitionBase,a6
.cd_ex:     movem.l (sp)+,a0-a3/d4-d6
            rts

stuffChar:  move.b  d0,(a3)+                ...put data to output string
            rts


*****************************************************************************
*
*       Display the flags' values and borders
*       inputs:     a4 <- window pointer


disp_flag:  movea.l wd_RPort(a4),a0
            lea.l   BordrFlga,a1            use the flags borders
            move.l  #392,d0
            moveq.l #38,d1
            jsr     _LVODrawBorder(a6)
            movea.l wd_RPort(a4),a0         this will do all flag text...
            lea.l   ITxtFlgx,a1
            move.l  #359,d0
            moveq.l #14,d1
            jsr     _LVOPrintIText(a6)
.flag_ex:   rts


*****************************************************************************
*
*       Process the input with the selected action
*       input:      d7 <- holds GadgetID


processit:  movem.l a6,-(sp)
            movea.l sourcinput,a1           pick up source and
            movea.l destinput,a2                    dest reg address
            move.l  (a1),d5                         and their values
            move.l  d5,oldsrcreg            d5<-source register
            move.l  (a2),d6                 d6<-destination reg
            moveq.l #0,d2                   d2<-a constant zero
            move.l  d2,d3
            cmpi.w  #200,d7                 check which op-code
            beq     .opclr
            cmpi.w  #201,d7                 neg
            beq     .opneg
            cmpi.w  #202,d7                 not
            beq     .opnot
            cmpi.w  #203,d7                 and
            beq     .opand
            cmpi.w  #204,d7                 or
            beq     .opor
            cmpi.w  #205,d7                 eor
            beq     .opeor
            cmpi.w  #206,d7                 lsl
            beq     .oplsl
            cmpi.w  #207,d7                 rol
            beq     .oprol
            cmpi.w  #208,d7                 roxl
            beq     .oproxl
            cmpi.w  #209,d7                 lsr
            beq     .oplsr
            cmpi.w  #210,d7                 ror
            beq     .opror
            cmpi.w  #211,d7                 roxr
            beq     .oproxr
            cmpi.w  #212,d7                 asl
            beq     .opasl
            cmpi.w  #213,d7                 mulu
            beq     .opmulu
            cmpi.w  #214,d7                 muls
            beq     .opmuls
            cmpi.w  #215,d7                 asr
            beq     .opasr
            cmpi.w  #216,d7                 divu
            beq     .opdivu
            cmpi.w  #217,d7                 divs
            beq     .opdivs
            cmpi.w  #218,d7                 add
            beq     .opadd
            cmpi.w  #219,d7                 exg
            beq     .opexg
            cmpi.w  #220,d7                 move
            beq     .opmove
            cmpi.w  #221,d7                 sub
            beq     .opsub
            cmpi.w  #222,d7                 swap
            bne     .do_sorc                then either quit...
            swap    d6                      ...or deal with a swap
            bra     .get_flg
.opclr:     tst.b   op_size
            bmi.s   .clbyt
            beq.s   .clwrd
            clr.l   d6                      clear long,
            bra     .get_flg
.clwrd:     clr.w   d6                              word,
            bra     .get_flg
.clbyt:     clr.b   d6                                  or byte
            bra     .get_flg
.opneg:     tst.b   op_size
            bmi.s   .ngbyt
            beq.s   .ngwrd
            neg.l   d6                      arithmetic neg long,
            bra     .get_flg
.ngwrd:     neg.w   d6                              word,
            bra     .get_flg
.ngbyt:     neg.b   d6                                  or byte
            bra     .get_flg
.opnot:     tst.b   op_size
            bmi.s   .ntbyt
            beq.s   .ntwrd
            not.l   d6                      arithmetic not long,
            bra     .get_flg
.ntwrd:     not.w   d6                              word,
            bra     .get_flg
.ntbyt:     not.b   d6                                  or byte
            bra     .get_flg
.opand:     tst.b   op_size
            bmi.s   .anbyt
            beq.s   .anwrd
            and.l   d5,d6                   logical and long,
            bra     .get_flg
.anwrd:     and.w   d5,d6                           word,
            bra     .get_flg
.anbyt:     and.b   d5,d6                               or byte
            bra     .get_flg
.opor:      tst.b   op_size
            bmi.s   .orbyt
            beq.s   .orwrd
            or.l    d5,d6                   logical or long,
            bra     .get_flg
.orwrd:     or.w    d5,d6                           word,
            bra     .get_flg
.orbyt:     or.b    d5,d6                               or byte
            bra     .get_flg
.opeor:     tst.b   op_size
            bmi.s   .eobyt
            beq.s   .eowrd
            eor.l   d5,d6                   exclusive or long,
            bra     .get_flg
.eowrd:     eor.w   d5,d6                           word,
            bra     .get_flg
.eobyt:     eor.b   d5,d6                               or byte
            bra     .get_flg
.oplsl:     tst.b   op_size
            bmi.s   .llbyt
            beq.s   .llwrd
            lsl.l   d5,d6                   logical shift left long,
            bra     .get_flg
.llwrd:     lsl.w   d5,d6                           word,
            bra     .get_flg
.llbyt:     lsl.b   d5,d6                               or byte
            bra     .get_flg
.oprol:     tst.b   op_size
            bmi.s   .rlbyt
            beq.s   .rlwrd
            rol.l   d5,d6                   rotate left long,
            bra     .get_flg
.rlwrd:     rol.w   d5,d6                           word,
            bra     .get_flg
.rlbyt:     rol.b   d5,d6                               or byte
            bra     .get_flg
.oproxl:    moveq.l #0,d0                   condcodes -> CCR
            move.w  condcodes,d0
            moveq.b #%00010000,d1           affect only X flag
            jsr     _LVOSetSR(a6)           a6<-is still _SysBase
            tst.b   op_size
            bmi.s   .xlbyt
            beq.s   .xlwrd
            roxl.l  d5,d6                   rotate extended left long,
            bra     .get_flg
.xlwrd:     roxl.w  d5,d6                           word,
            bra     .get_flg
.xlbyt:     roxl.b  d5,d6                               or byte
            bra     .get_flg
.oplsr:     tst.b   op_size
            bmi.s   .lrbyt
            beq.s   .lrwrd
            lsr.l   d5,d6                   logical shift right long,
            bra     .get_flg
.lrwrd:     lsr.w   d5,d6                           word,
            bra     .get_flg
.lrbyt:     lsr.b   d5,d6                               or byte
            bra     .get_flg
.opror:     tst.b   op_size
            bmi.s   .rrbyt
            beq.s   .rrwrd
            ror.l   d5,d6                   rotate right long,
            bra     .get_flg
.rrwrd:     ror.w   d5,d6                           word,
            bra     .get_flg
.rrbyt:     ror.b   d5,d6                               or byte
            bra     .get_flg
.oproxr:    moveq.l #0,d0                   condcodes -> CCR
            move.w  condcodes,d0
            moveq.b #%00010000,d1           affect only X flag
            jsr     _LVOSetSR(a6)           a6<-is still _SysBase
            tst.b   op_size
            bmi.s   .xrbyt
            beq.s   .xrwrd
            roxr.l  d5,d6                   rotate extended right long,
            bra     .get_flg
.xrwrd:     roxr.w  d5,d6                           word,
            bra     .get_flg
.xrbyt:     roxr.b  d5,d6                               or byte
            bra     .get_flg
.opasl:     tst.b   op_size
            bmi.s   .albyt
            beq.s   .alwrd
            asl.l   d5,d6                   arithmetic shift left long,
            bra     .get_flg
.alwrd:     asl.w   d5,d6                           word,
            bra.s   .get_flg
.albyt:     asl.b   d5,d6                               or byte
            bra.s   .get_flg
.opmulu:    mulu.w  d5,d6                   multiply unsigned
            bra.s   .get_flg
.opmuls:    muls.w  d5,d6                   multiply signed
            bra.s   .get_flg
.opasr:     tst.b   op_size
            bmi.s   .arbyt
            beq.s   .arwrd
            asr.l   d5,d6                   arithmetic shift right long,
            bra.s   .get_flg
.arwrd:     asr.w   d5,d6                           word,
            bra.s   .get_flg
.arbyt:     asr.b   d5,d6                               or byte
            bra.s   .get_flg
.opdivu:    tst.w   d5
            beq.s   .prc_pass
            divu.w  d5,d6                   divide unsigned
            bra.s   .get_flg
.opdivs:    tst.w   d5
            beq.s   .prc_pass
            divs.w  d5,d6                   divide signed
            bra.s   .get_flg
.opadd:     tst.b   op_size
            bmi.s   .adbyt
            beq.s   .adwrd
            add.l   d5,d6                   add long,
            bra.s   .get_flg
.adwrd:     add.w   d5,d6                           word,
            bra.s   .get_flg
.adbyt:     add.b   d5,d6                               or byte
            bra.s   .get_flg
.opexg:     exg.l   d5,d6                   exchange long
            move.l  d5,(a1)
            move.l  d6,(a2)
            movea.l a1,a2
            bra.s   .do_sorc
.opmove:    tst.b   op_size
            bmi.s   .mobyt
            beq.s   .mowrd
            move.l  d5,d6                   move long,
            bra.s   .get_flg
.mowrd:     move.w  d5,d6                           word,
            bra.s   .get_flg
.mobyt:     move.b  d5,d6                               or byte
            bra.s   .get_flg
.opsub:     tst.b   op_size
            bmi.s   .subyt
            beq.s   .suwrd
            sub.l   d5,d6                   subtract long,
            bra.s   .get_flg
.suwrd:     sub.w   d5,d6                           word,
            bra.s   .get_flg
.subyt:     sub.b   d5,d6                               or byte


*       Operation done - pick up flags and display result

.get_flg:   exg.l   d0,d2
            exg.l   d1,d3
            jsr     _LVOSetSR(a6)           SR -> condcodes
            move.w  d0,condcodes            store flags register
            move.l  d6,(a2)                 replace destination
            cmpa.l  a1,a2
            bne.s   .prc_pass               if src/dest different
            move.l  (a1),d5
            move.l  oldsrcreg,d3
            cmp.l   d3,d5                   has source changed ?
            beq.s   .prc_pass
.do_sorc:   move.l  d5,d6
            bsr.s   disp_src                    then display it

.prc_pass:  movea.l intuitionBase,a6        a6<-using intuition library
            lea.l   DstRGdg00,a3
            moveq.l #32,d0
            bsr     activ_bits              set up bit-display
            bsr     gad_refrsh              refr:  a3<-gad, a4, d0
            lea.l   dsthexdn1,a1
            movea.l destinput,a2
            move.l  (a2),d6
            bsr     conv_disp               conv_disp: a1<-hxtxt, d6<-reg
            moveq.l #0,d6
            move.w  condcodes,d6
            lea.l   flagsdispx,a0
            moveq.l #4,d3                   five flags - x n z v c
            bsr     set_bits                set_bits: a0<-txt, d3, d6
            bsr     displ_val               put up hex and
            bsr     disp_flag                              flags display
.prc_ex:    movem.l (sp)+,a6                a6 <- SysBase for Mesg
            rts


disp_src:   movea.l intuitionBase,a6        a6<-using intuition library
            lea.l   SrcRGdg00,a3
            moveq.l #32,d0
            bsr     activ_bits              set up bit-display
            bsr     gad_refrsh              refr:  a3<-gad, a4, d0
            lea.l   srchexdn1,a1
            movea.l sourcinput,a2
            move.l  (a2),d6
            bsr     conv_disp               conv_disp: a1<-hxtxt, d6<-reg
            movea.l destinput,a2
            move.l  (a2),d6                     and restore dest
di_ex:      rts


*****************************************************************************
*
*       Display the 'ABOUT' message


do_about:   move.l  #reqsize,d0             private memory for
            moveq.l #1,d1                           requester structure
            moveq.w #16,d2
            lsl.l   d2,d1
            jsr     _LVOAllocMem(a6)
            move.l  d0,regRequest
            beq.s   .abou_ex
            move.l  d0,a0
            move.w  #3,rq_LeftEdge(a0)
            move.w  #12,rq_TopEdge(a0)
            move.w  #442,rq_Width(a0)
            move.w  #61,rq_Height(a0)
            move.l  #AbOkay,rq_ReqGadget(a0)
            move.l  #ITxFCpyRt,rq_ReqText(a0)
            move.w  wflood,d0
            move.b  d0,rq_BackFill(a0)
            movea.l intuitionBase,a6        a6<-using intuition library
            movea.l a4,a1
            jsr     _LVORequest(a6)
            move.l  _SysBase,a6             a6<-changed to SysBase
            tst.w   d0
            beq.s   .free_rs
.wait_msg:  move.l  wd_UserPort(a4),a0      find window's user port address
            move.b  MP_SIGBIT(a0),d7        d7<-number of message signal
            moveq.l #1,d0
            lsl.l   d7,d0                   d0<-calculate signal value
            jsr     _LVOWait(a6)            and wait until signal occurs
.free_rs:   movea.l regRequest,a1
            move.l  #reqsize,d0
            jsr     _LVOFreeMem(a6)
.abou_ex:   rts


*****************************************************************************



