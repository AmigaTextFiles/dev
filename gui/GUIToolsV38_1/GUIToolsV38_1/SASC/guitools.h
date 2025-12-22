#ifndef LIBRARIES_GUITOOLS_H
#define LIBRARIES_GUITOOLS_H TRUE

/*
**    $VER: guitools.h 38.1 (19.04.94)
**
**    GUITools library structures, constants and definitions
**
**   (C) Copyright 1994 Carsten Ziegeler
**       Freeware, see GUITools Documentation
*/

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef GRAPHICS_DISPLAYINFO_H
#include <graphics/displayinfo.h>
#endif

#ifndef GRAPHICS_TEXT_H
#include <graphics/text.h>
#endif

#ifndef INTUITION_INTUITION_H
#include <intuition/intuition.h>
#endif

#ifndef LIBRARIES_GADTOOLS_H
#include <libraries/gadtools.h>
#endif

/*
 * NOTE:  obsolete stuff is included at the END of this file, if not
 *        GUITOOLS_OBSOLETE_H is set !
 */

/* ======================================================================= */
/*                              Constants                                  */
/* ======================================================================= */

#define GUIToolsName "guitools.library"

/* ------------- result from CreateGUIInfoTags in guiCreateError --------- */

#define cgiNoError        0   /* V38.0  everything seams to be OK*/
#define cgiNoWindow       1   /* V38.0  no window specified */
#define cgiNoVisualInfo   2   /* V38.0  couldn't get VisualInfo */
#define cgiNoMemory       3   /* V38.0  not enough memory */
#define cgiNoDrawInfo     4   /* V38.0  couldn't get DrawInfo */
#define cgiCreateContext  5   /* V38.0  error calling CreateContext */


/* ----------------- results from SetGUI / RedrawGUI --------------------- */

#define  guiSet            0    /* no error ,everything done */
#define  gadgetError       1    /* error calling CreateGadget */
#define  menuError         2    /* error calling CreateMenuA */
#define  memError          3    /* not enough memory */

#define  gadKeyDefTwice    4    /* V38.0  same key-equivalent for 2 gadgets*/
#define  menuSetError      5    /* V38.0  error calling SetMenuStrip */
#define  menuLayoutError   6    /* V38.0  error calling LayoutMenusA */
#define  gadKeyNotAllowed  7    /* V38.0  key-Equivalent is not a letter */
#define  tooManyGadsError  8    /* V38.0  more gadgets as mentioned/Create*/
#define  tooManyMenusError 9    /* V38.0  more menu items as mention.Create*/
#define  gadKeyNotFound    10   /* V38.0  GT_Underscore-Tag found, but the
                                          char is missing in the text */
#define  noGadToolsGadKind 11   /* V38.0  no GadTools-Gadget */
#define  noGUIToolsGadKind 12   /* V38.0  no GUITools-Gadget */
#define  rdGUIContextError 13   /* V38.0  RedrawGUI: error calling
                                          CreateContext */


/* ---------------- OpenIntWindow/Tags width and height ------------------ */

#define  asScreen    -1


/* --------------------- ResizeGadget ------------------------------------ */

#define  preserve    -1         /* V38.0 */


/* ------------ predefined displayIDs for OpenIntScreen/Tags ------------- */

#define  hiresPalID  (HIRES_KEY + PAL_MONITOR_ID)
#define  hiresID     (HIRES_KEY + DEFAULT_MONITOR_ID)
#define  loresPalID  (LORES_KEY + PAL_MONITOR_ID)
#define  loresID     (LORES_KEY + DEFAULT_MONITOR_ID)


/* -------------------- CreateGUIInfo / CreateGUIInfoTags ---------------- */

#define  noGadgets  0      /* V38.0 */
#define  noMenu     0      /* V38.0 */


/* --------------------- Gadget kinds for CreateSpecialGadget ------------ */

#define guiToolsKinds          65535  /* V38.0  now follow GUITools-Gadgets*/
#define progressIndicatorKind  65536  /* V38.0 */
#define bevelboxKind           65537  /* V38.0 */


/* -------------------- Requester kinds for ShowRequester ---------------- */

/* V38.0 */

#define generalReqKind  0
#define okReqKind       1
#define doitReqKind     2
#define yncReqKind      3

/* new ones for V38.1 */

