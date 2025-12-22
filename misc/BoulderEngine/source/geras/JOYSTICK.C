SHORT pekb(),pekc(),fire();
SHORT fire()
{ short a;
a=pekb(0xBFE000);
if(a>127) {return(0);}
return(1);
}
  /* Dievuleliau, Levas moka M68000 asembleri! */
#asm
   section code
   xdef _pekb
_pekb
   move.l 4(sp),d0
   movem.l a0,-(sp)
   move.l d0,a0
   move.l (a0),d0
   andi.l #$ff,d0
   movem.l (sp)+,a0
   rts
   xdef _pekc
_pekc
   movem.l d1,-(sp)
   move.w ($DFF00C),d0
   andi.l #$300,d0
   divu.w #64,d0
   move.w ($DFF00C),d1
   andi.l #$003,d1
   or.l d1,d0
   movem.l (sp)+,d1
   rts
#endasm
