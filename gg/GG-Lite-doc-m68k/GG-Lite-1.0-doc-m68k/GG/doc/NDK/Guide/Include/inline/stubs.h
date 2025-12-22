@DATABASE "gg:doc/NDK/Guide/Include/inline/stubs.h"
@MASTER   "gg:os-include/inline/stubs.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:45
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/stubs.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/stubs.h" LINK File}

@ENDNODE
@NODE File "inline/stubs.h"
#ifndef __INLINE_STUB_H
#define __INLINE_STUB_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#ifndef EXEC_NODES_H
#include <@{"exec/lists.h" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File"}>
#endif
#ifndef DOS_DOS_H
#include <@{"dos/dos.h" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File"}>
#endif
#ifndef INTUITION_CLASSES_H
#include <@{"intuition/classes.h" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File"}>
#endif
#ifndef GRAPHICS_DISPLAYINFO_H
#include <@{"graphics/displayinfo.h" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File"}>
#endif
#ifndef LIBRARIES_COMMODITIES_H
#include <@{"libraries/commodities.h" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File"}>
#endif

@{"struct AnchorPath" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 52};
struct AnimOb;
@{"struct AreaInfo" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 19};
struct BitMap;
@{"struct BitScaleArgs" LINK "gg:doc/NDK/Guide/Include/graphics/scale.h/File" 17};
struct Bob;
@{"struct Border" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 684};
struct Catalog;
@{"struct CardHandle" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 30};
struct ClipboardHandle;
@{"struct ClipRect" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 57};
struct ClockData;
@{"struct ColorMap" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 143};
struct ColorWheelRGB;
@{"struct ColorWheelHSB" LINK "gg:doc/NDK/Guide/Include/gadgets/colorwheel.h/File" 23};
struct ConfigDev;
@{"struct CSource" LINK "gg:doc/NDK/Guide/Include/dos/rdargs.h/File" 61};
struct CopList;
@{"struct CurrentBinding" LINK "gg:doc/NDK/Guide/Include/libraries/configvars.h/File" 61};
struct DataBase;
@{"struct DateStamp" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 52};
struct DateTime;
@{"struct Device" LINK "gg:doc/NDK/Guide/Include/exec/devices.h/File" 24};
struct DeviceNode;
@{"struct DeviceTData" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 38};
struct DiskObject;
@{"struct DosLibrary" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 237};
struct DosList;
@{"struct DevProc" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 421};
struct DosPacket;
@{"struct DrawInfo" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 66};
struct EasyStruct;
@{"struct EClockVal" LINK "gg:doc/NDK/Guide/Include/devices/timer.h/File" 35};
struct ExAllControl;
@{"struct ExAllData" LINK "gg:doc/NDK/Guide/Include/dos/exall.h/File" 45};
struct ExecBase;
@{"struct ExpansionBase" LINK "gg:doc/NDK/Guide/Include/libraries/expansionbase.h/File" 44};
struct FileInfoBlock;
@{"struct FileLock" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 456};
struct FileRequester;
@{"struct FontContentsHeader" LINK "gg:doc/NDK/Guide/Include/diskfont/diskfont.h/File" 53};
struct FreeList;
@{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214};
struct GadgetInfo;
@{"struct GelsInfo" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 37};
struct GlyphEngine;
@{"struct GlyphMap" LINK "gg:doc/NDK/Guide/Include/diskfont/glyph.h/File" 34};
struct GfxBase;
struct HelpNode;
struct Hook;
@{"struct IClass" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36};
struct Image;
@{"struct InfoData" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 147};
struct InputEvent;
@{"struct Interrupt" LINK "gg:doc/NDK/Guide/Include/exec/interrupts.h/File" 22};
struct IntuiText;
@{"struct IntuitionBase" LINK "gg:doc/NDK/Guide/Include/intuition/intuitionbase.h/File" 66};
struct IORequest;
@{"struct KeyMap" LINK "gg:doc/NDK/Guide/Include/devices/keymap.h/File" 21};
struct KeyQuery;
@{"struct Layer" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 27};
struct Layer_Info;
@{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34};
struct List;
@{"struct Locale" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 118};
struct LocaleBase;
@{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19};
struct MemHeader;
@{"struct MemList" LINK "gg:doc/NDK/Guide/Include/exec/memory.h/File" 56};
struct Menu;
@{"struct MenuItem" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 88};
struct Message;
struct MiscResource;
struct MsgPort;
@{"struct NamedObject" LINK "gg:doc/NDK/Guide/Include/utility/name.h/File" 25};
struct Node;
@{"struct NewAmigaGuide" LINK "gg:doc/NDK/Guide/Include/libraries/amigaguide.h/File" 103};
struct NewGadget;
@{"struct NewMenu" LINK "gg:doc/NDK/Guide/Include/libraries/gadtools.h/File" 114};
struct NewScreen;
@{"struct NewWindow" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1087};
struct NotifyRequest;
@{"struct Preferences" LINK "gg:doc/NDK/Guide/Include/intuition/preferences.h/File" 58};
struct RDArgs;
@{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52};
struct RealTimeBase;
@{"struct RecordLock" LINK "gg:doc/NDK/Guide/Include/dos/record.h/File" 27};
struct Rectangle;
@{"struct Region" LINK "gg:doc/NDK/Guide/Include/graphics/regions.h/File" 25};
struct Remember;
@{"struct Requester" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 144};
struct ReqToolsBase;
@{"struct Resident" LINK "gg:doc/NDK/Guide/Include/exec/resident.h/File" 18};
struct RexxMsg;
struct RomBootBase;
struct RxsLib;
@{"struct Screen" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 133};
struct Semaphore;
@{"struct SignalSemaphore" LINK "gg:doc/NDK/Guide/Include/exec/semaphores.h/File" 40};
struct SimpleSprite;
@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32};
struct Task;
@{"struct TextAttr" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 65};
struct TextExtent;
@{"struct TextFont" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 89};
struct timeval;
@{"struct UCopList" LINK "gg:doc/NDK/Guide/Include/graphics/copper.h/File" 89};
struct View;
@{"struct ViewPort" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 47};
struct VSprite;
struct WBObject;
struct Window;

@{"struct bltnode" LINK "gg:doc/NDK/Guide/Include/hardware/blit.h/File" 88};
struct cprlist;
@{"struct gpLayout" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 460};
struct dtPrint;

#endif /* __INLINE_STUB_H */
@ENDNODE
