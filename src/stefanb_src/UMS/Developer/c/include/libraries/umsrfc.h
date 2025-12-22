#ifndef LIBRARIES_UMSRFC_H
#define LIBRARIES_UMSRFC_H

/*
 * libraries/umsrfc.h
 *
 * C definitions for umsrfc.library
 *
 * $VER: umsrfc.h 1.2 (08.06.97)
 *
 * (C) 1994-1997 by Stefan Becker
 *
 */

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

#ifndef LIBRARIES_UMS_H
#include <libraries/ums.h>
#endif

/* Library version */
#define UMSRFC_LIBRARY_NAME    "umsrfc.library"
#define UMSRFC_LIBRARY_VERSION 1

/*
 * struct UMSRFCBases
 *
 * This structure contains pointers to library bases. These libraries are
 * needed by the functions of umsrfc.library. This data structure will be
 * used by umsrfc.library/AllocUMSRFCData().
 */
struct UMSRFCBases {
 const struct Library *urb_UMSBase;     /* Pointer to "ums.library" base     */
 const struct Library *urb_DOSBase;     /* Pointer to "dos.library" base     */
 const struct Library *urb_UtilityBase; /* Pointer to "utility.library" base */
};

/*
 * struct UMSRFCMsgData
 *
 * This data structure contains additional information about an UMS message.
 * It will be filled automatically by calling umsrfc.library/GetUMSMessage().
 *
 * ALL ENTRIES ARE READ ONLY!!!
 */
struct UMSRFCMsgData {
 UMSMsgNum  urmd_MsgNum;;   /* Msg number of current msg   READ ONLY!!! */
 UMSMsgNum  urmd_ChainUp;   /* Msg number of parent msg    READ ONLY!!! */
 UMSMsgNum  urmd_HardLink;  /* Msg is hard-linked to...    READ ONLY!!! */
 UMSMsgNum  urmd_SoftLink;  /* Msg is soft-linked to...    READ ONLY!!! */
 ULONG      urmd_MsgDate;   /* Receive date (Amiga epoch)  READ ONLY!!! */
 ULONG      urmd_MsgCDate;  /* Creation date (Amiga epoch) READ ONLY!!! */
 ULONG      urmd_HeaderLen; /* Header length               READ ONLY!!! */
 ULONG      urmd_TextLen;   /* Text length                 READ ONLY!!! */
};

/*
 * Global flags
 */
#define UMSRFC_FLAGS_NOOWNFQDN   0x01 /* System has no own domain name      */
                                      /* READ ONLY!!!                       */
#define UMSRFC_FLAGS_8BITALLOWED 0x02 /* Receiver allows 8bit encoding      */
                                      /* READ & WRITE, set by default       */
#define UMSRFC_FLAGS_MSGIS8BIT   0x04 /* Message created with 8bit encoding */
                                      /* READ ONLY!!!                       */

/*
 * Common tag items
 */
#define UMSRFC_TAGS_SUBJECT     0 /* UMSTAG_WSubject      */
#define UMSRFC_TAGS_FROMNAME    1 /* UMSTAG_WFromName     */
#define UMSRFC_TAGS_FROMADDR    2 /* UMSTAG_WFromAddr     */
#define UMSRFC_TAGS_REPLYNAME   3 /* UMSTAG_WReplyName    */
#define UMSRFC_TAGS_REPLYADDR   4 /* UMSTAG_WReplyAddr    */
#define UMSRFC_TAGS_DATE        5 /* UMSTAG_WCreationDate */
#define UMSRFC_TAGS_CDATE       6 /* UMSTAG_WMsgCDate     */
#define UMSRFC_TAGS_MSGID       7 /* UMSTAG_WMsgID        */
#define UMSRFC_TAGS_REFERID     8 /* UMSTAG_WReferID      */
#define UMSRFC_TAGS_ORG         9 /* UMSTAG_WOrganization */
#define UMSRFC_TAGS_MSGREADER  10 /* UMSTAG_WNewsReader   */
#define UMSRFC_TAGS_MSGTEXT    11 /* UMSTAG_WMsgText      */
#define UMSRFC_TAGS_ATTRIBUTES 12 /* UMSTAG_WAttributes   */
#define UMSRFC_TAGS_COMMENTS   13 /* UMSTAG_WComments     */

