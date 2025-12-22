#ifndef LIBRARIES_UMS_H
#define LIBRARIES_UMS_H

/*
 * libraries/ums.h
 *
 * C definitions for ums.library
 *
 * $VER: ums.h 11.5 (12.06.95)
 *
 */

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

#define UMSNAME    "ums.library"
#define UMSVERSION 11

/* typedefs */
typedef void     *UMSAccount;  /* UMS user account   */
typedef LONG      UMSMsgNum;   /* UMS message number */
typedef WORD      UMSError;    /* UMS error number   */
typedef LONGBITS  UMSSet;      /* UMS bit set        */

/* actions for UMSServerControl() */
#define UMSSC_CleanUp   1
#define UMSSC_Flush     2
#define UMSSC_Quit      3
#define UMSSC_QuitForce 4
#define UMSSC_Ping      5
#define UMSSC_LockCfg   6
#define UMSSC_UnlockCfg 7

/* message array index definitions (see "ums-mf.doc") */
#define UMSCODE_MsgText         0
#define UMSCODE_FromName        1
#define UMSCODE_FromAddr        2
#define UMSCODE_ToName          3
#define UMSCODE_ToAddr          4
#define UMSCODE_MsgID           5
#define UMSCODE_CreationDate    6
#define UMSCODE_ReceiveDate     7
#define UMSCODE_ReferID         8
#define UMSCODE_Group           9
#define UMSCODE_Subject        10
#define UMSCODE_Attributes     11
#define UMSCODE_Comments       12
#define UMSCODE_Organization   13
#define UMSCODE_Distribution   14
#define UMSCODE_Folder         15
#define UMSCODE_FidoID         16
#define UMSCODE_MausID         17
#define UMSCODE_ReplyGroup     18
#define UMSCODE_ReplyName      19
#define UMSCODE_ReplyAddr      20
#define UMSCODE_LogicalToName  21
#define UMSCODE_LogicalToAddr  22
#define UMSCODE_FileName       23
#define UMSCODE_RFCMsgNum      24

#define UMSCODE_FidoText       32
#define UMSCODE_ErrorText      33
#define UMSCODE_Newsreader     34
#define UMSCODE_RfcAttr        35
#define UMSCODE_FtnAttr        36
#define UMSCODE_ZerAttr        37
#define UMSCODE_MausAttr       38

#define UMSCODE_TempFileName  127

#define UMSNUMFIELDS          128

/* message data types */
typedef char *UMSMsgTextFields[UMSNUMFIELDS];
struct MessageInfo {
                    LONG      msgi_HeaderLength;
                    LONG      msgi_TextLength;
                    LONG      msgi_Date;
                    UMSMsgNum msgi_ChainUp;
                    UMSMsgNum msgi_ChainDn;
                    UMSMsgNum msgi_ChainLt;
                    UMSMsgNum msgi_ChainRt;
                    UMSSet    msgi_GlobalStatus;
                    UMSSet    msgi_UserStatus;
                    UMSSet    msgi_LoginStatus;
                    UMSMsgNum msgi_HardLink;
                    UMSMsgNum msgi_SoftLink;
                    /* V11 extension, only filled by UMSTAG_RExtMsgInfo  */
                    LONG      msgi_CDate;
                    LONG      msgi_Reserved[3];
                   };

/* user status bits */
#define UMSUSTATB_Archive      4
#define UMSUSTATB_Junk         5
#define UMSUSTATB_PostPoned    6
#define UMSUSTATB_Selected     7
#define UMSUSTATB_Filtered    15

#define UMSUSTATF_Archive     (1L<<UMSUSTATB_Archive)
#define UMSUSTATF_Junk        (1L<<UMSUSTATB_Junk)
#define UMSUSTATF_PostPoned   (1L<<UMSUSTATB_PostPoned)
#define UMSUSTATF_Selected    (1L<<UMSUSTATB_Selected)
#define UMSUSTATF_Filtered    (1L<<UMSUSTATB_Filtered)

#define UMSUSTATB_Old          8
#define UMSUSTATB_WriteAccess  9
#define UMSUSTATB_ReadAccess  10
#define UMSUSTATB_ViewAccess  11
#define UMSUSTATB_Owner       12