#define fileReqKind     4
#define dirReqKind      5

/* ---------------------- results from ShowRequester --------------------- */

#define reqYes     1    /* V38.0  yncReqKind */
#define reqNo      2    /* V38.0             */
#define reqCancel  0    /* V38.0             */
#define reqOK      0    /* V38.0  okReqKind */
#define reqDo      1    /* V38.0  doitReqKind */
#define reqLeave   0    /* V38.0              */
#define reqAslCancel 0  /* V38.1  all Asl requesters */
#define reqAslOK     1  /* V83.1                     */

/* --------------- gadget size and position description flags V38.1 ------ */

#define distNorm    0  /* Normal distance */
#define distAbs     1  /* absolute distance from an object */
#define distRel     2  /* relative distance from an object */
#define distPercent 3  /* percentual distance */

#define objBorder   0  /* window border */
#define objGadget   4  /* gadget (standard is previous gadget) */

#define objRight    0  /* distance from which part of the object */
#define objBottom   0
#define objLeft    32
#define objTop     32

#define shiftLeft    256*256*256 /* Use these to create the data */
#define shiftTop     256*256     /* for the SG_GadgetDesc tag */
#define shiftWidth   256         /* */
#define shiftHeight  1           /* */

/* macros for the SG_GadgetDesc and the SG_GadgetObjects tag */
#define GADDESC(l,t,w,h)   (shiftLeft*(l)+shiftTop*(t)+shiftWidth*(w)+h)
#define GADOBJS(l,t,w,h)   (shiftLeft*(l)+shiftTop*(t)+shiftWidth*(w)+h)

/* ======================================================================= */
/*                                 Types                                   */
/* ======================================================================= */

/* ------------------------ Hook-Functions ------------------------------- */

/* Hook function for key equivalents       V38.0

     GUITools calls the hook function in this way:

     ULONG vk_Function(register __d0 char key,
                       register __a0 WORD  *nbr,
                       register __a1 WORD  *shift);

     D0 contains the key . A0 is a pointer to WORD. Through this WORD the
     hook-function specifies the gadget-number.
     A1 points to WORD. Should the key treated as a shifted key (0 = no/
     FALSE or 1 = yes/TRUE).
     The result must be TRUE, if the key is an equivalent.


   MenuFct:                             V38.0

     ULONG menu_Function(void)

                    This function is called, when an IDCMP_MenuPick-Message
                    arrives and the GFLG_CallMenuData-flag is set.
                    If you want to wait for further messages return
                    TRUE / 1, otherwise 0 / FALSE to exit the message-loop

  New Hook function for key equivalents       V38.1

     GUITools calls this new hook function in this way:

     ULONG vk_Function(register __d0 char key,
                       register __a0 WORD *nbr,
                       register __a1 WORD *shift,
                       register __a2 APTR userData);

     D0 contains the key . A0 is a pointer to WORD. Through this WORD the
     hook-function specifies the gadget-number.
     A1 points to WORD. Should the key treated as a shifted key (0 = no/
     FALSE or 1 = yes/TRUE).
     A2 is a pointer to user defined data.
     The result must be TRUE, if the key is an equivalent.


   New MenuFct:                             V38.1

     ULONG menu_Function(register __a0 APTR userData)

                    This function is called, when an IDCMP_MenuPick-Message
                    arrives and the GFLG_CallMenuData-flag is set.
                    If you want to wait for further messages return
                    TRUE / 1, otherwise 0 / FALSE to exit the message-loop.
                    You get in A0 a pointer to user defined data.
*/


/* --------------------------- GUIInfoFlagSet ---------------------------- */


#define GFLG_StringNotify             0x0000001
                                    /* notifies the string-address */
#define GFLG_IntegerNotify            0x0000002  /* GTIN_Number : &LONG */
#define GFLG_LinkEntryGads            0x0000004
                                    /* activate automatically the next
                                       entry-gadget */
#define GFLG_CycleEntryGads           0x0000008
                                    /* If you exit the last EntryGadget
                                       activate again the first one */
#define GFLG_ActivateFirstEGad        0x0000010
                                    /* after creating gadgets, activate
                                       the first entry gadget */
