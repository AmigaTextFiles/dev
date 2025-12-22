/*
	·C·O·D·E·X· ·D·E·S·I·G·N· ·S·O·F·T·W·A·R·E·
	presents

	Palis

	FILE:	setman.c
	TASK:	the kernel....

	(c)1995 by Hans Bühler
*/

#include	"pl.h"

// ---------------------------
// defines
// ---------------------------

// for plPatch->_Cookie_
#define	MAGIC_COOKIE		0x4ef9	// assembly long jump code !! * DO NOT CHANGE *

// 
#define	ERR_NONE				0
#define	ERR_NOLIBNODE		1			// the following are assumed to be out-of-memory-errors
#define	ERR_NOOFFNODE		2			// ""
#define	ERR_NOPATCHNODE	3			// ""

// offset patched by this prog
#define	SETFUNC_OFF			-420		// exec/SetFunction()

// ??
#define	BUFLEN				31

// ---------------------------
// datatypes
// ---------------------------

// ---------------------------
// proto
// ---------------------------

extern __asm APTR _JUMPTOOLD(register __a1 struct Library *lib, register __a0 WORD off, register __d0 APTR func, register __a2 APTR oldFunc);

static APTR ErrorOff(struct Library *userLib, WORD userOff, APTR userEntry);
static struct plLib *GetLibNode(struct Library *lib);
static struct plOffset *GetOffNode(struct plLib *libNode, WORD off);
static struct plPatch *GetPatchNode(struct plOffset *offNode, APTR entry);
static struct plLib *MakeLibNode(struct Library *lib);
static struct plOffset *MakeOffNode(struct plLib *libNode, WORD off);
static struct plPatch *MakePatchNode(struct plOffset *offNode, APTR patchFunc);
static void RemPatches(struct plPatch *pNode);

// ---------------------------
// vars
// --------------------------- 

struct plBase		plBase;					// basic structure !!!!!!!!!!
static BOOL			SemAdded			=	FALSE;

static APTR			OldSetFunc		=	0;

static char			*OutOfMemPName	=	"[no memory for taskname]";

// ---------------------------
// funx: manage SetFunction()
// ---------------------------

/*********************************************************
 * Here's what I'm talking of: my new setfunction() !!!	*
 * -----------------------------------------------------	*
 * NOTE: There's a little problem if I cannot allocate	*
 * memory for a new patch (see below).							*
 * Up to now, in that case I just use the old SetFunc()	*
 * and everything as it was before.								*
 * Additionally, an error msg is sent to the main task	*
 * which will inform the user...									*
 *********************************************************/

__asm __saveds __interrupt MySetFunction(register __a1 struct Library *userLib, register __a0 WORD userOff, register __d0 APTR userEntry)
{
	struct plLib		*libNode;
	struct plOffset	*offNode;
	struct plPatch		*patch,*next;
	APTR					retFunc;
	BOOL					ok;

	// -- avoid access conflicts --

	ObtainSemaphore(&plBase.Sem);

	// -- first look whether we had a patch here before... --

	offNode	=	0;
	patch		=	0;

	if((libNode = GetLibNode(userLib)) &&
		(offNode = GetOffNode(libNode,userOff)) &&
		(patch	= GetPatchNode(offNode,userEntry)) )
	{
		// -- program wants to remove an old patch... --

		next		=	(struct plPatch *)patch->Node.mln_Succ;
		retFunc	=	patch->PatchFunc;

		if(next->Node.mln_Succ)			// is there a follower ?
		{
			patch->PatchFunc		=	patch->OldFunc;
													// now, this patcher will only call
													// its old function
			patch->OldFunc			=	0;
		}
		else
		{
			ok	=	FALSE;

			for(	next = (struct plPatch *)patch->Node.mln_Pred;
					next->Node.mln_Pred;
					next = (struct plPatch *)next->Node.mln_Pred)
			{
				if(next->OldFunc)
				{
					ok	=	TRUE;
					break;
				}
			}

			if(!ok)							// -- all patches might be removed now ! --
			{
				_JUMPTOOLD(userLib,userOff,offNode->OriginalFunc,OldSetFunc);
				RemPatches((struct plPatch *)next->Node.mln_Succ);		// rem all I donnot need anymore
			}
			else
			{
				_JUMPTOOLD(userLib,userOff,&next->_Cookie_,OldSetFunc);
				RemPatches((struct plPatch *)next->Node.mln_Succ);		// here, next points to *plBase !!!
			}
		}
	}
	else
	{
		// -- program wants to install a new patch... --

		// -- chk if there've been errors --

		if(plBase.LowMemErr)			/* old error status... */
		{
			ReleaseSemaphore(&plBase.Sem);
			return _JUMPTOOLD(userLib,userOff,userEntry,OldSetFunc);			// EMERGENCY EXIT
		}

		// -- get new memory --

		if(!libNode)
			if(!( libNode = MakeLibNode(userLib) ))
			{
				return ErrorOff(userLib,userOff,userEntry);		// EMERGENCY EXIT ! (see func)
			}

		if(!offNode)
			if(!( offNode = MakeOffNode(libNode,userOff) ))
			{
				return ErrorOff(userLib,userOff,userEntry);		// EMERGENCY EXIT ! (see func)
			}

		if(!( patch = MakePatchNode(offNode,userEntry) ))
		{
			return ErrorOff(userLib,userOff,userEntry);		// EMERGENCY EXIT ! (see func)
		}

		// -- set new function (more clearly: set my function jumping into new ;-) --

		patch->OldFunc	=	_JUMPTOOLD(userLib,userOff,&patch->_Cookie_,OldSetFunc);

		if(!offNode->OriginalFunc)
			offNode->OriginalFunc	=	patch->OldFunc;				// then, it was the first !!

		retFunc	=	patch->OldFunc;
	}

	// -- job done that far --

	ReleaseSemaphore(&plBase.Sem);

	return retFunc;
}

