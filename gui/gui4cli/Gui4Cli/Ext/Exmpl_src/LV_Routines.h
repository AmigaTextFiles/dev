
// ================================================================
// Delete all selected or unselected records - return success
// - fls - the fulist structure 
// - state - 0 = delete unselected, 1 = delete selected
// ================================================================
delselrec (struct fulist *fls, BOOL state)
{
	LONG del = 0;
	struct lister *fl, *nextfl;

	if (!fls || (!(fls->magic == MM_LISTVIEW))) return (0);

	fl = (struct lister *)fls->ls->lh_Head;
	while (nextfl = (struct lister *)(fl->node.ln_Succ))
	{
		if (fl->Selected == state)
		{
			// if it's the current record, null pointer
			if (fl == fls->curpt)
			{	fls->curpt = NULL;
				fls->line  = -1;
			}
			// remove node from list and free memory
			Remove	 (&fl->node);
			FreeMem (fl->start, (fl->length+1));
			FreeMem (fl, sizeof(struct lister));
			++del;
		}
		fl = nextfl;
	}
	// if the current record still exists, adjust it's line number
	if (fls->curpt)
		fls->line = findrecnum (fls, rec);

	return (1);
}

// ================================================================
// Delete a listview record - return success
// - will adjust the CURRENT Record pointer, remove the record
//	  from the list and free the relevant memory.
// ================================================================
delrec (struct lister *rec)
{
	struct fulist *fls;
	struct lister *r;
	LONG c;

	if (!rec || (!(fls = rec->fls))) return (0);

	// adjust pointers if this is the "current" record
	if (rec == fls->curpt)
	{	// if it's the 1st record, make next one current
		if (fls->curpt == (struct lister *)fls->ls->lh_Head)
			fls->curpt = (struct lister *)fls->curpt->node.ln_Succ;
		// otherwise, make previous one current
		else
		{	fls->curpt = (struct lister *)fls->curpt->node.ln_Pred;
			--fls->line;	// decrease current line number
		}
		// check if current record is still valid and null if not
		if (!fls->curpt || (fls->curpt == (struct lister *)fls->ls->lh_Tail))
		{	fls->curpt = NULL; 
			fls->line	= -1;	 
		}
	}
	// otherwise adjust the current line number
	else
	{	// find the record number
		if ((c = findrecnum(fls, rec)) < 0) return (0);
		// if rec is before the current record...
		if (c < fls->line) --fls->line;
	}

	// remove node from list and free memory
	Remove  (&rec->node);
	FreeMem (rec->start, (rec->length+1));
	FreeMem (rec, sizeof(struct lister));

	// decrease the total record counter
	--(fls->totnum);
}

// ================================================================
// Find a record - return it's line number or -1 if not found
// - rec = a pointer to the record
// - fls = a pointer to the parent fulist struct
// ================================================================
findrecnum (struct fulist *fls, struct lister *rec)
{
	LONG c = 0;
	struct lister *fl, *nextfl;

	fl = (struct lister *)fls->ls->lh_Head;
	while (nextfl = (struct lister *)(fl->node.ln_Succ))
	{	if (fl == rec) return (c);
		fl = nextfl;
		++c;
	}
	PutStr ("ERROR: Could not find record\n");
	return (-1);
}

// ================================================================
// Find a record by number - return record pointer or NULL
// - fls = the parent fulist structure
// - num = the number of the record we're looking for
// ================================================================
struct lister *findrec (struct fulist *fls, LONG num)
{
	struct lister *fl, *nextfl;
	register LONG c = 0;

	if (!fls) return (NULL);
	if ((num >= fls->totnum) || (num < 0))
	{	PutStr ("ERROR: Record out of range\n");
		return (NULL);
	}
	// loop to find the record..
	fl = (struct lister *)(fls->ls->lh_Head);
	while (nextfl = (struct lister *)(fl->node.ln_Succ))
	{	if (c == num) return (fl);
		fl = nextfl;
		++c;
	}
	return (NULL);
}


// ==============================================================
//		  - Allocate & initialise a new List structure
// ==============================================================
// prototype needed
void NewList (struct List *list);

struct List *getlist (void)
{
	struct List *ls;

	if (!(ls = (struct List *)AllocMem(sizeof(struct List), MEMF_CLEAR))) 
		 return (NULL);
	NewList (ls);
	return (ls);
}