#define GFLG_CycleNotify              0x0000020  /* GTCY_Active : &UWORD */
#define GFLG_CheckboxNotify           0x0000040  /* GTCB_Checked: &UBYTE */
#define GFLG_AutoUpdateEGads          0x0000080
                                    /* Copy the contents of the entry-
                                       gadgets in the variables when an
                                       IDCMP_GadgetUp-Message arrives */
#define GFLG_MXNotify                 0x0000100  /* GTMX_Active : &UWORD */

/* Flags of version 38.0 */

#define GFLG_VanillaKeysNotify        0x0000200  /* notify key equivalents */
#define GFLG_ConvertKeys              0x0000400  /* and convert them auto-
                                                    matically into gadget
                                                    messages if hit */
#define GFLG_NoHandleIntMsgCall       0x0000800  /* do not call HandleIntMsg
                                                    when using WaitIntMsg or
                                                    GetIntMsg */
#define GFLG_SliderNotify             0x0001000  /* GTSL_Level : &WORD */
#define GFLG_ScrollerNotify           0x0002000  /* GTSC_Top   : &WORD */
#define GFLG_ListviewNotify           0x0004000  /* GTLV_Selected : &UWORD */
#define GFLG_InternMsgHandling        0x0008000  /* the messages that are
                                                    complete processed by
                                                    GUITools will not be send
                                                    to the main-program */
#define GFLG_LVKeyClearTime           0x0010000  /* this clears the Sekonds
                                                    field of the IntuiMessage
                                                    from a LISTVIEW_KIND
                                                    gadget if the key equi-
                                                    valent was used */
#define GFLG_AllowAllVanillaKeys      0x0020000  /* All key equivalents are
                                                    allowed and not only
                                                    letters */
#define GFLG_AddBorderDims            0x0040000  /* Adds when defining a
                                                    gadget window->BorderLeft
                                                    to left and window->
                                                    BorderTop to top */
#define GFLG_CallVanillaKeyFct        0x0080000  /* calls the hook function
                                                    if GUITools can't handle
                                                    the IDCMP_VanillaKey
                                                    code */
#define GFLG_CallMenuData             0x0100000  /* jsr menuitem->MenuData */
#define GFLG_DoRefresh                0x0200000  /* automatic refresh */
#define GFLG_AddStdUnderscore         0x0400000  /* add GT_Underscore-Tag */
#define GFLG_PaletteNotify            0x0800000  /* GTPA_Color : &UWORD */

/* Flags for version 38.1 */

#define GFLG_DoResizing               0x1000000  /* automatic resizing */


/* ---------------------------- GUIInfo ---------------------------------- */

struct gadmsg {
       WORD  gadID;                   /* with IDCMP_GadgetUp/GadgetDown-
                                         Msgs: gadgetID */
       struct Gadget *gadget;         /* and pointer to event-gadget */
       };
struct menumsg {
       WORD menuNum;                  /* corresponding numbers for */
       WORD itemNum;                  /* IDCMP_MenuPick and IDCMP_MenuHelp */
       WORD subNum;                   /* V38.0 messages */
       };

struct GUIGadlist {
       struct Gadget *allGadgets[256];
       };

struct GUIMenulist {
       struct NewMenu allMenus[256];
       };

struct GUIInfo {

  struct Window *window;             /* pointer to the used window */
  struct Screen *screen;             /* pointer to window-screen */
  struct TextAttr  font;             /* Font for menus und gadgets (V37.3),
                                        can be changed. From V38.0 on only
                                        for gadgets when using
                                        CreateGUIInfoTags ! */
  APTR   visual;                     /* Pointer to screens VisualInfo */
  struct MsgPort *port;              /* Pointer to IDCMP-Port, kcan be
                                        changed for multiple windows with
                                        a shared port (not yet tested!) */
  struct Gadget *gadlist;            /* pointer to gadget-list */
  struct DrawInfo *drawinfo;         /* V38.0 Pointer to a copy of DrawInfo */
  struct NewGadget newgad;           /* used for CreateGadget,
                                        can be directly manipulated */
  WORD   actgad;                     /* actuel CreateGadget */
  WORD   winIWidth;                  /* V38.1 window inner width */
  struct GUIGadlist *gadgets;        /* max 256 ! */

