/* -*-C-*-
 *
 *
 * Filename : _ansi.c
 *
 * Author   : Simon J Raybould.    (sie@fulcrum.bt.co.uk).
 *
 * Date     : Thursday 28th May 1992.
 *
 * Desc     : ANSI support for curses.
 *            Implemented using termcap support.
 *
 *
 * THIS CODE IS NOT PUBLIC DOMAIN
 * ==============================
 * 
 * This code is copyright Simon J Raybould 1992, all rights are reserved.
 * All code, ideas, data structures and algorithms remain the property of the
 * author. Neither the whole nor sections of this code may be used as part
 * of other code without the authors consent. If you wish to use some of this
 * code then please email me at (sie@fulcrum.bt.co.uk).
 *
 * This source is not public domain, so you do not have any right to alter it
 * or sell it for personal gain. The source is provided purely for reference
 * purposes. You may re-compile the source with any compiler you choose.
 * You must not distribute altered copies without the authors consent. My
 * intention is that the source will help people isolate any bugs much more
 * effectively.
 *
 * Disclaimer
 * ==========
 *
 * No implication is made as to this code being fit for any purpose at all.
 * I (the author) shall not be held responsible for any loss of data or damage 
 * to property that may result from its use or misuse.
 *
 *
 * Revision History
 * ================
 *
 * $Log: _ansi.c,v $
 * Revision 1.4  1994/02/21  22:20:22  sie
 * removed _ANSIInit() as it is now replaced by setupterm().
 *
 * Revision 1.3  1993/05/17  23:33:10  sie
 * Underscores added to names.
 * Changes for version 2.10
 *
 * Revision 1.2  1992/12/25  23:43:43  sie
 * GNU C port
 *
 * Revision 1.1  92/06/10  23:46:04  sie
 * Initial revision
 * 
 *
 */

#include <libraries/dosextens.h>
#include <errno.h>
#include <exec/memory.h>
#include <fcntl.h>
#include "acurses.h"

static char *rcsid = "$Header: /SRC/lib/curses/src/RCS/_ansi.c,v 1.4 1994/02/21 22:20:22 sie Exp $";


static int
_myputc(char c)
{
  fputc(c, stdout);
  fflush(stdout);
  return 0;
}

void
_ANSIClear()
{
  tputs(_clstr, 1, _myputc);
}

void
_ANSIMove(int line, int col)
{
  tputs(tgoto(_cmstr, col, line), 1, _myputc);
}

void
_ANSIFlash()
{
  fputc(BELL, stdout);
}

void
_ANSIClearRect(int line, int col, int height, int width)
{
  char buf[BUFSIZ], *ptr;
  int i;
  
  if(!line && !col && height>=LINES-1 && width>=COLS-1) {
    _ANSIClear();
    return;
  }
  if(!(ptr = malloc(width+1)))	/* 1 for the NULL */
    return;
  memset(ptr, ' ', width);
  ptr[width] = '\0';		/* terminate  */
  for(i=line; i<line+height; i++) {
    sprintf(buf, "\033[%d;%dH%s", i+1, col+1, ptr);
    write(1, buf, strlen(buf));
  }
  free(ptr);
}


/*
 *
 * Author   : Chuck McManis.
 *
 * Date     : 18th June 1987.
 *
 * Desc     : These are routines for setting a given stream to RawMode or
 *            CanonMode mode on the Amiga.
 *
 */


/*
 * send_packet() - written by Phil Lindsay, Carolyn Scheppner, and Andy
 * Finkel. This function will send a packet of the given type to the Message
 * Port supplied. 
 */

static long
_send_packet(struct MsgPort *pid, long action, long args[], long nargs)
{
    struct MsgPort *replyport;
    struct StandardPacket *packet;

    long            count, *pargs, res1;

    replyport = (struct MsgPort *) CreatePort(NULL, 0);
    if (!replyport)
	return (0);

    /* Allocate space for a packet, make it public and clear it */
    packet = (struct StandardPacket *)
	AllocMem((long) sizeof(struct StandardPacket),
		 MEMF_PUBLIC | MEMF_CLEAR);
    if (!packet) {
	DeletePort(replyport);
	return (0);
    }
    packet->sp_Msg.mn_Node.ln_Name = (char *) &(packet->sp_Pkt);
    packet->sp_Pkt.dp_Link = &(packet->sp_Msg);
    packet->sp_Pkt.dp_Port = replyport;
    packet->sp_Pkt.dp_Type = action;

    /* copy the args into the packet */
    pargs = &(packet->sp_Pkt.dp_Arg1);	/* address of first argument */
    for (count = 0; count < nargs; count++)
	pargs[count] = args[count];

    PutMsg(pid, (struct Message *)packet);	/* send packet */

    WaitPort(replyport);
    GetMsg(replyport);

    res1 = packet->sp_Pkt.dp_Res1;

    FreeMem(packet, (long) sizeof(struct StandardPacket));
    DeletePort(replyport);

    return (res1);
}

/*
 * Function RawMode() - Convert the specified File Handle to 'RawMode' mode. This
 * only works on TTY's and essentially keeps DOS from translating keys for
 * you.
 */

long
_RawMode(BPTR afh)
{
    struct MsgPort *mp;		/* The File Handle message port */
    long            Arg[1], res;

    mp = ((struct FileHandle *) (BADDR(afh)))->fh_Type;
    Arg[0] = -1L;
    res = _send_packet(mp, ACTION_SCREEN_MODE, Arg, 1);
    if (res == 0) {
	errno = ENXIO;
	return (-1);
    }
    return (0);
}

/*
 * Function - CanonMode() this function returns the designate file pointer to
 * it's normal, wait for a <CR> mode. This is exactly like RawMode() except that
 * it sends a 0 to the console to make it back into a CON: from a RAWMODE: 
 */

long
_CanonMode(BPTR afh)
{
    struct MsgPort *mp;		/* The File Handle message port */
    long            Arg[1], res;

    mp = ((struct FileHandle *) (BADDR(afh)))->fh_Type;
    Arg[0] = 0L;
    res = _send_packet(mp, ACTION_SCREEN_MODE, Arg, 1);
    if (res == 0) {
	errno = ENXIO;
	return (-1);
    }
    return (0);
}
