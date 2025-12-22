;/* clip.c - Execute me to compile me with Lattice 5.04
LC -b1 -cfistq -v -y -j73 clip.c
LC -b1 -cfistq -v -y -j73 cbio.c
Blink FROM LIB:c.o,clip.o,cbio.o TO clip LIBRARY LIB:LC.lib,LIB:Amiga.lib
quit
*/

/*
 *  Program name:  clip
 *  Purpose:  Demonstrate the use of the clipboard
 *      This program can be run by itself, or two or more
 *      copies can be run, demonstrating how one program
 *      can send data to another.  If the POST option is used,
 *      two programs must be used together. 
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
#include <libraries/dos.h>
#include <devices/clipboard.h>

#ifdef LATTICE
#include <proto/all.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
int  CXBRK(void) { return(0); }		/* Disable Lattice CTRL-C handling */
int chkabort(void) { return(0); }	/* really */
#endif

extern long CBOpen(long);
extern void CBClose(void);
extern void writeLong(long *);
extern void CBCutS(UBYTE *);
extern long CBPasteS(UBYTE *);
extern long CBPost(void);
extern long CBCurrentReadID(void);
extern long CBCurrentWriteID(void);
extern BOOL CBCheckSatisfy(long *);
extern void CBSatisfyPost(UBYTE *);
extern void CBCut(UBYTE *,long);


void cleanExit(long);
void readS(UBYTE *);
void print(UBYTE *,long);

LONG con;

void main(int argc,char **argv)
{
    UBYTE c;
    ULONG postID;
    UBYTE cbuf[80];
    UBYTE buffer[80];

    con = Open("RAW:0/25/400/80/CLIP  w=write r=read p=post CTRL-\\=quit",MODE_OLDFILE);
    if( !con || CBOpen(PRIMARY_CLIP))cleanExit(10);

    print(cbuf,sprintf(cbuf,"\033[20hclipboard.device is open.\n"));

    c = 0;
    postID = 0;
    while (c != '\34')
    {   /* while not EOF */

    while((postID) && (!WaitForChar(con, 1000000)))

        if (CBCheckSatisfy(&postID))
        {
        if (postID)
        {
            print("Please satisfy request for post:\n",0);
            readS(buffer);
            print(cbuf,
            (sprintf(cbuf,"\nsatisfying with \"%s\"\n", buffer)));
            CBSatisfyPost(buffer);
            postID = 0;
        }
        }
    Read(con, &c, 1);
    switch ((int)c)
    {
        case 'w':
        print("Enter cut data\n",0);
        readS(buffer);
        CBCutS(buffer);
        print(cbuf,
            (sprintf(cbuf,"\n\"%s\" sent to clipboard\n",buffer)));
        break;
        case 'r':
        CBPasteS(buffer);
        print(cbuf,(sprintf(cbuf,"paste is \"%s\"\n",buffer)));

        break;
        case 'p':   /* This function will wait for another program */
            /* to request data from the clipboard. */
            /* Running two copies of this program is the */
            /* easiest way to do this. */
            print("Posting, waiting for data request\n",0);
        postID = CBPost();
        break;
        default:;
    }
    }
    print("Exiting...\n",0);
    cleanExit(0);
}

void cleanExit(error)
long error;
{
    CBClose();
    Close(con);
    exit(error);    
}

void readS(buf)
UBYTE *buf;
{
UBYTE c;
long count=0;

    while (Read(con, &c, 1), ((c != '\34') && (c != '\r')))
    {
    *buf++ = c;
    Write(con,&c,1);
    if(++count > 79)return;
    }
    *buf = '\0';
}

void print(string,length)
UBYTE *string;
long length;
{
if(!length) length=strlen(string);
Write(con,string,length);
}

