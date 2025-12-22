/* Copyright (c) 1997 Danny Y. Wong */
/* All Rights Reserved */

#include <exec/types.h>
#include <exec/memory.h>
#include <exec/ports.h>
#include <exec/devices.h>
#include <exec/io.h>
#include <dos/dos.h>
#include <graphics/gfxmacros.h>
#include <intuition/intuition.h>
#include <intuition/gadgetclass.h>
#include <intuition/imageclass.h>
#include <intuition/icclass.h>
#include <gadgets/listbrowser.h>
#include <gadgets/palette.h>
#include <gadgets/textfield.h>
#include <classes/requester.h>
#include <images/label.h>
#include <libraries/asl.h>
#include <libraries/gadtools.h>
#include <utility/tagitem.h>
#include <devices/audio.h>
#include <devices/narrator.h>
#include <clib/translator_protos.h>

#include <proto/asl.h>
#include <proto/dos.h>
#include <proto/diskfont.h>
#include <proto/exec.h>
#include <proto/gadtools.h>
#include <proto/graphics.h>
#include <proto/icon.h>
#include <proto/requester.h>
#include <proto/intuition.h>
#include <proto/utility.h>
#include <proto/wb.h>
#include <proto/palette.h>
#include <proto/textfield.h>
#include <proto/iffparse.h>

#include <classact.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include "stdlib.h"

/* file flags */

#define ASLFR_DOSAVEMODE                1
#define ASLFR_DOMULTISELECT             2
#define ASLFR_DOPATTERNS                4
#define ASLFR_DRAWERSONLY               8
#define ASLFR_REJECTICONS               16
#define ASLFR_FILTERDRAWERS             32
#define ASLFR_SLEEPWINDOW               64


extern BOOL MakeChooserList(struct List *list, UBYTE **labels);
extern VOID FreeChooserList(struct List *list);
extern BOOL MakeRadioList(struct List *list, UBYTE **labels);
extern VOID FreeRadioList(struct List *list);
extern BOOL MakeClickTabList(struct List *list, UBYTE **labels);
extern VOID FreeClickTabList(struct List *list);
extern VOID FreeListBrowserList(struct List *list);
extern BOOL MakeListBrowserList1(struct List *list, UBYTE **labels1);
extern BOOL MakeListBrowserList2(struct List *list, UBYTE **labels1, UBYTE **labels2);

extern int InitSpeech(void);
extern void DeInitSpeech(void);
extern int get_phoneme(UBYTE *in, short inlen, UBYTE *out, short outlen);
extern void talk_to_me(UBYTE *sentence, short vol, short rate, short sex);
extern int Speak(char sentence[], short vol, short rate, short sex);


