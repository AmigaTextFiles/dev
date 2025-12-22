
/***********************************************************************
*
*	GCSound 1.0 - D. Keletsekis (October 98)
*
*	compile: SC GCSound  NOSTACKCHECK  LINK  NOSTARTUP
*	..or have a look at the scoptions files..
*
*	This is a "host" program for playing 8SVX sound samples.
*	It can understand commands from ARexx or Gui4Cli and
*	load & play many samples together, multitaskinglisingly..
*
*	The name of the port opened is "gcsound" (note lower case)
*
*	These are the current commands :
*
*	QUIT	- abort all sounds and quit
*	LOAD    <SampleFile> <Alias> (default speed/time/volume)
*	PLAY    <alias> <times/0> <volume> <speed/-1> 
*	SOUND   <SampleFile> <times/0> <volume> <speed/-1> (load, play & quit)
*	VOLUME  <alias> <1-64>
*	SPEED   <alias> <?>
*	TIMES   <alias> <times/0>
*	INFO    <alias> (return "volume speed")
*	UNLOAD  <alias> (or "" for all samples - stop & unload)
*	STOP    <alias> (or "" for all samples - stop playing)
*
*	From Gui4Cli they can be called either with :
*	-> Call gcsound command arguments..        -or-
*	-> SendRexx gcsound "command arguments"    (note the quotes)
*
************************************************************************/
#define __USESYSBASE
#include <exec/exec.h>
#include <exec/execbase.h>
#include <exec/memory.h>
#include <dos/dosextens.h>
#include <dos/rdargs.h>
#include <dos/dostags.h>
#include <devices/audio.h>
#include <graphics/gfxbase.h>
#include <string.h>
#include <stdio.h>
#include <ctype.h>
#include <dos.h>
#include <proto/dos.h>
#include <proto/exec.h>
#include <proto/rexxsyslib.h>
#include <graphics/text.h>
#include <rexx/storage.h>
#include <datatypes/soundclass.h>	// include soundclass

#include "Gui4Cli.h"		// include Gui4Cli.h (for the message structure)

#include "gcsound_protos.h"

static const char VERSION[] = "\0$VER: gcsound 1.0 (D.Keletsekis Oct.98)";

#define BUFFER_SIZE 65536 	// the buffer size (should be a tooltype)
#define CLEANMEM (MEMF_ANY | MEMF_CLEAR | MEMF_PUBLIC)

// We use this "treat a 4 character string as if it were a LONG
// integer" ID method for identifying our commands also.
// This means that *only* the first four letters of each command
// are checked - but it allows us to use a fast case statement.
#define MakeID(a,b,c,d)	((LONG)(a)<<24L | (LONG)(b)<<16L | (c)<<8 | (d))
#define QUIT 	MakeID('Q','U','I','T')
#define LOAD 	MakeID('L','O','A','D')
#define PLAY 	MakeID('P','L','A','Y')
#define SOUND 	MakeID('S','O','U','N')
#define VOLUME 	MakeID('V','O','L','U')
#define SPEED 	MakeID('S','P','E','E')
#define TIMES 	MakeID('T','I','M','E')
#define INFO 	MakeID('I','N','F','O')
#define UNLOAD 	MakeID('U','N','L','O')
#define STOP 	MakeID('S','T','O','P')
// #define ID_FORM	MakeID('F','O','R','M')

struct myhandle		// each sample has one of these..
{
   struct VoiceHeader vh;	// the 8SVX header
   LONG   bodystart;		// offset of body start into file
   LONG   bodylength;		// total body length
   ULONG  speed;		// playback speed
   ULONG  volume;		// volume (default=64)
   ULONG  times;		// times to play
   ULONG  played;		// times already played
   UBYTE  *buff1, *buff2;	// the buffer pointers
   LONG   buffsize;		// buffer size
   BPTR   fp;			// the file pointer (if file is open)
   char   path[256];		// full name & path of file
   char   alias[40];		// alias - the given name (upper case)
   struct IOAudio io1, io2;  	// Pointers to Audio IO structures
   BOOL   out1, out2;		// flags indicating msgs outstanding
   ULONG  remain;		// remaining data length (large samples)
   BOOL   reload;		// 1 = reload sample before replaying
   BOOL   killflag;		// 1 = kill sample when all msgs replied
   BOOL   playonce;		// 1 = SOUND - load/play/quit sample
   struct base *bs;		// pointer to base
   struct myhandle *next;
};

