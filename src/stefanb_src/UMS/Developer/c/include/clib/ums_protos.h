#ifndef CLIB_UMS_PROTOS_H
#define CLIB_UMS_PROTOS_H

/*
 * clib/ums_protos.h
 *
 * ANSI C prototypes for ums.library functions
 *
 * $VER: ums_protos.h 11.5 (12.06.95)
 *
 */

#ifndef LIBRARIES_UMS_H
#include <libraries/ums.h>
#endif

/* Pre-V9 functions */

UMSAccount  UMSLogin          (STRPTR,    STRPTR);
VOID        UMSLogout         (UMSAccount);

UMSError    UMSErrNum         (UMSAccount);
STRPTR      UMSErrTxt         (UMSAccount);
BOOL        UMSDeleteMsg      (UMSAccount,UMSMsgNum);

/* V9 functions */

VOID        UMSExportedMsg    (UMSAccount,UMSMsgNum);
BOOL        UMSCannotExport   (UMSAccount,UMSMsgNum,        STRPTR);

VOID        UMSVLog           (UMSAccount,LONG,             STRPTR, APTR);
VOID        UMSLog            (UMSAccount,LONG,             STRPTR, ...);

UMSAccount  UMSRLogin         (STRPTR,    STRPTR,           STRPTR);

UMSMsgNum   UMSWriteMsg       (UMSAccount,struct TagItem *);
UMSMsgNum   UMSWriteMsgTags   (UMSAccount,Tag,              ...);
BOOL        UMSReadMsg        (UMSAccount,struct TagItem *);
BOOL        UMSReadMsgTags    (UMSAccount,Tag,              ...);
VOID        UMSFreeMsg        (UMSAccount,UMSMsgNum);

LONG        UMSSelect         (UMSAccount,struct TagItem *);
LONG        UMSSelectTags     (UMSAccount,Tag,              ...);
UMSMsgNum   UMSSearch         (UMSAccount,struct TagItem *);
UMSMsgNum   UMSSearchTags     (UMSAccount,Tag,              ...);

STRPTR      UMSReadConfig     (UMSAccount,struct TagItem *);
STRPTR      UMSReadConfigTags (UMSAccount,Tag,              ...);
VOID        UMSFreeConfig     (UMSAccount,STRPTR);
BOOL        UMSWriteConfig    (UMSAccount,struct TagItem *);
BOOL        UMSWriteConfigTags(UMSAccount,Tag,              ...);

/* V11 functions */

UMSError    UMSServerControl  (STRPTR    ,LONG);
BOOL        UMSMatchConfig    (UMSAccount,struct TagItem *);
BOOL        UMSMatchConfigTags(UMSAccount,Tag,              ...);
STRPTR      UMSErrTxtFromNum  (UMSError);
UMSAccount  UMSDupAccount     (UMSAccount);

#ifndef UMS_V11_NAMES_ONLY

/* old Pre-V11 function names */

#define LogUMS UMSVLog
#define LogUms UMSLog

#define WriteUMSMsg     UMSWriteMsg
#define WriteUMSMsgTags UMSWriteMsgTags
#define ReadUMSMsg      UMSReadMsg
#define ReadUMSMsgTags  UMSReadMsgTags
#define FreeUMSMsg      UMSFreeMsg

#define ReadUMSConfig      UMSReadConfig
#define ReadUMSConfigTags  UMSReadConfigTags
#define FreeUMSConfig      UMSFreeConfig
#define WriteUMSConfig     UMSWriteConfig
#define WriteUMSConfigTags UMSWriteConfigTags

#endif
#endif
