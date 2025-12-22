

// ===============================================================
//	do the commands
//	return 0 = OK, -1 = Quit - otherwise = error code
//	call function this way, so that we can also use arexx msgs
// ===============================================================

docommand (LONG com, struct base *bs, 
           UBYTE *arg0, UBYTE *arg1, UBYTE *arg2, UBYTE *arg3)
{
struct myhandle *h = NULL;
LONG   num, ret = 5;	// default - return warn
struct DosLibrary *DOSBase;
struct ExecBase *SysBase;
DOSBase=bs->dosbase; SysBase=bs->sysbase;

switch (com)
{
  case LOAD :				// ------- LOAD
    if (arg0 && arg1)
    {   // see if sample already exists
        makeupper (arg1);
        if (h = findsample(arg1, bs->toph))
        {   Printf ("Sample %s already loaded\n", arg1);
            return (5);
        }
        if (h = loadsample (arg0, bs))
        {   initsample (h, arg1, bs);  // in iff.h
            ret = 0; // return ok
    }   }
    break;

  case UNLOAD :				// -------- UNLOAD
    // if nothing passed, free all samples
    if (!arg0 || !arg0[0])
    {   killall (bs);
	ret = 0;
    }
    else if (h = findsample(arg0, bs->toph))
    {
	if ((!h->out1) && (!h->out2))	// if not playing, kill
	{   remlink (h);
	    freehandle (h);
	}
        else if (!h->killflag)
	{   abortsound (h);
            h->killflag = 1;   // will be deleted in gcsound.c
        }
        ret = 0;
    }
    break;

  case PLAY :				// -------- PLAY
    if (h = findsample(arg0, bs->toph))
    {
	// return ok if sample is already playing
	if ((h->out1) || (h->out2)) return (0);  

        // get settings, if sent.. (times, volume, speed
	get_args (h, bs, arg1, arg2, arg3);

	if (h->reload)  // reload big samples before replaying
	    reload (h);
	if (playsound (h, DOSBase, SysBase))
	    ret = 0;
    }
    break;

  case SOUND :				// -------- SOUND - load,play,quit
    if (!(h = loadsample (arg0, bs)))
       return (10);
    initsample (h, "SOUND", bs);

    // get settings, if sent.. (times, volume, speed)
    get_args (h, bs, arg1, arg2, arg3);

    h->killflag = 1;  // mark it for deletion
    if (playsound (h, DOSBase, SysBase))
	ret = 0;
    else	// if failed to play, kill immediately
    {  remlink (h);
       freehandle (h);
    }
    break;

  case VOLUME :				// -------- VOLUME
    if (h = findsample(arg0, bs->toph))
    {   if (arg1)	// get volume
        {   if ((StrToLong (arg1, &num)) > 0)
            {   if (num < 0) num = 64;
                else if (num > 64) num = 64;
		h->volume = num;
		if (setVolSpeed(h)) ret = 0;
    }   }   }
    break;

  case SPEED :				// -------- SPEED
    if (h = findsample(arg0, bs->toph))
    {   if (arg1)	// get speed
        {   if ((StrToLong (arg1, &num)) > 0)
            {	if ((num > 124) && (num < 1000))
		   h->speed = num;
		else  // use default
		   h->speed = bs->clock / h->vh.vh_SamplesPerSec;
		if (setVolSpeed(h)) ret = 0;
    }   }   }
    break;

  case TIMES :				// -------- TIMES
    if (h = findsample(arg0, bs->toph))
    {   if (arg1)	// get times - change only if small samp
        {   if ((StrToLong (arg1, &num)) > 0)
            {   if (num < 0) num = 0;
		h->times = num;
		ret = 0;
		// how to change times ????
    }   }   }
    break;

  case INFO : 				// -------- INFO
    if (h = findsample(arg0, bs->toph))
    {	// store "volume speed" of sample into return buffer
        stcl_d (bs->retbuff, h->volume);
        strcat (bs->retbuff, " ");
        stcl_d (&bs->retbuff[strlen(bs->retbuff)], h->speed);
        ret = 0;
    }
    break;

  case STOP :				// -------- STOP
    // if no alias passed, stop all samples
    if (!arg0 || !arg0[0])
    {  ret = 0;
       for (h = bs->toph; h; h = h->next)
       {   // if msgs outstanding, abort
           if (h->out1 || h->out2)
               abortsound (h);
    }  }
    else if (h = findsample(arg0, bs->toph))
    {   ret = 0;
	abortsound (h);
    }
    break;

  case QUIT :				// -------- QUIT
    --bs->users; // do not quit if there are still users..
    if (bs->users > 0) return (0);
    killall (bs);
    return (-1); 	// return quit
    break;

};  // end of switch

return (ret);
}

// ===============================================================
//	find the sample by alias, return handle or null
// ===============================================================

struct myhandle *findsample (char *alias, struct myhandle *toph)
{
   struct myhandle *h;

   if (!alias || !alias[0]) return (NULL);
   makeupper (alias);

   for (h=toph; h; h=h->next)
   {  if (!strcmp (h->alias, alias))
      {  return (h);
   }  }
   return (NULL);
}

// ===============================================================
//	get times/spped/volume
//	use functions since it's called twice
// ===============================================================

void get_args (struct myhandle *h, struct base *bs,
               UBYTE *arg1, UBYTE *arg2, UBYTE *arg3)
{
    LONG num;
    struct DosLibrary *DOSBase;
    struct ExecBase *SysBase;
    DOSBase=bs->dosbase; SysBase=bs->sysbase;

    // get settings, if sent.. (times, volume, speed
    if (arg1)		// times
    {   if ((StrToLong (arg1, &num)) > 0)
        {   if (num < 0) num = 1;
		h->times = num;
    }   }
    if (arg2)		// volume
    {   if ((StrToLong (arg2, &num)) > 0)
        {   if ((num < 1) || (num > 64)) num = 64;
	    h->volume = num;
    }   }
    if (arg3)		// speed - leave untouched if out of range
    {   if ((StrToLong (arg3, &num)) > 0)
        {   if ((num > 124) && (num < 1000))
		h->speed = num;
	    else  // use default
		h->speed = bs->clock / h->vh.vh_SamplesPerSec;
    }   }
}

// ==============================================================
//	killall
// 	abort and kill all samples (used in unload and quit)
// ==============================================================
void killall (struct base *bs)
{
    struct myhandle *hh, *h;

    for (h = bs->toph; h;)
    {   // if no msgs outstanding, kill it
        if ((!h->out1) && (!h->out2))
        {   hh = h;
	    h = h->next;
	    remlink (hh);
	    freehandle (hh);
	}
	else  // otherwise abort & mark
	{   abortsound (h);
	    h->killflag = 1;
	    h = h->next;
	}
}   }

// ==============================================================
//	makeret
// 	place "volume speed" into bs->msgret buffer
// ==============================================================
void makeret (struct myhandle *h)
{
   struct base *bs;
   struct DosLibrary *DOSBase;
   struct ExecBase *SysBase;
   bs = h->bs;
   DOSBase=bs->dosbase; SysBase=bs->sysbase;

   stcl_d (bs->retbuff, h->volume);
   strcat (bs->retbuff, " ");
   stcl_d (&bs->retbuff[strlen(bs->retbuff)], h->speed);
}

// ==============================================================
// convert string to UPPER case 
// (since stricpm doesn't work without the startup code)
// ==============================================================
void makeupper (UBYTE *str)
{
   if (!str) return;
   while (*str)
   {   if ((*str >= 'a') && (*str <= 'z')) *str -= 32;
       ++str;
   } 
}


