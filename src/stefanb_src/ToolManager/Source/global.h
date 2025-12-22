/*
 * global.h  V3.1
 *
 * Global definitions
 *
 * Copyright (C) 1990-98 Stefan Becker
 *
 * This source code is for educational purposes only. You may study it
 * and copy ideas or algorithms from it for your own projects. It is
 * not allowed to use any of the source codes (in full or in parts)
 * in other programs. Especially it is not allowed to create variants
 * of ToolManager or ToolManager-like programs from this source code.
 *
 */

/* Version */
#define TMVERSION "3.1"

/* Copyright year */
#define TMCOPYRIGHTYEAR "1990-98"

/* Handler task name */
#define TMHANDLERNAME "ToolManager Handler"

/* Catalog name */
#define TMCATALOGNAME "toolmanager.catalog"

/* Catalog version */
#define TMCATALOGVERSION 5

/* Configuration file name */
#define TMCONFIGNAME "ToolManager.prefs"

/* ToolManager configuration file version */
#define TMCONFIGVERSION "$VER: ToolManagerPrefs 3.0"

/* IFF FORM types for ToolManager configuration */
/* LIST & FORM types */
#define ID_TMPR MAKE_ID('T','M','P','R') /* TM configuration file type    */
#define ID_TMGP MAKE_ID('T','M','G','P') /* ToolManager global settings   */
#define ID_TMEX MAKE_ID('T','M','E','X') /* ToolManager Exec object       */
#define ID_TMIM MAKE_ID('T','M','I','M') /* ToolManager Image object      */
#define ID_TMSO MAKE_ID('T','M','S','O') /* ToolManager Sound object      */
#define ID_TMMO MAKE_ID('T','M','M','O') /* ToolManager Menu object       */
#define ID_TMIC MAKE_ID('T','M','I','C') /* ToolManager Icon object       */
#define ID_TMDO MAKE_ID('T','M','D','O') /* ToolManager Dock object       */
#define ID_TMAC MAKE_ID('T','M','A','C') /* ToolManager Access object     */

/* Property types */
#define ID_CDIR MAKE_ID('C','D','I','R') /* Current directory             */
#define ID_CMND MAKE_ID('C','M','N','D') /* Command name                  */
#define ID_DATA MAKE_ID('D','A','T','A') /* Fixed data structure          */
#define ID_ENTR MAKE_ID('E','N','T','R') /* ToolManager dock entry        */
#define ID_FILE MAKE_ID('F','I','L','E') /* File name                     */
#define ID_FONT MAKE_ID('F','O','N','T') /* Font name                     */
#define ID_FVER MAKE_ID('F','V','E','R') /* OS V37+ version string        */
#define ID_HKEY MAKE_ID('H','K','E','Y') /* Hotkey description            */
#define ID_OGRP MAKE_ID('O','G','R','P') /* Object group name             */
#define ID_OUTP MAKE_ID('O','U','T','P') /* Output file name              */
#define ID_NAME MAKE_ID('N','A','M','E') /* Object name                   */
#define ID_PATH MAKE_ID('P','A','T','H') /* Command path                  */
#define ID_PORT MAKE_ID('P','O','R','T') /* ARexx port name               */
#define ID_PSCR MAKE_ID('P','S','C','R') /* Public screen name            */

/* Definitions for global settings */
#define DATA_GLOBALF_NETWORKENABLE    0x1
#define DATA_GLOBALF_REMAPENABLE      0x2
#define DATA_GLOBALF_MASK             0x3 /* All valid flags */
#define DATA_GLOBAL_PRECISION_DEFAULT 1   /* Default remap precisions */
#define DATA_GLOBAL_PRECISION_MAX     4   /* Supported remap precisions */
struct GlobalDATAChunk {
 ULONG gdc_Flags;
 ULONG gdc_Precision;
};

/* Data structures for DATA chunks */
struct StandardDATAChunk {
 ULONG sdc_ID;             /* Object ID    */
 ULONG sdc_Flags;          /* Object Flags */
};

/* Definitions for Exec objects */
#define DATA_EXECF_ARGUMENTS 0x1
#define DATA_EXECF_TOFRONT   0x2
#define DATA_EXECF_MASK      0x3 /* All valid flags */
struct ExecDATAChunk {
 struct StandardDATAChunk edc_Standard;
 UWORD                    edc_ExecType;
 WORD                     edc_Priority;
 ULONG                    edc_Stack;
};

/* Definitions for Image objects */
#define DATA_IMAGEF_MASK 0x0 /* All valid flags */
/* Uses StandardDataChunk */

