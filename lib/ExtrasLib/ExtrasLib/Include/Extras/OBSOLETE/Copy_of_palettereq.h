#ifndef EXTRAS_PALETTEREQ_H
#define EXTRAS_PALETTEREQ_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef EXTRAS_LAYOUTGT_H
#include <extras/layoutgt.h>
#endif

struct prRGB
{
  ULONG Red,
        Green,
        Blue;
};

struct PaletteRequest
{
  /* User supplied */
  struct Screen *pr_UserScreen;
  struct Window *pr_UserWindow;
  STRPTR pr_WindowTitle;
  UBYTE *pr_UserColorTable;
  struct TextAttr *pr_TextAttr;

  /* GUI */  
  struct Window   *pr_Window;
  struct Screen   *pr_Screen;
  struct ColorMap *pr_CMap;
  APTR            pr_VisualInfo;
  struct LG_Control *pr_GadControl;
  struct TextFont  *pr_TextFont;


  UBYTE   *pr_ColorTable;
  LONG    pr_Flags;
  
  LONG          pr_Colors;
  struct prRGB *pr_Palette,
               *pr_UndoPalette,
               *pr_InitialPalette;

  ULONG pr_RetVal,
        pr_Mode,
        pr_ModeColor;

  LONG  pr_RedLevel,
        pr_GreenLevel,
        pr_BlueLevel,
        pr_RedMax,
        pr_GreenMax,
        pr_BlueMax;

  UBYTE pr_RedBits,
        pr_GreenBits,
        pr_BlueBits;

  WORD  pr_RedMult,
        pr_GreenMult,
        pr_BlueMult;
  ULONG pr_End;
  ULONG pr_ActiveColor,
        pr_PrevColor;
  struct Menu *pr_MenuStrip;
  WORD  pr_PLeft, /* the color view thingy */
        pr_PTop,
        pr_PWidth,
        pr_PHeight;
  WORD  pr_WinLeft, /* -1 if not set */
        pr_WinTop,
        pr_WinWidth,
        pr_WinHeight,
        pr_MinWidth,
        pr_MinHeight;
  BOOL  pr_PalGo;
  BOOL  pr_V39;
  char  pr_FileName[513];
  struct   FileRequester *pr_FileReq;
  
};

// ASLFO_Window
#define PR_DUMMY        (TAG_USER)

#define PR_Window       (PR_DUMMY + 1)
#define PR_Screen       (PR_DUMMY + 2)
#define PR_TextAttr     (PR_DUMMY + 3) /* Required */
#define PR_Title        (PR_DUMMY + 4)

#define PR_InitialLeftEdge  (PR_DUMMY + 5)
#define PR_InitialTopEdge   (PR_DUMMY + 6)
#define PR_InitialWidth     (PR_DUMMY + 7)
#define PR_InitialHeight    (PR_DUMMY + 8)

#define PR_InitialPalette     (PR_DUMMY + 10)
#define PR_Colors             (PR_DUMMY + 11) /* Number of colors */
/* These 2 are exclusive, but are not required */
#define PR_ColorTable         (PR_DUMMY + 12) /* (UBYTE *) */
#define PR_ObtainPens         (PR_DUMMY + 13) /* If set, it will attempt to ObtainPens */

#define PR_RedBits            (PR_DUMMY + 20) /* Red bits, if not set, uses screens */
#define PR_GreenBits          (PR_DUMMY + 21) 
#define PR_BlueBits           (PR_DUMMY + 22)
#define PR_ModeIDRGBBits      (PR_DUMMY + 23) /* Sets the above according to the ModeID */

#endif /* EXTRAS_PALETTEREQ_H */