#define UMSUSTATF_Old         (1L<<UMSUSTATB_Old)
#define UMSUSTATF_WriteAccess (1L<<UMSUSTATB_WriteAccess)
#define UMSUSTATF_ReadAccess  (1L<<UMSUSTATB_ReadAccess)
#define UMSUSTATF_ViewAccess  (1L<<UMSUSTATB_ViewAccess)
#define UMSUSTATF_Owner       (1L<<UMSUSTATB_Owner)

#define UMSUSTATF_Protected   (UMSUSTATF_WriteAccess | UMSUSTATF_ReadAccess | \
                               UMSUSTATF_ViewAccess  | UMSUSTATF_Owner)

/* global status bits */
#define UMSGSTATB_Deleted     0
#define UMSGSTATB_Expired     1
#define UMSGSTATB_Exported    2
#define UMSGSTATB_Orphan      3
#define UMSGSTATB_Link        4
#define UMSGSTATB_HardLink    5
#define UMSGSTATB_Parked      6
#define UMSGSTATB_HasFile     7

#define UMSGSTATF_Deleted     (1L<<UMSGSTATB_Deleted)
#define UMSGSTATF_Expired     (1L<<UMSGSTATB_Expired)
#define UMSGSTATF_Exported    (1L<<UMSGSTATB_Exported)
#define UMSGSTATF_Orphan      (1L<<UMSGSTATB_Orphan)
#define UMSGSTATF_Link        (1L<<UMSGSTATB_Link)
#define UMSGSTATF_HardLink    (1L<<UMSGSTATB_HardLink)
#define UMSGSTATF_Parked      (1L<<UMSGSTATB_Parked)
#define UMSGSTATF_HasFile     (1L<<UMSGSTATB_HasFile)

#define UMSGSTATF_Protected   (UMSGSTATF_Deleted  | UMSGSTATF_Exported | \
                               UMSGSTATF_Orphan   | UMSGSTATF_Link     | \
                               UMSGSTATF_HardLink | UMSGSTATF_HasFile)

/* UMS error numbers */
#define UMSERR_OK                  0
#define UMSERR_Unknown             1

#define UMSERR_NoSubject         100
#define UMSERR_ForbiddenCode     101
#define UMSERR_NoWriteAccess     102
#define UMSERR_NoReader          103
#define UMSERR_NoExporter        104
#define UMSERR_BadLink           105
#define UMSERR_NoWork            106
#define UMSERR_NoSysop           107
#define UMSERR_BadChange         108
#define UMSERR_GroupForm         109
#define UMSERR_ToBig             110
#define UMSERR_NotRunning        111
#define UMSERR_NoImportAcc       112
#define UMSERR_NoFromName        113
#define UMSERR_NoToName          114
#define UMSERR_CfgLocked         115
#define UMSERR_NoHardLinks       116

#define UMSERR_Dupe              200
#define UMSERR_NoReadAccess      201
#define UMSERR_NoViewAccess      202
#define UMSERR_MsgCorrupted      203
#define UMSERR_NoHdrSpace        204
#define UMSERR_NoSuchMsg         205
#define UMSERR_BadName           206
#define UMSERR_BadTag            207
#define UMSERR_MissingTag        208
#define UMSERR_NoSuchUser        209
#define UMSERR_NotFound          210
#define UMSERR_AutoBounce        211
#define UMSERR_MsgDeleted        212
#define UMSERR_NoNetAccess       213
#define UMSERR_BadPattern        214
#define UMSERR_BadVarname        215
#define UMSERR_FsFull            216
#define UMSERR_NoMsgMem          217
#define UMSERR_MissingIndex      218
#define UMSERR_MXTags            219
#define UMSERR_UserExists        220
#define UMSERR_NoSuchAlias       221
#define UMSERR_Suicide           222
#define UMSERR_ExeErr            223

#define UMSERR_ServerTerminated  300
#define UMSERR_CantWrite         301
#define UMSERR_CantRead          302
#define UMSERR_WrongMsgPtr       303
#define UMSERR_ServerNotFree     304
#define UMSERR_IDCountProb       305
#define UMSERR_NoLogin           306
#define UMSERR_WrongServer       307
#define UMSERR_NoMem             308
#define UMSERR_WrongTask         309

