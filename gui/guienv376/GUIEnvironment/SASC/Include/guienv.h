#ifndef LIBRARIES_GUIENV_H
#define LIBRARIES_GUIENV_H TRUE

/* **************************************************************************

$RCSfile: guienv.h $

$Revision: 1.6 $
    $Date: 1994/11/24 12:55:39 $

    GUIEnvironment library structures, constants and definitions

    SAS/C V6.51

  Copyright © 1994, Carsten Ziegeler
                    Augustin-Wibbelt-Str.7, 33106 Paderborn, Germany


*************************************************************************** */

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef GRAPHICS_TEXT_H
#include <graphics/text.h>
#endif

#ifndef INTUITION_INTUITION_H
#include <intuition/intuition.h>
#endif

#ifndef LIBRARIES_LOCALE_H
#include <libraries/locale.h>
#endif

/* ======================================================================= */
/*                              Constants                                  */
/* ======================================================================= */

#define GUIEnvName "guienv.library"
#define GUIEnvMinVersion 37         /* Revision 2 */

/* ======================================================================= */
/*                               Error codes                               */
/* ======================================================================= */

#define GE_Done                 0   /* no error, everything done */
#define GE_MemoryErr            1   /* not enough memory */
#define GE_WindowErr            2   /* no window specified */
#define GE_VisualInfoErr        3   /* couldn't get VisualInfo */
#define GE_DrawInfoErr          4   /* couldn't get DrawInfo */
#define GE_GuideErr            50   /* couldn't display AmigaGuide node */

#define GE_GadContextErr      100   /* GadTools CreateContext failed */
#define GE_GadCreateErr       101   /* error calling CreateGadget/NewObject */
#define GE_GadTooManyErr      102   /* more than 256 gadgets */
#define GE_GadKeyTwiceErr     103   /* same key equivalent for two gadgets */
#define GE_GadUnknownKind     104   /* unknown gadget kind */
#define GE_GadChainErr        105   /* ChainStart/ChainEnd missing */
#define GE_GadHookErr         106   /* Hook function failed */


#define GE_MenuCreateErr      200   /* error calling CreateMenu */
#define GE_MenuStripErr       201   /* error calling SetMenuStrip */
#define GE_MenuLayoutErr      202   /* error calling LayoutMenus */
#define GE_MenuTooManyErr     203   /* more than 256 menu items */



/* ======================================================================= */
/*                         GE Hook functions                               */
/* ======================================================================= */

/* The GUIEnvironment hook functions:
   - The hook functions are implemented as amiga callback hooks as
     documented in the Utilities documentation
   - Before a hook functions is called, the A4 register is set
   - The A0 register points to Hook structure
   - The A1/A2 register are used as stated below

*/

/* ------------------------ return values -------------------------------- */

#define GEH_KeyShifted    512
#define GEH_KeyUnknown    -1

/* ------------------------ The hook functions ---------------------------

            Hook function for key equivalents:

              A1      : Currently unused, set to NULL
              A2      : LONG : The ASCII character code
              RESULT  : LONG : gehKeyUnknown if the key is not a key
                                  equivalent or the number of the gadget,
                                  or the number of the gadget plus
                                  gehKeyShifted !

            Handle message hook

              A1, A2  : Currently unused, set to NULL
              RESULT  : LONG, handled as boolean
                        Return TRUE, if GUIEnv should not work on the
                        message anymore, otherwise FALSE

            Refresh hook

              A1, A2  : Currently unused, set to NULL
              RESULT  : Currently unused, set this always to 0 !


            Gadget event message hook

              A2      : Pointer to event gadget
              A1      : Currently unused, set to NULL
              RESULT  : LONG, handled as boolean
                        If you want to wait for further messages return
                        TRUE, otherwise FALSE to exit the message-loop.

            Menu event message hook

              A2      : Pointer to event menu item (if possible)
              A1      : Currently unused, set to NULL
              RESULT  : LONG, handled as boolean
                        If you want to wait for further messages return
                        TRUE, otherwise FALSE to exit the message-loop.

            Gadget creation hook

              A2      : Pointer to event gadget
              A1      : Currently unused, set to NULL
              RESULT  : LONG, handled as boolean
                        If your creation hook has done his work, return
                        TRUE, otherwise FALSE to stop creation !


*/

