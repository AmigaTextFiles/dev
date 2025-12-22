/* ==================================================
   =  Cia turi buti JOYSTICK'o proceduros  +        =
   =  Advanced topics.                              =
   =  FILE BOULDER3.C pradetas 1993.12.21           =
   =  ©bySAVELSOFT                +1995             =
   ================================================== */
SHORT hx,hy;
USHORT LIVES,ITEMS,BONUS,ALIVE,FINISH;
ULONG SCORE;
SHORT pekb(),pekc(),fire();
short man2()
{
SHORT a,b;
a=pekc();
b=0; hx=0; hy=0;
if(a==3) {b=1; hx=1; }
if(a==12) {b=1; hx=-1; return(b);}
if(a==4) {b=1; hy=-1; }
if(a==1) {b=1; hy=1; }
return(b);
}
man(mx,my)
SHORT mx,my;
{
SHORT i,q,x,y;
i=man2(); if(!i){ return(); }
x=mx+hx; y=my+hy;
q=e(x,y); if(q==12){FINISH=1; q=1;}
if(!fire()) {
 if(q==20) { LIVES++; q=1; }
 if(q<2 && !hy) {walk(mx,my,hx); return(); }
 if(q==3 && !hy) {walk(mx,my,hx); SCORE+=BONUS; Adzin=1;
    if(ITEMS){ITEMS--; }
    return(); }
 if(q<2) {set(mx,my,0); set(x,y,10); if(hy==-1){k(x,y)=9; ALIVE=16;} return(); }
 if(q==3) {set(mx,my,0); set(x,y,10); if(hy==-1){k(x,y)=9; ALIVE=16;}
  SCORE+=BONUS; Adzin=1;
  if(ITEMS){ITEMS--;} return(); }
 if((q==2 || q==14) && !e(mx+2*hx,my)) {set(mx,my,0); set(x,y,10);set(mx+2*hx,my,q);
   k(x,y)=9; ALIVE=19;
   return(); }
}
if(fire())
{
if(q==3) {set(x,y,0); SCORE+=BONUS; Adzin=1; if(ITEMS) {ITEMS--;} return(); }
if(q==1) {set(x,y,0); return(); }
if(q==20) {set(x,y,0); LIVES++; Adzin=1; return(); }
if((q==2 || q==14) && !e(mx+2*hx,my)) {set(x,y,0); set(mx+2*hx,my,q);
   if(hx==1){k(mx+2,my)=9;} return();
 }
}

 
}
walk(x,y,dx)
SHORT x,y,dx;
{
set(x,y,0);
set(x+dx,y,10); if(dx==1) { k(x+dx,y)=9; }
}

SHORT fire()
{ short a;
a=pekb(0xBFE000);
if(a>127) {return(0);}
return(1);
}
mgo(k,x,y,c1,c2,c3,c4)        /* Tai perkeltos Magmos proc. */
SHORT k,x,y,c1,c2,c3,c4;
{
 if(k==1) {set(c1,y,6); k(c1,y)=9; }
 if(k==2) {set(x,c3,6); k(x,c3)=9; }
 if(k==3) {set(c2,y,6); }
 if(k==4) {set(x,c4,6); }
}
go(c1,c2,c3,c4,kq,q,x,y)
SHORT c1,c2,c3,c4,kq,q,x,y;
{
set(x,y,0);
if(kq==1) {set(c1,y,q); k(c1,y)=20; return(); }
if(kq==2) {set(x,c3,q); k(x,c3)=30; }
if(kq==3) {set(c2,y,q); k(c2,y)=4; }
if(kq==4) {set(x,c4,q); k(x,c4)=5; }
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

