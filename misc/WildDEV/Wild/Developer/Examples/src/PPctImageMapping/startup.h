
#include <exec/exec.h>
#include <intuition/intuition.h>
#include <graphics/gfxbase.h>
#include <dos/dosextens.h>
#include <workbench/startup.h>
#include <exec/libraries.h>

extern struct ExecBase *SysBase;
extern struct IntuitionBase *IntuitionBase;
extern struct GraphicsBase *GraphicsBase;
extern struct DOSBase *DOSBase;
extern struct Library *IffParseBase;
extern struct Process *ThisTask;
extern struct WBStartup *WBMessage;
extern struct WildBase *WildBase;

extern void exit(ULONG code);
