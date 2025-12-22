/*
 * output.c V1.0.03
 *
 * UMS output functions for umsrfc.library/UMSRFCWriteMessage
 *
 * (c) 1994-98 Stefan Becker
 */

#include "ums2uucp.h"

/* Output function for umsrfc.library/UMSRFCWriteMessage (CR-LF filtering) */
void UUCPOutputFunction(__A0 struct ExportData *ed, __D0 char c)
{
 /* CR flag set? */
 if (ed->ed_Flags & EXPORTDATA_FLAGS_CR) {

  /* Yes, next character LF? */
  if (c != '\n') {

   /* No CR-LF encountered, write single CR character */
   ed->ed_Buffer[ed->ed_Counter++] = '\r';

   /* Buffer full? */
   if (ed->ed_Counter == OUTBUFSIZE) FlushOutput(ed);
  }

  /* Reset CR flag */
  ed->ed_Flags &= ~EXPORTDATA_FLAGS_CR;
 }

 /* Next character CR? */
 if (c == '\r') {

  /* Yes, set flag and don't write CR */
  ed->ed_Flags |= EXPORTDATA_FLAGS_CR;

 } else {

  /* No, write character */
  ed->ed_Buffer[ed->ed_Counter++] = c;

  /* Buffer full? */
  if (ed->ed_Counter == OUTBUFSIZE) FlushOutput(ed);
 }
}

/* Output function for umsrfc.library/UMSRFCWriteMessage (No filtering) */
void OutputFunction(__A0 struct ExportData *ed, __D0 char c)
{
 /* Write character */
 ed->ed_Buffer[ed->ed_Counter++] = c;

 /* Buffer full? */
 if (ed->ed_Counter == OUTBUFSIZE) FlushOutput(ed);
}

/* Flush output */
void FlushOutput(struct ExportData *ed)
{
 struct DOSBase *DOSBase = ed->ed_DOSBase;

 /* Write buffer to file */
 Write(ed->ed_Handle, ed->ed_Buffer, ed->ed_Counter);

 /* Reset counter */
 ed->ed_Counter = 0;

 /* Reset CR flag */
 ed->ed_Flags &= ~EXPORTDATA_FLAGS_CR;
}