/*
 * Mail tag items
 */
#define UMSRFC_TAGS_SOFTLINK   14 /* UMSTAG_WSoftLink     */
#define UMSRFC_TAGS_TONAME     15 /* UMSTAG_WToName       */
#define UMSRFC_TAGS_TOADDR     16 /* UMSTAG_WToAddr       */

/*
 * News tag items
 */
#define UMSRFC_TAGS_HARDLINK   14 /* UMSTAG_WHardLink     */
#define UMSRFC_TAGS_GROUP      15 /* UMSTAG_WGroup        */
#define UMSRFC_TAGS_REPLYGROUP 16 /* UMSTAG_WReplyGroup   */
#define UMSRFC_TAGS_DIST       17 /* UMSTAG_WDistribution */
#define UMSRFC_TAGS_HIDE       18 /* UMSTAG_WHide         */

/*
 * Number of tag items in the message tag arrays
 */
#define UMSRFC_MAILTAGS 18
#define UMSRFC_NEWSTAGS 20

/*
 * Length of RFC address buffers
 */
#define UMSRFC_ADDRLEN 200

/*
 * Length of RFC time/date buffers
 */
#define UMSRFC_TIMELEN 32

/*
 * struct UMSRFCData
 *
 * This data structure is needed by all functions of the umsrfc.library.
 * It will be allocated by calling umsrfc.library/AllocUMSRFCData(). It
 * can be freed by calling umsrfc.library/FreeUMSRFCData().
 *
 * MOST OF THE FIELDS ARE READ ONLY!
 */
struct UMSRFCData {
 /*
  * These fields will be filled by umsrfc.library/AllocUMSRFCData()
  */
 UMSAccount  urd_Account;    /* UMS user account             READ ONLY!!! */
 const char *urd_DomainName; /* Domain name of the system    READ ONLY!!! */
 const char *urd_PathName;   /* System name for Path: lines  READ ONLY!!! */
 ULONG       urd_Flags;      /* Global flags                 (see above)  */

 /*
  * These fields will be filled by umsrfc.library/GetUMSMessage()
  */
 UMSMsgTextFields     urd_MsgFields; /* UMS message fields   READ ONLY!!! */
 struct UMSRFCMsgData urd_MsgData;   /* Additional msg data  READ ONLY!!! */
                                     /* RFC addr of sender   READ ONLY!!! */
 UBYTE                urd_FromAddress[UMSRFC_ADDRLEN];

 /*
  * These fields will be filled by umsrfc.library/ReadRFCMessage()
  *
  * All tag values are READ ONLY except for the last entry, which will be
  * initialized to TAG_DONE. The caller may modify this value to TAG_MORE
  * in order to add a pointer to additional tag values.
  */
 struct TagItem urd_MailTags[UMSRFC_MAILTAGS]; /* Tag array for mail msgs */
 struct TagItem urd_NewsTags[UMSRFC_NEWSTAGS]; /* Tag array for news msgs */
};

#ifdef _DCC
#define __ASM
#define __REG_ARG(x) __ ## x
#elif __SASC
#define __ASM __asm
#define __REG_ARG(c) register x
#else
#error Register argument macros not defined!
#endif

/*
 * Function pointer prototype for output function
 *
 * This functions will be used by umsrfc.library/WriteRFCMessage()
 */
typedef __ASM void (*UMSRFCOutputFunction)(__REG_ARG(A0) void *outputdata,
                                           __REG_ARG(D0) char  character);

#endif
