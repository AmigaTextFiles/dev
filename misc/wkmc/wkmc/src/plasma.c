/* Plasma v0.3 (23 October 1995) - ©1995 by WK-Artworks */

/*

 wkmc is a simple true-color-display using a 8-bit-screen,
 the idea behind this came from Stefan Kost and Smack/IFT

 NOTE: I think it's fast beeing pure C !


 Advantages (compared against MultiColor):
  -terrible high speed
  -picture-size and -aspect isn't changed
  -no ugly diagonal-dithering
  -no flickering (uses Multiscan)
  -uses all 256 registers (not only 255)
  -every color-channel (RGB) has a diffent number of
   shades ("eye-sensitive")
*/

#include "wkmc.h"

void fSetPixel(int x,int y,double r,double g,double b) {
 SetPixel(x,y,(UBYTE)(256.0*r),(UBYTE)(256.0*g),(UBYTE)(256.0*b));
}

void fGetPixel(int x,int y,double *r,double *g,double *b) {
 UBYTE rr,gg,bb;
 GetPixel(x,y,&rr,&gg,&bb);
 (*r)=(double)rr*f256;
 (*g)=(double)gg*f256;
 (*b)=(double)bb*f256;
}

double rrmax=1.0/(double) RAND_MAX;

double drand48(void)
{
 return((double)rand()*rrmax);
} 


