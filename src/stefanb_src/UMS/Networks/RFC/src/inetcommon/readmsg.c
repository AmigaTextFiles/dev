/*
 * readmsg.c V1.0.00
 *
 * UMS INET read one message from socket
 *
 * (c) 1997 Stefan Becker
 */

#include "common.h"

/*
 * Read one message from a socket. Caller supplies a temporary file and
 * a read buffer. If the message was received correctly then the routine
 * reads it into memory and returns a pointer to the memory block. The
 * temporary file is automatically closed and deleted.
 */
char *ReadMessageFromSocket(struct InputData *id)
{
 struct OutputData *od         = id->id_OutputData;
 struct Library    *DOSBase    = od->od_DOSBase;
 enum CharState {CHAR_NORM,    /* Normal character */
                 CHAR_CR,      /* Suppresed CR     */
                 CHAR_EOLN,    /* End of line reached */
                 CHAR_POINT,   /* '.' at the start of line */
                 CHAR_EOM      /* End of message reached */
                 }  cs         = CHAR_EOLN; /* Start of line! */
 ULONG              n;
 char              *rc         = NULL;

 /* Reset counter */
 od->od_Counter = 0;

 {
  struct Library *SocketBase = id->id_SocketBase;

  /* Read from socket until end of message is reached */
  while ((cs != CHAR_EOM) &&
         ((n = Recv(id->id_Socket, id->id_Buffer, id->id_Length, 0)) > 0)) {
   char *p = id->id_Buffer;

   /* Look out for "\n.\n" */
   while (n--) {
    char c = *p++;

    /* State machine */
    switch (cs) {

     case CHAR_NORM:    /* Normal mode */
      switch (c) {
       case '\n': cs = CHAR_EOLN; break;    /* End of line reached */
       case '\r': cs = CHAR_CR;   continue; /* Suppress CR         */
       default:                   break;    /* Don't leave state   */
      }
      break;

     case CHAR_CR:      /* Last character was a CR */
      switch (c) {
       case '\n': cs = CHAR_EOLN; break;    /* CR-LF received, strip CR    */
       case '\r':                 break;    /* Don't leave state           */
       default:   OutputFunction(od, '\r'); /* No CR-LF, put CR back again */
                  cs = CHAR_NORM;
                  break;
      }
      break;

     case CHAR_EOLN:    /* We reached the line end */
      switch (c) {
       case '\n':                  break;    /* Don't leave state        */
       case '\r': cs = CHAR_CR;    continue; /* Suppress CR              */
       case '.' : cs = CHAR_POINT; break;    /* '.' at beginning of line */
       default  : cs = CHAR_NORM;  break;    /* Normal line              */
      }
      break;

     case CHAR_POINT:   /* '.' at beginning of line */
      switch (c) {
       case '\n':                              /* End of message */
                  /* If a CR follows a '.' at the start of a line then a LF  */
                  /* MUST follow! Otherwise it would be a single '.' at the  */
                  /* start of a line but these are always escaped with a '.' */
       case '\r': cs = CHAR_EOM; n = 0; break; /* End of message */
       default  : cs = CHAR_NORM;       break; /* Normal line    */
      }
      break;
    }

    /* Write character to temporary file */
    OutputFunction(od, c);
   }
  }
 }

 /* Message recieved correctly? */
 if (cs == CHAR_EOM) {
  struct Library *SysBase = id->id_SysBase;

  /* Yes, flush buffer */
  Write(od->od_Handle, od->od_Buffer, od->od_Counter);

  /* Get file size and remove trailing "\n.\n" */
  n = Seek(od->od_Handle, 0, OFFSET_BEGINNING) - 3;

  /* Allocate memory */
  if ((n > 0) && (rc = AllocMem(n + 1, MEMF_PUBLIC))) {

   /* Read file */
   if (Read(od->od_Handle, rc, n) == n) {

    /* Add string terminator */
    rc[n] = '\0';

    /* Store message length */
    id->id_MsgLength = n + 1;

   } else {

    /* Couldn't read message into buffer */
    FreeMem(rc, n + 1);
    rc = NULL;
   }
  }
 }

 /* Close & delete temporary file */
 Close(od->od_Handle);
 DeleteFile(id->id_FileName);

 /* Return pointer to message buffer */
 return(rc);
}