struct base 		// somewhere to hold everything
{
   struct myhandle *toph;	// top of handles linked list
   struct MsgPort *soundport;	// our sound reply port
   ULONG  clock;		// clock constant
   UBYTE  retbuff[80];          // return text..
   LONG   users;		// how many guis are using us
   struct DosLibrary *dosbase;	// carry these around..
   struct ExecBase *sysbase;
};


// ===============================================================
// 	MAIN() - note there is no need for a main() function
//	The program starts at the 1st function it finds, which
//	can be any name..
// ===============================================================

int main(void)
{
// these are the libraries we need
struct ExecBase *SysBase = (*((struct ExecBase **) 4));
struct DosLibrary *DOSBase=NULL;
struct Process *myself = (struct Process *)(SysBase->ThisTask);
struct MsgPort *myport=NULL;		// our port
ULONG  soundsig, portsig, sig;		// port signal masks
struct g4cmsg  *msg;	// Gui4Cli message pointer
int    rc = 10; 	// return code
BOOL   endflag = 0;	// control flags
BOOL   errorflag = 0;
struct base *bs=NULL;	// our base struct pointer
struct myhandle *h, *hh;
struct IOAudio *io;
struct Task *mt=NULL;	// for bumping task priority
BYTE   oldpri=0;
LONG   readmore, ret;
LONG   rxargs[6];		// for rexx msg parsing
struct RDArgs *rdargs;
struct RexxMsg *rxmsg;
struct RexxSysBase *RexxSysBase = NULL;

// -------------------- open the dos library or die..

if (!(DOSBase = (struct DosLibrary *)OpenLibrary("dos.library", 36L)))
{   myself->pr_Result2 = ERROR_INVALID_RESIDENT_LIBRARY;
    goto endprog;
}

// if rexx is not opened, rexx commands will not be executed
RexxSysBase = (struct RexxSysBase *)OpenLibrary ("rexxsyslib.library", 36L);

// -------------------- if gcsound is already running ++users & quit

if (myport = FindPort("gcsound"))
{   if (msg = (struct g4cmsg *)AllocVec(sizeof(struct g4cmsg), CLEANMEM))
    {   msg->magic = 392002;  // the only thing that's checked
	msg->node.mn_Length = sizeof(struct g4cmsg);
	PutMsg (myport, &msg->node);
	// msg will not be replied & *will* be freeveced
    }
    myport = NULL; // so that it's not freed
    rc = 0;
    goto endprog;
}

// -------------------- get our main base structure

if (!(bs = (struct base *)AllocVec(sizeof(struct base), CLEANMEM)))
    goto endprog;
bs->sysbase = SysBase;
bs->dosbase = DOSBase;
bs->users   = 1; // the guy who loaded us is also our 1st user
if (!getconstant(bs)) goto endprog;

// --------------------- increase our priority - why ?

mt = FindTask(NULL);
oldpri = SetTaskPri(mt,21);

// --------------------- Open message ports or die..

bs->soundport = CreatePort(0,0);	// sound return port
myport = openport ("gcsound", SysBase, DOSBase);  // G4C port
if (!bs->soundport || !myport)
{   PutStr ("Couldn't open ports!\n");
    goto endprog;
}
portsig  = (1 << myport->mp_SigBit);   // create signal masks
soundsig = (1 << bs->soundport->mp_SigBit);

// ---------------------- Main wait() & process loop
// quit on endflag but after all samples have quit first

while ((!endflag) || (bs->toph))
{
   // wait on combined port signals
   sig = Wait (portsig | soundsig);

   // ------------------- messages from Gui4Cli, ARexx etc

   // we support messages from an other instance of this program, or
   // from Gui4Cli or from ARexx - we check to see what we got

   if (sig & portsig)
   {
       while (msg = (struct g4cmsg *)GetMsg(myport))
       {
	   // if it's from an other instance of gcsound, ++users
	   if (msg->magic == 392002)
	   {   ++bs->users;
	       FreeVec (msg);  // do *not* reply - *do* FreeVec()
	   }

	   else if (msg->magic == 392001)  // from gui4cli
	   {
               // check that its like we expect it..
               if ((msg->type == GM_COMMAND) && msg->gcmain && msg->com)
               {
                  ret = docommand ((*((LONG *)msg->com)), bs, msg->args[0], msg->args[1], msg->args[2], msg->args[3]);
                  if (ret < 0) endflag = 1;       // quit
                  else 
                  {   // if there is a return, attach string
                      if (bs->retbuff[0])
                      {   if (msg->msgret = (UBYTE *)AllocVec(80, CLEANMEM))
                              strcpy (msg->msgret, bs->retbuff);
                          bs->retbuff[0] = '\0';
                      }
                      msg->res = ret;
                  }  
               }
               else msg->res = 20;  // indicate error

               // reply the message to Gui4Cli
               ReplyMsg ((struct Message *)msg);
           }

           else if (RexxSysBase) // try arexx message
           {
               rxmsg = (struct RexxMsg *)msg;
               if ((rxmsg->rm_Action & RXCODEMASK)==RXCOMM)  // it's a rexx command
               {
		   rdargs = readargs (rxargs, 5, rxmsg->rm_Args[0], "COM/A,A0,A1,A2,A3", bs);
		   if (rdargs)
		   {
		       makeupper ((UBYTE *)rxargs[0]);
		       ret = docommand ((*((LONG *)rxargs[0])), bs, (UBYTE *)rxargs[1], (UBYTE *)rxargs[2], (UBYTE *)rxargs[3], (UBYTE *)rxargs[4]);
		       if (ret < 0) endflag = 1;   // quit
		       else
		       {  if (bs->retbuff[0]) 
		          {  rxmsg->rm_Result2 = (LONG)CreateArgstring(bs->retbuff, strlen(bs->retbuff));
		             bs->retbuff[0] = '\0';
		          }
		          rxmsg->rm_Result1 = ret;
		       }
		       // free the arguments we got
		       freeargs (rdargs, bs);
		   }
		   else rxmsg->rm_Result1 = 10; // return error
               }
               ReplyMsg ((struct Message *)msg);
           }

           else ReplyMsg ((struct Message *)msg); // always reply

       }   // end of while getmsg()
   }       // end of command port handling

   // -------------------- message from audio device

   else if (sig & soundsig)
   {
       errorflag = 0;
       while ((io = (struct IOAudio *)GetMsg (bs->soundport)) && !errorflag)
       {
	   // if it's a volume/speed command, free it & finished
	   if (io->ioa_Request.io_Command == ADCMD_PERVOL)
	   {   FreeVec (io);
	       goto skipaudio;
	   }

	   // find the audio structure
	   if (!(h = findaudio (io, bs->toph)))
	   {   PutStr ("What was that?!\n");
	       goto skipaudio;
	   }

	   if (h->fp == NULL)	// file closed => small sample
	   {   // finished - message has played and returned..
	       h->out1 = 0;
	       CloseDevice ((struct IORequest *)&h->io1);
 	       if (h->killflag)
	       {   remlink (h);
		   freehandle (h);
		   h = NULL;
	       }
	       goto skipaudio;
	   }

	   // ----------- read in buffer for long samples

	   // adjust the "message outstanding" flag
	   if (io == &h->io1) h->out1 = 0;
	   else h->out2 = 0;
	   
	   // if no data remaining, we've finished playing..
	   // deal with aborted messages
	   if (h->remain <= 0)
	   {
	      // if both sample parts have returned..
	      if ((h->out1==0) && (h->out2==0))
	      {
		  // Printf ("-> Closing device on %s\n", h->alias);
		  // close up & kill sample if so marked
		  CloseDevice ((struct IORequest *)&h->io1);
 		  if (h->killflag)
	          {   remlink (h);
		      // Printf ("-> Freeing %s\n", h->alias);
		      freehandle (h);
		      h = NULL;
	      }   }
	      goto skipaudio;
	   }

	   // if there is little remmaining, start again as needed
	   if (h->remain < h->buffsize)
	   {
	      // read to end of data..
	      io->ioa_Length = Read (h->fp, io->ioa_Data, h->remain);
	      if (io->ioa_Length != h->remain)
	      {   PutStr ("Error reading file\n");
	          errorflag = 1;
	      }
	      
	      // if we still have times to play (0=forever)..
	      ++h->played;
	      if ((h->times == 0) || (h->played < h->times))
	      {
                 // how much to read from file start
                 readmore = h->buffsize - h->remain;
                 Seek (h->fp, h->bodystart, OFFSET_BEGINNING);

                 // read in rest of buffer
                 io->ioa_Length += Read (h->fp, &io->ioa_Data[h->remain], readmore);
                 if (io->ioa_Length != h->buffsize)
                 {   PutStr ("Error reading file\n");
                     errorflag = 1;
                 }
                 h->remain = h->bodylength - readmore;
              }
              else h->remain = 0;
	   }
	   
	   // otherwise plain read it in..
	   else
           {  io->ioa_Length = Read (h->fp, io->ioa_Data, h->buffsize);
	      if (io->ioa_Length != h->buffsize)
	      {   PutStr ("Error reading file\n");
	          errorflag = 1;
	      }
	      h->remain -= h->buffsize;
	   }

	   if (!errorflag)
	   {  // adjust the "message outstanding" flag
	      if (io == &h->io1) h->out1 = 1;
	      else h->out2 = 1;

	      // send out message again..
              BeginIO((struct IORequest *)io);
           }
           else 
	      CloseDevice ((struct IORequest *)&h->io1);
           
           skipaudio: 
		;

       } // end of while getmsg()

   } // end of audio handling

}  // end of main while(!endflag) loop

// set return code
if (endflag > 1) rc = endflag;   // 1 = ok quit
else rc = 0;

// ---------------------- END PROG - CLEAN UP

endprog :

if (bs)
{  if (bs->toph)  
   {   h = bs->toph;   // free all handles
       while (h)
       {   hh = h;  
           h = h->next;
           freehandle (hh);
   }   }
   if (bs->soundport) DeleteMsgPort (bs->soundport);
   FreeVec (bs);
}

if (myport)      closeport (myport, SysBase, DOSBase);
if (mt)          SetTaskPri (mt, oldpri);
if (RexxSysBase) CloseLibrary ((struct Library *)RexxSysBase);
if (DOSBase)     CloseLibrary ((struct Library *)DOSBase);
return (rc);
}