/* ======================================================================= */
/*                               Gadgets                                   */
/* ======================================================================= */

/* ----------------------- gadget kinds ---------------------------------- */

#define GEG_Kinds                    65535 /* GUIEnv gadgets */
#define GEG_ProgressIndicatorKind    65536
#define GEG_BevelboxKind             65537
#define GEG_BorderKind               65538

#define GEG_BOOPSIKinds             131071 /* BOOPSI gadgets */
#define GEG_BOOPSIPublicKind        131072
#define GEG_BOOPSIPrivateKind       131073

/* ----------------------- gadget chain flags ---------------------------- */

#define GEG_ChainUpNext     1   /* Flags, 16 bits */
#define GEG_ChainUpPrev     2
#define GEG_ChainDownNext   4
#define GEG_ChainDownPrev   8

/* ----------------------- gadget description flags ---------------------- */

#define GEG_DistNorm       0  /* Normal distance */
#define GEG_DistAbs        1  /* absolute distance from an object */
#define GEG_DistRel        2  /* relative distance from an object */
#define GEG_DistPercent    3  /* percentual distance */

#define GEG_ObjBorder      0  /* window border */
#define GEG_ObjGadget      4  /* gadget (standard is previous gadget) */

#define GEG_ObjRight       0  /* distance from which part of the object */
#define GEG_ObjBottom      0
#define GEG_ObjLeft       32
#define GEG_ObjTop        32

/* ----------------------- gadget tag values ----------------------------- */

#define GEG_ACTIVATIONUP     0
#define GEG_ACTIVATIONDOWN   1


#define GEG_ALLGADGETS      -1

/* ----------------------- gadget tags ----------------------------------- */

#define GEG_Base            (TAG_USER + 0x16000)
#define GEG_Text            (GEG_Base +  1)
#define GEG_Flags           (GEG_Base +  2)
#define GEG_Font            (GEG_Base +  3)
#define GEG_UserData        (GEG_Base +  4)
#define GEG_Description     (GEG_Base +  5)
#define GEG_Objects         (GEG_Base +  6)
#define GEG_GuideNode       (GEG_Base +  7)
#define GEG_CatalogString   (GEG_Base + 10)
#define GEG_Class           (GEG_Base + 11)
#define GEG_VarAddress      (GEG_Base + 12)
#define GEG_HandleInternal  (GEG_Base + 13)
#define GEG_StartChain      (GEG_Base + 14)
#define GEG_EndChain        (GEG_Base + 15)
#define GEG_Activate        (GEG_Base + 16)
#define GEG_ChainActivation (GEG_Base + 17)
#define GEG_Status          (GEG_Base + 19)
#define GEG_UpAHook         (GEG_Base + 20)
#define GEG_DownAHook       (GEG_Base + 21)
#define GEG_CreationAHook   (GEG_Base + 22)

#define GEG_PIMaxValue      (GEG_Base + 50)
#define GEG_PICurrentValue  (GEG_Base + 51)
#define GEG_BBRecessed      (GEG_Base + 52)

#define GEG_Disable         (GEG_Base + 100)
#define GEG_Enable          (GEG_Base + 101)
#define GEG_SetVar          (GEG_Base + 102)
#define GEG_GetVar          (GEG_Base + 103)
#define GEG_ActivateUp      (GEG_Base + 104)
#define GEG_ActivateDown    (GEG_Base + 105)

#define GEG_Address         (GEG_Base + 200)
#define GEG_LeftEdge        (GEG_Base + 201)
#define GEG_TopEdge         (GEG_Base + 202)
#define GEG_Width           (GEG_Base + 203)
#define GEG_Height          (GEG_Base + 204)
#define GEG_Redraw          (GEG_Base + 205)

/* ----------------------- GUIGadgetInfo structure ------------------------ */

struct GUIGadgetInfo      /* a pointer to this structure is stored in
                             gadget->UserData */
{
  APTR userData;          /* use this for own user data */
  LONG kind;              /* gadget kind */

  APTR gadgetClass;       /* The BOOPSI Gadget Class */

  struct Hook *functionUp, *functionDown;

  STRPTR guideNode;       /* The AmigaGuide node for this gadget */

};


/* ======================================================================= */
/*                             Menu Items                                  */
/* ======================================================================= */

