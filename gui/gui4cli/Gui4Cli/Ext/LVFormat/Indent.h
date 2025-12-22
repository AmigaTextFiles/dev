
// ==============================================================
// Indent the listview - return success
// go through all records, delete old, replace with new..
// gcm   = struct *GCmain
// instr = the string to indent it with
// ==============================================================

indentlist (struct GCmain *gcm, UBYTE *instr,
	    struct ExecBase *SysBase, struct DosLibrary *DOSBase)
{
	LONG   inlen, totlen;
	struct fulist *fls;
	struct lister *fl, *nextfl;
	UBYTE  *buff;
	
	inlen = strlen(instr);
	
	// get pointer to current listview
	if (!(fls = gcm->curlv) || !fls->ls) return (0);
	
	// do the whole list..
	fl = (struct lister *)(fls->ls->lh_Head);
	while (nextfl = (struct lister *)(fl->node.ln_Succ))
	{
	   if (fl->start[0] == '\0') goto skipline; // empty line

	   // get the buffer we need.. (NOTE totlen + 1 - always!)
	   totlen = inlen + fl->length;
	   if (!(buff = (UBYTE *)AllocMem(totlen + 1, MEMF_CLEAR)))
	   {   PutStr ("No memory!\n");
	       return (0);
	   }
	   // construct the line..
	   strcpy (buff, instr);
	   strcat (buff, fl->start);
	
	   // replace old line
	   FreeMem (fl->start, fl->length + 1); // note +1
	   fl->start  = buff;   
	   fl->length = totlen;

   	// store max line length
   	if (fls->maxlength < fl->length) fls->maxlength = fl->length;

	   // do next line..
	   skipline:
	   fl = nextfl;
	}
	return (1); // ok..
}

// ==============================================================
// Remove all tabs and spaces from the front of each line
//        of the current listview - return success
// ==============================================================

unindentlist (struct GCmain *gcm,
	      	  struct ExecBase *SysBase, struct DosLibrary *DOSBase)
{
	LONG   len, lead=600, tab, addspace, c;
	struct fulist *fls;
	struct lister *fl, *nextfl;
	UBYTE  *buff, *p, *start;

	// get pointer to current listview
	if (!(fls = gcm->curlv) || !fls->ls) return (0);
	tab = gcm->tab; // Gui4Cli tab size

	// go through list and find out the smallest indentation
	fl = (struct lister *)(fls->ls->lh_Head);
	while (nextfl = (struct lister *)(fl->node.ln_Succ))
	{
   	p = fl->start;
   	c = 0;

		if (*p) // skip empty lines
		{
      	// goto start of letters
      	while (*p && ((*p==' ')||(*p=='\t'))) 
			{
				// enpand tabs
				if (*p == '\t') c += tab - (c % tab);
				else ++c;
				++p;
			}
      	if (lead > c) lead = c;
		}

      // do next line..
      fl = nextfl;
   }

   if (lead == 0) return (1); // nowhere to go..

   // do the whole list..
   fl = (struct lister *)(fls->ls->lh_Head);
   while (nextfl = (struct lister *)(fl->node.ln_Succ))
	{
	   if (!(*(fl->start))) goto skipline; // skip empty lines

		// set p to start of line, accounting for tabs
		for (p=fl->start, c=0; c < lead; ++p)
		{
			if (*p == ' ') ++c;
			else if (*p == '\t')	c += tab - (c % tab);
		}

		len      = strlen(p);	// all this for tabs..
		start    = p;
		addspace = 0;

		// adjust if we're in the middle of a tab
		if (c > lead)
		{
			addspace = tab - (c - lead);
			len += addspace;
		}

	   // get the buffer we need.. (NOTE totlen + 1 - always!)
	   if (!(buff = (UBYTE *)AllocMem(len + 1, MEMF_CLEAR)))
	   {   PutStr ("No memory!\n");
	       return (0);
	   }

		// fill in spaces (if we were in middle of tab)
		for (c = 0; c < addspace; ++c) buff[c] = ' ';

		// copy the line text
	   if (*p) strcpy (&buff[addspace], p);

	   // replace old line
	   FreeMem (fl->start, fl->length + 1); // note +1
	   fl->start  = buff;
	   fl->length = len;
	
   	// store max line length
   	if (fls->maxlength < fl->length) fls->maxlength = fl->length;

	   // do next line..
	   skipline:
	   fl = nextfl;
	}
	return (1); // ok..
}



