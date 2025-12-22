#ifndef MULTIDESKTOP_MULTIDESKTOP_H
#define MULTIDESKTOP_MULTIDESKTOP_H
#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif
#ifndef EXEC_LIBRARIES_H
#include <exec/libraries.h>
#endif

#define MERR_NoError      0
#define MERR_NoMemory     1
#define MERR_GadgetError  2

#define STARTUP_TRAPHANDLER      (1L<<0)
#define STARTUP_ALERTHANDLER     (1L<<1)
#define STARTUP_BREAKHANDLER_ON  (1L<<2)
#define STARTUP_BREAKHANDLER_OFF (1L<<3)
#define STARTUP_BREAKHANDLER_C   (1L<<4)
#define STARTUP_BREAKHANDLER_D   (1L<<5)
#define STARTUP_BREAKHANDLER_E   (1L<<6)
#define STARTUP_BREAKHANDLER_F   (1L<<7)

#define SORT_ASCENDING  1
#define SORT_DESCENDING 2

struct MultiRememberEntry
{
 struct MultiRememberEntry *PrevRemember;
 struct MultiRememberEntry *NextRemember;
 ULONG                      MemorySize;
};

struct MultiRemember
{
 struct MultiRememberEntry *FirstRemember;
 struct MultiRememberEntry *LastRemember;
};

struct MultiTime
{
 UBYTE Day;
 UBYTE Month;
 UWORD Year;
 UBYTE WDay;
 UBYTE Hour;
 UBYTE Minute;
 UBYTE Second;

 ULONG SecondsSince1978;
 ULONG StarDate[2];
 /*
    StarDate-Format:
    StarDate[0] : Ganze Einheiten
    StarDate[1] : Nachkommaeinheiten mit 1000 multipliziert

    1.0000 StarDate-Einheiten = 32400 Sekunden = 9 Stunden
 */
};

struct MultiDesktopUser
{
 /* --- Verwaltung ------------------ */
 ULONG                MagicID;             /*  0 */ /* MultiDesktop-Kennung */
 UWORD                UserCount;           /*  4 */
 struct MultiRemember Remember;            /*  6 */

 /* --- Startup, Traps, Break ------- */
 struct WBStartup    *WBStartup;           /* 14 */
 ULONG                LastError;           /* 18 */
 ULONG                LastGuru;            /* 22 */
 APTR                 OldTrapHandler;      /* 26 */
 APTR                 OldExceptHandler;    /* 30 */
 UWORD                BreakControl;        /* 34 */
 UWORD                AlertControl;        /* 36 */
 VOID               (*TermProcedure)();    /* 38 */
 VOID               (*SysTermProcedure)(); /* 42 */

 /* --- Timer-Device ---------------- */
 struct MsgPort      *TimerPort;
 struct timerequest  *TimerReq;
 LONG                 TimerDev;

 /* --- zur freien Verfügung -------- */
 APTR                 MDUUserData[4];

 /* --- MultiDesktop-Libraries ------ */
 APTR                 MultiWindows;
 APTR                 MultiDisk;
 APTR                 MultiTransfer;
 APTR                 MultiSCSI;
};

#define MAGIC_ID 0x29091976

struct MultiDesktopBase
{
 /* --- Verwaltung ------------------ */
 struct Library        Library;

 /* --- Libraries ------------------- */
 struct ExecBase      *SysLib;
 struct DOSBase       *DosLib;
 struct IntuitionBase *IntLib;
 struct GfxBase       *GfxLib;
 struct Library       *DiskfontLib;
 struct Library       *GadToolsLib;
 struct Library       *IconLib;
 struct Library       *LayersLib;
 struct Library       *WorkbenchLib;
 struct Library       *UtilityLib;
 struct Library       *ExpansionLib;
 struct Library       *VersionLib;
 struct Library       *KeymapLib;
 struct Library       *TimerLib;
 struct Library       *ConsoleLib;
 struct Library       *InputLib;
 struct Library       *BattClockLib;

 ULONG                 pad01;

 /* --- Locale ---------------------- */
 struct Library       *LocaleLib;
 struct Locale        *Locale;
 struct Catalog       *Catalog;

 /* --- Verwaltung ------------------ */
 APTR                  SegList;
 UBYTE                 Flags;
 UBYTE                 pad;
};

#define SIGBREAK (SIGBREAKF_CTRL_C|SIGBREAKF_CTRL_D|SIGBREAKF_CTRL_E|SIGBREAKF_CTRL_F)
#define MULTI_SIZE 100
#endif

