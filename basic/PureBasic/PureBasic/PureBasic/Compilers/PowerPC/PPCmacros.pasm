                .ifndef    POWERPC_PPCMACROS_I
.set     POWERPC_PPCMACROS_I,1

**
**      0xVER: PPCmacros.i 8.0 (3.6.97)
**
**      standard macros and definitions for PowerPC
**

.extern _PowerPCBase

.macro       BITDEFPPC
\1P_\2    ,       \3
\1B_\2    ,       31-(\3)
\1F_\2    ,       1<<(31-(\3))
                .endm

.macro     ALLOCPPCMEM
                movem.l d1/a0/a1/a6,-(sp)
                move.l  _SysBase,a6
                add.l   #56,d0
                jsr     -684(a6)
                move.l  d0,d1
                beq     lb_1
                add.l   #39,d0
                and.l   #0xffffffe0,d0
                move.l  d0,a0
                move.l  d1,-4(a0)
lb_1:
                movem.l (sp)+,d1/a0/a1/a6
                .endm

.macro      FREEPPCMEM
                movem.l d0/d1/a0/a1/a6,-(sp)
                move.l  a1,d0
                beq.b   lb_2
                move.l  -4(a1),a1
                move.l  _SysBase,a6
                jsr     -690(a6)
lb_2:
                movem.l (sp)+,d0/d1/a0/a1/a6
                .endm

                .set _POWERMODE,1
                .ifdef     _POWERMODE

                .ifndef    __LOCALSIZE
.set     __LOCALSIZE,1024
                .endif
                .ifndef    local
.set     __LOCAL,r13
.set       local,r13
                .endif
.set        base,r2
.set       stack,r1
.set       trash,r0

**** these register symbols can be used when transferring parameters from
**** 68K to PPC and vice versa

.set         _d0,r3
.set         _d1,r4
.set         _d2,r22
.set         _d3,r23
.set         _d4,r24
.set         _d5,r25
.set         _d6,r26
.set         _d7,r27
.set         _a0,r5
.set         _a1,r6
.set         _a2,r28
.set         _a3,r29
.set         _a4,base
.set         _a5,r30
.set         _a6,r31

.set        _fp0,f1
.set        _fp1,f2
.set        _fp2,f3
.set        _fp3,f4
.set        _fp4,f5
.set        _fp5,f6
.set        _fp6,f7
.set        _fp7,f8

.macro        lw
                        .ifdef    NEAR
                                lwz     \1,\2(base)
                        .else
                                la      \1,\2
                                lwz     \1,0(\1)
                        .endif
                .endm

.macro        lh
                        .ifdef    NEAR
                                lhz     \1,\2(base)
                        .else
                                la      \1,\2
                                lhz     \1,0(\1)
                        .endif
                .endm

.macro       lhs
                        .ifdef    NEAR
                                lha     \1,\2(base)
                        .else
                                la      \1,\2
                                lha     \1,0(\1)
                        .endif
                .endm

.macro        lb
                        .ifdef    NEAR
                                lbz     \1,\2(base)
                        .else
                                la      \1,\2
                                lbz     \1,0(\1)
                        .endif
                .endm

.macro       lbs
                        .ifdef    NEAR
                                lbz     \1,\2(base)
                                extsb   \1,\1
                        .else
                                la      \1,\2
                                lbz     \1,0(\1)
                                extsb   \1,\1
                        .endif
                .endm

.macro        lf
                        .ifdef    NEAR
                                lfd     \1,\2(base)
                        .else
                                mr      trash,r3
                                la      r3,\2
                                lfd     \1,0(r3)
                                mr      r3,trash
                        .endif
                .endm

.macro        ls
                        .ifdef    NEAR
                                lfs     \1,\2(base)
                        .else
                                mr      trash,r3
                                la      r3,\2
                                lfs     \1,0(r3)
                                mr      r3,trash
                        .endif
                .endm

.macro        sw
                        .ifdef    NEAR
                                stw     \1,\2(base)
                        .else
                                mr      trash,\1
                                la      \1,\2
                                stw     trash,0(\1)
                                mr      \1,trash
                        .endif
                .endm

.macro        sh
                        .ifdef    NEAR
                                sth     \1,\2(base)
                        .else
                                mr      trash,\1
                                la      \1,\2
                                sth     trash,0(\1)
                                mr      \1,trash
                        .endif
                .endm

.macro        sb
                        .ifdef    NEAR
                                stb     \1,\2(base)
                        .else
                                mr      trash,\1
                                la      \1,\2
                                stb     trash,0(\1)
                                mr      \1,trash
                        .endif
                .endm

.macro        sf
                        .ifdef    NEAR
                                stfd    \1,\2(base)
                        .else
                                mr      trash,r3
                                la      r3,\2
                                stfd    \1,0(r3)
                                mr      r3,trash
                        .endif
                .endm

.macro        ss
                        .ifdef    NEAR
                                stfs    \1,\2(base)
                        .else
                                mr      trash,r3
                                la      r3,\2
                                stfs    \1,0(r3)
                                mr      r3,trash
                        .endif
                .endm

.macro       lba
                lbz     \1,\2
                extsb   \1,\1
                .endm

.macro      lbau
                lbzu    \1,\2
                extsb   \1,\1
                .endm

.macro      lbax
                lbzx    \1,\2,\3
                extsb   \1,\1
                .endm

.macro     lbaux
                lbzux   \1,\2,\3
                extsb   \1,\1
                .endm

.macro      stwi
                liw     trash,\1
                stw     trash,\2
                .endm

