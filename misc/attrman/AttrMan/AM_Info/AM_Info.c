/**************************************************************************************************
** AM_Info by Jeroen Massar
***************************************************************************************************
**
** History:
** 28.07.1996	36.0	- Created this proggie to show info about AttrMan.
** 11.08.1996	36.1	- Updated it to support ATTRMAN_Get_GlobalAttrStart.
** 15.08.1996	36.2	- Updated it to use the functions from AttrMan.h.
**			- Code is now 100% pure which means it is residentable.
**
**************************************************************************************************/
#define DEBUG_IT	0					/* defined = ON ,undefined = OFF */
#define DEBUG_WAIT	0					/* Waittime in 1/5th seconds */
#define NAME		"AM_Info"
#define CODER		"Jeroen Massar"
#define RELEASE		"1.0"
#define VER		"36.2"
#define VERSION		36
#define REVISION	2
#define DATE		"15.08.96"
#define COPYYEARS	"1996"

#define VERS		NAME" "VER
#define VSTRING		NAME" "VER" ("DATE")\r\n"
#define VERSTAG		"\0$VER: "NAME" "VER" ("DATE")"
#define RELSTAG		"\0$REL: "NAME" "RELEASE" ("VER") ("DATE") ©"COPYYEARS" by "CODER
#define COPYRIGHT	"Copyright ©"COPYYEARS" by "CODER

/**************************************************************************************************
** Includes
**************************************************************************************************/
#define ONE_GLOBAL_SECTION 1
#define USE_SYSBASE 1

#define REG(x) register __ ## x
#define SAVEDS __saveds
#define ASM __asm
#define REGARGS __regargs

/* Includes */
#include <exec/types.h>
#include <clib/alib_protos.h>
#include <clib/exec_protos.h>
#include <clib/dos_protos.h>
#include <pragmas/exec_pragmas.h>
#include <pragmas/dos_pragmas.h>
#include <exec/exec.h>
#include <intuition/intuition.h>

/**************************************************************************************************
** Shortcuts (define-style)
**************************************************************************************************/
#define CloseLib(base) {if (base) {CloseLibrary((struct Library *)base); base=NULL;}}
#define S(data) sizeof(struct data)

/**************************************************************************************************
** Protos
**************************************************************************************************/
ULONG Main(void);

/**************************************************************************************************
** Jump to main
**************************************************************************************************/
ULONG StartUp(void)
{
	return(Main());
}

/**************************************************************************************************
** Version/Revision Identifiers
**************************************************************************************************/
static const char VersionTag[]	= VERSTAG;
static const char ReleaseTag[]	= RELSTAG;
static const char Copyright[]	= COPYRIGHT;
static const char ProgName[]	= VERS;

/**************************************************************************************************
** Misc stuff
**************************************************************************************************/
/* Have to include it here as it includes code */
#define DEBUGNAME NAME														/* idname printed before string */
#include <Shorsha:cee/Debug.h>

#include <shorsha:cee/mymisc.h>
#include <AttrMan.h>

/**************************************************************************************************
** Main
**************************************************************************************************/
#define MAXDIGITS 8
ULONG Main(void)
{
	struct ExecBase		*SysBase;
	struct DOSLibrary	*DOSBase;
	ULONG			i,ret=RETURN_FAIL;
	struct AttrManSemaphore	*lock;
	struct Node		*nod;
	struct List		*list;

	SysBase=(*(struct ExecBase**)(4));
	if (DOSBase=(struct DOSLibrary *)OpenLibrary("dos.library",36))
	{
		PutStr("\x9b" "1m\x9b" "31m"NAME" "RELEASE"/" VER "\x9b" "0m ©" COPYYEARS " \x9b" "33m"CODER"\x9b" "0m\n");

		if (lock=AM_GetSem())
		{
			ret=RETURN_OK;
			Printf("This system is using : AttrMan %s/%ld.%ld (%s) by %s\n",lock->GetInfo(ATTRMAN_Get_Release),lock->GetInfo(ATTRMAN_Get_Version),lock->GetInfo(ATTRMAN_Get_Revision),lock->GetInfo(ATTRMAN_Get_Date),lock->GetInfo(ATTRMAN_Get_Coder));
			Printf("                       Global AttrStart: 0x%lx, ChunkSize: %ld\n",lock->GetInfo(ATTRMAN_Get_GlobalAttrStart),lock->GetInfo(ATTRMAN_Get_ChunkSize));
			if (i=lock->GetInfo(ATTRMAN_Get_Users))
			{
				Printf("The following ");
				if (i>1) Printf("%ld users are",i);
				else Printf("user is");
				Printf(" currently using AttrMan:\n");
				i=1;
				if (list=(struct List *)lock->GetInfo(ATTRMAN_Get_AllocList))
				{
					nod=list->lh_Head;
					Printf(",------+--------------------------------+------------+------------.\n");
					Printf("|  No  |              Name              |   Start    |    Size    |\n");
					Printf("|------+--------------------------------+------------+------------|\n");
					while ((nod)&&(nod!=(struct Node *)&list->lh_Tail))
					{
						Printf("| %4ld | %-30s | 0x%8lx | %10ld |\n",i,lock->UserInfo(ATTRMAN_Usr_Name,nod),lock->UserInfo(ATTRMAN_Usr_AllocStart,nod),lock->UserInfo(ATTRMAN_Usr_AllocSize,nod));
						nod=(struct Node *)nod->ln_Succ;
						i++;
					}
					Printf("`------+--------------------------------+------------+------------'\n");
				}
			}
			else Printf("There are currently no users.\n");
			AM_FreeSem(lock);
		}
		else
		{
			PutStr("Couldn't find AttrMan Semaphore called \""AttrManSemName"\"\nThis indicates that AttrMan is not running. Check your AttrMan documentation!\n");
		}
	}
	CloseLib(DOSBase);
	return(ret);
}
