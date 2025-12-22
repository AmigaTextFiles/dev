;/* audio1.c - Execute me to compile me with Lattice 5.04
LC -b1 -cfistq -v -y -j73 audio1.c
Blink FROM LIB:c.o,audio1.o TO audio1 LIBRARY LIB:LC.lib,LIB:Amiga.lib
quit
*/

/*
 * Audio1.c
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

#include <exec/types.h>         /* Some header files for system calls */
#include <exec/memory.h>
#include <devices/audio.h>
#include <graphics/gfxbase.h>
#include <proto/all.h>
#include <stdlib.h>
#include <stdio.h>

#ifdef LATTICE
int CXBRK(void) { return(0); }  /* Disable Lattice CTRL/C handling */
int chkabort(void) { return(0); }  /* really */
#endif

struct GfxBase *GfxBase;
/*-----------------------------------------------------------*/
/* The whichannel array is used when we allocate a channel.  */
/* It tells the audio device which channel we want. The code */
/* is 1 =channel0, 2 =channel1, 4 =channel2, 8 =channel3.    */
/* If you want more than one channel, add the codes up.      */
/* This array says "Give me channel 0. If it's not available */
/* then try channel 1; then try channel 2 and then channel 3 */
/*-----------------------------------------------------------*/
UBYTE           whichannel[] = { 1,2,4,8 };

void main(int argc, char **argv)
{
struct IOAudio *AIOptr;      /* Pointer to the IO block for IO commands   */
struct MsgPort *port;        /* Pointer to a port so the device can reply */
struct Message *msg;         /* Pointer for the reply message             */
ULONG           device;
BYTE           *waveptr;              /* Pointer to the sample bytes     */
LONG            frequency=440;        /* Frequency of the tone desired   */
LONG            duration =3;          /* Duration in seconds             */
LONG            clock    =3579545;    /* Clock constant, 3546895 for PAL */
LONG            samples  =2;          /* Number of sample bytes          */
LONG            samcyc   =1;          /* Number of cycles in the sample  */
/*-------------------------------------------------------------------------*/
/* Ask the system if we are PAL or NTSC and set clock constant accordingly */
/*-------------------------------------------------------------------------*/
GfxBase=(struct GfxBase *)OpenLibrary("graphics.library",0L);
if(GfxBase==0L)
    goto killaudio;
if(GfxBase->DisplayFlags & PAL) clock=3546895;        /* PAL clock */
else                            clock=3579545;        /* NTSC clock */

if(GfxBase)
    CloseLibrary((struct Library *) GfxBase);
/*--------------------------------------------------------------------------*/
/*  Create an audio I/O block so we can send commands to the audio device   */
/*--------------------------------------------------------------------------*/
AIOptr=(struct IOAudio *)
         AllocMem( sizeof(struct IOAudio),MEMF_PUBLIC | MEMF_CLEAR);
if(AIOptr==0)
    goto killaudio;
printf("IO block created...\n");
/*-------------------------------------------------------------------*/
/* Create a reply port so the audio device can reply to our commands */
/*-------------------------------------------------------------------*/
port=CreatePort(0,0);
if(port==0)
    goto killaudio;
printf("Port created...\n");
/*----------------------------------------------------------------------*/
/* Set up the audio I/O block for channel allocation:                   */
/* ioa_Request.io_Message.mn_ReplyPort is the address of a reply port.  */
/* ioa_Request.io_Message.mn_Node.ln_Pri sets the precedence (priority) */
/*   of our use of the audio device. Any tasks asking to use the audio  */
/*   device that have a higher precedence will steal the channel from us.*/
/* ioa_Request.io_Command is the command field for IO.                  */
/* ioa_Request.io_Flags is used for the IO flags.                       */
/* ioa_AllocKey will be filled in by the audio device if the allocation */
/*   succeeds. We must use the key it gives for all other commands sent.*/
/* ioa_Data is a pointer to the array listing the channels we want.     */
/* ioa_Length tells how long our list of channels is.                   */
/*----------------------------------------------------------------------*/
AIOptr->ioa_Request.io_Message.mn_ReplyPort  = port;
AIOptr->ioa_Request.io_Message.mn_Node.ln_Pri= 0;
AIOptr->ioa_Request.io_Command               = ADCMD_ALLOCATE;
AIOptr->ioa_Request.io_Flags                 = ADIOF_NOWAIT;
AIOptr->ioa_AllocKey                         = 0;
AIOptr->ioa_Data                             = whichannel;
AIOptr->ioa_Length                           = sizeof(whichannel);
printf("IO block initialized for channel allocation...\n");
/*-----------------------------------------------*/
/* Open the audio device and allocate a channel  */
/*-----------------------------------------------*/
device=OpenDevice("audio.device",0L, (struct IORequest *) AIOptr ,0L);
if(device!=0)
    goto killaudio;
printf("Audio device opened, channel allocated...\n");
/*----------------------------------------------*/
/* Create a very simple audio sample in memory. */
/*----------------------------------------------*/
waveptr=(BYTE *)AllocMem( samples , MEMF_CHIP|MEMF_PUBLIC);
if(waveptr==0)
    goto killaudio;
waveptr[0]=  127;
waveptr[1]= -127;
printf("Wave data ready...\n");

/*------------------------------------------------------------*/
/* Set up audio I/O block to play a sample using CMD_WRITE.   */
/* The io_Flags are set to ADIOF_PERVOL so we can set the     */
/*    period (speed) and volume with the our sample;          */
/* ioa_Data points to the sample; ioa_Length gives the length */
/* ioa_Cycles tells how many times to repeat the sample       */
/* If you want to play the sample at a given sampling rate,   */
/* set ioa_Period = clock/(given sampling rate)               */
/*------------------------------------------------------------*/
AIOptr->ioa_Request.io_Message.mn_ReplyPort=port;
AIOptr->ioa_Request.io_Command             =CMD_WRITE;
AIOptr->ioa_Request.io_Flags               =ADIOF_PERVOL;
AIOptr->ioa_Data                           =(BYTE *)waveptr;
AIOptr->ioa_Length                         =samples;
AIOptr->ioa_Period                         =clock*samcyc/(samples*frequency);
AIOptr->ioa_Volume                         =64;
AIOptr->ioa_Cycles                         =frequency*duration/samcyc;
printf("IO block initialized to play tone...\n");

/*---------------------------------------------------*/
/* Send the command to start a sound using BeginIO() */
/* Go to sleep and wait for the sound to finish with */
/* Wait().  When we wake-up we have to get the reply */
/*---------------------------------------------------*/
printf("Starting tone now...\n");
BeginIO((struct IORequest *) AIOptr );
Wait(1L << port->mp_SigBit);
msg=GetMsg(port);

printf("Sound finished...\n");

killaudio:

printf("Killing audio device...\n");
if(waveptr!=0)
    FreeMem(waveptr, 2);
if(port!=0)   
    DeletePort(port);
if(device==0) 
    CloseDevice( (struct IORequest *) AIOptr );
if(AIOptr!=0) 
    FreeMem( AIOptr,sizeof(struct IOAudio) );
}