/* ---------------------- menu item tags --------------------------------- */

#define GEM_Base            (TAG_USER + 0x18000)
#define GEM_UserData        (GEM_Base + 1)
#define GEM_GuideNode       (GEM_Base + 3)
#define GEM_CatalogString   (GEM_Base + 4)
#define GEM_ShortCut        (GEM_Base + 5)
#define GEM_Flags           (GEM_Base + 6)
#define GEM_MutualExclude   (GEM_Base + 7)
#define GEM_AHook           (GEM_Base + 8)

/* ---------------------- GUIMenuInfo structure -------------------------- */


struct GUIMenuInfo        /* a pointer to this structure is stored in
                              menuitem^.userData */
{
  APTR userData;          /* use this for own user data */

  struct Hook *function;

  STRPTR guideNode;       /* The AmigaGuide node for this menuitem */

};


/* ======================================================================= */
/*                            GUIInfo                                      */
/* ======================================================================= */

/* -------------------------- GUIInfo structure -------------------------- */


struct GUIInfo {

  struct Window *window;            /* pointer to the used Window */
  struct Screen *screen;            /* pointer to window's screen */
  APTR   visualInfo;                /* Pointer to screen's VisualInfo */
  struct DrawInfo *drawInfo;        /* pointer to a copy of DrawInfo */
  struct Locale *localeInfo;        /* pointer to locale environment */

  struct TextAttr *menuFont;        /* pointer to menu-font. Is set to
                                       screens font. */

  WORD creationWidth;               /* window inner width */
  WORD creationHeight;              /* window inner height */

  struct MsgPort *msgPort;          /* Pointer to IDCMP-Port */

  struct IntuiMessage *intuiMsg;    /* Points to a copy of the
                                       FULL IntuiMessage even if it
                                       is extended (OS3.0+) */

 /* Additional information about the message: */
  ULONG msgClass;

  WORD  msgCode;
  UBYTE msgBoolCode;                /* This should be BOOL, but we have
                                       only 1 byte and BOOL needs 2 bytes */
  char  msgCharCode;

  struct Gadget *msgGadget;

  struct MenuItem *msgItemAdr;

  WORD msgGadNbr;

  WORD msgMenuNum;
  WORD msgItemNum;
  WORD msgSubNum;


 /* Some user stuff: */
  APTR userData;                    /* for own data */
  APTR compilerReg;                 /* for compiler data reg */

  STRPTR gadgetGuide;               /* name & path for the guide */
  STRPTR menuGuide;                 /* name & path for the guide */

  struct Catalog *catalogInfo;      /* points to the catalog given
                                       with the GUI_CatalogFile tag */

  LONG gadgetCatalogString;         /* The number of the next string */
  LONG menuCatalogString;           /* in the catalog */

  struct Hook *vanKeyHook;                  /* Hook functions */
  struct Hook *handleMsgHook;
  struct Hook *refreshHook;

  APTR   hookInterface;

  struct TextAttr *creationFont;    /* GUIDefinition: text/gadget font */
  struct TextAttr *textFont;        /* Font for gadgets and text */
};


/* --------------------------- GUI Tags ------------------------------------ */

#define GUI_Base                (TAG_USER + 0x15000)
#define GUI_TextFont            (GUI_Base +  1)
#define GUI_MenuFont            (GUI_Base +  2)
#define GUI_CreateError         (GUI_Base +  4)
#define GUI_UserData            (GUI_Base +  5)
#define GUI_CompilerReg         (GUI_Base +  6)
#define GUI_GadgetGuide         (GUI_Base +  8)
#define GUI_MenuGuide           (GUI_Base +  9)
#define GUI_CatalogFile         (GUI_Base + 10)
#define GUI_GadgetCatalogOffset (GUI_Base + 11)
#define GUI_MenuCatalogOffset   (GUI_Base + 12)
#define GUI_CreationWidth       (GUI_Base + 13)
#define GUI_CreationHeight      (GUI_Base + 14)
#define GUI_MsgPort             (GUI_Base + 16)
#define GUI_RefreshAHook        (GUI_Base + 17)
#define GUI_HandleMsgAHook      (GUI_Base + 18)
#define GUI_VanKeyAHook         (GUI_Base + 19)
#define GUI_HookInterface       (GUI_Base + 20)
#define GUI_CreationFont        (GUI_Base + 21)
#define GUI_PreserveWindow      (GUI_Base + 22)

