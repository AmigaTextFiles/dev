/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * qlbs.h
 *
 * --- LICENSE --------------------------------------------------------
 *
 * 'QLBS'   is   free  software;  you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the  Free  Software  Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * 'QLBS'   is   distributed  in  the  hope  that  it  will  be useful,
 * but  WITHOUT  ANY  WARRANTY;  without  even  the implied warranty of
 * MERCHANTABILITY  or  FITNESS  FOR  A  PARTICULAR  PURPOSE.  See  the
 * GNU General Public License for more details.
 *
 * You  should  have  received a copy of the GNU General Public License
 * along  with  'qdev';  if not, write to the Free Software Foundation,
 * Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301   USA
 *
 * --- VERSION --------------------------------------------------------
 *
 * $VER: qlbs.h 1.4 (21/09/2014) QLBS
 * AUTH: lbasegen
 *
 * --- COMMENT --------------------------------------------------------
 *
 * This file was generated automatically.
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#ifndef ___QLBS_H_INCLUDED___
#define ___QLBS_H_INCLUDED___

#ifndef ___QLBS_NOMACROS

#define ___QLBS_NT_LOCALBASE 109
#define ___QLBS_NT_LOCALVECT 119

#ifndef ___QLBS_SYMATTRS
#define ___QLBS_SYMATTRS __attribute__((unused))
#endif

#ifndef ___QLBS_SYMCAST
#define ___QLBS_SYMCAST *(void **)
#endif

#ifndef ___QLBS_SYMPREFIX
#define ___QLBS_SYMPREFIX L_
#endif

#define ___QLBS_MAKESTR(in) __QLBS_MAKESTR(in)
#define __QLBS_MAKESTR(in) #in

#define ___QLBS_PRIBASE(ptr) __QLBS_PRIBASE(ptr)
#define __QLBS_PRIBASE(ptr)                               \
(typeof(ptr))(*(void **)((struct Node *)ptr)->ln_Pred)

#define ___QLBS_SECBASE(ptr) __QLBS_SECBASE(ptr)
#define __QLBS_SECBASE(ptr)                               \
(typeof(ptr))(((struct Node *)ptr)->ln_Succ)

