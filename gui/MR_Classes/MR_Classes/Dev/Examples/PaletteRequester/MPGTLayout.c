#include <proto/intuition.h>
#include <proto/exec.h>
#include <proto/gadtools.h>
#include <proto/modepro.h>
#include <classes/requesters/palette.h>
#include <proto/classes/requesters/palette.h>
#include <clib/alib_protos.h>

#include <utility/tagitem.h>


#include <stdio.h>



struct Library *PaletteRequesterBase;

void main(void)
{
  ULONG l;
  struct prRGB pal[256];
    
  if(PaletteRequesterBase=OpenLibrary("sys:classes/requesters/palette.requester",1))
  {
    Object *o;
    
    o=PREQ_NewRequester(PR_Colors, 256, PR_PubScreenName, "Workbench",TAG_DONE);
    {
      DoMethod(o,RM_DOREQUEST,0);

      GetAttr(PR_Palette, o, pal);
        
/*      for(l=0;l<16;l++)
      {
        printf("PR_Palette %d R:%08x G:%08x B:%08x\n",l,pal[l].Red,pal[l].Green,pal[l].Blue);
      }*/
      
      SetAttrs(o, PR_Palette, pal, TAG_DONE);
      
      DoMethod(o,RM_DOREQUEST,0);


      PREQ_DisposeRequester(o);
    }
    CloseLibrary(PaletteRequesterBase);
  }
}

