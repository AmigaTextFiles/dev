#ifndef CLIB_GADOUTLINE_PROTOS_H
#define CLIB_GADOUTLINE_PROTOS_H

#ifndef LIBRARIES_GADOUTLINE_H
#include <libraries/gadoutline.h>
#endif

// =====================================================
// BASIC GADOUTLINE INTERFACE FUNCTIONS
// =====================================================

void FreeGadOutline(struct GadOutline *GadOutline);

struct GadOutline *AllocGadOutlineA(ULONG *Outline, struct TagItem *TagList);

void DimenGadOutlineA(struct GadOutline *GadOutline, struct TagItem *TagList);

void RebuildGadOutlineA(struct GadOutline *GadOutline, 
                        struct TagItem *TagList);

void ResizeGadOutlineA(struct GadOutline *GadOutline, 
                       struct TagItem *TagList);

void UpdateGadOutlineA(struct GadOutline *GadOutline, 
                       struct TagItem *TagList);

void DestroyGadOutlineA(struct GadOutline *GadOutline, 
                        struct TagItem *TagList);

void DrawGadOutlineA(struct GadOutline *GadOutline, struct TagItem *TagList);

void HookGadOutlineA(struct GadOutline *GadOutline, struct TagItem *TagList);

void UnhookGadOutlineA(struct GadOutline *GadOutline, 
                       struct TagItem *TagList);

// =====================================================
// COMMAND HOOK GADOUTLINE INTERFACE FUNCTIONS
// =====================================================

ULONG GO_CallCmdHookA(struct CmdInfo *Command, struct CmdHookMsg *Message);

ULONG GO_ContCmdHookA(struct CmdInfo *Command, struct CmdHookMsg *Message);

LONG GO_InterpretTypedSize(struct GadOutline *GadOutline, LONG CurrentValue, 
                           TYPEDSIZE TypedSize);

LONG GO_ParseTypedSizeListA(struct GadOutline *GadOutline, LONG CurrentValue, 
                            struct TagItem *TypedSizeTags);

// =====================================================
// TRANSLATION HOOK GADOUTLINE INTERFACE FUNCTIONS
// =====================================================

ULONG GO_CallTransHookA(struct GadOutline *GadOutline, 
                        struct CmdHookMsg *Message);

ULONG GO_ContTransHookA(struct GadOutline *GadOutline, 
                        struct CmdHookMsg *Message);

// =====================================================
// GADOUTLINE RESOURCE INTERFACE FUNCTIONS
// =====================================================

void *GO_AllocMem(struct GadOutline *GadOutline, GOERR ErrReport, ULONG Size, 
                  ULONG Flags);

void GO_FreeMem(void *Address);

struct Library *GO_OpenLibrary(struct GadOutline *GadOutline, 
                               GOERR ErrReport, UBYTE *Name, ULONG Version);

void GO_CloseLibrary(struct GadOutline *GadOutline, struct Library *LibBase);

// =====================================================
// GADOUTLINE DATA STRUCTURE INTERFACE FUNCTIONS
// =====================================================

struct CmdInfo *GO_GetCmdInfo(struct GadOutline *GadOutline, CMDID SearchID, 
                              struct CmdInfo *PrevCmd);

struct BoxAttr *GO_GetBoxAttr(struct GadOutline *GadOutline, CMDID SearchID, 
                              struct BoxAttr *PrevBox);

struct ObjectAttr *GO_GetObjectAttr(struct GadOutline *GadOutline, 
                                    CMDID SearchID, 
                                    struct ObjectAttr *PrevObject);

struct ImageAttr *GO_GetImageAttr(struct GadOutline *GadOutline, 
                                  CMDID SearchID, 
                                  struct ImageAttr *PrevImage);

// =====================================================
// GADOUTLINE ERROR CONTROL AND REPORTING FUNCTIONS
// =====================================================

ULONG GO_SetErrorA(struct GadOutline *GadOutline, GOERR ErrorCode, 
                   void *ErrorObject, UBYTE **Params);

GOERR GO_GetErrorCode(struct GadOutline *GadOutline);

UBYTE *GO_GetErrorText(struct GadOutline *GadOutline);

void *GO_GetErrorObject(struct GadOutline *GadOutline);

ULONG GO_ShowErrorA(struct GadOutline *GadOutline, GOERR ErrorCode, 
                    void *ErrorObject, UBYTE **Params);