#define GUI_RemoveMenu          (GUI_Base + 100)
#define GUI_RemoveGadgets       (GUI_Base + 101)
#define GUI_ClearWindow         (GUI_Base + 102)
#define GUI_EmptyMsgPort        (GUI_Base + 103)
#define GUI_DoBeep              (GUI_Base + 104)
#define GUI_Lock                (GUI_Base + 105)  /* Requires ReqTools */
#define GUI_UnLock              (GUI_Base + 106)  /* Requires ReqTools */


/* -------------------- Preserve Window Flags ---------------------------- */

#define GUI_PWFull    0  /* Preserve the window and the min and max values */
#define GUI_PWSize    1  /* Preserve only the window */
#define GUI_PWMinMax  2  /* Preserve only the min and max values */


/* ======================================================================= */
/*                             Requester                                   */
/* ======================================================================= */

/* -------------------- Requester kinds ---------------------------------- */

#define GER_GeneralKind   0
#define GER_OKKind        1
#define GER_DoItKind      2
#define GER_YNCKind       3
#define GER_FileKind      4
#define GER_DirKind       5

#define GER_RTKind        100   /* Requires ReqTools */
#define GER_RTOKKind      101
#define GER_RTDoItKind    102
#define GER_RTYNCKind     103
#define GER_RTFileKind    104
#define GER_RTDirKind     105

/* --------------------- Return values ----------------------------------- */

#define GER_Cancel   0   /* GER_YNCKind / GER_DoItKind / GER_OKKind /
                            GER_FileKind / GER_DirKind */

#define GER_Yes      1   /* GER_YNCKind / GER_DoItKind / GER_FileKind /
                            GER_DirKind */

#define GER_No       2   /* GER_YNCKind */


/* --------------------- Requester tags ---------------------------------- */

#define GER_Base           (TAG_USER + 0x17000)
#define GER_Gadgets        (GER_Base +  1)
#define GER_Args           (GER_Base +  2)
#define GER_Flags          (GER_Base +  3)
#define GER_Title          (GER_Base +  4)
#define GER_IDCMP          (GER_Base +  5)
#define GER_Pattern        (GER_Base +  6)
#define GER_NameBuffer     (GER_Base +  7)
#define GER_FileBuffer     (GER_Base +  8)
#define GER_DirBuffer      (GER_Base +  9)
#define GER_Save           (GER_Base + 10)
#define GER_LocaleID       (GER_Base + 11)

/* ======================================================================= */
/*                              Windows                                    */
/* ======================================================================= */

/* ---------------------- window tags ------------------------------------ */

#define GEW_Base            (TAG_USER + 0x19000)
#define GEW_OuterSize       (GEW_Base + 1)


/* ======================================================================= */
/*                            Library functions                            */
/* ======================================================================= */

/* --------- protos ------------- */

struct TextFont *OpenGUIFont( STRPTR, WORD, struct TextAttr * );
VOID CloseGUIFont( struct TextFont * );
struct Screen *OpenGUIScreenA( ULONG, WORD, STRPTR, struct TextAttr *,
                               struct TagItem * );
struct Screen *OpenGUIScreen( ULONG, WORD, STRPTR, struct TextAttr *,
                              ULONG, ... );
struct Window *OpenGUIWindowA( WORD, WORD, WORD, WORD, STRPTR, ULONG,
                               ULONG, struct Screen *, struct TagItem * );
struct Window *OpenGUIWindow( WORD, WORD, WORD, WORD, STRPTR, ULONG,
                              ULONG, struct Screen *, ULONG, ... );
VOID CloseGUIWindow( struct Window * );
VOID CloseGUIScreen( struct Screen * );
struct GUIInfo *CreateGUIInfoA( struct Window *, struct TagItem * );
struct GUIInfo *CreateGUIInfo( struct Window *, ULONG, ... );
VOID FreeGUIInfo( struct GUIInfo * );
WORD DrawGUIA( struct GUIInfo *, struct TagItem * );
WORD DrawGUI( struct GUIInfo *, ULONG, ... );
WORD ChangeGUIA( struct GUIInfo *, struct TagItem * );
WORD ChangeGUI( struct GUIInfo *, ULONG, ... );
VOID CreateGUIGadgetA( struct GUIInfo *, WORD, WORD, WORD, WORD, LONG,
                       struct TagItem * );