  struct Menu  *menus;               /* Pointer to new menu */
  WORD   actmenu;                    /* same as with gadgets */
  WORD   winIHeight;                 /* V38.1 window inner height */
  struct GUIMenulist *newMenus;      /* max 256 ! */

  struct IntuiMessage im;            /* copy of IntuiMessage */

  union {
    struct gadmsg  gm;
    struct menumsg mm;
  } im_un;

  ULONG  flags;                      /* valid flags, to be changed */

  union {
    UWORD  cardCode;                 /* V38.0 copy of the IntuiMsg code */
    WORD   intCode;                  /* V38.0 */
    struct oc {
      UBYTE boolCode;                /* V38.0 for CHECKBOX_KIND */
      char  charCode;                /* V38.0 */
    };
  } mc_un;

  WORD  gadNbr;                      /* V38.0 gadget-number in the
                                              gadgets field */
  struct TextAttr *menuFont;         /* V38.0 pointer to menuFont. Is set to
                                        screens font with CreateGUIInfoTags
                                        and to GUIInfo->font with
                                        CreateGUIInfo */
  APTR   vanKeyHook;                 /* V38.0 Hook fct for key equivalents */
  ULONG  msgClass;                   /* IntuiMessage-IDCMPFlags */

  union {
    struct MenuItem *itemAdr;        /* V38.0 Item address */
    struct NewMenu  *menuAdr;        /* V38.0 act NewMenu */
  } ma_un;
  APTR   vanKeyFctData;              /* V38.1 NewVanKeyFct user data */
  APTR   menuFctData;                /* V38.1 NewMenuFct user data */
  APTR   userData;                   /* V38.1 for own data */
  APTR   compilerReg;                /* V38.1 for compiler data reg */
};


/* --------------------------- GUIGadgetInfo ----------------------------- */

struct GUIGadgetInfo     /* a pointer to this structure is stored in
                            gadget->UserData */
{
  APTR  userData;        /* use this for own user-data */
  ULONG kind;            /* gadget kind */
};


/* ======================================================================= */
/*                                 Tags                                    */
/* ======================================================================= */

/* -------------------- Tags for CreateGUIInfoTags ----------------------- */

/* Tags for version 38.0 */
#define GUI_Dummy             (TAG_USER + 0x15000)
#define GUI_ResizableGads     (GUI_Dummy + 1)   /* UBYTE / 0 */
#define GUI_Flags             (GUI_Dummy + 2)   /* ULONG / 0 */
#define GUI_GadFont           (GUI_Dummy + 3)   /* *TextAttr /
                                                   window->Font =gui->font*/
#define GUI_MenuFont          (GUI_Dummy + 4)   /* *TextAttr /screen->Font */
#define GUI_VanKeyFct         (GUI_Dummy + 5)   /* APTR / NULL */
#define GUI_CreateError       (GUI_Dummy + 6)   /* *LONG / NULL */
#define GUI_SetProcessWindow  (GUI_Dummy + 7)   /* UBYTE / 0 */
#define GUI_RestoreProcessWindow (GUI_Dummy+8)  /* UBYTE / 0 */
#define GUI_RefreshWindowFrame   (GUI_Dummy+9)  /* UBYTE */
/* Tags for version 38.1 */
#define GUI_VanKeyFctData     (GUI_Dummy +10)   /* APTR / gui */
#define GUI_MenuFctData       (GUI_Dummy +11)   /* APTR / gui */
#define GUI_UserData          (GUI_Dummy +12)   /* APTR / NIL */
#define GUI_CompilerReg       (GUI_Dummy +13)   /* APTR / NIL */
#define GUI_UseGadDesc        (GUI_Dummy +14)   /* UBYTE / 0 */

/* -------------------- Tags for CreateSpecialGadget --------------------- */

/* Tags for version 38.0 */
#define SG_Dummy              (TAG_USER + 0x16000)
#define SG_GadgetText         (SG_Dummy + 1)    /* APTR / NULL */
#define SG_GadgetFlags        (SG_Dummy + 2)    /* ULONG / 0 */
#define SGPI_MaxValue         (SG_Dummy + 3)    /* UWORD / 100 */
#define SGPI_CurrentValue     (SG_Dummy + 4)    /* UWORD /   0 */
#define SGBB_Recessed         (SG_Dummy + 5)    /* UBYTE / 0 */
/* Tags for version 38.1 */
#define SG_GadgetFont         (SG_Dummy + 6)
#define SG_GadgetID           (SG_Dummy + 7)
#define SG_VisualInfo         (SG_Dummy + 8)
#define SG_UserData           (SG_Dummy + 9)
#define SG_GadgetDesc         (SG_Dummy +10)
#define SG_GadgetObjects      (SG_Dummy +11)


