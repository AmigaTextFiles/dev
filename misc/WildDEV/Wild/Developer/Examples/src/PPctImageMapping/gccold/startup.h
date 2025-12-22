
#include <exec/exec.h>
#include <inline/exec.h>
#include <intuition/intuition.h>
#include <graphics/gfxbase.h>
#include <dos/dosextens.h>
#include <workbench/startup.h>
#include <exec/libraries.h>

#define SysBase *(struct ExecBase **)4L
extern struct IntuitionBase *IntuitionBase;
extern struct GraphicsBase *GraphicsBase;
extern struct DOSBase *DOSBase;
extern struct Library *IffParseBase;
extern struct Process *ThisTask;
extern struct WBStartup *WBMessage;
extern struct WildBase *WildBase;

void exit(ULONG code);