.macro      sthi
                li      trash,\1
                sth     trash,\2
                .endm

.macro      stbi
                li      trash,\1
                stb     trash,\2
                .endm

.macro     stwiu
                liw     trash,\1
                stwu    trash,\2
                .endm

.macro     sthiu
                li      trash,\1
                sthu    trash,\2
                .endm

.macro     stbiu
                li      trash,\1
                stbu    trash,\2
                .endm

.macro     stwix
                liw     trash,\1
                stwx    trash,\2,\3
                .endm

.macro     sthix
                li      trash,\1
                sthx    trash,\2,\3
                .endm

.macro     stbix
                li      trash,\1
                stbx    trash,\2,\3
                .endm

.macro    stwiux
                liw     trash,\1
                stwux   trash,\2,\3
                .endm

.macro    sthiux
                li      trash,\1
                sthux   trash,\2,\3
                .endm

.macro    stbiux
                li      trash,\1
                stbux   trash,\2,\3
                .endm

.macro       swi
                        .ifdef NEAR
                                liw     trash,\1
                                stw     trash,\2(base)
                        .else
                                stw     r3,-4(local)
                                liw     trash,\1
                                la      r3,\2
                                stw     trash,0(r3)
                                lwz     r3,-4(local)
                        .endif
                .endm

.macro       shi
                        .ifdef    NEAR
                                li      trash,\1
                                sth     trash,\2(base)
                        .else
                                stw     r3,-4(local)
                                li      trash,\1
                                la      r3,\2
                                sth     trash,0(r3)
                                lwz     r3,-4(local)
                        .endif
                .endm

.macro       sbi
                        .ifdef    NEAR
                                li      trash,\1
                                stb     trash,\2(base)
                        .else
                                stw     r3,-4(local)
                                li      trash,\1
                                la      r3,\2
                                stb     trash,0(r3)
                                lwz     r3,-4(local)
                        .endif
                .endm

.macro       liw
                lis     \1,\2@ha
                ori     \1,\1,\2@l
                .endm

.macro      clrw
                xor\0   \1,\1,\1
                .endm

.macro      clrh
                clrrwi\0 \1,\1,16
                .endm

.macro      clrb
                clrrwi\0 \1,\1,8
                .endm

.macro      setb
                ori     \1,\1,0xff
                .endm

.macro      seth
                ori     \1,\1,0xffff
                .endm

.macro      setw
                eqv\0   \1,\1,\1
                .endm

.macro        mh
                insrwi\0 \1,\2,16,16
                .endm

.macro        mb
                insrwi\0 \1,\2,8,24
                .endm

.macro      tstb
                extsb.  trash,\1
                .endm

.macro      tsth
                extsh.  trash,\1
                .endm

.macro      tstw
                mr.     \1,\1
                .endm

.macro    bittst
                .iflt    (\2)-31
                        extrwi. trash,\1,1,\2
                .else
                        andi.   trash,\1,0x1
                .endif
                .endm

.macro    bitset
                .iflt    (\2)-16
                        oris    \1,\1,(1<<(15-(\2)))
                .else
                        ori     \1,\1,(1<<(31-(\2)))
                .endif
                .endm

.macro    bitclr
                .iflt    (\2)-16
                        oris    \1,\1,(1<<(15-(\2)))
                        xoris   \1,\1,(1<<(15-(\2)))
                .else
                        ori     \1,\1,(1<<(31-(\2)))
                        xori    \1,\1,(1<<(31-(\2)))
                .endif
                .endm

.macro    bitchg
                .iflt    (\2)-16
                        xoris   \1,\1,(1<<(15-(\2)))
                .else
                        xori    \1,\1,(1<<(31-(\2)))
                .endif
                .endm

.macro      push
                stwu    \1,-4(local)
                .endm

.macro     pushf
                stfdu   \1,-8(local)
                .endm

.macro    pushlr
                mflr    trash
                stwu    trash,-4(local)
                .endm

.macro   pushctr
                mfctr   trash
                stwu    trash,-4(local)
                .endm

.macro    pushcr
                mfcr    trash
                stwu    trash,-4(local)
                .endm

.macro       pop
                lwz     \1,0(local)
                addi    local,local,4
                .endm

.macro      popf
                lfd     \1,0(local)
                addi    local,local,8
                .endm

.macro     poplr
                lwz     trash,0(local)
                addi    local,local,4
                mtlr    trash
                .endm

.macro    popctr
                lwz     trash,0(local)
                addi    local,local,4
                mtctr   trash
                .endm

.macro     popcr
                lwz     trash,0(local)
                addi    local,local,4
                mtcr    trash
                .endm

.macro       lnk
                stwu    \1,-4(local)
                mr      \1,local
                addi    local,local,\2
                .endm

.macro      ulnk
                mr      local,\1
                lwz     \1,0(local)
                addi    local,local,4
                .endm


.macro  setlocal
.set     __LOCALSIZE,\1
.set     __LOCAL,\2
.set       local,\2
.endm


.macro    prolog
                stw     base,20(stack)
                mflr    trash
                stw     trash,8(stack)
                mfcr    trash
                stw     trash,4(stack)
                stw     local,-4(stack)
                subi    local,stack,4
.set      __ARGS,24+4+(__LOCALSIZE)+56
                        stwu    stack,-((__ARGS)-56)(stack)
                .endm

.macro    epilog
                lwz     stack,0(stack)
                lwz     local,-4(stack)
                lwz     trash,8(stack)
                mtlr    trash
                lwz     trash,4(stack)
                mtcr    trash
                lwz     base,20(stack)
                blr
                .endm

                .endif

                .endif