/* -------------------- Tags for ShowRequester --------------------------- */

/* Tags for version 38.0 */
#define SR_Dummy              (TAG_USER + 0x17000)
#define SR_Gadgets            (SR_Dummy + 1)    /* *char / NULL */
#define SR_Args               (SR_Dummy + 2)    /* APTR / NULL */
#define SR_Flags              (SR_Dummy + 3)    /* ULONG / 0 */
#define SR_Title              (SR_Dummy + 4)    /* *char / NULL */
#define SR_IDCMP              (SR_Dummy + 5)    /* *ULONG / NULL */
#define SR_ReqWindow          (SR_Dummy + 6)    /* *Window / gui->window */
/* Tags for version 38.1 */
#define SR_AslPattern         (SR_Dummy + 7)    /* *char / NULL */
#define SR_AslNameBuffer      (SR_Dummy + 8)    /* *char / NULL */
#define SR_AslFileBuffer      (SR_Dummy + 9)    /* *char / NULL */
#define SR_AslDirBuffer       (SR_Dummy +10)    /* *char / NULL */
#define SR_AslSave            (SR_Dummy +11)    /* UBYTE / 0 */


/* --------- protos ------------- */

struct GUIInfo *CreateGUIInfo(struct window *, WORD, WORD);
void FreeGUIInfo(struct GUIInfo *);
WORD SetGUI(struct GUIInfo *);
void CreateGadgetA(struct GUIInfo *, WORD, WORD, WORD, WORD, ULONG,
                   struct TagItem *);
void CreateGadget(struct GUIInfo *, WORD, WORD, WORD, WORD, ULONG,
                  ULONG, ...);
void CreateGadgetTextA(struct GUIInfo *, WORD, WORD, WORD, WORD, ULONG,
                       STRPTR, struct TagItem *);
void CreateGadgetText(struct GUIInfo *, WORD, WORD, WORD, WORD, ULONG,
                      STRPTR, ULONG, ...);
void CreateGadgetFullA(struct GUIInfo *, WORD, WORD, WORD, WORD, ULONG,
                       STRPTR, ULONG, struct TagItem *);
void CreateGadgetFull(struct GUIInfo *, WORD, WORD, WORD, WORD, ULONG,
                      STRPTR, ULONG, ULONG, ...);
void MakeMenuEntry(struct GUIInfo *, UBYTE, STRPTR, STRPTR);
void WaitIntMsg(struct GUIInfo *);
UBYTE GetIntMsg(struct GUIInfo *);
void EmptyIntMsgPort(struct GUIInfo *);
void GadgetStatus(struct GUIInfo *, WORD, UBYTE);
void ModifyGadgetA(struct GUIInfo *, WORD, struct TagItem *);
void ModifyGadget(struct GUIInfo *, WORD, ULONG, ...);
void UpdateEntryGadgets(struct GUIInfo *);
struct TextAttr *TopazAttr(void);
struct TextFont *GetOwnFont(STRPTR, UWORD, struct TextAttr *);
void RemOwnFont(struct TextFont *);
struct Screen *OpenIntScreen(ULONG, WORD, STRPTR, struct TextAttr *);
struct Window *OpenIntWindow(WORD, WORD, WORD, WORD, STRPTR, ULONG, ULONG,
                             struct Screen *);
void CloseIntWindow(struct Window *);
void CloseIntScreen(struct Screen *);
void HandleIntMsg(struct GUIInfo *);
void UpdateEGad(struct GUIInfo *, WORD);

/* Version 38.0 */

void DrawBox(struct GUIInfo *, WORD, WORD, WORD, WORD, UBYTE);
void ConvKMsgToGMsg(struct GUIInfo *);
void VarToGad(struct GUIInfo *, WORD);
void AllVarsToGad(struct GUIInfo *);
void GadWithKey(struct GUIInfo *, WORD, UBYTE);
struct Screen *OpenIntScreenTagList(ULONG, WORD, STRPTR, struct TextAttr *,
                                    struct TagItem *);