#define ___QLBS_BASEDECL(p, t, b, a, i...)                \
__QLBS_BASEDECL(, p, t, b, a, ##i)
#define __QLBS_BASEDECL(x, p, t, b, a, i...)              \
t a b =___QLBS_PRIBASE(##i##)##x;t p##b =___QLBS_SECBASE(##i##)##x

#define ___QLBS_BASEDECL2(p, t, b, a, i...)               \
__QLBS_BASEDECL2(, p, t, b, a, ##i)
#define __QLBS_BASEDECL2(x, p, t, b, a, i...)             \
t a b =##i;t p##b = (typeof(b))&b

#ifndef ___QLBS_BASELOCAL
#define ___QLBS_BASELOCAL(c, p, b) __QLBS_BASELOCAL(c, p, b)
#define __QLBS_BASELOCAL(c, p, b) c##p##b
#endif

#ifndef QBASEDECL
#define QBASEDECL(t, b, i...)                             \
___QLBS_BASEDECL(___QLBS_SYMPREFIX, t, b, ___QLBS_SYMATTRS, ##i)
#endif
#ifndef QBASEDECL2
#define QBASEDECL2(t, b, i...)                            \
___QLBS_BASEDECL2(___QLBS_SYMPREFIX, t, b, ___QLBS_SYMATTRS, ##i)
#endif

#ifndef QBASEASSIGN
#define QBASEASSIGN(b, i)                                 \
___QLBS_BASEDECL(___QLBS_SYMPREFIX,, b,, i)
#endif
#ifndef QBASEASSIGN2
#define QBASEASSIGN2(b, i)                                \
___QLBS_BASEDECL2(___QLBS_SYMPREFIX,, b,, i)
#endif

#ifndef QBASELOCAL
#define QBASELOCAL(b)                                     \
___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, b)
#endif

#ifndef QBASEPOINTER
#define QBASEPOINTER(b)                                   \
(typeof(b))&___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, b)
#endif

#ifndef QBASEJUMPTAB
#define QBASEJUMPTAB(b)                                   \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, b)
#endif

#ifndef QBASESLOTS
#define QBASESLOTS(b, p...) _QBASESLOTS(, b, ##p)
#define _QBASESLOTS(x, b, p...)                           \
(b##_SLOTS + (b##_SLOTS *##p## *656##x >> 16))
#endif

#endif /* ___QLBS_NOMACROS */

#ifndef ___QLBS_NOALIASES

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, MathTransBase);
#define MATHTRANS_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, MathTransBase)
#define MathTransBase_SLOTS 21   /* No FD file found! */

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, MathIeeeSingTransBase);
#define MATHIEEESINGTRANS_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, MathIeeeSingTransBase)
#define MathIeeeSingTransBase_SLOTS 21   /* No FD file found! */

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, MathIeeeSingBasBase);
#define MATHIEEESINGBAS_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, MathIeeeSingBasBase)
#define MathIeeeSingBasBase_SLOTS 16   /* No FD file found! */

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, MathIeeeDoubTransBase);
#define MATHIEEEDOUBTRANS_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, MathIeeeDoubTransBase)
#define MathIeeeDoubTransBase_SLOTS 21   /* No FD file found! */

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, MathIeeeDoubBasBase);
#define MATHIEEEDOUBBAS_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, MathIeeeDoubBasBase)
#define MathIeeeDoubBasBase_SLOTS 16   /* No FD file found! */

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, MathBase);
#define MATHFFP_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, MathBase)
#define MathBase_SLOTS 16   /* No FD file found! */

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, CyberGfxBase);
#define CYBERGRAPHICS_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, CyberGfxBase)
#define CyberGfxBase_SLOTS 33

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, NeuralBase);
#define NEURALNET_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, NeuralBase)
#define NeuralBase_SLOTS 24

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, MysticBase);
#define MYSTICVIEW_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, MysticBase)
#define MysticBase_SLOTS 13

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, ScreenNotifyBase);
#define SCREENNOTIFY_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, ScreenNotifyBase)
#define ScreenNotifyBase_SLOTS 10

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, PopupMenuBase);
#define PM_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, PopupMenuBase)
#define PopupMenuBase_SLOTS 25   /* No FD file found! */

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, RenderBase);
#define RENDER_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, RenderBase)
#define RenderBase_SLOTS 56

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, NewIconBase);
#define NEWICON_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, NewIconBase)
#define NewIconBase_SLOTS 13

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, GuiGFXBase);
#define GUIGFX_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, GuiGFXBase)
#define GuiGFXBase_SLOTS 31

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, MMUBase);
#define MMU_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, MMUBase)
#define MMUBase_SLOTS 67

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, AHIsubBase);
#define AHI_SUB_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, AHIsubBase)
#define AHIsubBase_SLOTS 19

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, AHIBase);
#define AHI_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, AHIBase)
#define AHIBase_SLOTS 27

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, WindowBase);
#define WINDOW_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, WindowBase)
#define WindowBase_SLOTS 5

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, AmlBase);
#define AML_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, AmlBase)
#define AmlBase_SLOTS 62

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, ARexxBase);
#define AREXX_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, ARexxBase)
#define ARexxBase_SLOTS 5

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, BevelBase);
#define BEVEL_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, BevelBase)
#define BevelBase_SLOTS 5

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, BitMapBase);
#define BITMAP_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, BitMapBase)
#define BitMapBase_SLOTS 5

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, ButtonBase);
#define BUTTON_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, ButtonBase)
#define ButtonBase_SLOTS 5

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, CheckBoxBase);
#define CHECKBOX_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, CheckBoxBase)
#define CheckBoxBase_SLOTS 5

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, ChooserBase);
#define CHOOSER_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, ChooserBase)
#define ChooserBase_SLOTS 9

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, ClickTabBase);
#define CLICKTAB_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, ClickTabBase)
#define ClickTabBase_SLOTS 9

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, DateBrowserBase);
#define DATEBROWSER_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, DateBrowserBase)
#define DateBrowserBase_SLOTS 8

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, DrawListBase);
#define DRAWLIST_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, DrawListBase)
#define DrawListBase_SLOTS 5

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, FuelGaugeBase);
#define FUELGAUGE_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, FuelGaugeBase)
#define FuelGaugeBase_SLOTS 5

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, GetFileBase);
#define GETFILE_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, GetFileBase)
#define GetFileBase_SLOTS 5

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, GetFontBase);
#define GETFONT_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, GetFontBase)
#define GetFontBase_SLOTS 5

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, GetScreenModeBase);
#define GETSCREENMODE_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, GetScreenModeBase)
#define GetScreenModeBase_SLOTS 5

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, IntegerBase);
#define INTEGER_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, IntegerBase)
#define IntegerBase_SLOTS 5

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, LabelBase);
#define LABEL_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, LabelBase)
#define LabelBase_SLOTS 5

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, LayoutBase);
#define LAYOUT_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, LayoutBase)
#define LayoutBase_SLOTS 12

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, ListBrowserBase);
#define LISTBROWSER_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, ListBrowserBase)
#define ListBrowserBase_SLOTS 20

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, PaletteBase);
#define PALETTE_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, PaletteBase)
#define PaletteBase_SLOTS 5

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, PenMapBase);
#define PENMAP_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, PenMapBase)
#define PenMapBase_SLOTS 5

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, PopCycleBase);
#define POPCYCLE_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, PopCycleBase)
#define PopCycleBase_SLOTS 9

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, RadioButtonBase);
#define RADIOBUTTON_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, RadioButtonBase)
#define RadioButtonBase_SLOTS 9

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, RequesterBase);
#define REQUESTER_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, RequesterBase)
#define RequesterBase_SLOTS 5

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, ResourceBase);
#define RESOURCE_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, ResourceBase)
#define ResourceBase_SLOTS 12

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, ScrollerBase);
#define SCROLLER_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, ScrollerBase)
#define ScrollerBase_SLOTS 5

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, SliderBase);
#define SLIDER_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, SliderBase)
#define SliderBase_SLOTS 5

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, SpaceBase);
#define SPACE_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, SpaceBase)
#define SpaceBase_SLOTS 5

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, SpeedBarBase);
#define SPEEDBAR_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, SpeedBarBase)
#define SpeedBarBase_SLOTS 9

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, StringBase);
#define STRING_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, StringBase)
#define StringBase_SLOTS 5

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, TextFieldBase);
#define TEXTEDITOR_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, TextFieldBase)
#define TextFieldBase_SLOTS 5

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, AmigaGuideBase);
#define AMIGAGUIDE_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, AmigaGuideBase)
#define AmigaGuideBase_SLOTS 35

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, AslBase);
#define ASL_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, AslBase)
#define AslBase_SLOTS 14

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, BattClockBase);
#define BATTCLOCK_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, BattClockBase)
#define BattClockBase_SLOTS 5

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, BattMemBase);
#define BATTMEM_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, BattMemBase)
#define BattMemBase_SLOTS 4

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, BulletBase);
#define BULLET_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, BulletBase)
#define BulletBase_SLOTS 10

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, ColorWheelBase);
#define COLORWHEEL_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, ColorWheelBase)
#define ColorWheelBase_SLOTS 6

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, CxBase);
#define COMMODITIES_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, CxBase)
#define CxBase_SLOTS 39

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, DataTypesBase);
#define DATATYPES_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, DataTypesBase)
#define DataTypesBase_SLOTS 54

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, DiskBase);
#define DISK_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, DiskBase)
#define DiskBase_SLOTS 6

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, DiskfontBase);
#define DISKFONT_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, DiskfontBase)
#define DiskfontBase_SLOTS 11

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, DOSBase);
#define DOS_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, DOSBase)
#define DOSBase_SLOTS 175

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, DOSPathBase);
#define DOSPATH_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, DOSPathBase)
#define DOSPathBase_SLOTS 13   /* No FD file found! */

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, DTClassBase);
#define DTCLASS_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, DTClassBase)
#define DTClassBase_SLOTS 5

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, SysBase);
#define EXEC_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, SysBase)
#define SysBase_SLOTS 162

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, ExpansionBase);
#define EXPANSION_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, ExpansionBase)
#define ExpansionBase_SLOTS 27

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, GadToolsBase);
#define GADTOOLS_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, GadToolsBase)
#define GadToolsBase_SLOTS 29

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, GlyphBase);
#define GLYPH_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, GlyphBase)
#define GlyphBase_SLOTS 5

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, GfxBase);
#define GRAPHICS_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, GfxBase)
#define GfxBase_SLOTS 176

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, IconBase);
#define ICON_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, IconBase)
#define IconBase_SLOTS 33

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, IFFParseBase);
#define IFFPARSE_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, IFFParseBase)
#define IFFParseBase_SLOTS 45

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, InputBase);
#define INPUT_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, InputBase)
#define InputBase_SLOTS 7

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, IntuitionBase);
#define INTUITION_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, IntuitionBase)
#define IntuitionBase_SLOTS 138

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, KeymapBase);
#define KEYMAP_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, KeymapBase)
#define KeymapBase_SLOTS 8

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, LayersBase);
#define LAYERS_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, LayersBase)
#define LayersBase_SLOTS 36

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, LocaleBase);
#define LOCALE_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, LocaleBase)
#define LocaleBase_SLOTS 36

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, LowLevelBase);
#define LOWLEVEL_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, LowLevelBase)
#define LowLevelBase_SLOTS 27

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, VirtualBase);
#define VIRTUAL_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, VirtualBase)
#define VirtualBase_SLOTS 7

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, MiscBase);
#define MISC_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, MiscBase)
#define MiscBase_SLOTS 2

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, NVBase);
#define NONVOLATILE_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, NVBase)
#define NVBase_SLOTS 11

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, PotgoBase);
#define POTGO_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, PotgoBase)
#define PotgoBase_SLOTS 3

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, RealTimeBase);
#define REALTIME_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, RealTimeBase)
#define RealTimeBase_SLOTS 14

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, RexxSysBase);
#define REXXSYSLIB_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, RexxSysBase)
#define RexxSysBase_SLOTS 76

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, TimerBase);
#define TIMER_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, TimerBase)
#define TimerBase_SLOTS 11

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, TranslatorBase);
#define TRANSLATOR_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, TranslatorBase)
#define TranslatorBase_SLOTS 5

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, UMSBase);
#define UMS_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, UMSBase)
#define UMSBase_SLOTS 52   /* No FD file found! */

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, UtilityBase);
#define UTILITY_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, UtilityBase)
#define UtilityBase_SLOTS 50

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, WorkbenchBase);
#define WB_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, WorkbenchBase)
#define WorkbenchBase_SLOTS 22

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, WBStartBase);
#define WBSTART_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, WBStartBase)
#define WBStartBase_SLOTS 6   /* No FD file found! */

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, SocketBase);
#define SOCKET_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, SocketBase)
#define SocketBase_SLOTS 50

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, AmiSSLMasterBase);
#define AMISSLMASTER_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, AmiSSLMasterBase)
#define AmiSSLMasterBase_SLOTS 9   /* No FD file found! */

extern void *___QLBS_BASELOCAL(, ___QLBS_SYMPREFIX, AmiSSLBase);
#define AMISSL_BASE_NAME \
___QLBS_BASELOCAL(___QLBS_SYMCAST, ___QLBS_SYMPREFIX, AmiSSLBase)
#define AmiSSLBase_SLOTS 2529   /* No FD file found! */

#endif /* ___QLBS_NOALIASES */

#endif /* ___QLBS_H_INCLUDED___ */