/***************************************************************
 * This func will be called if prog was not able to allocate	*
 * memory for a new patch.													*
 * NOTES:	1)	A message is sent to main process to say user	*
 *					what happened												*
 *				2)	New function is set via old SetFunction().		*
 *					Now, new patches won't be tracked !					*
 *				3)	All old patch-routines remain in memory.			*
 *					These patches might be removed savely.				*
 ***************************************************************/

static APTR ErrorOff(struct Library *userLib, WORD userOff, APTR userEntry)
{
	plBase.LowMemErr	=	TRUE;			// ough !
	ReleaseSemaphore(&plBase.Sem);

	return _JUMPTOOLD(userLib,userOff,userEntry,OldSetFunc);			// EMERGENCY EXIT
}

// ---------------------------
// funx: find nodes
// ---------------------------

/******************
 * find a libnode *
 ******************/

static struct plLib *GetLibNode(struct Library *lib)
{
	struct plLib	*libNode;

	for(	libNode = (struct plLib *)plBase.LibList.mlh_Head;
			libNode->Node.mln_Succ;
			libNode = (struct plLib *)libNode->Node.mln_Succ)
	{
		if(lib == libNode->Lib)
			return libNode;
	}

	return 0;
}

/******************
 * find a offnode *
 ******************/

static struct plOffset *GetOffNode(struct plLib *libNode, WORD off)
{
	struct plOffset	*offNode;

	for(	offNode = (struct plOffset *)libNode->OffList.mlh_Head;
			offNode->Node.mln_Succ;
			offNode = (struct plOffset *)offNode->Node.mln_Succ)
	{
		if(off == offNode->Offset)
			return offNode;
	}

	return 0;
}

/****************
 * find a patch *
 ****************/

static struct plPatch *GetPatchNode(struct plOffset *offNode, APTR entry)
{
	struct plPatch	*pNode;

	for(	pNode = (struct plPatch *)offNode->PatchList.mlh_Head;
			pNode->Node.mln_Succ;
			pNode = (struct plPatch *)pNode->Node.mln_Succ)
	{
		if(pNode->OldFunc && (entry == pNode->OldFunc))
			return pNode;
	}

	return 0;
}

// ---------------------------
// funx: mk new node
// ---------------------------

/*************************
 * create a new lib node *
 *************************/

static struct plLib *MakeLibNode(struct Library *lib)
{
	struct plLib	*libNode;

	if(!( libNode = AllocVec(sizeof(struct plLib), MEMF_PUBLIC|MEMF_CLEAR) ))
		return 0;

	libNode->Lib	=	lib;

	InitEmptyList(&libNode->OffList);
	libNode->OffCnt			=	0;

	AddTail((struct List *)&plBase.LibList,(struct Node *)libNode);
	plBase.LibCnt++;

	return libNode;
}

/*********************
 * make new off node *
 *********************/

static struct plOffset *MakeOffNode(struct plLib *libNode, WORD off)
{
	struct plOffset	*offNode,*prec;

	if(!libNode ||
		!( offNode = AllocVec(sizeof(struct plOffset), MEMF_PUBLIC|MEMF_CLEAR)) )
		return 0;

	offNode->Offset			=	off;
	offNode->plLib				=	libNode;

	InitEmptyList(&offNode->PatchList);
	offNode->PatchCnt			=	0;

	// -- find node after which we want our new patch to be installed --

	for(	prec = (struct plOffset *)libNode->OffList.mlh_TailPred;
			prec->Node.mln_Pred;
			prec = (struct plOffset *)prec->Node.mln_Pred)
	{
		if(prec->Offset > off)
			break;
	}

