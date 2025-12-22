#ifndef CLIB_EXTRAS_PROTOS_H
#define CLIB_EXTRAS_PROTOS_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef DOS_DOS_H
#include <dos/dos.h>
#endif

#ifndef INTUITION_INTUITION_H
#include <intuition/intuition.h>
#endif

#ifndef LIBRARIES_GADTOOLS_H
#include <libraries/gadtools.h>
#endif

#ifndef LIBRARIES_COMMODITIES_H
#include <libraries/commodities.h>
#endif

#ifndef	GRAPHICS_TEXT_H
#include <graphics/text.h>
#endif

#ifndef EXTRAS_GUI_H
#include <extras/gui.h>
#endif

/***** More protos *****/

#ifndef CLIB_EXTRAS_BOOPSI_PROTOS_H
#include <clib/extras/boopsi_protos.h>
#endif

#ifndef CLIB_EXTRAS_DB_PROTOS_H
#include <clib/extras/db_protos.h>
#endif

#ifndef CLIB_EXTRAS_EXEC_PROTOS_H
#include <clib/extras/exec_protos.h>
#endif

#ifndef CLIB_EXTRAS_GUI_PROTOS_H
#include <clib/extras/gui_protos.h>
#endif

#ifndef CLIB_EXTRAS_INTUITION_PROTOS_H
#include <clib/extras/intuition_protos.h>
#endif

/*
#ifndef CLIB_EXTRAS_LAYOUTBOXES_PROTOS_H
#include <clib/extras/layoutboxes_protos.h>
#endif
*/

#ifndef CLIB_EXTRAS_GADTOOLS_PROTOS_H
#include <clib/extras/layoutgt_protos.h>
#endif

#ifndef CLIB_EXTRAS_PROGRESSMETER_PROTOS_H
#include <clib/extras/progressmeter_protos.h>
#endif

#ifndef CLIB_EXTRAS_NNSTRING_PROTOS_H
#include <clib/extras/nnstring_protos.h>
#endif

#ifndef CLIB_EXTRAS_STRING_PROTOS_H
#include <clib/extras/string_protos.h>
#endif

/**** Misc Interface ()'s ****/
CxObj *AddHotKey(CxObj *Broker,struct MsgPort *BrokerPort,UBYTE *HotKey,ULONG ID);

struct Requester *Busy(struct Window *w);
void NotBusy(struct Window *w,struct Requester *);


struct Gadget *MakeGadgets(struct Screen    *Scr,
                           APTR             VisualInfo,
                           ULONG            NumGadgets,
                           struct NewGadget *NewGads,
                           ULONG            *NewGadTags,
                           ULONG            *NewGadTypes,
                           struct Gadget    **Gadgets,
                           struct TextAttr  *TA,
                           float            XMult,
                           float            YMult);







BOOL ArgYesNo(UBYTE **TTypes, STRPTR Entry,BOOL DefVal);
           
/*** iffx.o ***/
LONG WriteDataChunk(struct IFFHandle *IFF, Tag Tags, ... );
LONG WriteDataChunkA(struct IFFHandle *IFF, struct TagItem *TagList);

APTR ReadDataChunk(APTR Data, Tag Tags, ... );
APTR ReadDataChunkA(APTR Data, struct TagItem *TagList);

/*** Find a line in a file */
LONG FindLine(BPTR File, STRPTR Name, STRPTR Buffer, ULONG BufferSize);

LONG key_Unshifted(UBYTE C);
LONG key_Shifted(UBYTE C);

void Bases(void);

#endif
