/* Example for   millibar.library */
/*                                */
/* By Stefan Popp 06/2001         */


#include "stdio.h"
#include <exec/types.h>
#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>
#include <graphics/gfxbase.h>
#include <stdlib.h>
#include <clib/exec_protos.h>
#include <clib/graphics_protos.h>
#include <clib/intuition_protos.h>

#include <exec/libraries.h>
#include <pragma/exec_lib.h>

#include "millibar.h"
#include "millibar_protos.h"
#include "millibar_lib.h"

struct Library *MBCBase;

main()
{


 struct NewScreen ns = {

 0,0,
 640,256,
 2,
 0,1,
 HIRES,
 CUSTOMSCREEN,
 NULL,
 (UBYTE *) "Millibar T E S T",
 NULL,
 NULL };

 struct Library *IntuitionBase, *gfxbase;
 struct Screen *screen;
 struct RastPort *rp;


 MBC_PAR mbc_par;
 char xx[10];


 if (!(IntuitionBase=OpenLibrary("intuition.library",39L)))
  exit (100);
 if (!(gfxbase=(struct Library*)OpenLibrary("graphics.library",39L)))
  exit(100);
 if (!(MBCBase=(struct Library*)OpenLibrary("millibar.library",1)))
  exit(100);

 screen = (struct Screen*) OpenScreen(&ns);

 rp = &screen->RastPort;

 mbc_par.rp       = rp;
 mbc_par.code     = "123456";
 mbc_par.xpos     = 50;
 mbc_par.ypos     = 50;
 mbc_par.yscale   = 100;
 mbc_par.xscale   = 3;
 mbc_par.codetype = CODABAR;

 mbc_draw_code_e ( &mbc_par );

 scanf("%s",xx);

 CloseScreen(screen);

 CloseLibrary(IntuitionBase);

 CloseLibrary(gfxbase);
 CloseLibrary(MBCBase);

}
