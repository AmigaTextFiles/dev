#ifndef IEDITOR_DEFS_H
#define IEDITOR_DEFS_H

/*
** InterfaceEditor definitions' file    **
**                                      **
** ©1995-1996 Simone Tellini            **
**                                      **
** $VER: IEditor_Include 3.0 (27.11.95) **
*/


#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif
#ifndef EXEC_LISTS_H
#include <exec/lists.h>
#endif
#ifndef EXEC_NODES_H
#include <exec/nodes.h>
#endif
#ifndef IE_PROTOS_H
#include "DEV_IE:IE_Protos.h"
#endif
#ifndef IEDITOR_H
#include "DEV_IE:Include/IEditor.h"
#endif
#ifndef IEDIT_EXPANDER_H
#include "DEV_IE:Include/expanders.h"
#endif



struct MacroNode {
	struct Node         Node;
	struct MenuItem    *Menu;
	UBYTE               File[256];
};

struct CatCompArrayType
{
    LONG   cca_ID;
    STRPTR cca_Str;
};


struct LoaderNode {
	struct Node     Node;
	struct Library *LoaderBase;
};


struct GeneratorNode {
	struct Node         Node;
	struct Generator   *GenBase;
};


struct MyRect {
	WORD    Left, Top, Width, Height;
};


// GestisciListFin flags; private.

#define     MARK_SELECTED   0
#define     EXIT            1

// General Flags (flags); private

#define         RECTFIXED       (1<<0)
#define         ESCI            (1<<1)
#define         WNDCHIUSA       (1<<2)
#define         SALVATO         (1<<3)
//#define         NO_IEX          (1<<4)
#define         LOADGUI         (1<<5)
#define         MOVE            (1<<6)
//#define         NODISKFONT      (1<<7)

// General Flags  (flags_2); private

//#define         GENERASCR       (1<<1)
#define         DEMO            (1<<2)
#define         REXX            (1<<3)
#define         DONTUPDATESCR   (1<<4)
#define         REXXCALL        (1<<6)
#define         WNDPTR          (1<<7)

// Genaral Preferences (mainprefs)

#define WB_OPEN                 (1<<0)
#define WFLAGS                  (1<<1)
#define PRIMOPIANO              (1<<2)
#define STACCATI                (1<<3)
#define TOOLSWND                (1<<4)
#define CREAICONE               (1<<5)



#define         Q_W     5
#define         Q_H     3


#define ATTIVAMENU_NUOVAW_NUM   22
#define ATTIVA_CARICATA_NUM     4
#define DISATTIVAMENU_0WND_NUM  18


#define _f1 (WFLG_NEWLOOKMENUS | WFLG_CLOSEGADGET | WFLG_DRAGBAR | WFLG_DEPTHGADGET)
#define _f2 (WFLG_SIZEGADGET | WFLG_ACTIVATE | WFLG_SIMPLE_REFRESH | WFLG_REPORTMOUSE)
#define         W_F     (_f1 | _f2)


#define _i1 (IDCMP_CLOSEWINDOW | IDCMP_MENUPICK | IDCMP_REFRESHWINDOW | IDCMP_ACTIVEWINDOW | IDCMP_RAWKEY | IDCMP_VANILLAKEY)
#define _i2 (IDCMP_MOUSEMOVE | IDCMP_MOUSEBUTTONS | IDCMP_CHANGEWINDOW | IDCMP_GADGETDOWN | IDCMP_GADGETUP | IDCMP_INTUITICKS)
#define         WorkWIDCMP      (_i1 | _i2)


#define NUM_IDCMPS  27
#define NUM_FLAGS   18

extern struct IE_Data       IE;
extern int                  RetCode;
extern UBYTE                Macros[30][256];
extern UBYTE                Bar_txt[], smartrefresh_txt[];
extern struct MinList       listidcmp, listflags;
extern ULONG               *list_from_eor, *list_to_eor;
extern ULONG                idcmps[], wflgs[];
extern ULONG               *newtags_index[];
extern APTR                 settag_index[];
extern UBYTE                MyPubName[], ScreenTitle[], DefaultTool[];
extern UBYTE                ok_txt[], initial_file[], initial_drawer[], ReqFile[];
extern UWORD                toolsx, clickx;
extern UWORD                toolsy, clicky;
extern WORD                 offx, offy, mousex, mousey, lastx, lasty;
extern struct Process      *MyTask;
extern ULONG                signalset, rexx_mask, editing_mask, back_mask;
extern struct MsgPort      *IDCMP_Port;
extern ULONG                attivamenu_nuovawin[];
extern UBYTE                NoWorkWnd_txt[];
extern UBYTE                NoAsl_txt[], ok_txt[];
extern struct Catalog      *catalog;
extern struct Library      *LocaleBase, *ReqToolsBase;
extern struct ExecBase     *SysBase;
extern UBYTE                Annullato_txt[], allpath[], ErroreFile_txt[], allpath2[], save_file[];
extern ULONG                DataHeader[], ScrHeader, InterfHeader;
extern ULONG                FinestraHeader, GadgetHeader, ScrHeader, MenuHeader;
extern BPTR                 File;
extern UBYTE                FileSconosciuto_txt[], ScrPattern[];
extern UBYTE                NoILBM_txt[], MemoriaIns_txt[], sino_txt[];
extern UBYTE                VersioneDiversa_txt[], Modificato_txt[];
extern __far UWORD          puntatore[];
extern long                 buffer, buffer2, buffer3;
extern APTR                 buffer4;
extern ULONG                CheckedTag[], CycleTag[], PaletteTag[];
extern ULONG                WorkWndTags[], StringTag[], PaletteTag2[];
extern ULONG                IntegerTag[], MXTag[], DisableTag[], ListTag[];
extern ULONG                List2Tag[], List2Tag2[], CycleTag2[], CycleTag3[];
extern ULONG                List2Tag3[], TextTag[], ReqTags[];
extern __far struct UserData *User;
extern UBYTE                AP_IntString2[], AP_GadString2[], CP_ChipString2[];
extern UBYTE                AP_RexxString2[], AP_DosString2[], AP_GfxString2[];
extern UBYTE                AP_FntString2[], CP_ChipString2[];
extern UBYTE                DrawModes[], Elimina_txt[];
extern UBYTE                ExtraProc[], ARexxPortName[], RexxExt[];
extern UBYTE                GetImg_txt[], NoAslReq_txt[], TracciaGadget_txt[];
extern ULONG                disattiva_noopen[];
extern struct GXY           gadgetxy_index[];
extern struct MinList       listgadgets, TabOrder_List;
extern UBYTE                GadgetAggiunto_txt[];
extern struct Node          NoneNode;
extern WORD                 Timer;
extern struct ScreenInfo    ScrData;
extern struct MinList       Loaders, Generators;
extern struct Generator    *GenBase;
extern struct Expander     *IEXBase;
extern UWORD                Generator, NumMacros, NewWinID;
extern BOOL                 Ok_to_Run;
extern struct LocaleData    LocInfo;
extern struct MinList       MacroList;
extern struct IEXSrcFun     IEXSrcFunctions;


// Posizione dei valori nell'array WorkWndTag

#define     WORKFLAGS       1
#define     WORKTOP         3
#define     WORKLEFT        5
#define     WORKWIDTH       7
#define     WORKHEIGHT      9
#define     WORKTITLE      11
#define     WORKSCR        13
#define     WORKGADGETS    15

#endif
