

// ==================================================================
//	playsound
//	will start the sound and return - msg reply is in gcsound.c
// ==================================================================

playsound (struct myhandle *h,
  	   struct DosLibrary *DOSBase, struct ExecBase *SysBase)
{
   UBYTE  channels[] = { 1,2,4,8 };   // array for requesting channel
   LONG   dev_error  = 1;  // 0 = device was opened ok

   // struct DosLibrary *DOSBase;
   // struct ExecBase *SysBase;
   // DOSBase=h->bs->dosbase; SysBase=h->bs->sysbase;

   // ----------- Open audio.device & get next available channel

   h->io1.ioa_Request.io_Message.mn_ReplyPort   = h->bs->soundport;
   h->io1.ioa_Request.io_Message.mn_Node.ln_Pri = 127;    // No stealing!
   h->io1.ioa_AllocKey  = 0;                 // filled by OpenDevice
   h->io1.ioa_Data      = channels;          // ask for any channel
   h->io1.ioa_Length    = sizeof(channels);

   if (dev_error = OpenDevice(AUDIONAME, 0L, (struct IORequest *)&h->io1, 0L))
      return(0);

   // ----------- Set Up Audio IO Blocks for Sample Playing

   h->io1.ioa_Request.io_Command = CMD_WRITE;
   h->io1.ioa_Request.io_Flags   = ADIOF_PERVOL;

   h->io1.ioa_Length  = h->buffsize;  // sample length
   h->io1.ioa_Volume  = (UWORD)h->volume;
   h->io1.ioa_Period  = (UWORD)h->speed;

   // pass times to play only for small samples
   if (h->fp == NULL) 
       h->io1.ioa_Cycles = (UWORD)h->times; // 0=forever
   else
       h->io1.ioa_Cycles = 1;

   h->played = 0;

   // ----------- clone structures so they're the same

   h->io2 = h->io1;

   // ----------- set their data

   h->io1.ioa_Data = h->buff1;
   h->io2.ioa_Data = h->buff2;

   // ----------- Run the sample 

   if (h->fp == NULL)      // ---------- file was closed = small sample
   {
       BeginIO ((struct IORequest *)&h->io1);
       h->remain = 0;  h->out1 = 1;
   }

   else                    // ----------- large sample
   {
       BeginIO ((struct IORequest *)&h->io1);  // Start up the first 2 blocks
       BeginIO ((struct IORequest *)&h->io2);
       h->remain = h->bodylength - (h->buffsize * 2);  // remaining data length
       h->out1 = h->out2 = 1;   // both messages are outstanding
       h->reload = 1; // flag to reload sample before replaying
   }
   return (1);
}

// ==================================================================
// 	setVolSpeed
//	set the volume &/or speed of a playing sample
// ==================================================================
setVolSpeed (struct myhandle *h)
{
   struct IOAudio *io;		// new msg - FREEVEC AT GCSOUND.C!!
   struct DosLibrary *DOSBase;
   struct ExecBase *SysBase;
   if (!h) return(0);
   DOSBase=h->bs->dosbase; SysBase=h->bs->sysbase;

   // change fields, if sample is playing
   if (h->out1 || h->out2)
   {
      if (!(io = (struct IOAudio *)AllocVec(sizeof(struct IOAudio), CLEANMEM)))
         return(0);
      *io = h->io1;        // clone the request
      io->ioa_Request.io_Command = ADCMD_PERVOL;
      io->ioa_Request.io_Flags   = IOF_QUICK;
      io->ioa_Data    = NULL;
      io->ioa_Length  = 0;
      io->ioa_Volume  = (UWORD)h->volume;
      io->ioa_Period  = (UWORD)h->speed;
      BeginIO ((struct IORequest *)io);
   }

   // set also the normal structures
   h->io1.ioa_Volume  = (UWORD)h->volume;
   h->io1.ioa_Period  = (UWORD)h->speed;
   h->io2.ioa_Volume  = (UWORD)h->volume;
   h->io2.ioa_Period  = (UWORD)h->speed;

   return (1);
   // reply in gcsound.c
}

// ==================================================================
// 	stopsound
//	abort the sound - (wait for replies in gcsound.c)
// ==================================================================
void abortsound (struct myhandle *h)
{
   struct DosLibrary *DOSBase;
   struct ExecBase *SysBase;
   if (!h) return;
   DOSBase=h->bs->dosbase; SysBase=h->bs->sysbase;

   if (h->out1)    // if it's outstanding, abort it..
      AbortIO ((struct IORequest *)&h->io1);
   if (h->out2)
      AbortIO ((struct IORequest *)&h->io2);
   h->remain = 0;
   h->played = h->times;
}

// ==================================================================
// get constant (magic stuff you just do and don't ask why..)
// ==================================================================
BOOL getconstant (struct base *bs)
{
   struct GfxBase *GfxBase;
   struct ExecBase *SysBase;
   SysBase=bs->sysbase;

   if (GfxBase = (struct GfxBase *)OpenLibrary("graphics.library",0L))
   {
      if (GfxBase->DisplayFlags & PAL) bs->clock=3546895L; // PAL clock
      else  bs->clock=3579545L;                            // NTSC clock
      CloseLibrary ((struct Library *)GfxBase);
      return (1);
   }
   return (0);
}


