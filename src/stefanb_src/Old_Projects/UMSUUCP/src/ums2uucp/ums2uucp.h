/*
 * ums2uucp.h  V0.8.04
 *
 * ums2uucp include file
 *
 * (c) 1992-94 Stefan Becker
 *
 */

#include "/AUUCPLib/auucplib.h"
#include "/ums_uucp.h"
#include <clib/alib_protos.h>
#include <clib/dos_protos.h>
#include <clib/exec_protos.h>
#include <clib/locale_protos.h>
#include <clib/ums_protos.h>
#include <pragmas/dos_pragmas.h>
#include <pragmas/exec_pragmas.h>
#include <pragmas/locale_pragmas.h>
#include <dos/dostags.h>
#include <exec/libraries.h>
#include <exec/memory.h>
#include <limits.h>
#include <lists.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <time.h>

#define UUX_FILENAMELEN 20

struct ExportData {
                   char  *ed_UMSVar;   /* Pointer to UMS variable */
                   char  *ed_XFileCmd; /* Command name for X.* file */
                   char  *ed_CompCmd;  /* Compress command name */
                   char  *ed_DFileHdr; /* Header for D.* file */
                   ULONG  ed_MaxSize;  /* Max. size for batch (uncompressed) */
                   FILE  *ed_OutFile;
                   BOOL   ed_Batch;    /* Batch: Yes/No */
                   char   ed_TmpCmdFile[UUX_FILENAMELEN];
                   char   ed_LocalCmdFile[UUX_FILENAMELEN];
                   char   ed_DataFile[UUX_FILENAMELEN];
                   char   ed_TmpName[L_tmpnam];
                  };

struct MessageData {
                    UMSMsgNum  md_ChainUp;   /* Parent of message */
                    UMSMsgNum  md_HardLink;  /* Message is hard-linked to... */
                    UMSMsgNum  md_SoftLink;  /* Message is soft-linked to... */
                    ULONG      md_MsgDate;   /* Message received date */
                    ULONG      md_HeaderLen; /* Header length */
                    ULONG      md_TextLen;   /* Text length */
                   };

/* Bit masks for local flags */
#define SELBIT  1 /* This message has been selected for export */
#define MARKBIT 2 /* This soft-linked message should be exported */

#define FROMBUFSIZE 1024
#define TMP1BUFSIZE 1024
#define TMP2BUFSIZE 1024
#define BUFFERSIZE  (FROMBUFSIZE + TMP1BUFSIZE + TMP2BUFSIZE)

#if 0
extern struct Library *SysBase,*DOSBase,*UMSBase;
#endif
extern UMSUserAccount Account;
extern char *NodeName;
extern char *PathName;
extern char *DomainName;
extern UBYTE *FromAddrBuffer;
extern UBYTE *Tmp1Buffer;
extern UBYTE *Tmp2Buffer;
extern char CutNodeName[8];
extern char CutRemoteName[8];
extern UMSMsgTextFields MsgFields;
extern struct MessageData MessageData;

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
BOOL  CreateUUCPFiles(struct ExportData *, char *, char *);
BOOL  FinishUUCPFiles(struct ExportData *);
void  GetRFCData(void);
void  FreeRFCData(void);
BOOL  WriteRFCMessage(FILE *, UMSMsgNum, BOOL, BOOL);
void  GetConversionData(void);
void  FreeConversionData(void);
BOOL  ConvertAddress(char *, char *, char *);
void  GetRouteData(void);
void  FreeRouteData(void);
char *CreateRouteAddress(char *, char *);