	if(!prec->Node.mln_Pred)			// prec is minlist...
		prec	=	0;							// add head !

	Insert((struct List *)&libNode->OffList,(struct Node *)offNode,(struct Node *)prec);

	libNode->OffCnt++;

	return offNode;
}

/***************************
 * generate new patch node *
 ***************************/

static struct plPatch *MakePatchNode(struct plOffset *offNode, APTR patchFunc)
{
	struct plPatch	*pNode;
	struct Task		*thisTask;
	char				*pName;
	char				buf[BUFLEN+1];

	if(!offNode ||
		!(pNode = AllocVec(sizeof(struct plPatch), MEMF_PUBLIC|MEMF_CLEAR)) )
		return 0;

	pNode->_Cookie_		=	MAGIC_COOKIE;				// assembly 'jmp'
	pNode->PatchFunc		=	patchFunc;
	pNode->plOffset		=	offNode;

	thisTask	=	SysBase->ThisTask;
	pName		=	0;

	if((thisTask->tc_Node.ln_Type == NT_PROCESS) &&
		((struct Process *)thisTask)->pr_TaskNum )
	{
		if(GetProgramName(buf,BUFLEN) && buf[0])
			pName	=	buf;
	}

	if(!pName)
		pName	=	thisTask->tc_Node.ln_Name;

	if( pNode->ProcName = AllocVec(strlen(pName)+1, MEMF_PUBLIC) )
		strcpy(pNode->ProcName,pName);
	else
		pNode->ProcName	=	OutOfMemPName;

	AddTail((struct List *)&offNode->PatchList,(struct Node *)pNode);
	offNode->PatchCnt++;
	plBase.PatchCnt++;

	return pNode;
}

// ---------------------------
// funx: remove unused nodes
// ---------------------------

/*********************************************************
 * remove a patch node and, if needed, all other nodes	*
 *********************************************************/

static void RemPatches(struct plPatch *pNode)
{
	struct plPatch		*next;
	struct plOffset	*offNode;
	struct plLib		*plLib;

	if(!pNode)
		return;

	if(plBase.LowMemErr)
		return;						/* won't be save to do that, then... */

	// -- remove all nodes not needed from plOffset --

	offNode	=	pNode->plOffset;

	while(next = (struct plPatch *)pNode->Node.mln_Succ)
	{
		Remove((struct Node *)pNode);
		offNode->PatchCnt--;
		plBase.PatchCnt--;
		if(pNode->ProcName != OutOfMemPName)
			FreeVec(pNode->ProcName);
		FreeVec(pNode);

		pNode	=	next;
	}

	// -- remove offset and check whether we need plLib anymore --

	if(!offNode->PatchCnt)
	{
		plLib	=	offNode->plLib;

		Remove((struct Node *)offNode);
		FreeVec(offNode);

		if(!--plLib->OffCnt)
		{
			Remove((struct Node *)plLib);
			plBase.LibCnt--;
			FreeVec(plLib);
		}
	}
}

// ---------------------------
// funx: init/rem
// ---------------------------

/*************************
 * patch exec.library... *
 *************************/

BOOL InitMyFunc(void)
{
	InitEmptyList(&plBase.LibList);

	plBase.Sem.ss_Link.ln_Name	=	PALIS_SEMAPHORE_NAME;
	plBase.Sem.ss_Link.ln_Pri	=	0;

	plBase.LibCnt		=	0;
	plBase.PatchCnt	=	0;
	plBase.LowMemErr	=	FALSE;
	plBase.Version		=	PALIS_VERSION;

	AddSemaphore(&plBase.Sem);
	SemAdded		=	TRUE;

	OldSetFunc	=	SetFunction((struct Library *)SysBase,SETFUNC_OFF,(APTR)MySetFunction);
}

/************************************************************
 * unpatch exec.															*
 * I assume that SetFunction() is _not_ been patched since	*
 * quitting this prog will only work if no more patches		*
 * (that is to say patches to SetFunction(), too) are known.*
 * I may change some things here in future... ;=(				*
 ************************************************************/

void RemMyFunc(void)
{
	// -- remove old function --

	if(OldSetFunc)
	{
		_JUMPTOOLD((struct Library *)SysBase,SETFUNC_OFF,OldSetFunc,OldSetFunc);

		Delay(2);			// wait till any task left my SetFunc()
								// (new calls will go for the old SetFunction..,
								// current calls will at any time use ObtainSemaphore()
		ObtainSemaphore(&plBase.Sem);
	}

	if(SemAdded)
		RemSemaphore(&plBase.Sem);

	/*
		aufräumen ist nicht, da die evtl. noch vorhanden patches u.U.
		noch angesprungen werden... ;/(
	*/
}
