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


/* start independant mc-stuff */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <exec/types.h>
#include <graphics/displayinfo.h>
#include <intuition/intuition.h>
#include <time.h>
static double tm,dt;
static time_t tm1,tm2;

#ifdef __GNUC__
#else
 #include <clib/exec_protos.h>
 #include <clib/graphics_protos.h>
 #include <clib/intuition_protos.h>
#endif

struct GfxBase *GfxBase=NULL;
struct IntuitionBase *IntuitionBase=NULL;
struct Screen *theScreen=NULL;
struct Window *theWindow=NULL;
struct RastPort *rp=NULL;

static ULONG ct[770],cvals[256];
static UBYTE pt[256],rt[256],gt[256],bt[256],rbit[256][8],gbit[256][8],bbit[256][8];
static UBYTE entry[9];
static ULONG ind;
static double f256=1.0/256.0;

void cleanup(void) {
 if(theWindow!=NULL) {CloseWindow(theWindow);theWindow=NULL;}
 if(theScreen!=NULL) {CloseScreen(theScreen);theScreen=NULL;}
 if(GfxBase!=NULL) {CloseLibrary((struct Library*)GfxBase);GfxBase=NULL;}
 if(IntuitionBase!=NULL) {CloseLibrary((struct Library*)IntuitionBase);IntuitionBase=NULL;}
}

UBYTE getbit(UBYTE val,UBYTE bit) {
 if(bit!=0) return((val>>bit)%2);
 else return(val%2);
}

int init(int width,int height) {
 int i,rs=76,gs=150,bs=30;
 float cscl,cl,cmode=1;
 ULONG lval,lv;
 UBYTE j;
 GfxBase=(struct GfxBase *)OpenLibrary("graphics.library",39L);
 if(GfxBase==NULL) {printf(" Couldn't open graphics.library V39+.\n");return(1);}
 IntuitionBase=(struct IntuitionBase *) OpenLibrary("intuition.library",39L);
 if(IntuitionBase==NULL) {printf(" Couldn't open intuition.library V39+.\n");cleanup();return(2);}

 if(cmode==0) {
  rs=85;gs=86;bs=85;
 }
 else if(cmode==1) {
  rs=76,gs=150,bs=30;
 }

 ct[0]=(ULONG)256<<16;ct[769]=0;
 lval=1;

 cscl=256.0/(float)rs;
 for(i=0;i<rs;i++) {
  cl=(float)i*cscl+0.5;
  lv=(ULONG)cl;if(lv>255) lv=255;
  cvals[i]=lv;
  pt[i]=lv;
 }  
 for(i=0;i<rs;i++) {
  ct[lval]=cvals[i]<<24;lval++;
  ct[lval]=0;lval++;
  ct[lval]=0;lval++;
 }

 cscl=256.0/(float)gs;
 for(i=0;i<gs;i++) {
  cl=(float)i*cscl+0.5;
  lv=(ULONG)cl;if(lv>255) lv=255;
  cvals[i]=lv;
  pt[i+rs]=lv;
 }
 for(i=0;i<gs;i++) {
  ct[lval]=0;lval++;
  ct[lval]=cvals[i]<<24;lval++;
  ct[lval]=0;lval++;
 }

 cscl=256.0/(float)bs;
 for(i=0;i<bs;i++) {
  cl=(float)i*cscl+0.5;
  lv=(ULONG)cl;if(lv>255) lv=255;
  cvals[i]=lv;
  pt[i+rs+gs]=lv;
 }
 for(i=0;i<bs;i++) {
  ct[lval]=0;lval++;
  ct[lval]=0;lval++;
  ct[lval]=cvals[i]<<24;lval++;
 }

 cscl=(float)rs/256.0;
 for(i=0;i<256;i++) {
  cl=(float)i*cscl+0.5;
  lval=(ULONG)cl;if(lval>(rs-1)) lval=rs-1;
  rt[i]=(UBYTE)lval;
 }

 cscl=(float)gs/256.0;
 for(i=0;i<256;i++) {
  cl=(float)i*cscl+0.5;
  lval=(ULONG)cl;if(lval>(gs-1)) lval=gs-1;
  gt[i]=(UBYTE)lval+(UBYTE)rs;
 }

 cscl=(float)bs/256.0;
 for(i=0;i<256;i++) {
  cl=(float)i*cscl+0.5;
  lval=(ULONG)cl;if(lval>(bs-1)) lval=bs-1;
  bt[i]=(UBYTE)lval+(UBYTE)rs+(UBYTE)gs;
 }

 for(i=0;i<256;i++) {
  for(j=0;j<8;j++) {
   rbit[i][j]=getbit(rt[i],j);
   gbit[i][j]=getbit(gt[i],j);
   bbit[i][j]=getbit(bt[i],j);
  }
 }

 theScreen=(struct Screen*)OpenScreenTags(NULL,
  SA_DisplayID,(ULONG)0x39024,
  SA_Overscan,OSCAN_TEXT,
  SA_Width,width,
  SA_Height,height,
  SA_Depth,8,
  SA_AutoScroll,1,
  SA_Title,"WKMC-Screen",
  SA_Colors32,ct,
  TAG_DONE);
 if(theScreen==NULL) {printf(" Couln't open screen.\n");cleanup();return(3);}
 theWindow=(struct Window*)OpenWindowTags(NULL,
  WA_Left,0,
  WA_Top,0,
  WA_Width,width,
  WA_Height,height,
  WA_MinWidth,50,
  WA_MinHeight,40,
  WA_MaxWidth,-1,
  WA_MaxHeight,-1,
  WA_IDCMP,VANILLAKEY,
  WA_SizeGadget,FALSE,
  WA_DepthGadget,FALSE,
  WA_DragBar,FALSE,
  WA_CloseGadget,FALSE,
  WA_Borderless,TRUE,
  WA_NoCareRefresh,TRUE,
  WA_SmartRefresh,TRUE,
  WA_CustomScreen,theScreen,
  WA_Activate,TRUE,
  TAG_DONE);
 if(theWindow==NULL) {printf(" Couldn't open window.\n");cleanup();return(4);}
 rp=theWindow->RPort;
 return(0);
}

