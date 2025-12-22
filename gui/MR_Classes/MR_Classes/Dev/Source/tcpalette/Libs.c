#include "private.h"
#include <extras/libs.h>

struct ExecBase       *SysBase;
struct GfxBase        *GfxBase;
struct IntuitionBase  *IntuitionBase;
struct Library        *UtilityBase;
struct LocaleBase     *LocaleBase;
struct Library  *BevelBase,
                *LabelBase,
                *CyberGfxBase,
                *DitherRectBase,
                *KeymapBase;
                            
                
struct LocaleBase *LocaleBase;

struct Libs MyLibs[]=
{
  (APTR *)&CyberGfxBase,  "cybergraphics.library",      39,     OLF_OPTIONAL,
  (APTR *)&GfxBase,       "graphics.library",           39,     0,
  (APTR *)&IntuitionBase, "intuition.library",          39,     0,
  (APTR *)&LocaleBase,    "locale.library",             39,     0,
  (APTR *)&UtilityBase,   "utility.library",            39,     0,
  (APTR *)&KeymapBase,    "keymap.library",            39,     0,


  (APTR *)&BevelBase,     "images/bevel.image",         44,     0,
  (APTR *)&LabelBase,     "images/label.image",         44,     0,

  (APTR *)&DitherRectBase,  "images/mlr_ordered.pattern",    1,     OLF_OPTIONAL,
  0
};

                      
                      

BOOL i_OpenLibs(void)
{
  ULONG *LongMem=0;

  SysBase=(APTR)LongMem[1];

 	return(ex_OpenLibs(0, "TCPalette.Gadget", 0,0,0, MyLibs));
}

void i_CloseLibs(void)
{
  ex_CloseLibs(MyLibs);
}



