/*
 * Includes to use FarPrint
 */

#ifndef	EXEC_TYPES_H
#include <exec/types.h>
#endif /* !EXEC_TYPES_H */

#ifdef	FARPRINT

#define FM_ADDTXT	0
#define FM_REQTXT	1
#define FM_REQNUM	2

#define FP_PRINT0(fmt)							SendText(fmt)
#define FP_PRINT1(fmt,arg1)						SendText(fmt,arg1)
#define FP_PRINT2(fmt,arg1,arg2)					SendText(fmt,arg1,arg2)
#define FP_PRINT3(fmt,arg1,arg2,arg3)					SendText(fmt,arg1,arg2,arg3)
#define FP_PRINT4(fmt,arg1,arg2,arg3,arg4)				SendText(fmt,arg1,arg2,arg3,arg4)
#define FP_PRINT5(fmt,arg1,arg2,arg3,arg4,arg5)				SendText(fmt,arg1,arg2,arg3,arg4,arg5)
#define FP_PRINT6(fmt,arg1,arg2,arg3,arg4,arg5,arg6)			SendText(fmt,arg1,arg2,arg3,arg4,arg5,arg6)
#define FP_PRINT7(fmt,arg1,arg2,arg3,arg4,arg5,arg6,arg7)		SendText(fmt,arg1,arg2,arg3,arg4,arg5,arg6,arg7)
#define FP_PRINT8(fmt,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8)		SendText(fmt,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8)
#define FP_PRINT9(fmt,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9)	SendText(fmt,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9)
#define FP_GET_STRING(id,buf)	((BYTE *)SendIt(buf,id,FM_REQTXT))
#define FP_GET_NUMBER(id)	((LONG)SendIt(NULL,id,FM_REQNUM))

IMPORT VOID SendText(BYTE *format,...);
IMPORT LONG SendIt(BYTE *msg_text,BYTE *msg_indent,USHORT msg_port);

#else	/* FARPRINT */

#define FP_PRINT0(fmt)
#define FP_PRINT1(fmt,arg1)
#define FP_PRINT2(fmt,arg1,arg2)
#define FP_PRINT3(fmt,arg1,arg2,arg3)
#define FP_PRINT4(fmt,arg1,arg2,arg3,arg4)
#define FP_PRINT5(fmt,arg1,arg2,arg3,arg4,arg5)
#define FP_PRINT6(fmt,arg1,arg2,arg3,arg4,arg5,arg6)
#define FP_PRINT7(fmt,arg1,arg2,arg3,arg4,arg5,arg6,arg7)
#define FP_PRINT8(fmt,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8)
#define FP_PRINT9(fmt,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9)
#define FP_GET_STRING(id,buf)	NULL
#define FP_GET_NUMBER(id)	0L

#endif	/* FARPRINT */
