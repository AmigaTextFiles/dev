/*
 * sendmsg.c V1.0.00
 *
 * UMS POP3 (server) get an UMS message and send as mail messages
 *
 * (c) 1994-97 by Stefan Becker
 */

#include "umspop3d.h"

/* Local data */
static struct OutputData od;
static char OutputBuffer[BUFLEN];

/* Initialize messages sending */
void InitSendMessage(void)
{
 od.od_DOSBase = DOSBase;
 od.od_Handle  = NULL;
 od.od_Counter = 0;
 od.od_Length  = BUFLEN;
 od.od_Buffer  = OutputBuffer;
}

/* Send an UMS message as SMTP mail */
void SendMessage(struct UMSRFCData *urd)
{
 char *filename = tmpnam(NULL);

 /* Open temporary file */
 if (od.od_Handle = Open(filename, MODE_NEWFILE)) {
  ULONG len;
  char *buf;

  /* Reset buffer */
  od.od_Counter = 0;

  /* Write UMS message as RFC message into temporary file */
  UMSRFCWriteMessage(urd, OutputFunction, &od, TRUE);

  /* Flush buffer */
  Write(od.od_Handle, OutputBuffer, od.od_Counter);

  /* Move to beginning of file */
  len = Seek(od.od_Handle, 0, OFFSET_BEGINNING);

  DEBUGLOG(kprintf("Length of msg: %ld Bytes\n", len);)

  /* Allocate memory for file */
  if (len && (buf = AllocMem(len, MEMF_PUBLIC))) {

   /* Read temporary file into memory */
   if (Read(od.od_Handle, buf, len) == len) {
    UMSAccount account = urd->urd_Account;

    /* Delete temporary file */
    Close(od.od_Handle);
    DeleteFile(filename);

    /* Send the whole bunch of bytes :-) */
    Send(POP3DSocket, buf, len, 0);

   } else {
    /* Delete temporary file */
    Close(od.od_Handle);
    DeleteFile(filename);
   }

   FreeMem(buf, len);
  } else {
   /* Delete temporary file */
   Close(od.od_Handle);
   DeleteFile(filename);
  }
 }
}
