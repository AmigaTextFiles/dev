/*
 * ums2uucp.h  V1.0.04
 *
 * UMS UUCP exporter main include file
 *
 * (c) 1992-98 Stefan Becker
 *
 */

/* UUCP common include file */
#include <common.h>

/* OS function prototypes */
#include <clib/alib_protos.h>
#include <clib/locale_protos.h>

/* OS function inline calls */
#include <pragmas/locale_pragmas.h>

/* ANSI C include files */
#include <limits.h>

/* Compiler specific include files */
#ifdef _DCC
#include <lists.h>
#endif

#define UUX_FILENAMELEN 20

/* Flag definitions for ed_Flags */
#define EXPORTDATA_FLAGS_BATCH 0x01 /* Batched transfer */
#define EXPORTDATA_FLAGS_CR    0x02 /* CR detected      */

/* Data for exporting mail or news */
struct ExportData {
 ULONG           ed_Flags;
 char           *ed_UMSVar;           /* Pointer to UMS variable            */
 char           *ed_XFileCmd;         /* Command name for X.* file          */
 char           *ed_CompCmd;          /* Compress command name              */
 char           *ed_DFileHdr;         /* Header for D.* file                */
 ULONG           ed_MaxSize;          /* Max. size for batch (uncompressed) */
 struct Library *ed_DOSBase;          /* Pointer to DOS library             */
 BPTR            ed_Handle;           /* Handle for output file             */
 UBYTE          *ed_Buffer;           /* Pointer to output buffer           */
 UWORD           ed_Counter;          /* Buffer counter                     */
 char            ed_TmpCmdFile[UUX_FILENAMELEN];
 char            ed_LocalCmdFile[UUX_FILENAMELEN];
 char            ed_DataFile[UUX_FILENAMELEN];
 char            ed_TmpName[L_tmpnam];
 char            ed_Grade;
};

/* Bit masks for local flags */
#define SELBIT  1 /* This message has been selected for export */
#define MARKBIT 2 /* This soft-linked message should be exported */

/* Envelope types */
#define ENVELOPE_NONE  0
#define ENVELOPE_DUMB  1
#define ENVELOPE_SMART 2

/* Buffer sizes */
#define TMPBUF1SIZE 1024
#define TMPBUF2SIZE 1024
#define TMPBUF3SIZE 1024
#define OUTBUFSIZE  1024
#define BUFFERSIZE  (TMPBUF1SIZE + TMPBUF2SIZE + TMPBUF3SIZE + 2 * OUTBUFSIZE)

/* Global data */
extern struct Library *SysBase, *UtilityBase, *UMSBase, *UMSRFCBase;
extern struct DOSBase *DOSBase;
extern struct UMSRFCData *URData;
extern UMSAccount Account;
extern char  *NodeName;
extern UBYTE *TempBuffer1;
extern UBYTE *TempBuffer2;
extern UBYTE *TempBuffer3;
extern UBYTE *MailOutBuffer;
extern UBYTE *NewsOutBuffer;
extern char   CutNodeName[8];
extern char   CutRemoteName[8];

/* Function prototypes */
BOOL  ScanNew(ULONG);
BOOL  InitMailExport(void);
BOOL  BatchedMail(void);
BOOL  ExportMail(UMSMsgNum);
BOOL  FinishMailExport(void);
BOOL  InitNewsExport(void);
BOOL  ExportNews(UMSMsgNum);
BOOL  FinishNewsExport(void);
BOOL  GetExportData(char *, struct ExportData *);
void  FreeExportData(struct ExportData *);
void  EnableTaylorUUCPMode(void);
BOOL  CreateUUCPFiles(struct ExportData *, char *, char *);
BOOL  FinishUUCPFiles(struct ExportData *);
void  GetRouteData(void);
void  FreeRouteData(void);
char *CreateRouteAddress(char *, char *);
void  UUCPOutputFunction(__A0 struct ExportData *, __D0 char);
void  OutputFunction(__A0 struct ExportData *, __D0 char);
void  FlushOutput(struct ExportData *);
