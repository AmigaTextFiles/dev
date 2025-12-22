#include "GRAFKERNEL.C"
#include "JOYSTICK.C"
#include <math.h>
#include <libraries/mathffp.h>

static float alpha=0,pi=3.1415926;
static long x=320,y=200;
int MathTransBase,MathBase;
posukis(m)
float m;
{
alpha=alpha+m;
if(alpha>2*pi) {alpha=alpha-pi-pi; }
}
judek(a)
float a;
{
 x=x+(int)(a*SPSin(alpha)); if(x>640) {x=639;}
 y=y+(int)(a*SPCos(alpha)); if(y>400) {y=399;}
}
snaige(a,k,m)
float a;
long k,m;
{
 long i;
 for(i=1;i<6;i++)
 {
  Move(&rastport,x,y);
  posukis(pi*2/3);
  judek(a);
  Draw(&rastport,x,y);
  judek(a/k);
  if(m>1) { snaige(a/k,k,m-1); }
  judek(-a/k);
  posukis(pi);
  judek(a);
 }
}

main()
{
if((MathTransBase=OpenLibrary("mathtrans.library",0))<1)
exit(-1);
if((MathBase=OpenLibrary("mathffp.library",0))<1) exit(-1);
pasiruosk();
SetRast(&rastport,0L);
SetAPen(&rastport,1L);
snaige(4,2,3);
while(!fire()) { }
FreeMemory();
CloseLibrary(MathTransBase);
CloseLibrary(MathBase);
}


