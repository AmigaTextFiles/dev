/*
 * umsrfc.h V1.0.06
 *
 * Main include file
 *
 * (c) 1994-98 Stefan Becker
 */

#define UMS_V11_NAMES_ONLY

/* OS include files */
#include <dos/dos.h>
#include <exec/libraries.h>
#include <exec/memory.h>
#include <exec/nodes.h>
#include <exec/resident.h>
#include <libraries/locale.h>

/* OS function prototypes */
#include <clib/dos_protos.h>
#include <clib/exec_protos.h>
#include <clib/locale_protos.h>
#include <clib/ums_protos.h>
#include <clib/utility_protos.h>

/* OS function inline calls */
#include <pragmas/dos_pragmas.h>
#include <pragmas/exec_pragmas.h>
#include <pragmas/locale_pragmas.h>
#include <pragmas/ums_pragmas.h>
#include <pragmas/utility_pragmas.h>

/* ANSI C include files */
#include <stdarg.h>
#include <string.h>
#include <time.h>

/* Library base */
struct UMSRFCBase {
 struct Library urb_Library;
 UWORD          urb_Pad;
 BPTR           urb_Segment;
};

/* We are compiling the library now */
#define COMPILING_UMSRFC_LIBRARY 1
#ifdef _DCC
#define __LIB_PREFIX __geta4
#define __LIB_ARG(x) __ ## x
#define __LIB_BASE , __A6 const struct UMSRFCBase *UMSRFCBase
#elif __SASC
#define __LIB_PREFIX __saveds __asm
#define __LIB_ARG(x) register __ ## x
#define __LIB_BASE , register __A6 const struct UMSRFCBase *UMSRFCBase
#else
#error Library macros not defined!
#endif

/* Library include files */
#include "/include/libraries/umsrfc.h"
#include "/include/clib/umsrfc_protos.h"

/*
 * Data structures for domain name lists
 */
struct DomainData {
 char  *dd_Name;   /* Pointer to domain name */
 ULONG  dd_Length; /* Length of domain name  */
};

struct DomainList {
 char              *dl_UMSVar;  /* Pointer to UMS config var */
 ULONG              dl_Length;  /* Buffer length             */
 ULONG              dl_Entries; /* Entries in this list      */
 struct DomainData  dl_Data;    /* Begin of array            */
};

/*
 * Buffer sizes
 */
#define TEMPNAMESIZE    34
#define BUFFERSIZE    1024
#define COMMENTSIZE  65536

/*
 * RFC date & time format
 *
 * [<day of week>,] <day> <mon> <year> <hr:min[:sec]> <zone>
 *        1           2     3      4         5           6
 */
#define MAXDATEARGS 6

/*
 * Template & data structure for parsing "Attributes"
 */
#define UMSRFC_ATTRTEMPLATE "ALIAS/K,MIME/S,RECEIPT-REQUEST/K,URGENT/S," \
                            "IGNORE/M"
struct AttributesData {
 char  *ad_Alias;
 ULONG  ad_MIME;
 char  *ad_ReceiptRequest;
 ULONG  ad_Urgent;
 ULONG  ad_Ignore;
};

/*
 * Template & data structure for parsing "RFC Attributes"
 */
#define UMSRFC_RFCATTRTEMPLATE "MISC/M"
struct RFCAttributesData {
 char  **rad_Misc;
};

/*
 * Extended structure for UMS RFC data
 */
