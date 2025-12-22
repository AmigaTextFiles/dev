/*----------------------------------------------------------------------*
  defs.h version 2.3 -  © Copyright 1990-91 Jaba Development

  Author : Jan van den Baard
  Purpose: headerfile for making a pre-copiled symbol file (Aztec V5.0a)
 *----------------------------------------------------------------------*/
#include <exec/types.h>
#include <exec/memory.h>
#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>
#include <libraries/dos.h>
#include <libraries/dosextens.h>
#include <workbench/workbench.h>
#include <workbench/startup.h>
#include <workbench/icon.h>
#include <functions.h>
#include <tool.h>               /* tool.library V8++ !!! */

#define AND     &&
#define OR      ||

#define Alloc(c,s)    AllocItem(c,(ULONG)s,MEMF_PUBLIC|MEMF_CLEAR)

struct BitMapHeader
        {
         UWORD  w,h;
         WORD   x,y;
         UBYTE  nPlanes;
         UBYTE  masking;
         UBYTE  compression;
         UBYTE  pad1;
         UWORD  transparentColor;
         UBYTE  xAspect, yAspect;
         WORD   pageWidth, pageHeight;
        };

struct FORMChunk
        {
         ULONG  fc_Type;
         ULONG  fc_Length;
         ULONG  fc_SubType;
        };

struct IFFChunk
        {
         ULONG  ic_Type;
         ULONG  ic_Length;
        };

#define bpr(w)  (((w+15)>>4)<<1)

#define RENDER  0
#define SELECT  1
#define STDPRP  2

#define TXT_ADD     0
#define TXT_MOVE    1
#define TXT_MODIFY  2
#define TXT_DELETE  3

#define TITLE ((UBYTE *)"GadgetEd V2.3 © Jaba Development")

#define OLDTYPE   ((ULONG)'EGAD')
#define TYPE      ((ULONG)'EG2+')

struct ge_prefs
 {
  BOOL      skip_zero_planes;
  BOOL      auto_size;
  BOOL      image_copy;
  BOOL      text_copy;
  BOOL      static_structures;
  BOOL      no_flags;
  BOOL      res[2];
 };

#define GE_VERSION  2
#define GE_REVISION 3

struct BinHeader
 {
  ULONG           FileType;
  USHORT          Version;
  USHORT          Revision;
  USHORT          NumGads;
  USHORT          ScrDepth;
  BOOL            ReqGads;
  BOOL            WBScreen;
  USHORT          NumTexts;
  USHORT          Colors[32];
  USHORT          FPen;
  USHORT          BPen;
  USHORT          BackFill;
  USHORT          WDBackFill;
  USHORT          LightSide;
  USHORT          DarkSide;
  USHORT          Res[2];
 };

#define GADGETOFF       0x0001
#define BORDERONLY      0x0002
#define NOSIGNAL        0x0004
#define IMAGEONLY       0x0008      /* not yet implemented! */
#define NOBORDER        0x0010
#define OS20BORDER      0x0020
#define MAXLABEL        32

struct MyGadget
 {
  struct MyGadget   *Succ;
  struct MyGadget   *Pred;
  struct Gadget      Gadget;
  USHORT             SpecialFlags;
  UBYTE              GadgetLabel[MAXLABEL];
 };

struct GadgetList
 {
  struct MyGadget   *Head;
  struct MyGadget   *Tail;
  struct MyGadget   *TailPred;
 };

#define ESC         0x45
#define F1          0x50
#define F2          0x51
#define F3          0x52
#define F4          0x53
#define F5          0x54
#define F6          0x55
#define F7          0x56
#define F8          0x57
#define F9          0x58
#define F10         0x59
#define HELP        0x5F
