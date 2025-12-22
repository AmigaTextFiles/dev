/* PPMView v0.3 (23 October 1995) - ©1995 by WK-Artworks */
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

int main(int argc,char **argv) {
 FILE *fh;
 char hs[64];
 UBYTE *bl[8];
 int width,height,i,qt=0,bn;
 UBYTE *line=NULL;
 struct IntuiMessage *imsg;
 ULONG iclass;
 USHORT icode;
 printf("\n PPMView v0.3 - ©1995 by WK-Artworks\n");
 printf("-------------------------------------\n");
 if(argc<2) {printf(" Usage: ppmview <ppm-file>\n");return(1);}
 fh=fopen(argv[1],"rb");
 if(fh==NULL) return(1);
 fscanf(fh,"%s",hs);

 fscanf(fh,"%s",hs);
 width=strtol(hs,NULL,10);
 fscanf(fh,"%s",hs);
 height=strtol(hs,NULL,10);
 fscanf(fh,"%s",hs);
 #ifdef __GNUC__
 fread(&i,1,1,fh);
 #endif
 printf(" Resolution : %dx%d\n",width,height);
 if(init(width,height)==0) {

  /* do it */
  bn=theScreen->BitMap.BytesPerRow;

  for(i=0;i<8;i++) {bl[i]=malloc(bn);if(bl[i]==NULL) return(1);}
  line=(UBYTE*)malloc(3*width);
  if(line==NULL) {fclose(fh);return(1);}
  time(&tm1);
  for(i=0;i<height;i++) {
   fread(line,1,3*width,fh);   
   SetLineS(i,line,width,bn,bl); 
  }

  time(&tm2);
  tm=difftime(tm2,tm1);
  printf(" Decode-time: %lds\n",(ULONG)tm);
  free(line);
  for(i=0;i<8;i++) free(bl[i]);
  fclose(fh);

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