#define UMSERR_TCPError          400

/* Tags */
#define UMSTAG_String    0x2000
#define UMSTAG_VarPar    0x4000

/* UMSReadMsg() */
#define UMSTAG_RMsgNum         (TAG_USER +                  1)
#define UMSTAG_RHeaderLength   (TAG_USER + UMSTAG_VarPar +  2)
#define UMSTAG_RTextLength     (TAG_USER + UMSTAG_VarPar +  3)
#define UMSTAG_RMsgDate        (TAG_USER + UMSTAG_VarPar +  4)
#define UMSTAG_RChainUp        (TAG_USER + UMSTAG_VarPar +  7)
#define UMSTAG_RChainDn        (TAG_USER + UMSTAG_VarPar +  8)
#define UMSTAG_RChainLt        (TAG_USER + UMSTAG_VarPar +  9)
#define UMSTAG_RChainRt        (TAG_USER + UMSTAG_VarPar + 10)
#define UMSTAG_RGlobalFlags    (TAG_USER + UMSTAG_VarPar + 11)
#define UMSTAG_RUserFlags      (TAG_USER + UMSTAG_VarPar + 12)
#define UMSTAG_RLoginFlags     (TAG_USER + UMSTAG_VarPar + 13)
#define UMSTAG_RHardLink       (TAG_USER + UMSTAG_VarPar + 14)
#define UMSTAG_RSoftLink       (TAG_USER + UMSTAG_VarPar + 15)
#define UMSTAG_RMsgCDate       (TAG_USER + UMSTAG_VarPar + 16)

#define UMSTAG_RDateStyle      (TAG_USER +                 64)
#define UMSTAG_RIDStyle        (TAG_USER +                 68)
#define UMSTAG_RNoUpdate       (TAG_USER +                 69)

#define UMSTAG_ReadMsgField    (TAG_USER + UMSTAG_String + UMSTAG_VarPar + 256)
#define UMSTAG_RMsgText        (UMSTAG_ReadMsgField + UMSCODE_MsgText)
#define UMSTAG_RFromName       (UMSTAG_ReadMsgField + UMSCODE_FromName)
#define UMSTAG_RFromAddr       (UMSTAG_ReadMsgField + UMSCODE_FromAddr)
#define UMSTAG_RToName         (UMSTAG_ReadMsgField + UMSCODE_ToName)
#define UMSTAG_RToAddr         (UMSTAG_ReadMsgField + UMSCODE_ToAddr)
#define UMSTAG_RMsgID          (UMSTAG_ReadMsgField + UMSCODE_MsgID)
#define UMSTAG_RCreationDate   (UMSTAG_ReadMsgField + UMSCODE_CreationDate)
#define UMSTAG_RReceiveDate    (UMSTAG_ReadMsgField + UMSCODE_ReceiveDate)
#define UMSTAG_RReferID        (UMSTAG_ReadMsgField + UMSCODE_ReferID)
#define UMSTAG_RGroup          (UMSTAG_ReadMsgField + UMSCODE_Group)
#define UMSTAG_RSubject        (UMSTAG_ReadMsgField + UMSCODE_Subject)
#define UMSTAG_RAttributes     (UMSTAG_ReadMsgField + UMSCODE_Attributes)
#define UMSTAG_RComments       (UMSTAG_ReadMsgField + UMSCODE_Comments)
#define UMSTAG_ROrganization   (UMSTAG_ReadMsgField + UMSCODE_Organization)
#define UMSTAG_RDistribution   (UMSTAG_ReadMsgField + UMSCODE_Distribution)
#define UMSTAG_RFolder         (UMSTAG_ReadMsgField + UMSCODE_Folder)
#define UMSTAG_RFidoID         (UMSTAG_ReadMsgField + UMSCODE_FidoID)
#define UMSTAG_RMausID         (UMSTAG_ReadMsgField + UMSCODE_MausID)
#define UMSTAG_RReplyGroup     (UMSTAG_ReadMsgField + UMSCODE_ReplyGroup)
#define UMSTAG_RReplyName      (UMSTAG_ReadMsgField + UMSCODE_ReplyName)
#define UMSTAG_RReplyAddr      (UMSTAG_ReadMsgField + UMSCODE_ReplyAddr)
#define UMSTAG_RLogicalToName  (UMSTAG_ReadMsgField + UMSCODE_LogicalToName)
#define UMSTAG_RLogicalToAddr  (UMSTAG_ReadMsgField + UMSCODE_LogicalToAddr)
#define UMSTAG_RFileName       (UMSTAG_ReadMsgField + UMSCODE_FileName)
#define UMSTAG_RRFCMsgNum      (UMSTAG_ReadMsgField + UMSCODE_RFCMsgNum)

