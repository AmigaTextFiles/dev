/*
 * command.c V1.0.01
 *
 * UMS NNTP (client) handle NNTP commands, responses and authentication
 *
 * (c) 1998 Stefan Becker
 */

#include "umsnntp.h"

/* Read answer from server */
ULONG GetReturnCode(struct NNTPCommandData *ncd)
{
 /* Read line from server */
 if (ReadLine(ncd->ncd_ConnectData.cd_SocketBase,
              ncd->ncd_ConnectData.cd_Socket, ncd->ncd_Buffer, BUFLEN)) {

  DEBUGLOG(kprintf("Response: %s\n", ncd->ncd_Buffer);)

  /* Convert number */
  return(strtol(ncd->ncd_Buffer, NULL, 10));

 } else
  /* Error */
  return(NNTP_SERVICE_DISCONTINUED);
}

/* Send one NNTP command to server, read the response and authenticate */
ULONG SendNNTPCommand(struct NNTPCommandData *ncd, const char *cmd, ULONG len)
{
 struct Library *SocketBase = ncd->ncd_ConnectData.cd_SocketBase;
 LONG            Socket     = ncd->ncd_ConnectData.cd_Socket;
 ULONG           rc;

 DEBUGLOG(kprintf("Command: %s\n", cmd);)

 /* Send command to server */
 Send(Socket, cmd, len, 0);

 /* Get response from server. Authentication required? */
 if ((rc = GetReturnCode(ncd)) == NNTP_AUTHENTICATION_REQUIRED) {
  char  *buffer = ncd->ncd_Buffer;
  ULONG  buflen;

  DEBUGLOG(kprintf("Authentication required, sending user '%s'\n",
                   ncd->ncd_User);)

  /* Yes, send user information */
  buflen = sprintf(buffer, "AUTHINFO USER %s\r\n", ncd->ncd_User);
  Send(Socket, buffer, buflen, 0);

  /* Get response from server. More authentication information needed? */
  if ((rc = GetReturnCode(ncd)) == NNTP_MORE_AUTHINFO_REQUIRED) {

   DEBUGLOG(kprintf("Password required, sending password '%s'\n",
                    ncd->ncd_Password);)

   /* Yes, send password information */
   buflen = sprintf(buffer, "AUTHINFO PASS %s\r\n", ncd->ncd_Password);
   Send(Socket, buffer, buflen, 0);

   /* Get response from server */
   rc = GetReturnCode(ncd);
  }

  /* Authentication accepted? */
  if (rc == NNTP_AUTHENTICATION_ACCEPTED) {

   /* Yes, retry original command */
   Send(Socket, cmd, len, 0);

   /* Get response from server */
   rc = GetReturnCode(ncd);
  }
 }

 /* Return last server response */
 return(rc);
}
