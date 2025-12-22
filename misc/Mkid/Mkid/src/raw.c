/* 
 *      raw.c
 *
 *    This is a routine for setting a given stream to raw or cooked mode.
 * This is useful when you are using Lattice C to produce programs that
 * want to read single characters with the "getch()" or "fgetc" call.
 *
 * Written : 18-Jun-87 By Chuck McManis. 
 *           If you use it I would appreciate credit for it somewhere.
 */
#include <exec/types.h>
#include <libraries/dos.h>
#include <libraries/dosextens.h>
#include <stdio.h>
#include <ios1.h>
#include <error.h>

/* New Packet in 1.2 */
#define ACTION_SCREEN_MODE      994L

extern  int     errno;          /* The error variable */
 
/*
 * Function raw() - Convert the specified file pointer to 'raw' mode. This
 * only works on TTY's and essentially keeps DOS from translating keys for
 * you, also (BIG WIN) it means getch() will return immediately rather than
 * wait for a return. You lose editing features though.
 */
long
raw(fp)

FILE *fp;
 
{
  struct MsgPort        *mp; /* The File Handle message port */
  struct FileHandle     *afh;
  struct UFB            *ufb;
  long                  Arg[1],res;

  ufb = (struct UFB *) chkufb(fileno(fp));  /* Step one, get the file handle */
  afh = (struct FileHandle *)(ufb->ufbfh); 

  if (!IsInteractive(afh)) {    /* Step two, check to see if it's a console */
    errno = ENOTTY;
    return(-1);
  }
                              /* Step three, get it's message port. */
  mp  = ((struct FileHandle *)(BADDR(afh)))->fh_Type;
  Arg[0] = -1L;
  res = SendPacket(mp,ACTION_SCREEN_MODE,Arg,1); /* Put it in RAW: mode */
  if (res == 0) {
    errno = ENXIO;
    return(-1);
  }
  return(0);
}
 
/*
 * Function - cooked() this function returns the designate file pointer to
 * it's normal, wait for a <CR> mode. This is exactly like raw() except that
 * it sends a 0 to the console to make it back into a CON: from a RAW:
 */

long
cooked(fp)
 
FILE *fp;
 
{
  struct MsgPort        *mp; /* The File Handle message port */
  struct FileHandle     *afh;
  struct UFB            *ufb;
  long                  Arg[1],res;
 
  ufb = (struct UFB *) chkufb(fileno(fp));
  afh = (struct FileHandle *)(ufb->ufbfh);
  if ( ! IsInteractive(afh)) {
    errno = ENOTTY;
    return(-1);
  }
  mp  = ((struct FileHandle *)(BADDR(afh)))->fh_Type;
  Arg[0] = 0;
  res = SendPacket(mp,ACTION_SCREEN_MODE,Arg,1);
  if (res == 0) {
    errno = ENXIO;
    return(-1);
  }
  return(0);
}