struct PrivateURD {
 struct UMSRFCData         purd_Public;
 struct UMSRFCBases        purd_Bases;
 ULONG                     purd_Flags;
 const char               *purd_ExportFIDODomain;
 const char               *purd_ExportMausDomain;
 const struct DomainList  *purd_ImportFIDODomainList;
 const struct DomainList  *purd_ImportMausDomainList;
 ULONG                     purd_MailEncodingType;
 ULONG                     purd_NewsEncodingType;
 BPTR                      purd_LogFile;
 struct RDArgs            *purd_AttrRDArgs;
 struct RDArgs            *purd_RFCAttrRDArgs;
 struct AttributesData     purd_AttributesData;
 struct RFCAttributesData  purd_RFCAttributesData;
 LONG                      purd_GMTOffset;
 char                     *purd_DateTimeArray[MAXDATEARGS];
 struct ClockData          purd_ClockData;
 char                      purd_LogName[TEMPNAMESIZE];
 char                      purd_GMTOffsetString[6];
 UBYTE                     purd_FromAddr[BUFFERSIZE];
 UBYTE                     purd_FromName[BUFFERSIZE];
 UBYTE                     purd_ReplyAddr[BUFFERSIZE];
 UBYTE                     purd_ReplyName[BUFFERSIZE];
 UBYTE                     purd_Attributes[BUFFERSIZE];
 UBYTE                     purd_Buffer1[BUFFERSIZE];
 UBYTE                     purd_Buffer2[BUFFERSIZE];
 UBYTE                     purd_Buffer3[BUFFERSIZE];
 UBYTE                     purd_CommentBuffer[COMMENTSIZE];
};

/* Values for purd_Flags */
#define PURDF_FIDO     0x01
#define PURDF_MAUS     0x02
#define PURDF_PATHNAME 0x04

/* Values for purd_Encoding */
#define ENCODE_NONE             0
#define ENCODE_QUOTED_PRINTABLE 1
#define ENCODE_BASE64           2

/* Library version & revision */
#include "/revision.h"

/* UMSRFC-specific header for comments */
#define UMSRFC_HEADER      "UMS-RFC\n"
#define UMSRFC_HEADER_LEN  (sizeof(UMSRFC_HEADER)-1)

/* Global data */
extern struct Library *SysBase;
extern const char UMSRFCHeader[]; /* read.c, used in: write.c  */
extern const char DateNotSet[];   /* read.c, used in: write.c */

/* Prototypes of library internal functions */
void  FreeImportAddresses(struct PrivateURD *); /* alloc.c, used in: free.c  */
void  FreeExportAddresses(struct PrivateURD *); /* alloc.c, used in: free.c  */
void  DecodeHeaderLine(char *);                 /* decode.c, used in: read.c */
BOOL  DecodeMessage(const char *, const char *, /* decode.c, used in: read.c */
                    char *);
void  EncodeMessage(UMSRFCOutputFunction,      /* encode.c, used in: write.c */
                    void *, char *, ULONG, BOOL);
int   pvsprintf(char *, const char *, ULONG *args);              /* misc.c   */
int   psprintf(char *, const char *, ...);                       /* misc.c   */
void  pfputs(UMSRFCOutputFunction, void *, const char *);        /* misc.c   */
void  pfprintf(UMSRFCOutputFunction, void *, const char *, ...); /* misc.c   */

const char *CreateTempName(struct PrivateURD *, /* misc.c, used in: log.c    */
                           ULONG, char *);

/* Values for CreateTempName */
#define TEMPNAME_LOG 1

/* UMS tagcall functions */
#ifdef _DCC
/* I WANT "#pragma tagcall"!!! */
char      *PrivateUMSReadConfigTags(struct Library *, UMSAccount, Tag, ...);
BOOL       PrivateUMSReadMsgTags(struct Library *, UMSAccount, Tag, ...);
UMSMsgNum  PrivateUMSWriteMsgTags(struct Library *, UMSAccount, Tag, ...);
UMSMsgNum  PrivateUMSSearchTags(struct Library *, UMSAccount, Tag, ...);
void       PrivateUMSLog(struct Library *, UMSAccount, LONG level, STRPTR,
                         ...);

#define TAGCALL(func) Private ## func
#define UMSBASE UMSBase,
#elif __SASC
#define TAGCALL(func) func
#define UMSBASE
#else
#error UMS tagcall macros not defined!
#endif

/* Debugging */
#ifdef DEBUG
void kprintf(char *, ...);
#define DEBUGLOG(x) x
#else
#define DEBUGLOG(X)
#endif
