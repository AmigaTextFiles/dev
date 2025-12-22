#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/commodities.h>
#include <proto/locale.h>
#include <proto/datatypes.h>
#include <proto/classes/supermodel.h>

#include <clib/extras/exec_protos.h>

struct ExecBase       *SysBase;
struct GfxBase        *GfxBase;
struct IntuitionBase  *IntuitionBase;
struct Library        *UtilityBase;
struct LocaleBase     *LocaleBase;
struct Library  
                *ButtonBase,
                *IntegerBase,
                *LayoutBase,
                *TCPaletteBase,
                *SliderBase,
                *SpaceBase,

                *BevelBase,
                *LabelBase,
                            
                *WindowBase,                            
                
                *SuperModelBase;
                
struct LocaleBase *LocaleBase;

struct Libs MyLibs[]=
{
  (APTR *)&DataTypesBase, "datatypes.library",          39,     0,
  (APTR *)&GfxBase,       "graphics.library",           39,     0,
  (APTR *)&IntuitionBase, "intuition.library",          39,     0,
  (APTR *)&LocaleBase,    "locale.library",             39,     0,
  (APTR *)&UtilityBase,   "utility.library",            39,     0,

  (APTR *)&ButtonBase,        "gadgets/button.gadget",          44,     0,
  (APTR *)&LayoutBase,        "gadgets/layout.gadget",          44,     0,
  (APTR *)&TCPaletteBase,     "gadgets/tcpalette.gadget",       44,     0,
  (APTR *)&SliderBase,        "gadgets/slider.gadget",          44,     0,
  (APTR *)&SpaceBase,         "gadgets/space.gadget",           44,     0,

  (APTR *)&BevelBase,         "images/bevel.image",             44,     0,
  (APTR *)&LabelBase,         "images/label.image",             44,     0,

  (APTR *)&WindowBase,        "window.class",                   44,     0,
  (APTR *)&SuperModelBase,    "supermodel.class",               44,     0,

  0
};

                      
                      

BOOL i_OpenLibs(void)
{
  ULONG *LongMem=0;

  SysBase=(APTR)LongMem[1];

 	return(ex_OpenLibs(0, "MPEditor", 0,0,0, MyLibs));
}

void i_CloseLibs(void)
{
  ex_CloseLibs(MyLibs);
}


