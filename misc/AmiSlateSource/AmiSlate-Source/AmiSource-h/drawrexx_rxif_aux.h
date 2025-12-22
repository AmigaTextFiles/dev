/* Things we want to include in drawrexx_rxif.c but don't
   want overwritten */
   
#include <clib/intuition_protos.h>
#include <clib/graphics_protos.h>
#include <intuition/intuition.h>
#include <devices/timer.h>

#include "drawrexx.h"
#include "drawrexx_aux.h"
#include "amislate.h"
#include "tools.h"
#include "palette.h"
#include "drawlang.h"
#include "drawtcp.h"
#include "remote.h"
#include "flood.h"
#include "asl.h"
#include "StringRequest.h"

extern struct PaintInfo PState;
extern struct Window *DrawWindow;
extern struct Screen *Scr;
extern BOOL BSafeFloods;
extern BOOL BNetConnect;
extern BOOL BProgramDone;
extern BOOL BPalettesLocked;
extern char targethost[80];
extern FILE *fpOut;
extern char szSendString[256], szReceiveString[256];
extern int Not[2];
extern char szVersionString[];
extern struct timerequest *TimerIO;

__chip extern UBYTE waitPointer[];

int XRexxPen = -1, YRexxPen = -1;

extern BYTE bFloodFromCode;
extern BOOL BIFFLoadPending;
extern BOOL BRexxProtectInter, BRexxExpand, BRexxLoadPalette;

