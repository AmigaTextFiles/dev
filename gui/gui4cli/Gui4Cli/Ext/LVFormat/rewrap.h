
// ==============================================================
// Rewrap a listview
// - construct a new list with the line lengths wanted and
//	  replace & kill the old one.
// gcm	 = struct *GCmain (from where we get the lv pointer)
// length = the new line length wanted
// hdchars = the chars which will be considered as header
// justmode = 1=justify, 2=unjustijy, 3=center, 0=leave alone
// ==============================================================

rewrap (struct GCmain *gcm, LONG length, UBYTE *hdchars, SHORT justmode,
	struct ExecBase *SysBase, struct DosLibrary *DOSBase)
{
	LONG	 lh=0, c=0, lastc=0;
	struct List	  *ls, *lst;
	struct fulist *fls;
	struct lister *fl, *nextfl;
	UBYTE	 *buff, *p, *b, *lastp, *lastb;
	UBYTE	 *head, *h, *jbf;
	BOOL	 just=0, unjust=0, center=0, reset=0, flag=0;

	// get pointer to current listview
	if (!(fls = gcm->curlv) || !fls->ls || IsListEmpty(fls->ls)) 
		 return (0);
	
	// get working buffers, check they're long enough
	if (gcm->buffsize < (length - 2)) return (0);
	buff = gcm->membuff[0];
	head = gcm->membuff[1]; // for line header
	jbf  = gcm->membuff[2]; // for justification

	// set justify flags
	if		  (justmode == 1) { just=1; unjust=1; }
	else if (justmode == 2) unjust=1;
	else if (justmode == 3) { center=1; unjust=1; } 
	else if (justmode == 4) { reset=1; unjust=1; }

	// prepare a new list struct
	if (!(lst = getlist(SysBase, DOSBase))) return (0);
	// unattach old list - attach new
	ls = fls->ls; fls->ls = lst;
	fls->maxlength = fls->maxnow = fls->totnum = 0;
	fls->curpt = NULL; fls->line	= -1;

	fl = (struct lister *)(ls->lh_Head); // point to 1st rec

	// skip any blank lines at beginning
	while ((nextfl = (struct lister *)(fl->node.ln_Succ)) && !flag)
	{	 if (fl->start[0] == '\0')
		 {		addline (fls, "", 0, SysBase, DOSBase);
				fl = nextfl;
		 }
		 else flag = 1;
	}

	// get 1st leading indent
	p = lastp = fl->start;
	for (lh=0, h=head; (lh<length) && *p && ((*p==' ') || isin(*p, hdchars)); ++p, ++h, ++lh)
		 *h = *p;
	*h = '\0';
	if (reset)	
	{	 c=0;	 *buff='\0';  b=lastb=buff;	}
	else
	{	 c=lh; strcpy (buff, head);
		 b = lastb = &buff[lh];
	}

