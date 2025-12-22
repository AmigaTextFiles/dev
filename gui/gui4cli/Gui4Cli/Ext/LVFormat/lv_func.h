
// ==============================================================
//	- Allocate & initialise a new List structure
// ==============================================================
// prototype needed
void NewList (struct List *list);

struct List *getlist (struct ExecBase *SysBase, struct DosLibrary *DOSBase)
{
	struct List *ls;

	if (!(ls = (struct List *)AllocMem(sizeof(struct List), MEMF_CLEAR))) 
	    return (NULL);
	NewList (ls);
	return (ls);
}

// ==============================================================
//	- Free a lister List - return success
// ==============================================================
freelist (struct List *xls,
	  struct ExecBase *SysBase, struct DosLibrary *DOSBase)
{
	struct lister *ls, *nextls;

	// return if it's an empty list
	if (IsListEmpty(xls)) return (0);

	// free the records
	ls = (struct lister *)(xls->lh_Head);
	while (nextls = (struct lister *)(ls->node.ln_Succ))
	{
	   FreeMem (ls->start, (ls->length+1));
	   FreeMem (ls, sizeof(struct lister));
	   ls = nextls;
	}

	FreeMem (xls, sizeof (struct List));
	return (1);
}

// ==============================================================
//	- Add line to list - return success
//	fls  = the fulist structure to add the line to
//	buff = the line to add
//	len  = it's strlen()
// ==============================================================
addline (struct fulist *fls, UBYTE *buff, LONG len,
	 struct ExecBase *SysBase, struct DosLibrary *DOSBase)
{
	struct lister *lstr;

	if ((!fls) || (!fls->ls)) return (0);

	if (lstr = getlister (buff, len, SysBase, DOSBase))
	{   // adjust fulist & pointers & add
	    lstr->fls = fls;
	    AddTail ((struct List *)fls->ls, (struct Node *)lstr);
	    ++fls->totnum;
	    return (1);
	}
	return (0); 
}

// ==============================================================
//	Allocate & initialise a lister structure
//	- buff - the line contents
//	- len  - strlen(buff)
//	NOTE : the lstr->fls field is not set!!
// ==============================================================
struct lister *getlister (UBYTE *buff, LONG len,
	      struct ExecBase *SysBase, struct DosLibrary *DOSBase)
{
	struct lister *lstr;

	if ((lstr = (struct lister *)AllocMem(sizeof (struct lister), MEMF_CLEAR)))
	{  if ((lstr->start = (UBYTE *)AllocMem(len+1, MEMF_CLEAR)))
	   {
	      strcpy (lstr->start, buff);
	      lstr->length = len;
	      lstr->node.ln_Name = lstr->start;  // start of visible text
	      lstr->node.ln_Type = 100;
	      lstr->type         = 5;     // normal "file" type
	   }
	   else
	   {  FreeMem (lstr, sizeof (struct lister));
	      return (NULL);
	   }
	}
	else return (NULL);
	return (lstr);
}









