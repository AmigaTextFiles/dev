/***************************************************************************
 * wpad_data.c
 *
 * wpad.library, Copyright ©1995 Lee Kindness.
 *
 * 
 */

#include "wpad_global.h"

struct ExecBase *SysBase;
struct DosLibrary *DOSBase;
struct Library *IntuitionBase;
struct GfxBase *GfxBase;
struct Library *UtilityBase;
struct Library *GadToolsBase;
struct Library *DiskfontBase;
struct Library *CxBase;

struct SignalSemaphore EntrySem;


