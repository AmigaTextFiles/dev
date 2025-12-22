
// ==============================================================
// Clean up a listview from amiga guide nodes stuff 
// - return success
// gcm   = pointer to the GCmain structure
// ==============================================================

agclean (struct GCmain *gcm,
	 struct ExecBase *SysBase, struct DosLibrary *DOSBase)
{
	LONG   totlen, bfsize;
	struct fulist *fls;
	struct lister *fl, *nextfl;
	UBYTE  *buff, *bf, *p, *link, *endlink, *bfend;
	
	// get pointer to current listview
	if (!(fls = gcm->curlv) || !fls->ls) return (0);

	// get one of Gui4Cli's temporary buffers to work with
	bf = gcm->membuff[0];
	bfsize = gcm->buffsize; // buffer size
	bfend = &bf[bfsize-5];  // safe end of available buffer 
		
	// do the whole list..
	fl = (struct lister *)(fls->ls->lh_Head);
	while (nextfl = (struct lister *)(fl->node.ln_Succ))
	{
	   p = fl->start;
	   while (*p && (bf < bfend))
	   {
			// if it's a link copy out the title..
			if ((*p == '@') && (p[1] == '{'))
			{  p = &p[2];
		   	if (link = getlink(p, &endlink))
		   	{  while ((link < endlink) && (bf < bfend))
					{  *bf = *link;
			    		++bf; ++link;
					}	
					p = endlink;
		   	}
		   	// skip rest of link
		   	while (*p && (*p!='}')) ++p;
		   	++p;
			}
			else
			{  *bf = *p;
		   	++bf; ++p;
			}
	   }
	   *bf = '\0';	// null end..
	   totlen = bf - gcm->membuff[0]; // length of new buffer
	   bf = gcm->membuff[0]; // point to start again

	   // get the buffer we need.. (NOTE totlen + 1 - always!)
	   if (!(buff = (UBYTE *)AllocMem(totlen + 1, MEMF_CLEAR)))
	   {	PutStr ("No memory!\n");
	   	return (0);
	   }
	   strcpy (buff, bf);
	
	   // replace old line
	   FreeMem (fl->start, fl->length + 1); // note +1
	   fl->start  = buff;   
	   fl->length = totlen;
	
   	// store max line length
   	if (fls->maxlength < fl->length) fls->maxlength = fl->length;

	   // do next line..
	   fl = nextfl;
	}
	
	return (1); // ok..
}

// ==================================================================
//	scan a @{...} 
//	- if it's a link, return ptr to start of title, storing end
//	  in **end - if not, return null.
// ==================================================================

UBYTE *getlink (UBYTE *buff, UBYTE **end)
{
UBYTE *start, *link, *endlink, *nextpos;

if ((start = nextword (buff, end)) && *end)
{
   nextpos = *end;
   // if we stopped at a quote, advance..
   if ((*nextpos == '\'') || (*nextpos = '\"'))
	  ++nextpos;

   if ((link = nextword (nextpos, &endlink)) && endlink)
   {
		if ((agcomp(link, endlink, "LINK", "link")) ||
	    	(agcomp(link, endlink, "RX", "rx")) ||
	    	(agcomp(link, endlink, "RXS", "rxs")) ||
	    	(agcomp(link, endlink, "SYSTEM", "system")))
	   	// found link
	   	return (start);
   }
}
*end = NULL;
return (NULL);
}

// ==================================================================
//	Break out next word.
//	- return ptr to its start & store end in **next (or null both)
//	  note: if end is a quote ++end before repeated call
// ==================================================================

UBYTE *nextword (UBYTE *p, UBYTE **next)
{
	UBYTE *start, g;

	*next = NULL; // by default
	while (*p && ((*p==' ') || (*p=='\t') || (*p=='\n')))
	   ++p;
	start = p;

	while (*p)
	{  switch (*p)
	   {
		case ' ' :	// end of word
		case '\n' :
		case '\t' :
			*next = p;
			return (start);
			break;

		case '}' : // end of definition
			return (start);
			break;

		case '\'' :
		case '\"' :
			g = *p;
			++p;
			start = p;
			while (*p && (*p!=g)) ++p;
			if (!(*p)) return (NULL);
			*next = p;  // points to the quote !!
			return (start);
			break;
	   };
	   ++p;
	}
	// if we get here, we enqountered a null
	return (NULL);
}

// ==================================================================
//	compare from *start to *end for either *up or *dn buffers
//	- return success
// ==================================================================

BOOL agcomp(UBYTE *start, UBYTE *end, UBYTE *up, UBYTE *dn)
{
	while ((start < end) && *up && ((*start == *up) || (*start == *dn)))
	{  ++start; 
		++up; ++dn;
	}

	if ((start == end) && (!(*up))) return (1);
	return (0);
}



