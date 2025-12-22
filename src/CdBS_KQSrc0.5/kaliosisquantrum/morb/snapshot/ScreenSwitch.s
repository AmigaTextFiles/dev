*
* CdBSian Obviously Universal & Interactive Nonsense (COUIN)
* (Absurdité CdBSienne Manifestement Universelle et Interactive)
* ©1997, CdBS Software (MORB)
* System/COUIN screen switch routines
* $Id: ScreenSwitch.s 0.0 1997/09/11 16:55:06 MORB Exp MORB $
*

;fs "_SwitchToCOUIN"
_SwitchToCOUIN:
         lea       CustomBase,a6
         move.w    dmaconr(a6),_SysDMA
         move.w    intenar(a6),_SysIntEna
         move.w    intreqr(a6),_SysIntReq

         move.w    #$7fff,d0
         move.w    d0,intena(a6)
         move.w    d0,intreq(a6)
         move.w    d0,dmacon(a6)
         clr.w     color(a6)
         move.w    #$20,beamcon0(a6)

         movec     vbr,d0
         move.l    d0,a0
         move.l    $6c(a0),_SysLevel3

         lea       _Level3_Int,a1
         move.l    a1,$6c(a0)

         move.l    #CopperList,cop1lc(a6)
         clr.w     copjmp1(a6)

         move.w    #$c068,intena(a6)
         move.w    #DMAF_SETCLR|DMAF_MASTER|DMAF_RASTER|DMAF_COPPER|DMAF_BLITTER|DMAF_SPRITE,dmacon(a6)
         rts
;fe
;fs "_SwitchToSystem"
_SwitchToSystem:
         lea       CustomBase,a6
         move.w    #$7fff,d0
         move.w    d0,intena(a6)
         move.w    d0,intreq(a6)

         btst      #6,dmaconr(a6)
.WBlit:
         btst      #6,dmaconr(a6)
         bne.s     .WBlit

         movec     vbr,d0
         move.l    d0,a0
         move.l    _SysLevel3(pc),$6c(a0)

         move.l    Gfx_Base,a0
         move.l    gb_copinit(a0),cop1lc(a6)
         clr.w     copjmp1(a6)

         move.w    _SysIntReq(pc),d0
         bset      #15,d0
         move.w    d0,intreq(a6)

         move.w    _SysIntEna(pc),d0
         bset      #15,d0
         move.w    d0,intena(a6)

         move.w    _SysDMA(pc),d0
         bset      #15,d0
         move.w    d0,dmacon(a6)
         rts
;fe

_SysLevel3:
         ds.l      1
_SysDMA:
         ds.w      1
_SysIntEna:
         ds.w      1
_SysIntReq:
         ds.w      1
