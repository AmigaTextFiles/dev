#include <extras/progressmeter.h>

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef INTUITION_INTUITION_H
#include <intuition/intuition.h>
#endif

#ifndef GRAPHICS_TEXT_H
#include <graphics/text.h>
#endif
  
/***************/
/*** PRIVATE ***/
/***************/

struct _ProgressMeter
{
  struct Window   *pm_MeterWindow,  
                  *pm_ParentWindow;
  struct Screen   *pm_Screen;
  struct TextFont *pm_Font;
  APTR   pm_VisualInfo;
  struct Gadget   *pm_GList,
                  *pm_GTGads[1];
  struct DrawInfo *pm_DrawInfo;
  WORD   pm_BarLeftEdge,  pm_BarTopEdge,        /* dimensions of the indicator bar */
         pm_BarWidth, pm_BarHeight;
  STRPTR pm_MeterLabel,
         pm_MeterFormat,
         pm_LowText,
         pm_HighText,
         pm_CancelText;
  LONG   pm_MeterType,
         pm_MeterValue,
         pm_LowValue,
         pm_HighValue,
         pm_NumTicks,
         pm_FormatPen,
         pm_MeterPen,
         pm_MeterBgPen,
         pm_MeterLabelPen,
         pm_LowTextPen,
         pm_HighTextPen;
  WORD   pm_MeterCenter,
         pm_LowCenter,
         pm_HighCenter,
         pm_LabelY,
         pm_HiLowY;
};

/* #undef ProgressMeter*/
/*typedef struct ProgressMeter *  ProgressMeter;*/