struct Screen *OpenIntScreenTags(ULONG, WORD, STRPTR, struct TextAttr *,
                                 ULONG, ...);
struct Window *OpenIntWindowTagList(WORD,WORD, WORD, WORD, STRPTR, ULONG,
                      ULONG, struct Screen *, struct TagItem *);
struct Window *OpenIntWindowTags(WORD,WORD, WORD, WORD, STRPTR, ULONG,
                      ULONG, struct Screen *, ULONG, ...);
WORD RedrawGadgets(struct GUIInfo *, UBYTE);
WORD RedrawMenu(struct GUIInfo *);
void ResizeGadget(struct GUIInfo *, WORD, WORD, WORD, WORD, WORD);
void NewGadgetFont(struct GUIInfo *, WORD, struct TextAttr *);
void NewGadgetText(struct GUIInfo *, WORD, STRPTR);
void RemoveGadgets(struct GUIInfo *, UBYTE);
void RemoveMenu(struct GUIInfo *, UBYTE);
struct GUIInfo *CreateGUIInfoTagList(struct Window *, WORD, WORD,
                                  struct TagItem *);
struct GUIInfo *CreateGUIInfoTags(struct Window *, WORD, WORD,
                                  ULONG, ...);
void NewFontAllGadgets(struct GUIInfo *, struct TextAttr *);
void ClearWindow(struct GUIInfo *);
void CreateSpecialGadgetA(struct GUIInfo *, WORD, WORD, WORD, WORD, ULONG,
                          struct TagItem *);
void CreateSpecialGadget(struct GUIInfo *, WORD, WORD, WORD, WORD, ULONG,
                         ULONG, ...);
void BeginRefresh(struct GUIInfo *);
void EndRefresh(struct GUIInfo *, UBYTE);
LONG ShowRequesterA(struct GUIInfo *, STRPTR, ULONG, struct TagItem *);
LONG ShowRequester(struct GUIInfo *, STRPTR, ULONG, ULONG, ...);                                     /* V38.0 */
struct Window *SetProcessWindow(struct Window *);
LONG SimpleReq(STRPTR, ULONG);

/* Version 38.1 */

void CreateGadgetNewA(struct GUIInfo *, WORD, WORD, WORD, WORD, ULONG,
                      struct TagItem *);
void CreateGadgetNew(struct GUIInfo *, WORD, WORD, WORD, WORD, ULONG,
                     ULONG, ...);
void DoResize(struct GUIInfo *);


/* --------- pragmas ------------ */

extern struct Library *GUIToolsBase;

#pragma libcall GUIToolsBase CreateGUIInfo 1e 10803
#pragma libcall GUIToolsBase FreeGUIInfo 24 801
#pragma libcall GUIToolsBase SetGUI 2a 801
#pragma libcall GUIToolsBase CreateGadgetA 30 943210807
#pragma tagcall GUIToolsBase CreateGadget  30 943210807
#pragma libcall GUIToolsBase CreateGadgetTextA 36 A943210808
#pragma tagcall GUIToolsBase CreateGadgetText  36 A943210808
#pragma libcall GUIToolsBase CreateGadgetFullA 3c A5943210809
#pragma tagcall GUIToolsBase CreateGadgetFull  3c A5943210809
#pragma libcall GUIToolsBase MakeMenuEntry 42 A90804
#pragma libcall GUIToolsBase WaitIntMsg 48 801
#pragma libcall GUIToolsBase GetIntMsg 4e 801
#pragma libcall GUIToolsBase EmptyIntMsgPort 54 801
#pragma libcall GUIToolsBase GadgetStatus 60 10803
#pragma libcall GUIToolsBase ModifyGadgetA 66 90803
#pragma tagcall GUIToolsBase ModifyGadget  66 90803
#pragma libcall GUIToolsBase UpdateEntryGadgets 6c 801
#pragma libcall GUIToolsBase TopazAttr 72 0
#pragma libcall GUIToolsBase GetOwnFont 78 90803
#pragma libcall GUIToolsBase RemOwnFont 7e 801
#pragma libcall GUIToolsBase OpenIntScreen 84 981004
#pragma libcall GUIToolsBase OpenIntWindow 8a 9548321008
#pragma libcall GUIToolsBase CloseIntWindow 90 801
#pragma libcall GUIToolsBase CloseIntScreen 96 801
#pragma libcall GUIToolsBase HandleIntMsg 9c 801
#pragma libcall GUIToolsBase UpdateEGad a2 0802