VOID CreateGUIGadget( struct GUIInfo *, WORD, WORD, WORD, WORD, LONG,
                      ULONG, ... );
VOID CreateGUIMenuEntryA( struct GUIInfo *, BYTE, STRPTR, struct TagItem * );
VOID CreateGUIMenuEntry( struct GUIInfo *, BYTE, STRPTR, ULONG, ... );
VOID WaitGUIMsg( struct GUIInfo * );
BOOL GetGUIMsg( struct GUIInfo * );
VOID SetGUIGadgetA( struct GUIInfo *, WORD, struct TagItem * );
VOID SetGUIGadget( struct GUIInfo *, WORD, ULONG, ... );
LONG GetGUIGadget( struct GUIInfo *, WORD, ULONG);
VOID GUIGadgetActionA( struct GUIInfo *, struct TagItem * );
VOID GUIGadgetAction( struct GUIInfo *, ULONG, ... );
LONG GUIRequestA( struct GUIInfo *, STRPTR, LONG, struct TagItem * );
LONG GUIRequest( struct GUIInfo *, STRPTR, LONG, ULONG, ... );
WORD ShowGuideNodeA( struct GUIInfo *, STRPTR, STRPTR, struct TagItem * );
WORD ShowGuideNode( struct GUIInfo *, STRPTR, STRPTR, ULONG, ... );
STRPTR GetCatStr( struct GUIInfo *, LONG, STRPTR );
STRPTR GetLocStr( struct GUIInfo *, LONG, STRPTR );


/* --------- pragmas ------------ */

extern struct Library *GUIEnvBase;

#pragma libcall GUIEnvBase OpenGUIFont 1e 90803
#pragma libcall GUIEnvBase CloseGUIFont 24 801
#pragma libcall GUIEnvBase OpenGUIScreenA 2a 981004
#pragma tagcall GUIEnvBase OpenGUIScreen  2a 981004
#pragma libcall GUIEnvBase OpenGUIWindowA 30 A9548321009
#pragma tagcall GUIEnvBase OpenGUIWindow  30 A9548321009
#pragma libcall GUIEnvBase CloseGUIWindow 36 801
#pragma libcall GUIEnvBase CloseGUIScreen 3c 801
#pragma libcall GUIEnvBase CreateGUIInfoA 42 9802
#pragma tagcall GUIEnvBase CreateGUIInfo  42 9802
#pragma libcall GUIEnvBase FreeGUIInfo 48 801
#pragma libcall GUIEnvBase DrawGUIA 4e 9802
#pragma tagcall GUIEnvBase DrawGUI  4e 9802
#pragma libcall GUIEnvBase ChangeGUIA 54 9802
#pragma tagcall GUIEnvBase ChangeGUI  54 9802
#pragma libcall GUIEnvBase CreateGUIGadgetA 5a 943210807
#pragma tagcall GUIEnvBase CreateGUIGadget  5a 943210807
#pragma libcall GUIEnvBase CreateGUIMenuEntryA 60 A90804
#pragma tagcall GUIEnvBase CreateGUIMenuEntry  60 A90804
#pragma libcall GUIEnvBase WaitGUIMsg 66 801
#pragma libcall GUIEnvBase GetGUIMsg 6c 801
#pragma libcall GUIEnvBase SetGUIGadgetA 72 90803
#pragma tagcall GUIEnvBase SetGUIGadget  72 90803
#pragma libcall GUIEnvBase GetGUIGadget  78 10803
#pragma libcall GUIEnvBase GUIGadgetActionA 7e 9802
#pragma tagcall GUIEnvBase GUIGadgetAction  7e 9802
#pragma libcall GUIEnvBase GUIRequestA 84 A09804
#pragma tagcall GUIEnvBase GUIRequest  84 A09804
#pragma libcall GUIEnvBase ShowGuideNodeA 8a BA9804
#pragma tagcall GUIEnvBase ShowGuideNode  8a BA9804
#pragma libcall GUIEnvBase GetCatStr 90 90803
#pragma libcall GUIEnvBase GetLocStr 96 90803


#endif /* LIBRARIES_GUIENV_H */