#define UMSTAG_RFidoText       (UMSTAG_ReadMsgField + UMSCODE_FidoText)
#define UMSTAG_RErrorText      (UMSTAG_ReadMsgField + UMSCODE_ErrorText)
#define UMSTAG_RNewsreader     (UMSTAG_ReadMsgField + UMSCODE_Newsreader)
#define UMSTAG_RRfcAttr        (UMSTAG_ReadMsgField + UMSCODE_RfcAttr)
#define UMSTAG_RFtnAttr        (UMSTAG_ReadMsgField + UMSCODE_FtnAttr)
#define UMSTAG_RZerAttr        (UMSTAG_ReadMsgField + UMSCODE_ZerAttr)
#define UMSTAG_RMausAttr       (UMSTAG_ReadMsgField + UMSCODE_MausAttr)

#define UMSTAG_RTempFileName   (UMSTAG_ReadMsgField + UMSCODE_TempFileName)

#define UMSTAG_RMsgInfo        (TAG_USER + 512)
#define UMSTAG_RTextFields     (TAG_USER + 513)
#define UMSTAG_RReadHeader     (TAG_USER + 514)
#define UMSTAG_RReadAll        (TAG_USER + 515)
#define UMSTAG_RExtMsgInfo     (TAG_USER + 516)

/* UMSWriteMsg() */
#define UMSTAG_WMsgNum         (TAG_USER +  1)
#define UMSTAG_WMsgDate        (TAG_USER +  4)
#define UMSTAG_WChainUp        (TAG_USER +  7)
#define UMSTAG_WHardLink       (TAG_USER + 14)
#define UMSTAG_WSoftLink       (TAG_USER + 15)
#define UMSTAG_WMsgCDate       (TAG_USER + 16)

#define UMSTAG_WAutoBounce     (TAG_USER + 65)
#define UMSTAG_WHdrFill        (TAG_USER + 66)
#define UMSTAG_WTxtFill        (TAG_USER + 67)
#define UMSTAG_WNoUpdate       (TAG_USER + 69)
#define UMSTAG_WHide           (TAG_USER + 70)
#define UMSTAG_WCheckHeader    (TAG_USER + 71)

