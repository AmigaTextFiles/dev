#include "GRAFKERNEL.C"
#include "JOYSTICK.C"
#include "RND.C"
extern long rnd();
/* Graftalas paparcio sakele */

Three()
{
int b[100];
int k,n,x=0,y=0,z=0,newx,newy;
static int a[4][3][4]={
{ {0,0,0,0},{0,20,0,0},{0,0,0,0}       } , 
{ {85,0,0,0},{0,85,11,70},{0,-10,85,0} } ,
{ {31,-41,0,0},{10,21,0,21},{0,0,30,0} } ,
{ {-29,40,0,0},{10,19,0,56},{0,0,30,0} } };

while (!fire())
{
 for(k=1;k<100;++k)
 {
  b[k]=rnd(10);
   if(b[k]>3) {b[k]=1;}
 }
 for (k=1;k<100;++k)
 {
 newx=(a[b[k]][0][0]*x+a[b[k]][0][1]*y+a[b[k]][0][2]*z)/100+a[b[k]][0][3];
 newy=(a[b[k]][1][0]*x+a[b[k]][1][1]*y+a[b[k]][1][2]*z)/100+a[b[k]][1][3];
    z=(a[b[k]][2][0]*x+a[b[k]][2][1]*y+a[b[k]][2][2]*z)/100+a[b[k]][2][3];

 x=newx; y=newy;

  plot(310-x+z,390-y);
 }
}
}
main()
{
pasiruosk();
SetRast(&rastport,0L);
SetAPen(&rastport,1L);
Move(&rastport,0L,0L); Draw(&rastport,629L,0L);
Draw(&rastport,629L,399L); Draw(&rastport,0L,399L);
Draw(&rastport,0L,0L);

rnd(-73456L);
Three();
FreeMemory();
}
