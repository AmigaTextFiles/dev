#ifndef PRAGMAS_UMSRFC_H
#define PRAGMAS_UMSRFC_H

/*
 * pragmas/umsrfc_pragmas.h
 *
 * #pragmas for inline calls for umsrfc.library functions
 *
 * $VER: ums_pragmas.h 1.0 (23.05.97)
 *
 * (C) 1994-1997 by Stefan Becker
 *
 */

#pragma libcall UMSRFCBase UMSRFCAllocData 24 ba9804
#pragma libcall UMSRFCBase UMSRFCFreeData 2a 801
#pragma libcall UMSRFCBase UMSRFCVLog 30 a9803
#pragma libcall UMSRFCBase UMSRFCFlushLog 36 801
#pragma libcall UMSRFCBase UMSRFCConvertUMSAddress 3c ba9804
#pragma libcall UMSRFCBase UMSRFCConvertRFCAddress 42 ba9804
#pragma libcall UMSRFCBase UMSRFCGetMessage 48 0802
#pragma libcall UMSRFCBase UMSRFCFreeMessage 4e 801
#pragma libcall UMSRFCBase UMSRFCWriteMessage 54 0a9804
#pragma libcall UMSRFCBase UMSRFCReadMessage 5a 109804
#pragma libcall UMSRFCBase UMSRFCPutMailMessage 60 9802
#pragma libcall UMSRFCBase UMSRFCPutNewsMessage 66 09803
#pragma libcall UMSRFCBase UMSRFCPrintTime 6c 90803
#pragma libcall UMSRFCBase UMSRFCPrintCurrentTime 72 9802
#pragma libcall UMSRFCBase UMSRFCGetTime 78 9802

#ifdef __SASC
#pragma tagcall UMSRFCBase UMSRFCLog 30 a9803
#endif

#endif
