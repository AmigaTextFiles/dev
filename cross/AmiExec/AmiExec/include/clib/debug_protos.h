/****************************************************************************

$Source: MASTER:include/clib/debug_protos.h,v $
$Revision: 3.0 $
$Date: 1994/06/27 15:38:37 $

Prototypes for public procedures of debug.library.

****************************************************************************/

void XCrash(char *msg, struct Context *context);
void XDebug(char *msg, struct Context *context);
void InitTerminal(BYTE port);
void EndTerminal(BYTE port);
void BootMsg(char *fmstr, char *modname);
void CrashMsg(char *str);
void DebugMsg(char *str);
void Print(char *str);
void AuxPrint(char *str);