// =====================================================
// GADOUTLINE SCREEN AND WINDOW INTERFACE FUNCTIONS
// =====================================================

struct Screen *GO_OpenScreenA(struct GadOutline *GadOutline, 
                              struct TagItem *TagList);

void GO_CloseScreen(struct GadOutline *GadOutline);

struct Window *GO_OpenWindowA(struct GadOutline *GadOutline, 
                              struct TagItem *TagList);

void GO_CloseWindow(struct GadOutline *GadOutline);

// =====================================================
// GADOUTLINE ATTRIBUTE INTERFACE FUNCTIONS
// =====================================================

void GO_SetCmdAttrsA(struct GadOutline *GadOutline, CMDID CmdID, ULONG Flags, 
                     struct TagItem *TagList);

void GO_SetCmdGrpAttrsA(struct GadOutline *GadOutline, CMDID CmdID, 
                        ULONG Flags, struct TagItem *TagList);

void GO_SetObjAttrsA(struct GadOutline *GadOutline, CMDID CmdID, ULONG Flags, 
                     struct TagItem *TagList);

void GO_SetObjGrpAttrsA(struct GadOutline *GadOutline, CMDID CmdID, 
                        ULONG Flags, struct TagItem *TagList);

void GO_GetCmdAttrsA(struct GadOutline *GadOutline, CMDID StdID, ULONG Flags, 
                     struct TagItem *TagList);

ULONG GO_GetCmdAttr(struct GadOutline *GadOutline, CMDID StdID, ULONG Flags, 
                    Tag GetTag, ULONG DefaultValue);

void GO_GetObjAttrsA(struct GadOutline *GadOutline, CMDID StdID, ULONG Flags, 
                     struct TagItem *TagList);

ULONG GO_GetObjAttr(struct GadOutline *GadOutline, CMDID StdID, ULONG Flags, 
                    Tag GetTag, ULONG DefaultValue);

void GO_ResetCmdAttrsA(struct GadOutline *GadOutline, CMDID CmdID, 
                       ULONG Flags, struct TagItem *TagList);

void GO_ResetCmdGrpAttrsA(struct GadOutline *GadOutline, CMDID CmdID, 
                          ULONG Flags, struct TagItem *TagList);

void GO_ResetObjAttrsA(struct GadOutline *GadOutline, CMDID CmdID, 
                       ULONG Flags, struct TagItem *TagList);

void GO_ResetObjGrpAttrsA(struct GadOutline *GadOutline, CMDID CmdID, 
                          ULONG Flags, struct TagItem *TagList);

// =====================================================
// GADOUTLINE IDCMP PROCESSING INTERFACE FUNCTIONS
// =====================================================

struct GadOutline *GO_GetGOFromIMsg(struct IntuiMessage *Message);

struct GadOutline *GO_GetGOFromGOIMsg(struct GOIMsg *Message);

struct GOIMsg *GO_DupGOIMsg(struct GadOutline *GadOutline, 
                            struct GOIMsg *Message);

struct GOIMsg *GO_UndupGOIMsg(struct GOIMsg *Message);

void GO_AttachHotKey(struct GadOutline *GadOutline, ULONG KeyCode, 
                     CMDID CmdID);

void GO_ParseGOIMsgA(struct GadOutline *GadOutline, CMDID StdID, 
                     struct GOIMsg *Message, struct TagItem *TagList);

struct CmdInfo *GO_CmdAtPointA(struct GadOutline *GadOutline, 
                               struct GOIMsg *Message, 
                               struct CmdInfo *PrevCmd, 
                               struct TagItem *TagList);

// =====================================================
// GADOUTLINE MESSAGE AND REFRESH INTERFACE FUNCTIONS
// =====================================================

struct GOIMsg *GO_FilterGOIMsg(struct GadOutline *GadOutline, 
                               struct IntuiMessage *Message);

struct IntuiMessage *GO_PostFilterGOIMsg(struct GOIMsg *Message);

struct GOIMsg *GO_GetGOIMsg(struct GadOutline *GadOutline);

void GO_ReplyGOIMsg(struct GOIMsg *Message);

void GO_BeginRefresh(struct GadOutline *GadOutline);

void GO_EndRefresh(struct GadOutline *GadOutline, BOOL Complete);

