/*
 * output.c V1.0.00
 *
 * UMS NNTP/SMTP output function for umsrfc.library/UMSRFCWriteMessage
 *
 * (c) 1994-97 Stefan Becker
 */

#include "common.h"

/* Output function for umsrfc.library/UMSRFCWriteMessage */
void OutputFunction(__A0 struct OutputData *od, __D0 char c)
{
 /* Write character */
 od->od_Buffer[od->od_Counter++] = c;

 /* Buffer full? */
 if (od->od_Counter == od->od_Length) {
  /* Yes */
  struct DOSBase *DOSBase = od->od_DOSBase;

  /* Write buffer to file */
  Write(od->od_Handle, od->od_Buffer, od->od_Length);

  /* Reset counter */
  od->od_Counter = 0;
 }
}