void SetPixelS(int x,int y,UBYTE r,UBYTE g,UBYTE b) {
 if((x%2==0) && (y%2==0)) {
  SetAPen(rp,rt[r]);
  WritePixel(rp,x,y); 
  SetAPen(rp,gt[g]);
  WritePixel(rp,x+1,y);
  SetAPen(rp,bt[b]);
  if(y%4==0) WritePixel(rp,x,y+1);
  else WritePixel(rp,x+1,y+1); 
 }
}

void SetPixel(int x,int y,UBYTE r,UBYTE g,UBYTE b) {
 register int xx,yy;
 xx=x+x;yy=y+y;
 SetAPen(rp,rt[r]);
 WritePixel(rp,xx,yy);
 SetAPen(rp,gt[g]);
 WritePixel(rp,xx+1,yy);
 SetAPen(rp,bt[b]);
 if(yy%4==0) WritePixel(rp,xx,yy+1);
 else WritePixel(rp,xx+1,yy+1);
}


void GetPixel(int x,int y,UBYTE *r,UBYTE *g,UBYTE *b) {
 register int xx,yy;
 xx=x+x;yy=y+y;
 (*r)=pt[ReadPixel(rp,xx,yy)];
 (*g)=pt[ReadPixel(rp,xx+1,yy)];
 if(yy%4==0) (*b)=pt[ReadPixel(rp,xx,yy+1)];
 else (*b)=pt[ReadPixel(rp,xx+1,yy+1)];
}

void SetLine(int i,UBYTE* line,int width,int bn,UBYTE **bl) {
 register int k,act,l,act3,ii;
 ii=i+i;

 /* rg */
 act=0;
 for(k=0;k<bn;k++) {
  act3=act+act+act;
  for(l=0;l<8;l++) {
   entry[l]=rbit[line[act3]][l]<<7;
   entry[l]+=gbit[line[act3+1]][l]<<6;
  }
  act++;
  act3=act+act+act;
  for(l=0;l<8;l++) {
   entry[l]+=rbit[line[act3]][l]<<5;
   entry[l]+=gbit[line[act3+1]][l]<<4;
  }
  act++;
  act3=act+act+act;
  for(l=0;l<8;l++) {
   entry[l]+=rbit[line[act3]][l]<<3;
   entry[l]+=gbit[line[act3+1]][l]<<2;
  }
  act++;
  act3=act+act+act;
  for(l=0;l<8;l++) {
   entry[l]+=rbit[line[act3]][l]<<1;
   entry[l]+=gbit[line[act3+1]][l];
  }
  act++;
  for(l=0;l<8;l++) bl[l][k]=entry[l];
 }
 ind=(ULONG)ii*(ULONG)bn;
 for(k=0;k<8;k++) memcpy(&(theScreen->BitMap.Planes[k][ind]),bl[k],bn);

 /* b */
 if(i%4==0) {
  act=0;
  for(k=0;k<bn;k++) {
   act3=act+act+act+2;
   for(l=0;l<8;l++) {
    entry[l]=bbit[line[act3]][l]<<7;
   }
   act++;
   act3=act+act+act+2;
   for(l=0;l<8;l++) {
    entry[l]+=bbit[line[act3]][l]<<5;
   }
   act++;
   act3=act+act+act+2;
   for(l=0;l<8;l++) {
    entry[l]+=bbit[line[act3]][l]<<3;
   }
   act++;
   act3=act+act+act+2;
   for(l=0;l<8;l++) {
    entry[l]+=bbit[line[act3]][l]<<1;
   }
   act++;
   for(l=0;l<8;l++) bl[l][k]=entry[l];
  }
 }
 else {
  act=0;
  for(k=0;k<bn;k++) {
   act3=act+act+act+2;
   for(l=0;l<8;l++) {
    entry[l]=bbit[line[act3]][l]<<6;
   }
   act++;
   act3=act+act+act+2;
   for(l=0;l<8;l++) {
    entry[l]+=bbit[line[act3]][l]<<4;
   }
   act++;
   act3=act+act+act+2;
   for(l=0;l<8;l++) {
    entry[l]+=bbit[line[act3]][l]<<2;
   }
   act++;
   act3=act+act+act+2;
   for(l=0;l<8;l++) {
    entry[l]+=bbit[line[act3]][l];
   }
   act++;
   for(l=0;l<8;l++) bl[l][k]=entry[l];
  }
 }
 ind+=(ULONG)bn;
 for(k=0;k<8;k++) memcpy(&(theScreen->BitMap.Planes[k][ind]),bl[k],bn);
}