/* Definitions for Sound objects */
#define DATA_SOUNDF_MASK 0x0 /* All valid flags */
/* Uses StandardDataChunk */

/* Definitions for Menu objects */
#define DATA_MENUF_MASK 0x0 /* All valid flags */
struct MenuDATAChunk {
 struct StandardDATAChunk mdc_Standard;
 ULONG                    mdc_ExecObject;
 ULONG                    mdc_SoundObject;
};

/* Definitions for Icon objects */
#define DATA_ICONF_SHOWNAME 0x1
#define DATA_ICONF_MASK     0x1 /* All valid flags */
struct IconDATAChunk {
 struct StandardDATAChunk idc_Standard;
 ULONG                    idc_LeftEdge;
 ULONG                    idc_TopEdge;
 ULONG                    idc_ExecObject;
 ULONG                    idc_ImageObject;
 ULONG                    idc_SoundObject;
};

/* Definitions for Dock objects */
#define DATA_DOCKF_ACTIVATED 0x001
#define DATA_DOCKF_MENU      0x002
#define DATA_DOCKF_BORDER    0x004
#define DATA_DOCKF_IMAGES    0x008
#define DATA_DOCKF_TEXT      0x010
#define DATA_DOCKF_CENTERED  0x020
#define DATA_DOCKF_STICKY    0x040
#define DATA_DOCKF_BACKDROP  0x080
#define DATA_DOCKF_FRONTMOST 0x100
#define DATA_DOCKF_POPUP     0x200
#define DATA_DOCKF_MASK      0x3FF /* All valid flags */
struct DockDATAChunk {
 struct StandardDATAChunk ddc_Standard;
 ULONG                    ddc_LeftEdge;
 ULONG                    ddc_TopEdge;
 ULONG                    ddc_Columns;
 UWORD                    ddc_FontYSize;
 UBYTE                    ddc_FontStyle;
 UBYTE                    ddc_FontFlags;
};
struct DockEntryChunk {
 ULONG dec_ExecObject;
 ULONG dec_ImageObject;
 ULONG dec_SoundObject;
};

/* Definitions for Access objects */

/* Debugging */
#ifdef DEBUG
/* Global data */
extern ULONG DebugFlags[DEBUGFLAGENTRIES];

/* Function prototypes */
void            InitDebug(const char *);
#ifdef DEBUGPRINTTAGLIST
const char     *GetTagName(ULONG);
void            PrintTagList(const struct TagItem *);
#endif
void            kprintf(const char *, ...);
__stkargs void  KPutChar(char);
__stkargs void  KPutStr(const char *);

/* Macros */
#define INITDEBUG(name)          InitDebug(#name);
#define _DEBUGHEADER(func, text) __FILE__ "/" #func "/" #text ": "
#define DEBUGHEADER(text)        _DEBUGHEADER(DEBUGFUNCTION, text)
#define ERROR_LOG(x)             x;
#define _LOG(o, b, x)            if (DebugFlags[o] & (1 << (b))) x;
#define LOG0(x)                  KPutStr(DEBUGHEADER(x) "-\n")
#define LOG1(x, f, a)            kprintf(DEBUGHEADER(x) f "\n",(a))
#define LOG2(x, f, a, b)         kprintf(DEBUGHEADER(x) f "\n",(a),(b))
#define LOG3(x, f, a, b, c)      kprintf(DEBUGHEADER(x) f "\n",(a),(b),(c))
#define LOG4(x, f, a, b, c, d)   kprintf(DEBUGHEADER(x) f "\n",(a),(b),(c),(d))
#define LOG5(x, f, a, b, c, d, e) \
                             kprintf(DEBUGHEADER(x) f "\n",(a),(b),(c),(d),(e))
#else
#define INITDEBUG(name)
#define DEBUGHEADER(x)
#define ERROR_LOG(x)
#define LOG0(x)
#define LOG1(x)
#define LOG2(x)
#define LOG3(x)
#define LOG4(x)
#define LOG5(x)
#endif

/* Log information only if DEBUG is greater than zero */
#if DEBUG > 0
#define INFORMATION_LOG(x) x;
#else
#define INFORMATION_LOG(x)
#endif

/* Memory */
BOOL  InitMemory(void);
void  DeleteMemory(void);
void *GetMemory(ULONG);
void  FreeMemory(void *, ULONG);
void *GetVector(ULONG);
void  FreeVector(void *);

/* Miscellaneous */
#define GetHead(list) GetSucc((struct MinNode *) (list))
#define GetTail(list) GetPred((struct MinNode *) &(list)->mlh_Tail)
struct MinNode *GetSucc(struct MinNode *);
struct MinNode *GetPred(struct MinNode *);
