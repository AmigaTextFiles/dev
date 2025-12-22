/*
 *  Program name:  cbio
 *  Purpose:  Provide standard clipboard device interface routines
 *            such as Open, Post, Read, Write, etc.
 *            (link with clip.c example)
 *
 * Copyright (c) 1990 Commodore-Amiga, Inc.
 *
 * This example is provided in electronic form by Commodore-Amiga, Inc. for
 * use with the 1.3 revisions of the Addison-Wesley Amiga reference manuals. 
 * The 1.3 Addison-Wesley Amiga Reference Manual series contains additional
 * information on the correct usage of the techniques and operating system
 * functions presented in this example.  The source and executable code of
 * this example may only be distributed in free electronic form, via bulletin
 * board or as part of a fully non-commercial and freely redistributable
 * diskette.  Both the source and executable code (including comments) must
 * be included, without modification, in any copy.  This example may not be
 * published in printed form or distributed with any commercial product.
 * However, the programming techniques and support routines set forth in
 * this example may be used in the development of original executable
 * software products for Commodore Amiga computers.
 * All other rights reserved.
 * This example is provided "as-is" and is subject to change; no warranties
 * are made.  All use is at your own risk.  No liability or responsibility
 * is assumed.
 *
 */

#include <exec/types.h>
#include <exec/ports.h>
#include <exec/io.h>
#include <devices/clipboard.h>

#ifdef LATTICE
#include <proto/all.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#endif

struct IOClipReq *clipboardIO = 0;
struct MsgPort *clipboardMsgPort= 0;
struct MsgPort *satisfyMsgPort = 0;

long CBOpen(long);
void CBClose(void);
void writeLong(long *);
void CBCutS(UBYTE *);
long CBPasteS(UBYTE *);
long CBPost(void);
long CBCurrentReadID(void);
long CBCurrentWriteID(void);
BOOL CBCheckSatisfy(long *);
void CBSatisfyPost(UBYTE *);
void CBCut(UBYTE *,long);

long CBOpen(unit)
long unit;
{
    long error;

    /* open the clipboard device */
    clipboardMsgPort = CreatePort(0L,0L);
    satisfyMsgPort = CreatePort(0L,0L);

    clipboardIO=(struct IOClipReq *)
    CreateExtIO(clipboardMsgPort,sizeof(struct IOClipReq));

    if ((error = OpenDevice("clipboard.device", unit, clipboardIO, 0)))
    return(error);
    return(0);
}

void CBClose()
{
    CloseDevice(clipboardIO);
    DeletePort(satisfyMsgPort);
    DeletePort(clipboardMsgPort);
    DeleteExtIO(clipboardIO);
}

void CBCut(stream, length)
UBYTE *stream;
long length;
{
    clipboardIO->io_Command = CMD_WRITE;
    clipboardIO->io_Data = stream;
    clipboardIO->io_Length = length;
    clipboardIO->io_Offset = 0;
    clipboardIO->io_ClipID = 0;
    DoIO(clipboardIO);
    clipboardIO->io_Command = CMD_UPDATE;
    DoIO(clipboardIO);
}


void CBCutS(string)
UBYTE *string;
{
    clipboardIO->io_ClipID = 0;
    CBSatisfyPost(string);
}

void writeLong(ldata)
long *ldata;
{
    clipboardIO->io_Command = CMD_WRITE;
    clipboardIO->io_Data = (char *)ldata;
    clipboardIO->io_Length = 4;
    DoIO(clipboardIO);
}

void CBSatisfyPost(string)
UBYTE *string;
{
    long length,slen=strlen(string);
    BOOL odd = (slen & 1); /* pad byte flag */

    length= (odd) ? slen+1 : slen;
    clipboardIO->io_Offset = 0;

    writeLong((long *)"FORM");          /* "FORM" */
    length += 12;
    writeLong(&length);             /* #  */
    writeLong((long *)"FTXT");          /* "FTXT" for example */
    writeLong((long *)"CHRS");          /* "CHRS" for example */
    writeLong(&slen);                           /* #  (length of string) */

    clipboardIO->io_Command = CMD_WRITE;
    clipboardIO->io_Data = (char *)string;
    clipboardIO->io_Length = slen;      /* length of string */
    DoIO(clipboardIO);              /* text string */

    if(odd)
    {
        clipboardIO->io_Command = CMD_WRITE;
        clipboardIO->io_Data = "";
        clipboardIO->io_Length = 1;
        DoIO(clipboardIO);          /* pad byte */
    }
    clipboardIO->io_Command = CMD_UPDATE;
    DoIO(clipboardIO);
}


long CBPasteS(string)
UBYTE *string;
{
    long length,slen;
    long len[5];

    clipboardIO->io_Command = CMD_READ; /* assume FORM # FTXTCHRS # */
    clipboardIO->io_ClipID = 0;
    clipboardIO->io_Offset = 0;     /* offset must be 0 on initial read */
    clipboardIO->io_Data = (char *)len; 
    clipboardIO->io_Length = 20;
    DoIO(clipboardIO);

    length=len[1];  /* the length of the cut */
    slen=len[4];    /* the length of string */

    clipboardIO->io_Data = (char *)string;  /* read the string */
    clipboardIO->io_Length = slen;
    DoIO(clipboardIO);

    clipboardIO->io_Offset  += length;  /* read past end of current clip to */
    clipboardIO->io_Length = 1;     /* close clip for reading */
    clipboardIO->io_Data = 0;
    DoIO(clipboardIO);

    string[slen] = '\0';   /* NULL terminate the string */
    return(slen);
}

long CBPost()
{
    clipboardIO->io_Command = CBD_POST;
    clipboardIO->io_Data = (char *)satisfyMsgPort;
    clipboardIO->io_ClipID = 0;
    DoIO(clipboardIO);
    return(clipboardIO->io_ClipID);
}

long CBCurrentReadID()
{
    clipboardIO->io_Command = CBD_CURRENTREADID;
    DoIO(clipboardIO);
    return(clipboardIO->io_ClipID);
}

long CBCurrentWriteID()
{
    clipboardIO->io_Command = CBD_CURRENTWRITEID;
    DoIO(clipboardIO);
    return(clipboardIO->io_ClipID);
}

BOOL CBCheckSatisfy(idVar)
long *idVar;
{
    struct SatisfyMsg *sm;

    if (*idVar == 0)
    return(TRUE);
    if (*idVar < CBCurrentWriteID())
    {
    *idVar = 0;
    return(TRUE);
    }
    if (sm = (struct SatisfyMsg *)GetMsg(satisfyMsgPort))
    {
    if (*idVar == sm->sm_ClipID)
        return(TRUE);
    }
    return(FALSE);
}

