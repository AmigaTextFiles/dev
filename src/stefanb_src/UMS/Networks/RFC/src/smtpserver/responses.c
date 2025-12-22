/*
 * responses.c V1.0.00
 *
 * UMS SMTP (server) response queueing routines (ESMTP PIPELINE support)
 *
 * (c) 1994-97 Stefan Becker
 */

#include "umssmtpd.h"

/* Local data */
static fd_set  FDSet;
static char    ResponseBuffer[BUFLEN];
static char   *NextResponse = ResponseBuffer;
static char    BufferFree = BUFLEN - 1;

/* Initialize response buffer */
void InitResponseBuffer(void)
{
 /* Initialize file descriptor set */
 FD_ZERO(&FDSet);
}

/* Flush response buffer */
void FlushResponseBuffer(void)
{
 ULONG len = NextResponse - ResponseBuffer;

 DEBUGLOG(kprintf("Response buffer flush requested.\n");)

 /* Something in the buffer? */
 if (len > 0) {

  /* Yes, send whole buffer to client */
  Send(SMTPDSocket, ResponseBuffer, len, 0);

  DEBUGLOG(kprintf("Response buffer flushed.\n");)

  /* Reset buffer */
  NextResponse = ResponseBuffer;
  BufferFree   = BUFLEN - 1;
 }
}

/* Queue one response */
void QueueResponse(const char *response, ULONG len)
{
 struct timeval timeout;

 /* Does the response fit into the buffer? */
 if (len > BufferFree)

  /* No, empty buffer first */
  FlushResponseBuffer();

 /* Append new response to buffer */
 strcpy(NextResponse, response);
 NextResponse += len;
 BufferFree   -= len;

 /* Set timeout to zero (Polling) */
 timeout.tv_sec  = 0;
 timeout.tv_usec = 0;

 /* Initialize file descriptor set */
 FD_SET(SMTPDSocket, &FDSet);

 DEBUGLOG(kprintf("Checking socket.\n");)

 /* Is there something to read from the socket? */
 if (WaitSelect(SMTPDSocket + 1, &FDSet, NULL, NULL, &timeout, NULL) == 0)

  /* No. This means either a) there is no command queued,  */
  /* or b) the client does not support command pipelining. */
  /* The response buffer must be flushed (see RFC1854).    */
  FlushResponseBuffer();
}
