/*
 * readline.c V1.0.00
 *
 * UMS INET read one line from socket
 *
 * (c) 1994-97 Stefan Becker
 */

#include "common.h"

/*
 * Read one line from client. The buffer may hold a maximum of "len"
 * characters including string terminator. The routine returns FALSE
 * when the connection to the client was lost during reading the line.
 * The buffer will always contain a valid C string after the call.
.*/
BOOL ReadLine(struct Library *SocketBase, LONG Socket, char *buf, LONG len)
{
 char *p = buf;

 /* Is enough space left in buffer to read more characters? */
 while (--len > 0) {

  /* Yes, read one character from socket */
  if (Recv(Socket, p, 1, 0) <= 0) {

   /* Error or end of input reached */
   len = -1;

   /* Leave loop */
   break;
  }

  /* End of line reached? */
  if (*p == '\n') {

   /* Yes, strip CR if line end was marked by CRLF */
   if ((p != buf) && (*(p - 1) == '\r')) p--;

   /* Leave loop */
   break;

  } else
   /* No, normal character */
   p++;
 }

 /* Add string terminator */
 *p = '\0';

 return(len >= 0);
}
