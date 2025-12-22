#define DEBUG
#include <debug.h>

#include <clib/extras_protos.h>

#include <proto/diskfont.h>
#include <proto/dos.h>
#include <proto/exec.h>
#include <proto/gadtools.h>
#include <proto/graphics.h>
#include <proto/intuition.h>
#include <proto/utility.h>

void Bases(void)
{
  DKP("DiskfontBase   =%8lx\n",DiskfontBase);
  DKP("DOSBase        =%8lx\n",DOSBase);
  DKP("GadToolsBase   =%8lx\n",GadToolsBase);
  DKP("GfxBase        =%8lx\n",GfxBase);
  DKP("IntuitionBase  =%8lx\n",IntuitionBase);
  DKP("UtilityBase    =%8lx\n",UtilityBase);
}

