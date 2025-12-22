#ifndef PRAGMAS_MOREREQ_PRAGMAS_H
#define PRAGMAS_MOREREQ_PRAGMAS_H

#ifndef CLIB_MOREREQ_PROTOS_H
#include <clib/morereq_protos.h>
#endif

#ifdef PRAGMAS_DECLARING_LIBBASE
extern struct Library *MoreReqBase;
#endif

#pragma libcall MoreReqBase mrAllocRequestA 84 8002
#pragma libcall MoreReqBase mrFreeRequest 8a 801
#pragma libcall MoreReqBase mrMaxLenA 90 8902
#pragma libcall MoreReqBase mrRequestA 96 8902
#pragma libcall MoreReqBase mrMatchVanillaKeyA 9c 8002
#pragma libcall MoreReqBase mrCloseWindowSafely a2 801
#pragma libcall MoreReqBase mrLockWindow a8 801
#pragma libcall MoreReqBase mrUnlockWindow ae 9802

#ifdef __SASC_60
#pragma tagcall MoreReqBase mrAllocRequest 84 8002
#pragma tagcall MoreReqBase mrMaxLen 90 8902
#pragma tagcall MoreReqBase mrRequest 96 8902
#pragma tagcall MoreReqBase mrMatchVanillaKey 9c 8002
#endif	/*  __SASC_60  */

#endif	/*  PRAGMAS_MOREREQ_PRAGMAS_H  */