void SetLineS(int i,UBYTE *line,int width,int bn,UBYTE **bl) {
 register int k,act,l,act3;
 if(i%2!=0) return;

 /* rg */

 act=0;
 for(k=0;k<bn;k++) {
  act3=act+act+act;
  for(l=0;l<8;l++) {
   entry[l]=rbit[line[act3]][l]<<7;
   entry[l]+=gbit[line[act3+1]][l]<<6;
  }
  act+=2;
  act3=act+act+act;
  for(l=0;l<8;l++) {
   entry[l]+=rbit[line[act3]][l]<<5;
   entry[l]+=gbit[line[act3+1]][l]<<4;
  }
  act+=2;
  act3=act+act+act;
  for(l=0;l<8;l++) {
   entry[l]+=rbit[line[act3]][l]<<3;
   entry[l]+=gbit[line[act3+1]][l]<<2;
  }
  act+=2;
  act3=act+act+act;
  for(l=0;l<8;l++) {
   entry[l]+=rbit[line[act3]][l]<<1;
   entry[l]+=gbit[line[act3+1]][l];
  }
  act+=2;
  for(l=0;l<8;l++) bl[l][k]=entry[l];
 }
 ind=(ULONG)i*(ULONG)bn;
 for(k=0;k<8;k++) memcpy(&(theScreen->BitMap.Planes[k][ind]),bl[k],bn);

 /* b */
 if(i%4==0) {
  act=0;
  for(k=0;k<bn;k++) {
   act3=act+act+act+2;
   for(l=0;l<8;l++) {
    entry[l]=bbit[line[act3]][l]<<7;
   }
   act+=2;
   act3=act+act+act+2;
   for(l=0;l<8;l++) {
    entry[l]+=bbit[line[act3]][l]<<5;
   }
   act+=2;
   act3=act+act+act+2;
   for(l=0;l<8;l++) {
    entry[l]+=bbit[line[act3]][l]<<3;
   }
   act+=2;
   act3=act+act+act+2;
   for(l=0;l<8;l++) {
    entry[l]+=bbit[line[act3]][l]<<1;
   }
   act+=2;
   for(l=0;l<8;l++) bl[l][k]=entry[l];
  }
 }
 else {
  act=0;
  for(k=0;k<bn;k++) {
   act3=act+act+act+2;
   for(l=0;l<8;l++) {
    entry[l]=bbit[line[act3]][l]<<6;
   }
   act+=2;
   act3=act+act+act+2;
   for(l=0;l<8;l++) {
    entry[l]+=bbit[line[act3]][l]<<4;
   }
   act+=2;
   act3=act+act+act+2;
   for(l=0;l<8;l++) {
    entry[l]+=bbit[line[act3]][l]<<2;
   }
   act+=2;
   act3=act+act+act+2;
   for(l=0;l<8;l++) {
    entry[l]+=bbit[line[act3]][l];
   }
   act+=2;
   for(l=0;l<8;l++) bl[l][k]=entry[l];
  }
 }
 ind+=(ULONG)bn;
 for(k=0;k<8;k++) memcpy(&(theScreen->BitMap.Planes[k][ind]),bl[k],bn);
}

/* end independant mc-stuff */