#define UMSTAG_WriteMsgField   (TAG_USER + UMSTAG_String + 256)
#define UMSTAG_WMsgText        (UMSTAG_WriteMsgField + UMSCODE_MsgText)
#define UMSTAG_WFromName       (UMSTAG_WriteMsgField + UMSCODE_FromName)
#define UMSTAG_WFromAddr       (UMSTAG_WriteMsgField + UMSCODE_FromAddr)
#define UMSTAG_WToName         (UMSTAG_WriteMsgField + UMSCODE_ToName)
#define UMSTAG_WToAddr         (UMSTAG_WriteMsgField + UMSCODE_ToAddr)
#define UMSTAG_WMsgID          (UMSTAG_WriteMsgField + UMSCODE_MsgID)
#define UMSTAG_WCreationDate   (UMSTAG_WriteMsgField + UMSCODE_CreationDate)
#define UMSTAG_WReceiveDate    (UMSTAG_WriteMsgField + UMSCODE_ReceiveDate)
#define UMSTAG_WReferID        (UMSTAG_WriteMsgField + UMSCODE_ReferID)
#define UMSTAG_WGroup          (UMSTAG_WriteMsgField + UMSCODE_Group)
#define UMSTAG_WSubject        (UMSTAG_WriteMsgField + UMSCODE_Subject)
#define UMSTAG_WAttributes     (UMSTAG_WriteMsgField + UMSCODE_Attributes)
#define UMSTAG_WComments       (UMSTAG_WriteMsgField + UMSCODE_Comments)
#define UMSTAG_WOrganization   (UMSTAG_WriteMsgField + UMSCODE_Organization)
#define UMSTAG_WDistribution   (UMSTAG_WriteMsgField + UMSCODE_Distribution)
#define UMSTAG_WFolder         (UMSTAG_WriteMsgField + UMSCODE_Folder)
#define UMSTAG_WFidoID         (UMSTAG_WriteMsgField + UMSCODE_FidoID)
#define UMSTAG_WMausID         (UMSTAG_WriteMsgField + UMSCODE_MausID)
#define UMSTAG_WReplyGroup     (UMSTAG_WriteMsgField + UMSCODE_ReplyGroup)
#define UMSTAG_WReplyName      (UMSTAG_WriteMsgField + UMSCODE_ReplyName)
#define UMSTAG_WReplyAddr      (UMSTAG_WriteMsgField + UMSCODE_ReplyAddr)
#define UMSTAG_WLogicalToName  (UMSTAG_WriteMsgField + UMSCODE_LogicalToName)
#define UMSTAG_WLogicalToAddr  (UMSTAG_WriteMsgField + UMSCODE_LogicalToAddr)
#define UMSTAG_WFileName       (UMSTAG_WriteMsgField + UMSCODE_FileName)
#define UMSTAG_WRFCMsgNum      (UMSTAG_WriteMsgField + UMSCODE_RFCMsgNum)

#define UMSTAG_WFidoText       (UMSTAG_WriteMsgField + UMSCODE_FidoText)
#define UMSTAG_WErrorText      (UMSTAG_WriteMsgField + UMSCODE_ErrorText)
#define UMSTAG_WNewsreader     (UMSTAG_WriteMsgField + UMSCODE_Newsreader)
#define UMSTAG_WRfcAttr        (UMSTAG_WriteMsgField + UMSCODE_RfcAttr)
#define UMSTAG_WFtnAttr        (UMSTAG_WriteMsgField + UMSCODE_FtnAttr)
#define UMSTAG_WZerAttr        (UMSTAG_WriteMsgField + UMSCODE_ZerAttr)
#define UMSTAG_WMausAttr       (UMSTAG_WriteMsgField + UMSCODE_MausAttr)

#define UMSTAG_WTempFileName   (UMSTAG_WriteMsgField + UMSCODE_TempFileName)

#define UMSTAG_WTextFields     (TAG_USER + 513)

/* UMSSelect() */
#define UMSTAG_SelSet          (TAG_USER +                 1024)
#define UMSTAG_SelUnset        (TAG_USER +                 1025)
#define UMSTAG_SelWriteGlobal  (TAG_USER +                 1026)
#define UMSTAG_SelWriteLocal   (TAG_USER +                 1027)
#define UMSTAG_SelWriteUser    (TAG_USER + UMSTAG_String + 1028)
#define UMSTAG_SelStart        (TAG_USER +                 1032)
#define UMSTAG_SelStop         (TAG_USER +                 1033)
#define UMSTAG_SelReadGlobal   (TAG_USER +                 1034)
#define UMSTAG_SelReadLocal    (TAG_USER +                 1035)
#define UMSTAG_SelReadUser     (TAG_USER + UMSTAG_String + 1036)
#define UMSTAG_SelMask         (TAG_USER +                 1040)
#define UMSTAG_SelMatch        (TAG_USER +                 1041)
#define UMSTAG_SelParent       (TAG_USER +                 1042)
#define UMSTAG_SelDate         (TAG_USER +                 1043)
#define UMSTAG_SelTree         (TAG_USER +                 1044)
#define UMSTAG_SelSubTree      (TAG_USER +                 1045)
#define UMSTAG_SelMsg          (TAG_USER +                 1046)
#define UMSTAG_SelQuick        (TAG_USER +                 1047)
#define UMSTAG_SelLink         (TAG_USER +                 1048)
#define UMSTAG_SelCDate        (TAG_USER +                 1049)
#define UMSTAG_SelSize         (TAG_USER +                 1050)
#define UMSTAG_SelMaxCount     (TAG_USER +                 1051)
#define UMSTAG_SelMaxSize      (TAG_USER +                 1052)

