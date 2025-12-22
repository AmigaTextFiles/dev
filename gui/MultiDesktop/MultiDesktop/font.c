#include <exec/types.h>
#include <graphics/rastport.h>
#include <graphics/text.h>
#include <libraries/diskfont.h>

APTR DiskfontBase;
APTR GfxBase;

struct RastPort *rp,xrp;
struct TextAttr  attr={0L,0,FS_NORMAL,FPF_DISKFONT};
struct TextFont *font;

UBYTE *TestText="abcdefghijklmnopqrstuvwxyz  -  1234567890 #,.;:*+^/*?!|$%&()= <> ABCDEFGHIJKLMNOPQRSTUVWXYZ öäüÄÖÜß";

void main(argc,argv)
 int argc;
 UBYTE *argv[];
{
 long i,j;

 if(argc!=3)
  {
   puts("Usage: Font [name] [size]");
   exit(0);
  }

 GfxBase=OpenLibrary("graphics.library",0L);
 DiskfontBase=OpenLibrary("diskfont.library",0L);

 rp=&xrp;
 InitRastPort(rp);

 attr.ta_Name=argv[1];
 attr.ta_YSize=atol(argv[2]);

 font=OpenDiskFont(&attr);
 if(font!=NULL)
  {
   SetFont(rp,font);

   i=TextLength(rp,TestText,strlen(TestText));
   printf("H=%5ld\nV=%5ld\n",i,font->tf_YSize);

   CloseFont(font);
  }
 else
  {
   puts("Unable to open font!");
  }

 CloseLibrary(DiskfontBase);
 CloseLibrary(GfxBase);
}

