/*
 * free.c V0.12.01
 *
 * umsrfc.library/UMSRFCFreeData()
 *
 * (c) 1994-96 Stefan Becker
 */

#include "umsrfc.h"

__LIB_PREFIX void UMSRFCFreeData(
             __LIB_ARG(A0) struct UMSRFCData *urd
             /* __LIB_BASE */)
{
 struct PrivateURD *purd       = (struct PrivateURD *) urd;
 const struct Library *UMSBase = purd->purd_Bases.urb_UMSBase;
 const struct Library *DOSBase = purd->purd_Bases.urb_DOSBase;
 UMSAccount account            = purd->purd_Public.urd_Account;

 UMSRFCFlushLog((struct UMSRFCData *) purd);
 if (purd->purd_Flags & PURDF_PATHNAME)
  UMSFreeConfig(account, purd->purd_Public.urd_PathName);
 FreeExportAddresses(purd);
 FreeImportAddresses(purd);
 UMSFreeConfig(account, purd->purd_Public.urd_DomainName);
 FreeDosObject(DOS_RDARGS, purd->purd_RFCAttrRDArgs);
 FreeDosObject(DOS_RDARGS, purd->purd_AttrRDArgs);
 FreeMem(purd, sizeof(struct PrivateURD));
 UMSLogout(account);
}
