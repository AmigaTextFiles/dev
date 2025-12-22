#ifndef  WFIBASE_H
#define  WFIBASE_H

#include <exec/types.h>
#include <exec/libraries.h>
#include <graphics/gfxbase.h>

#include <intuition/intuition.h>
#include <intuition/classes.h>
#include <intuition/classusr.h>
#include <intuition/imageclass.h>
#include <dos.h>

#include "compiler.h"


struct waveformData
{
   struct DrawInfo     *wf_DrawInfo;
   LONG                 wf_WaveShape;
   LONG                 wf_WaveType;
   LONG                 wf_Outline;
   LONG                 wf_BoxFrame;         /* whether to frame the graphic or NOT */
   WORD                 wf_ShadowPen;        /* used for box outline shadow */
   WORD                 wf_HiLitePen;        /*    ...same for highlighting */
   WORD                 wf_WavePen;
   WORD                 wf_ZeroPen;
   WORD                 wf_OsciPen;          /* see user tags below */
   WORD                 wf_Pad;
};


struct WFIBase
{
   struct Library          wfi_Lib;          /* Node (14) -> Library (34) */
   UWORD                   wfi_padword;
   ULONG                   wfi_SegList;
   struct SignalSemaphore  wfi_LibLock;
   Class                  *wfi_WFIClass;
   struct Library         *wfi_SysBase;
   struct Library         *wfi_IntuitionBase;
   struct Library         *wfi_GfxBase;
   struct Library         *wfi_UtilityBase;
};


#endif /* WFIBASE_H */