// ================================================================
// 	create a new public message port
//	Note we pass our library bases as arguments since we'll
//	use functions that are included therein. Actually, we
//	only need to pass SysBase, since there are no dos.library
//	functions called here (AFAIK), but what the hey..
// ================================================================

struct MsgPort *openport (char *portname, struct ExecBase *SysBase, struct DosLibrary *DOSBase)
{
   struct MsgPort *port=NULL;

   Forbid ();
   if ((port = FindPort(portname)) != NULL)  
   {    // if port already exists - return NULL
        port = NULL;
   }
   else
        port = CreatePort (portname, 0);
   Permit();

   return (port);
}

// ================================================================
//	 free a public message port
// ================================================================

void closeport (struct MsgPort *port, struct ExecBase *SysBase, struct DosLibrary *DOSBase)
{
   struct Message *msg;

   Forbid ();
   // empty port
   while (msg = GetMsg (port))
          ReplyMsg (msg);
   // remove port name since it's a public msg port
   if (port->mp_Node.ln_Name)
          RemPort (port);
   // delete port
   DeleteMsgPort (port);
   Permit ();
}

// ===============================================================
//	find the handle from an audio struct
// ===============================================================
struct myhandle *findaudio (struct IOAudio *io, struct myhandle *h)
{
   while (h)
   {  if ((io == &h->io1) || (io == &h->io2)) return (h);
      h = h->next;
   }
   return (NULL);
}

// ===============================================================
// include other files here, so they are after the main function
#include "docommands.h"
#include "sound.h"
#include "iff.h"
#include "ReadArgs.h"