int main(int argc,char **argv) {
 int width,height,w2,h2,qt=0;
 double frac=20.0;
 double aktr,aktg,aktb,c1r,c1g,c1b,c3r,c3g,c3b,c5r,c5g,c5b,c7r,c7g,c7b,c9r,c9g,c9b,f13,f14;
 UWORD f[300][4],dimx,dimy;
 double rndf,dimf;
 WORD ptr=0;
 UWORD x1,x2,x3,y1,y2,y3;

 struct IntuiMessage *imsg;
 ULONG iclass;
 USHORT icode;
 printf("\n Plasma v0.3 - ©1995 by WK-Artworks\n");
 printf(" (Plasma-algorithm by Stefan Kost)\n");
 printf("------------------------------------\n");
 width=320;
 height=240;
 if(argc<2) {printf(" Usage: plasma <frac> [LARGE]\n");return(1);}
 frac=strtod(argv[1],NULL);
 if(frac<=0.0) frac=20.0;
 if(argc>2) {width=640;height=480;}
 if(init(width,height)==0) {
 printf(" Resolution : %dx%d\n",width,height);

  /* do it */
  w2=width/2;h2=height/2;
  f13=(double)1.0/(double)3.0;
  f14=(double)1.0/(double)4.0;

  time(&tm1);
  dimf=frac/((double)h2*(double)w2);
  f[0][0]=0;f[0][1]=0;f[0][2]=w2-1;f[0][3]=h2-1;
  aktr=drand48();aktg=drand48();aktb=drand48();
  fSetPixel(0,0,aktr,aktg,aktb);
  aktr=drand48();aktg=drand48();aktb=drand48();
  fSetPixel(w2-1,0,aktr,aktg,aktb);
  aktr=drand48();aktg=drand48();aktb=drand48();
  fSetPixel(w2-1,h2-1,aktr,aktg,aktb);
  aktr=drand48();aktg=drand48();aktb=drand48();
  fSetPixel(0,h2-1,aktr,aktg,aktb);
  while(ptr>-1) {
	dimx=f[ptr][2]-f[ptr][0];
	dimy=f[ptr][3]-f[ptr][1];
	if(dimx>1 || dimy>1) {
    rndf=(dimx*dimy)*dimf;
	 x1=f[ptr][0];x3=f[ptr][2];x2=x1+((x3-x1)>>1);
	 y1=f[ptr][1];y3=f[ptr][3];y2=y1+((y3-y1)>>1);
	 fGetPixel(x1,y1,&c1r,&c1g,&c1b);
    fGetPixel(x3,y1,&c3r,&c3g,&c3b);
    fGetPixel(x3,y3,&c9r,&c9g,&c9b);
    fGetPixel(x1,y3,&c7r,&c7g,&c7b);
    c5r=(c1r+c3r+c7r+c9r)*f14+(rndf*(0.5-drand48()));
    if(c5r>1.0) c5r=1.0;
	 if(c5r<0.0) c5r=0.0;
	 c5g=(c1g+c3g+c7g+c9g)*f14+(rndf*(0.5-drand48()));
    if(c5g>1.0) c5g=1.0;
	 if(c5g<0.0) c5g=0.0;
	 c5b=(c1b+c3b+c7b+c9b)*f14+(rndf*(0.5-drand48()));
	 if(c5b>1.0) c5b=1.0;
    if(c5b<0.0) c5b=0.0;
	 fSetPixel(x2,y2,c5r,c5g,c5b);
    fGetPixel(x2,y1,&aktr,&aktb,&aktg);
    if(aktr==0.0 && aktg==0.0 && aktb==0.0) {
     aktr=(c1r+c3r+c5r)*f13;
	  aktg=(c1g+c3g+c5g)*f13;
     aktb=(c1b+c3b+c5b)*f13;
     fSetPixel(x2,y1,aktr,aktg,aktb); 
	 }
    fGetPixel(x1,y2,&aktr,&aktg,&aktb);
    if((aktr==0.0) && (aktg==0.0) && (aktb==0.0)) {
     aktr=(c1r+c7r+c5r)*f13;
     aktg=(c1g+c7g+c5g)*f13;
     aktb=(c1b+c7b+c5b)*f13;
     fSetPixel(x1,y2,aktr,aktg,aktb); 
    }
	 fGetPixel(x3,y2,&aktr,&aktg,&aktb);
    if((aktr==0.0) && (aktg==0.0) && (aktb==0.0)) {
     aktr=(c3r+c9r+c5r)*f13;
	  aktg=(c3g+c9g+c5g)*f13;
	  aktb=(c3b+c9b+c5b)*f13;
	  fSetPixel(x3,y2,aktr,aktg,aktb); 
	 }
	 fGetPixel(x2,y3,&aktr,&aktg,&aktb);
    if((aktr==0.0) && (aktg==0.0) && (aktb==0.0)) {
     aktr=(c7r+c9r+c5r)*f13;
     aktg=(c7g+c9g+c5g)*f13;
     aktb=(c7b+c9b+c5b)*f13;
     fSetPixel(x2,y3,aktr,aktg,aktb); 
    }
    f[ptr][2]=x2;f[ptr][3]=y2;ptr++;
    f[ptr][0]=x2;f[ptr][1]=y1;f[ptr][2]=x3;f[ptr][3]=y2;ptr++;
    f[ptr][0]=x2;f[ptr][1]=y2;f[ptr][2]=x3;f[ptr][3]=y3;ptr++;
    f[ptr][0]=x1;f[ptr][1]=y2;f[ptr][2]=x2;f[ptr][3]=y3;
    if(ptr>250) {
     printf("stack overflow\n");
     ptr=-1;
    }
	}
	else ptr--;
  }

  time(&tm2);
  tm=difftime(tm2,tm1);
  printf(" Render-time: %lds\n",(ULONG)tm);


  /* wait */
  do {
   WaitPort(theWindow->UserPort);
   do {
    imsg=(struct IntuiMessage*)GetMsg(theWindow->UserPort);
    if(imsg!=NULL) {
     iclass=imsg->Class;
     icode=imsg->Code;
     ReplyMsg((struct Message*)imsg);
     switch(iclass) {
      case IDCMP_VANILLAKEY:switch(icode) {
                             case ' ':qt=1;break;
                            }
     }
    }
   } while(imsg!=NULL);
  } while(qt==0);
  /* clean up*/
  cleanup();
 }
 return(0);
 printf("\n");
}


