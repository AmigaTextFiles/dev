#include "GRAFKERNEL.C"
#include "RND.C"
#include "JOYSTICK.C"

extern long rnd();
static LONG x,y;

static UBYTE k[52*400],gyva;

masyvas()
{
REGISTER SHORT i;
SHORT n;
n=51*400;
for(i=0;i<n;i++)
 {
  k[i]=10;
 }
}
grozis()
{
SetRast(&rastport,0L);
SetAPen(&rastport,1L);
Move(&rastport,0L,0L); Draw(&rastport,600L,0L); Draw(&rastport,600L,399L);
Draw(&rastport,0L,399L); Draw(&rastport,0L,0L);
RectFill(&rastport,0L,0L,50L,400L);
SetAPen(&rastport,0L);
}

banga()
{
BYTE dy,b;
dy=rnd(3)-1;
x--; y=y+dy;
if(y<1) {y=1;}
if(y>398) {y=398;}
if(x<2) {gyva=0; return();}
if(x<51)
 {
  b=k[x*400+y];
  if(b>0)
  {
   if(b<2) { plot(x,y); }
   b--;
   k[x*400+y]=b; gyva=0;
  }
 }
}
start()
{
x=60; gyva=1;
y=rnd(396)+2;
while(gyva && !fire())
{  banga(); }
}
main()
{
pasiruosk();
rnd(-87341);
grozis();
masyvas();
while(!fire())
{ start(); }
FreeMemory();
}