// =====================================================
// VARARGS VERSIONS OF LIBRARY FUNCTIONS
// =====================================================

struct GadOutline *AllocGadOutline(ULONG *Outline, ULONG Tag1Type, ...);
void DimenGadOutline(struct GadOutline *GadOutline, ULONG Tag1Type, ...);
void RebuildGadOutline(struct GadOutline *GadOutline, 
                        ULONG Tag1Type, ...);
void ResizeGadOutline(struct GadOutline *GadOutline, 
                       ULONG Tag1Type, ...);
void UpdateGadOutline(struct GadOutline *GadOutline, 
                       ULONG Tag1Type, ...);
void DestroyGadOutline(struct GadOutline *GadOutline, 
                        ULONG Tag1Type, ...);
void DrawGadOutline(struct GadOutline *GadOutline, ULONG Tag1Type, ...);
void HookGadOutline(struct GadOutline *GadOutline, ULONG Tag1Type, ...);
void UnhookGadOutline(struct GadOutline *GadOutline, 
                       ULONG Tag1Type, ...);

ULONG GO_CallCmdHook(struct CmdInfo *Command, ULONG Message, ULONG NumArgs, ...);
ULONG GO_ContCmdHook(struct CmdInfo *Command, ULONG Message, ULONG NumArgs, ...);
LONG GO_ParseTypedSizeList(struct GadOutline *GadOutline, LONG CurrentValue, 
                            ULONG Size1Type, ...);

ULONG GO_CallTransHook(struct GadOutline *GadOutline, 
                        ULONG Message, ULONG NumArgs, ...);
ULONG GO_ContTransHook(struct GadOutline *GadOutline, 
                        ULONG Message, ULONG NumArgs, ...);

ULONG GO_SetError(struct GadOutline *GadOutline, GOERR ErrorCode, 
                   void *ErrorObject, UBYTE *Format, ...);
ULONG GO_ShowError(struct GadOutline *GadOutline, GOERR ErrorCode, 
                    void *ErrorObject, UBYTE *Format, ...);

struct Screen *GO_OpenScreen(struct GadOutline *GadOutline, 
                              ULONG Tag1Type, ...);
struct Window *GO_OpenWindow(struct GadOutline *GadOutline, 
                              ULONG Tag1Type, ...);

void GO_SetCmdAttrs(struct GadOutline *GadOutline, CMDID CmdID, ULONG Flags, 
                     ULONG Tag1Type, ...);
void GO_SetCmdGrpAttrs(struct GadOutline *GadOutline, CMDID CmdID, 
                        ULONG Flags, ULONG Tag1Type, ...);
void GO_SetObjAttrs(struct GadOutline *GadOutline, CMDID CmdID, ULONG Flags, 
                     ULONG Tag1Type, ...);
void GO_SetObjGrpAttrs(struct GadOutline *GadOutline, CMDID CmdID, 
                        ULONG Flags, ULONG Tag1Type, ...);
void GO_GetCmdAttrs(struct GadOutline *GadOutline, CMDID StdID, ULONG Flags, 
                     ULONG Tag1Type, ...);
void GO_GetObjAttrs(struct GadOutline *GadOutline, CMDID StdID, ULONG Flags, 
                     ULONG Tag1Type, ...);
void GO_ResetCmdAttrs(struct GadOutline *GadOutline, CMDID CmdID, 
                       ULONG Flags, ULONG Tag1Type, ...);
void GO_ResetCmdGrpAttrs(struct GadOutline *GadOutline, CMDID CmdID, 
                          ULONG Flags, ULONG Tag1Type, ...);
void GO_ResetObjAttrs(struct GadOutline *GadOutline, CMDID CmdID, 
                       ULONG Flags, ULONG Tag1Type, ...);
void GO_ResetObjGrpAttrs(struct GadOutline *GadOutline, CMDID CmdID, 
                          ULONG Flags, ULONG Tag1Type, ...);

void GO_ParseGOIMsg(struct GadOutline *GadOutline, CMDID StdID, 
                     struct GOIMsg *Message, ULONG Tag1Type, ...);
struct CmdInfo *GO_CmdAtPoint(struct GadOutline *GadOutline, 
                               struct GOIMsg *Message, 
                               struct CmdInfo *PrevCmd, 
                               ULONG Tag1Type, ...);
#endif