	// do the whole list..
	while (nextfl = (struct lister *)(fl->node.ln_Succ))
	{
		while (*p)
		{
			// mark last space or line breakable char encountered
			if (*p==' ')
			{
				if (unjust)	 // delete spaces if unjust on
				{	while (p[1]==' ') ++p;
					if (b==buff) ++p; // if at the start of a line..
				}
				lastp = p;
				lastb = b;
				lastc = c;
			}

			// copy char
			*b = *p;
			++b; ++p; ++c;
			 
			// if we're over the length, change line..
			if (c >= length)
			{
				  if (lastb == &buff[lh])	 // line unbroken - force break
				  {  lastp = p;
					  lastc = c;
					  lastb = b;
				  }
				  else
				p = lastp;
				
				// if (*p == ' ') ++p;
				while (*p==' ') ++p;
				*lastb = '\0';

				// if justify is on..
				if (just)
				{	c = justify (buff, &buff[lh], jbf, length, SysBase, DOSBase);
					addline (fls, jbf, c, SysBase, DOSBase);
				}
				else if (center)
				{	c = centertxt (buff, &buff[lh], jbf, length, SysBase, DOSBase);
					addline (fls, jbf, c, SysBase, DOSBase);
				}
				else
					addline (fls, buff, lastc, SysBase, DOSBase);

				// reinitiate line head buffer
				if (reset)
				{	 c=0; *buff='\0'; b=lastb=buff; }
				else
				{	 strcpy (buff, head);
					 b = lastb = &buff[lh];
				 	c = lh;
				}
			
			}	 // end of new line handling

		}	 // end of while (*p)

		// (!*p) == end of line..

		if (!nextfl->node.ln_Succ)					  // end of file
		{
			 *b = '\0';
			 if (center)
			 {	 c = centertxt (buff, &buff[lh], jbf, length, SysBase, DOSBase);
		  		 addline (fls, jbf, c, SysBase, DOSBase);
			 }
			 else 
				 addline (fls, buff, c, SysBase, DOSBase);
			 goto endwrap;
		}
		else if (nextfl->start[0] == '\0')		  // a paragraph..
		{
			 *b = '\0';
			 if (center)
			 {	 c = centertxt (buff, &buff[lh], jbf, length, SysBase, DOSBase);
		  		 addline (fls, jbf, c, SysBase, DOSBase);
			 }
			 else 
		  		 addline (fls, buff, c, SysBase, DOSBase);

			 fl = nextfl;
			 nextfl = (struct lister *)(fl->node.ln_Succ);
			 // add a blank line
			 addline (fls, "", 0, SysBase, DOSBase);
			 // goto next line..
			 fl = nextfl;

			 // reinitiate head buffer
			 p = lastp = fl->start;
			 for (lh=0, h=head; (lh<length) && *p && ((*p==' ') || isin(*p, hdchars)); ++p, ++h, ++lh)
				  *h = *p;
			 *h = '\0';
			 if (reset)	 
			 {	  c=0;  *buff='\0';	b=lastb=buff;	 }
			 else
			 {	  c=lh; strcpy (buff, head);
				  b = lastb = &buff[lh];
			 }
		}
		// otherwise skip it
		else 
		{	 fl = nextfl;
			 // reinitiate head buffer
			 p = lastp = fl->start;
			 for (lh=0, h=head; (lh<length) && *p && ((*p==' ') || isin(*p, hdchars)); p++, h++, lh++)
				  *h = *p;
			 *h = '\0';
			 *b = ' ';		// insert a space at line end
			 lastb = b;
			 lastc = c;
			 ++b; ++c; 
		}

	}	// end of main while loop

	endwrap:
	// our new list is ready - free the old one
	freelist (ls, SysBase, DOSBase);

	return (1); // ok..
}

// ==============================================================
// do justify
// Justify *str into *buff which should become length long
// hdrend is the end of the line header
// ==============================================================
LONG justify (UBYTE *str, UBYTE *hdrend, UBYTE *buff, LONG length,
			struct ExecBase *SysBase, struct DosLibrary *DOSBase)
{
	LONG spaces, len=0, add=0, fill, c, step=0, stepcount=0, bal=0;
	UBYTE *p, *buffstart;
	buffstart = buff;

	// count spaces in str & it's length
	for (p=str; *p && (p < hdrend); ++p, ++len); // go past header
	for (spaces=0; *p; ++p, ++len) if (*p==' ') ++spaces;

	// the number of characters we have to add
	fill = length - len;
	if (spaces) 
	{	// num of spaces to add to each space (probably 0)
		add = fill / spaces;
		// also add a space every <step> chars
		bal = fill - (spaces * add); // how many chars left
		if (bal)
			step = spaces / bal;	 // add space every step chars
	}

	while (*str)
	{	 if ((*str == ' ') && (str > hdrend))
		 {
			 *buff = ' ';
			 ++buff;
			 for (c=0; c<add; ++c) {  *buff=' '; ++buff; }
			 ++stepcount;
			 if ((stepcount == step) && bal)
			 {	 *buff=' '; ++buff;
				 stepcount = 0;
				 --bal;
			 }
		 }
		 else 
		 {	 *buff=*str; 
			 ++buff;
		 }
		 ++str;
	}
	*buff = '\0';
	return ((LONG)(buff - buffstart));
}


// ==============================================================
// Center text
// Center *str into *buff for a line length long
// hdrend is the end of the line header
// ==============================================================
LONG centertxt (UBYTE *str, UBYTE *hdrend, UBYTE *buff, LONG length,
			struct ExecBase *SysBase, struct DosLibrary *DOSBase)
{
	LONG	linelen, actlen, addlen, hdrlen;
	UBYTE *p, *b;

	hdrlen = (LONG)(hdrend - str);
	linelen = length - hdrlen;
	actlen  = strlen(str) - hdrlen;
	addlen  = (linelen - actlen) / 2; // the No of spaces to be added each side

	b = buff;
	while (str < hdrend)		// copy header
	{	 *b = *str;
		 ++b; ++str;
	}
	while (addlen)				// copy left spaces
	{	 *b=' ';	 ++b;
		 --addlen;
	}
	while (*str)				// copy the text
	{	 *b = *str;
		 ++b; ++str;
	}
	*b = '\0';
	return ((LONG)(b - buff));
}



