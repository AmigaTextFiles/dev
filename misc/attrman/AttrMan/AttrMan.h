#include <exec/exec.h>
#include <utility/tagitem.h>

struct AttrManSemaphore
{
	struct SignalSemaphore	Sem;
	APTR			Private;
	ASM ULONG		(*AllocAttr)	(REG(d0) ULONG size, REG(a0) const char *owner);
	ASM void		(*FreeAttr)	(REG(d0) ULONG start);
	ASM ULONG		(*GetAttrSize)	(REG(d0) ULONG start);
	ASM ULONG		(*GetInfo)	(REG(d0) ULONG what);
	ASM ULONG		(*UserInfo)	(REG(d0) ULONG what, REG(a0) struct Node *user);
};

/* Values for GetInfo What */
enum {	ATTRMAN_Get_Release=0,		/* v36 const char *	Release TxT (1.0) */
	ATTRMAN_Get_Version,		/* v36 ULONG		Version number (36.x) */
	ATTRMAN_Get_Revision,		/* v36 ULONG		Revision text (xx.1) */
	ATTRMAN_Get_Date,		/* v36 const char *	Release Date */
	ATTRMAN_Get_Coder,		/* v36 const char *	Coder Name */
	ATTRMAN_Get_Users,		/* v36 ULONG		Number of users */
	ATTRMAN_Get_ChunkSize,		/* v36 ULONG		ChunkSize set by chunksize argument */
	ATTRMAN_Get_AllocList,		/* v36 struct List *	Users */
					/*			Names are in ln_Name of each Node. */
					/*			Get info with UserInfo(user,what). */
	ATTRMAN_Get_GlobalAttrStart,	/* v36 ULONG		Global AttrStart. */
	};

/* Values for UserInfo What */
enum {	ATTRMAN_Usr_Name=0,		/* const char *		Name */
	ATTRMAN_Usr_AllocStart,		/* ULONG		Start of Allocated Area */
	ATTRMAN_Usr_AllocSize,		/* ULONG		Allocated Size */
	};

#define AttrManSemName "« AttrMan »"

/* Library Classes should use the following method in their dispatcher
   to allow applications to call it in order to get the AttrStart value
   by using attrstart=DoMethod(obj,OM_AttrStart) which should return your
   AttrStart value. You should also be prepared to receive this when there
   is no object (yet) like GM_DOMAIN, allowing the caller to set values at
   init time. */
#define OM_ATTRSTART OM_Dummy

/*
** Some handy shortcuts for use with AttrMan.
** You should use these or a similar version.
*/
struct AttrManSemaphore *AM_GetSem(void);
#define AM_FreeSem(lock) ReleaseSemaphore((struct SignalSemaphore *)lock);
ULONG AM_AllocAttr(ULONG size,const char *owner);
void AM_FreeAttr(ULONG start);
ULONG AM_GetAttrStart(const char *owner);

struct AttrManSemaphore *AM_GetSem(void)
{
	struct ExecBase *SysBase=(*(struct ExecBase**)(4));
	struct SignalSemaphore *lock;
	Forbid();
	if (lock=(struct AttrManSemaphore *)FindSemaphore((char *)AttrManSemName))
	{
		ObtainSemaphore(lock);
	}
	Permit();
	return((struct AttrManSemaphore *)lock);
}

ULONG AM_AllocAttr(ULONG size,const char *owner)
{
	struct ExecBase *SysBase=(*(struct ExecBase**)(4));
	struct AttrManSemaphore *lock;
	ULONG ret;
	if (lock=AM_GetSem())
	{
		ret=lock->AllocAttr(size,owner);
		AM_FreeSem(lock);
	}
	else ret=TAG_USER;
	return(ret);
}

void AM_FreeAttr(ULONG start)
{
	struct ExecBase *SysBase=(*(struct ExecBase**)(4));
	struct AttrManSemaphore *lock;
	if (lock=AM_GetSem())
	{
		lock->FreeAttr(start);
		AM_FreeSem(lock);
	}
}

/* This should be used when you want to know an users AttrStart
   nut there is no supplied way of getting it from the user. */
ULONG AM_GetAttrStart(const char *owner)
{
	struct ExecBase *SysBase=(*(struct ExecBase**)(4));
	struct AttrManSemaphore *lock;
	struct List *list;
	struct Node *user;
	ULONG ret=TAG_USER;
	if (lock=AM_GetSem())
	{
		if (list=(struct List *)lock->GetInfo(ATTRMAN_Get_AllocList))
		{
			for (user=list->lh_Head;user&&(user!=(struct Node *)&list->lh_Tail)&&(strcmp((char *)lock->UserInfo(ATTRMAN_Usr_Name,user),(char *)owner)!=0);user=(struct Node *)user->ln_Succ);
			if (user) ret=lock->UserInfo(ATTRMAN_Usr_AllocStart,user);
		}
		AM_FreeSem(lock);
	}
	return(ret);
}