/*
 * putnews.c V0.3.01
 *
 * umsrfc.library/UMSRFCPutNewsMessage()
 *
 * (c) 1994 Stefan Becker
 */

#include "umsrfc.h"

__LIB_PREFIX UMSMsgNum UMSRFCPutNewsMessage(
             __LIB_ARG(A0) struct UMSRFCData *urd,
             __LIB_ARG(A1) const char        *group,
             __LIB_ARG(D0) UMSMsgNum          lastmsg
             /* __LIB_BASE */)
{
 struct PrivateURD *purd       = (struct PrivateURD *) urd;
 const struct Library *UMSBase = purd->purd_Bases.urb_UMSBase;
 struct TagItem *tags          = purd->purd_Public.urd_NewsTags;

 /* Set group name */
 tags[UMSRFC_TAGS_GROUP].ti_Data = (ULONG) group;

 /* Linked message? */
 if (lastmsg) {
  tags[UMSRFC_TAGS_HARDLINK].ti_Tag  = UMSTAG_WHardLink;
  tags[UMSRFC_TAGS_HARDLINK].ti_Data = lastmsg;
 } else
  /* Default: no crossposting */
  tags[UMSRFC_TAGS_HARDLINK].ti_Tag  = TAG_IGNORE;

 /* Put message into UMS */
 return(UMSWriteMsg(purd->purd_Public.urd_Account, tags));
}
