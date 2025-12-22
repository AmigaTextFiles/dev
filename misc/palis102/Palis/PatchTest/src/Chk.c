/*
	·C·O·D·E·X· ·D·E·S·I·G·N· ·S·O·F·T·W·A·R·E·
	presents

	TestPatch

	this program will check whether library patching is observed by
	a PatchManager like SaferPatches or PALIS.
	returns appropiate codes to the caller.

	FILE:	Chk.c
	TASK:	all stuff... ;-)

	(c)1996 by Hans Bühler, codex@stern.mathematik.hu-berlin.de
*/

#include	"chk.h"
#include	<stdio.h>

// ---------------------------
// defines
// ---------------------------

#define	ARG_LIB			0
#define	ARG_OFF			1
#define	ARG_QUIET		2
#define	ARG_NUM			3

#define	BUFLEN			512

#define	GET_LIB			((char *)Array[ARG_LIB])
#define	GET_OFF			(*((LONG *)Array[ARG_OFF]))
#define	GET_QUIET		((BOOL)Array[ARG_QUIET])

#define	errprintf			if(!GET_QUIET)	\
										printf(

#define	JMP_CODE				0x4ef9

// ---------------------------
// datatypes
// ---------------------------

struct Func
	{
		UWORD	Jmp;
		APTR	OldFunc;
	};

// ---------------------------
// proto
// ---------------------------

extern int main(int argc, char **argp);

// ---------------------------
// vars
// ---------------------------

struct RDArgs
	*OwnArgs			=	0,
	*Args				=	0;

static char
	*Template		=	"LIB=LIBRARY/A,OFF=OFFSET/N/A,QUIET/S";

ULONG
	Array[ARG_NUM]	=	{	0,
								0,
								FALSE
							};

static char
	*InfoTxt	=	PROGNAME_FULL " by Hans Bühler, Codex Design Software:\n"
					"\n"
					"This program tests whether patching libraries is observed\n"
					"by any patch manager as SaferPatches etc.\n"
					"\n\x9b" "2;32;41m"
					"+------------------------------------------------------+\n"
					"| WARNING : Misuse of this program will for sure crash |\n"
					"| your computer !                                      |\n"
					"| Note that the author cannot be held liable for _any_ |\n"
					"| damage caused by the use or misuse of this program ! |\n"
					"+------------------------------------------------------+\n"
					"\x9b" "0m\n"
					"LIBRARY¹ : Name of library to patch for a test.\n"
					"OFFSET/N¹: Function offset to patch for a test.\n"
					"QUIET    : No output.\n"
					"\n"
					" ¹: Please note " LIBNAME " which might be used without\n"
					"    causing problems.\n"
					"\n"
					"This program comes along with the dev/misc/palis archive.\n"
					"It and its source is freeware ;^)\n"
					"\n"
					" [<Hans Bühler>:codex@stern.mathematik.hu-berlin.de]\n",
	*WarnTxt	=	"\n"
					"\x9b" "2;32;41m"
					"+----------------------------------------------------+\n"
					"| WARNING: This program is for _expert_ users only ! |\n"
					"|          It will perform  risky operations in your |\n"
					"|          system thus PLEASE read the manual before |\n"
					"|          continuing !                              |\n"
					"| Type '?' twice to receive short information.       |\n"
					"+----------------------------------------------------+\n"
					"\x9b" "0m\n"
					"Are you sure you want to continue [n]: ",
	*ErrHeader=	PROGNAME " error: ";

static struct Func
	Func1	=	{
					JMP_CODE,
					0
				},
	Func2	=	{
					JMP_CODE,
					0
				};

// ---------------------------
// funx: job...
// ---------------------------

static int ChkPatch(void)
{
	APTR				dummy;
	struct Library	*lib;
	int				ret;

	errprintf "Opening library '%s'... ",GET_LIB);

	if(!( lib = OpenLibrary(GET_LIB,0) ))
	{
		errprintf "FAILED !\n");
		return RETURN_FAIL;
	}

	errprintf "okay.\n");

	if(!GET_QUIET)
	{
		char	c;

		printf(PROGNAME " will now install 2 patches to '%s/%ld'\n"
				 " and will then try to remove them in reverse order.\n"
				 " Is that okay for you [n]: ",GET_LIB,GET_OFF);

		scanf("%c",&c);fflush(stdin);

		if((c | ' ') != 'y')
		{
			CloseLibrary(lib);
			return RETURN_FAIL;
		}
	}

	errprintf "Okay. Operation starts now... ");

	Forbid();

	Func1.OldFunc	=	SetFunction(lib,GET_OFF,(APTR)&Func1.Jmp);
	Func2.OldFunc	=	SetFunction(lib,GET_OFF,(APTR)&Func2.Jmp);		// == &Func1

	dummy				=	SetFunction(lib,GET_OFF,Func1.OldFunc);

	if(dummy != &Func1.Jmp)			// no mamanger ! ;-(
	{
		// we don't have to care about the original function since
		// we replaced right this into the library.
		// therefore we are out and everything is fine ;^>

		ret	=	RETURN_WARN;
	}
	else
	{
		// well, it seems there's a manager. Therefore we will
		// remove our second function and everything will be cleared
		// up.

		SetFunction(lib,GET_OFF,Func2.OldFunc);

		ret	=	RETURN_OK;
	}

	Permit();

	if(!GET_QUIET)
	{
		printf("done.\n\nStatus: ");
		if(ret == RETURN_OK)
			puts("\x9b" "2mAll right !\x9b" "0m\n"
				  "------- It seems there's any manager taking care of you ;-)\n");
		else
			puts("\x9b" "2mNO PATCH MANAGER FOUND !\x9b" "0m\n"
				  "------- Please get one from the net !\n"
				  "        (e.g. util/misc/SaferPatches)\n");
	}

	CloseLibrary(lib);

	errprintf "Library closed.\n");

	return ret;
}

// ---------------------------
// funx: warning
// ---------------------------

static int Warning(void)
{
	char	c;

	if(!GET_QUIET)
	{
		printf(WarnTxt);
		scanf("%c",&c);fflush(stdin);

		if ((c | ' ') != 'y')
			return RETURN_FAIL;

		putchar('\n');
	}

	return RETURN_OK;
}

// -----------------------------
// funx: arguments
// -----------------------------

static int ParseArgs(void)
{
	if(OwnArgs = AllocDosObject(DOS_RDARGS,0))
	{
		OwnArgs->RDA_ExtHelp	=	InfoTxt;
	}

	if(!(Args = ReadArgs(Template,Array,OwnArgs)))
	{
		char	buf[BUFLEN];

		Fault(IoErr(),0,buf,BUFLEN);
		errprintf "%s%s.\n",ErrHeader,buf);
		return RETURN_FAIL;
	}

	return RETURN_OK;
}

static void UnParseArgs(void)
{
	if(Args)
		FreeArgs(Args);
	if(OwnArgs)
		FreeDosObject(DOS_RDARGS,OwnArgs);
}

// ---------------------------
// funx
// ---------------------------

int main(int argc, char **argp)
{
	int	ret;

	if((ret = ParseArgs()) == RETURN_OK)
	{
		if((ret = Warning()) == RETURN_OK)
		{
			ret	=	ChkPatch();
		}
	}
	UnParseArgs();

	exit(ret);
}