/* UMSSearch() */
#define UMSTAG_SearchLast      (TAG_USER +                 2048)
#define UMSTAG_SearchQuick     (TAG_USER +                 2049)
#define UMSTAG_SearchGlobal    (TAG_USER +                 2050)
#define UMSTAG_SearchLocal     (TAG_USER +                 2051)
#define UMSTAG_SearchUser      (TAG_USER + UMSTAG_String + 2052)
#define UMSTAG_SearchDirection (TAG_USER +                 2053)
#define UMSTAG_SearchPattern   (TAG_USER +                 2054)
#define UMSTAG_SearchMask      (TAG_USER +                 2064)
#define UMSTAG_SearchMatch     (TAG_USER +                 2065)

/* UMSReadConfig(), UMSWriteConfig() */
#define UMSTAG_CfgGlobalOnly   (TAG_USER +                 3072)
#define UMSTAG_CfgName         (TAG_USER + UMSTAG_String + 3073)
#define UMSTAG_CfgUser         (TAG_USER + UMSTAG_String + 3074)
#define UMSTAG_CfgQuoted       (TAG_USER +                 3083)

/* UMSReadConfig() */
#define UMSTAG_CfgUserName           (TAG_USER + UMSTAG_String + 3075)
#define UMSTAG_CfgNextVar            (TAG_USER + UMSTAG_String + 3076)
#define UMSTAG_CfgNextAlias          (TAG_USER + UMSTAG_String + 3077)
#define UMSTAG_CfgNextUser           (TAG_USER + UMSTAG_String + 3078)
#define UMSTAG_CfgNextExporter       (TAG_USER + UMSTAG_String + 3079)
#define UMSTAG_CfgNextNetGroup       (TAG_USER + UMSTAG_String + 3080)
#define UMSTAG_CfgNextNetGroupMember (TAG_USER + UMSTAG_String + 3081)
#define UMSTAG_CfgLockVar            (TAG_USER +                 3082)

/* UMSWriteConfig() */
#define UMSTAG_CfgDump           (TAG_USER + UMSTAG_String + 3088)
#define UMSTAG_CfgData           (TAG_USER + UMSTAG_String + 3089)
#define UMSTAG_CfgCreateUser     (TAG_USER + UMSTAG_String + 3090)
#define UMSTAG_CfgDeleteUser     (TAG_USER + UMSTAG_String + 3091)
#define UMSTAG_CfgCreateAlias    (TAG_USER + UMSTAG_String + 3092)
#define UMSTAG_CfgDeleteAlias    (TAG_USER + UMSTAG_String + 3093)
#define UMSTAG_CfgNetGroup       (TAG_USER + UMSTAG_String + 3094)
#define UMSTAG_CfgAddNetGroup    (TAG_USER + UMSTAG_String + 3095)
#define UMSTAG_CfgDeleteNetGroup (TAG_USER + UMSTAG_String + 3096)
#define UMSTAG_CfgUnlockVar      (TAG_USER +                 3097)
#define UMSTAG_CfgLocal          (TAG_USER +                 3098)
#define UMSTAG_CfgCreateSysop    (TAG_USER + UMSTAG_String + 3099)
#define UMSTAG_CfgCreateExporter (TAG_USER + UMSTAG_String + 3100)

/* UMSMatchConfig() */
#define UMSTAG_MatchGlobalOnly   (TAG_USER +                 4096)
#define UMSTAG_MatchName         (TAG_USER + UMSTAG_String + 4097)
#define UMSTAG_MatchUser         (TAG_USER + UMSTAG_String + 4098)
#define UMSTAG_MatchString       (TAG_USER + UMSTAG_String + 4099)
#define UMSTAG_MatchDefault      (TAG_USER + UMSTAG_String + 4100)


#ifndef UMS_V11_NAMES_ONLY

/* old Pre-V11 types */

#define UMSUserAccount UMSAccount

#define UMSUSTATB_Read UMSUSTATB_Old
#define UMSUSTATF_Read UMSUSTATF_Old

#endif
#endif
