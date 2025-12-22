/*
 * freemsg.c V0.0.03
 *
 * umsrfc.library/UMSRFCFreeMessage()
 *
 * (c) 1994 Stefan Becker
 */

#include "umsrfc.h"

__LIB_PREFIX void UMSRFCFreeMessage(
             __LIB_ARG(A0) struct UMSRFCData *urd
             /* __LIB_BASE */)
{
 struct PrivateURD *purd       = (struct PrivateURD *) urd;
 const struct Library *UMSBase = purd->purd_Bases.urb_UMSBase;
 const struct Library *DOSBase = purd->purd_Bases.urb_DOSBase;

 FreeArgs(purd->purd_RFCAttrRDArgs);
 FreeArgs(purd->purd_AttrRDArgs);
 UMSFreeMsg(purd->purd_Public.urd_Account,
            purd->purd_Public.urd_MsgData.urmd_MsgNum);
}
