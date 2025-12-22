#ifndef CLIB_UMSRFC_H
#define CLIB_UMSRFC_H

/*
 * clib/umsrfc_protos.h
 *
 * ANSI C prototypes for umsrfc.library functions
 *
 * $VER: umsrfc_protos.h 1.0 (23.05.97)
 *
 * (C) 1994-1997 by Stefan Becker
 *
 */

#ifndef LIBRARIES_UMSRFC_H
#include <libraries/umsrfc.h>
#endif

/* Are we currently compiling the library? */
#ifndef COMPILING_UMSRFC_LIBRARY
#define __LIB_PREFIX
#define __LIB_ARG(x)
#define __LIB_BASE
#endif

__LIB_PREFIX struct UMSRFCData *UMSRFCAllocData(
             __LIB_ARG(A0) const struct UMSRFCBases *urb,
             __LIB_ARG(A1) const char               *user,
             __LIB_ARG(A2) const char               *password,
             __LIB_ARG(A3) const char               *server
             /* __LIB_BASE */);

__LIB_PREFIX void UMSRFCFreeData(
             __LIB_ARG(A0) struct UMSRFCData *urd
             /* __LIB_BASE */);

__LIB_PREFIX void UMSRFCVLog(
             __LIB_ARG(A0) struct UMSRFCData *urd,
             __LIB_ARG(A1) const char        *format,
             __LIB_ARG(A2) const ULONG       *args
             /* __LIB_BASE */);

void UMSRFCLog(struct UMSRFCData *urd, const char *format, ...);

__LIB_PREFIX void UMSRFCFlushLog(
             __LIB_ARG(A0) struct UMSRFCData *urd
             /* __LIB_BASE */);

__LIB_PREFIX BOOL UMSRFCConvertUMSAddress(
             __LIB_ARG(A0) struct UMSRFCData *urd,
             __LIB_ARG(A1) const char        *addr,
             __LIB_ARG(A2) const char        *name,
             __LIB_ARG(A3) char              *buffer
             /* __LIB_BASE */);

__LIB_PREFIX void UMSRFCConvertRFCAddress(
             __LIB_ARG(A0) struct UMSRFCData *urd,
             __LIB_ARG(A1) const char        *rfcaddr,
             __LIB_ARG(A2) char              *addr,
             __LIB_ARG(A3) char              *name
             /* __LIB_BASE */);

__LIB_PREFIX BOOL UMSRFCGetMessage(
             __LIB_ARG(A0) struct UMSRFCData *urd,
             __LIB_ARG(D0) UMSMsgNum          msgnum
             /* __LIB_BASE */);

__LIB_PREFIX void UMSRFCFreeMessage(
             __LIB_ARG(A0) struct UMSRFCData *urd
             /* __LIB_BASE */);

__LIB_PREFIX BOOL UMSRFCWriteMessage(
             __LIB_ARG(A0) struct UMSRFCData    *urd,
             __LIB_ARG(A1) UMSRFCOutputFunction  func,
             __LIB_ARG(A2) void                 *data,
             __LIB_ARG(D0) BOOL                  smtp
             /* __LIB_BASE */);

__LIB_PREFIX BOOL UMSRFCReadMessage(
             __LIB_ARG(A0) struct UMSRFCData *urd,
             __LIB_ARG(A1) char              *msg,
             __LIB_ARG(D0) BOOL               mail,
             __LIB_ARG(D1) BOOL               smtp
             /* __LIB_BASE */);

__LIB_PREFIX UMSMsgNum UMSRFCPutMailMessage(
             __LIB_ARG(A0) struct UMSRFCData *urd,
             __LIB_ARG(A1) const char        *recipient
             /* __LIB_BASE */);

__LIB_PREFIX UMSMsgNum UMSRFCPutNewsMessage(
             __LIB_ARG(A0) struct UMSRFCData *urd,
             __LIB_ARG(A1) const char        *group,
             __LIB_ARG(D0) UMSMsgNum          lastmsg
             /* __LIB_BASE */);

__LIB_PREFIX void UMSRFCPrintTime(
             __LIB_ARG(A0) struct UMSRFCData *urd,
             __LIB_ARG(D0) ULONG              time,
             __LIB_ARG(A1) char              *buffer
             /* __LIB_BASE */);

__LIB_PREFIX void UMSRFCPrintCurrentTime(
             __LIB_ARG(A0) struct UMSRFCData *urd,
             __LIB_ARG(A1) char              *buffer
             /* __LIB_BASE */);

__LIB_PREFIX ULONG UMSRFCGetTime(
             __LIB_ARG(A0) struct UMSRFCData *urd,
             __LIB_ARG(A1) char              *time
             /* __LIB_BASE */);

#endif