/* Version 38.0 */

#pragma libcall GUIToolsBase DrawBox 5a 43210806
#pragma libcall GUIToolsBase ConvKMsgToGMsg a8 801
#pragma libcall GUIToolsBase VarToGad ae 0802
#pragma libcall GUIToolsBase AllVarsToGad b4 801
#pragma libcall GUIToolsBase GadWithKey ba 10803
#pragma libcall GUIToolsBase OpenIntScreenTagList c0 A981005
#pragma tagcall GUIToolsBase OpenIntScreenTags    c0 A981005
#pragma libcall GUIToolsBase OpenIntWindowTagList c6 A9548321009
#pragma tagcall GUIToolsBase OpenIntWindowTags    c6 A9548321009
#pragma libcall GUIToolsBase RedrawGadgets cc 0802
#pragma libcall GUIToolsBase RedrawMenu d2 801
#pragma libcall GUIToolsBase ResizeGadget d8 43210806
#pragma libcall GUIToolsBase NewGadgetFont de 90803
#pragma libcall GUIToolsBase NewGadgetText e4 90803
#pragma libcall GUIToolsBase RemoveGadgets ea 0802
#pragma libcall GUIToolsBase RemoveMenu f0 0802
#pragma libcall GUIToolsBase CreateGUIInfoTagList f6 910804
#pragma tagcall GUIToolsBase CreateGUIInfoTags    f6 910804
#pragma libcall GUIToolsBase NewFontAllGadgets  fc 9802
#pragma libcall GUIToolsBase ClearWindow 102 801
#pragma libcall GUIToolsBase CreateSpecialGadgetA 108 943210807
#pragma tagcall GUIToolsBase CreateSpecialGadget  108 943210807
#pragma libcall GUIToolsBase BeginRefresh 10e 801
#pragma libcall GUIToolsBase EndRefresh 114 0802
#pragma tagcall GUIToolsBase ShowRequesterA 11a A09804
#pragma tagcall GUIToolsBase ShowRequester 11a A09804
#pragma libcall GUIToolsBase SetProcessWindow 120 801
#pragma libcall GUIToolsBase SimpleReq 126 0802

/* Version 38.1 */

#pragma libcall GUIToolsBase CreateGadgetNewA 108 943210807
#pragma tagcall GUIToolsBase CreateGadgetNew  108 943210807
#pragma libcall GUIToolsBase DoResizing 12c 801


/* ATTENTION:

   Include obsolete identifiers:
   The name of these identifiers has changed beginning with version 38.1
   so use the new ones instead ! */

#ifndef GUITOOLS_OBSOLETE_H

void CreateGadgetTag(struct GUIInfo *, WORD, WORD, WORD, WORD, ULONG,
                     struct TagItem *);
void CreateGadgetTextTag(struct GUIInfo *, WORD, WORD, WORD, WORD, ULONG,
                         STRPTR, struct TagItem *);
void CreateGadgetFullTag(struct GUIInfo *, WORD, WORD, WORD, WORD, ULONG,
                         STRPTR, ULONG, struct TagItem *);
void ModifyGadgetTag(struct GUIInfo *, WORD, struct TagItem *);

#pragma libcall GUIToolsBase CreateGadgetTag 30 943210807
#pragma libcall GUIToolsBase CreateGadgetTextTag 36 A943210808
#pragma libcall GUIToolsBase CreateGadgetFullTag 3c A5943210809
#pragma libcall GUIToolsBase ModifyGadgetTag 66 90803

/* Version 38.0 */
void CreateSpecialGadgetTag(struct GUIInfo *, WORD, WORD, WORD, WORD, ULONG,
                            struct TagItem *);
LONG ShowRequesterTag(struct GUIInfo *, STRPTR, ULONG,
                      struct TagItem *);

#pragma libcall GUIToolsBase CreateSpecialGadgetTag 108 943210807
#pragma libcall GUIToolsBase ShowRequesterTag 11a A09804

#endif

#endif /* LIBRARIES_GUITOOLS_H */
