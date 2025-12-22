/******************************************************************************
 *
 * fd2inline
 *
 * Should be able to parse CBM fd files and generate vanilla inline calls
 * for gcc. Works as a filter.
 *
 * by Wolfgang Baron, all rights reserved.
 *
 * improved, updated, simply made workable by Rainer F. Trunz 1/95
 *
 * Completely reworked Version, cleaned up and removed a whole lot of bugs
 * found by Kamil Iskra.
 *
 * Expect miracles now (hopefully...). Ok, I am just kidding :)
 *
 * Version 0.99a by Rainer F. Trunz 6/95
 *
 * Version 0.99b and later by Kamil Iskra.
 *
 ******************************************************************************/

#include <ctype.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/******************************************************************************
 * The program has a few sort of class definitions, which are the result of
 * object oriented thinking, to be imlemented in plain C. I just haven't
 * had the time to learn C++ or install the compiler. The design does however
 * improve robustness, which allows the source to be used over and over again.
 * if you use this code, please leave a little origin note.
 ******************************************************************************/

const static char version_str[]="$VER: fd2inline " VERSION " (31.1.97)";

/******************************************************************************
 * These are general definitions including types for defining registers etc.
 ******************************************************************************/

#ifdef DEBUG
#define DBP(a) a
#else /* !DEBUG */
#define DBP(a)
#endif /* !DEBUG */

#if (defined(__GNUC__) || defined(__SASC)) && 0
#define INLINE __inline /* Gives 20% *larger* executable with GCC?! */
#else
#define INLINE
#endif

#define REGS 16  /* d0=0,...,a7=15 */
#define FDS 1000

typedef enum
{
	d0, d1, d2, d3, d4, d5, d6, d7, a0, a1, a2, a3, a4, a5, a6, a7, illegal
} regs;

typedef unsigned char uchar, shortcard;
typedef unsigned long ulong;

typedef enum { false, nodef, real_error } Error;

enum {NEW, OLD, STUBS, PROTO} output_mode=NEW;

char BaseName[32], BaseNamU[32],  BaseNamL[32];

const static char *LibExcTable[]=
{
	"BattClockBase",			"Node",
	"BattMemBase",				"Node",
	"ConsoleDevice",			"Device",
	"DiskBase",					"DiskResource",
	"DOSBase",					"DosLibrary",
	"SysBase",					"ExecBase",
	"ExpansionBase",			"ExpansionBase",
	"GfxBase",					"GfxBase",
	"InputBase",				"Device",
	"IntuitionBase",			"IntuitionBase",
	"LocaleBase",				"LocaleBase",
	"MathIeeeDoubBasBase",	"MathIEEEBase",
	"MathIeeeDoubTransBase","MathIEEEBase",
	"MathIeeeSingBasBase",	"MathIEEEBase",
	"MathIeeeSingTransBase","MathIEEEBase",
	"MiscBase",					"Node",
	"PotgoBase",				"Node",
	"RamdriveDevice",			"Device",
	"RealTimeBase",			"RealTimeBase",
	"RexxSysBase",				"RxsLib",
	"TimerBase",				"Device",
	"UtilityBase",				"UtilityBase"
};
const char *StdLib; /* global lib-name ptr */

/*******************************************
 * just some support functions, no checking
 *******************************************/

char*
NewString(char** new, const char* old)
{
	const char *high;
	ulong len;

	while (*old && (*old==' ' || *old=='\t'))
		old++;
	len=strlen(old);
	for (high=old+len-1; high>=old && (*high==' ' || *high=='\t'); high--);
	high++;
	len=high-old;
	*new=malloc(1+len);
	if (*new)
	{
		strncpy(*new, old, len);
		(*new)[len]='\0';
	}
	else
		fprintf(stderr, "no mem for string\n");
	return *new;
}

static INLINE void
illparams(const char* funcname)
{
	fprintf(stderr, "%s: illegal Parameters\n", funcname);
}

static INLINE const char*
RegStr(regs reg)
{
	const static char *myregs[]=
	{
		"d0", "d1", "d2", "d3", "d4", "d5", "d6", "d7",
		"a0", "a1", "a2", "a3", "a4", "a5", "a6", "a7", "illegal"
	};

	if (reg>illegal)
		reg=illegal;
	if (reg<d0)
		reg=d0;
	return myregs[reg];
}

/******************************************************************************
 *    StrNRBrk
 *
 * searches string in from position at downwards, as long as in does not
 * contain any character in not.
 *
 ******************************************************************************/

const char*
StrNRBrk(const char* in, const char* not, const char* at)
{
	const char *chcheck;
	Error ready;

	chcheck=""; /* if at<in, the result will be NULL */
	for (ready=false; ready==false && at>=in;)
	{
		for (chcheck=not; *chcheck && *chcheck != *at; chcheck++);
		if (*chcheck)
			ready=real_error;
		else
			at--;
	}
	DBP(fprintf(stderr, "{%c}", *chcheck));
	return *chcheck ? at : NULL;
}

/*
  Our own "strupr", since it is a non-standard function.
*/
void
StrUpr(char* str)
{
	while (*str)
	{
		*str=toupper(*str);
		str++;
	}
}

/******************************************************************************
 *    CLASS fdFile
 *
 * stores a file with a temporary buffer (static length, sorry), a line number,
 * an offset (used for library offsets and an error field.
 * When there's no error, line will contain line #lineno and offset will be
 * the last offset set by the interpretation of the last line. If there's been
 * no ##bias line, this field assumes a bias of 30, which is the standard bias.
 * It is assumed offsets are always negative.
 ******************************************************************************/

#define fF_BUFSIZE 1024

/* all you need to know about an fdFile you parse */

typedef struct
{
	FILE*	file;					/* the file we're reading from		*/
	char	line[fF_BUFSIZE];	/* the current line						*/
	ulong	lineno;				/* current line number					*/
	long	offset;				/* current fd offset (-bias)			*/
	Error	error;				/* is everything o.k.					*/
	char	private;				/* are we in ##public or ##private	*/
} fdFile;

fdFile*
fF_ctor			(const char* fname);
static void
fF_dtor			(fdFile* obj);
static void
fF_SetError		(fdFile* obj, Error error);
static void
fF_SetOffset	(fdFile* obj, long at);
Error
fF_readln		(fdFile* obj);
static Error
fF_GetError		(const fdFile* obj);
static long
fF_GetOffset	(const fdFile* obj);
char*
fF_FuncName		(fdFile* obj); /* return name or null */
static void
fF_SetPrivate	(fdFile* obj, char priv);
static char
fF_GetPrivate	(const fdFile* obj);

static INLINE void
fF_dtor(fdFile* obj)
{
  fclose(obj->file);
  free(obj);
}

static INLINE void
fF_SetError(fdFile* obj, Error error)
{
	if (obj)
		obj->error=error;
	else
		illparams("fF_SetError");
}

static INLINE void
fF_SetOffset(fdFile* obj, long at)
{
	if (obj)
		obj->offset= at;
	else
		illparams("fFSetOffset");
}

static INLINE void
fF_SetPrivate(fdFile* obj, char priv)
{
  if (obj)
    obj->private=priv;
  else
    illparams("fF_SetPrivate");
}

fdFile*
fF_ctor(const char* fname)
{
	fdFile *result;

	if (fname)
	{
		result=malloc(sizeof(fdFile));
		if (result)
		{
			result->file=fopen(fname, "r");
			if (result->file)
			{
				result->lineno=0;
				fF_SetOffset(result, -30);
				fF_SetError(result, false);
				fF_SetPrivate(result, 0);
				result->line[0]='\0';
			}
			else
			{
				free(result);
				result=NULL;
			}
		}
	}
	else
	{
		result=NULL;
		illparams("fF_ctor");
	}
	return result;
}

Error
fF_readln(fdFile* obj)
{
	char *low, *bpoint;
	long glen,	/* the length we read until now */
	len;			/* the length of the last segment */

	if (obj)
	{
		low=obj->line;
		glen=0;

		for (;;)
		{
			obj->lineno++;
			if (!fgets(low, fF_BUFSIZE-1-glen, obj->file))
			{
				fF_SetError(obj, real_error);
				obj->line[0]='\0';
				return real_error;
			}
			if (low==strpbrk(low, "*#/"))
			{
				DBP(fprintf(stderr, "in# %s\n", obj->line));
				return false;
			}
			len=strlen(low);
			bpoint=low+len-1;
			while (len && isspace(*bpoint))
			{
				bpoint--;
				len--;
			}
			if (*bpoint==';' || *bpoint==')')
			{
				DBP(fprintf(stderr, "\nin: %s\n", obj->line));
				return false;
			}
			glen+=len;
			low+=len;
			if (glen>=fF_BUFSIZE-10) /* somewhat pessimistic? */
			{
				fF_SetError(obj, real_error);
				fprintf(stderr, "line %lu too long.\n", obj->lineno);
				return real_error;
			}
			DBP(fprintf(stderr, "+"));
		}
	}
	illparams("fF_readln");
	return real_error;
}

static INLINE Error
fF_GetError(const fdFile* obj)
{
	if (obj)
		return obj->error;
	illparams("fF_GetError");
	return real_error;
}

static INLINE long
fF_GetOffset(const fdFile* obj)
{
	if (obj)
		return obj->offset;
	illparams("fF_GetOffset");
	return -1;
}

/******************************************************************************
 * fF_FuncName
 *
 * checks if it can find a function-name and return it's address, or NULL
 * if the current line does not seem to contain one. The return value will
 * be a pointer into a malloced buffer, thus the caller will have to free().
 ******************************************************************************/

char*
fF_FuncName(fdFile* obj)
{
	const char *lower;
	const char *upper;
	char *buf;
	long obraces;	/* count of open braces */
	Error ready;	/* ready with searching */

	if (!obj || fF_GetError(obj)==real_error)
	{
		illparams("fF_FuncName");
		return NULL;
	}

	lower=obj->line;
	while (*lower && (*lower==' ' || *lower=='\t'))
		lower++;

	if (!*lower || (!isalpha(*lower) && *lower!='_'))
	{
		fF_SetError(obj, nodef);
		return NULL;
	}

	while (*lower)
	{
		if (!isalnum(*lower) && !isspace(*lower) && *lower!='*' && *lower!=','
		&& *lower!='.' && *lower!=';' && *lower!='(' && *lower!=')' &&
		*lower!='[' && *lower!=']' && *lower!='_' && *lower!='\\')
		{
			fF_SetError(obj, nodef);
			return NULL;
		}
		lower++;
	}

	lower=NULL;
	buf=NULL;

	if (obj && fF_GetError(obj)==false)
	{
		if ((upper=strrchr(obj->line, ')'))!=0)
		{
			DBP(fprintf(stderr, "end:%s:", upper));

			for (obraces=1, ready=false; ready==false; upper=lower)
			{
				lower=StrNRBrk(obj->line, "()", --upper);
				if (lower)
				{
					switch (*lower)
					{
						case ')':
							obraces++;
							DBP(fprintf(stderr, " )%ld%s", obraces, lower));
							break;
						case '(':
							obraces--;
							DBP(fprintf(stderr, " (%ld%s", obraces, lower));
							if (!obraces)
								ready=nodef;
							break;
						default:
							fprintf(stderr, "faulty StrNRBrk\n");
					}
				}
				else
				{
					fprintf(stderr, "'(' or ')' expected in line %lu.\n",
						obj->lineno);
					ready=real_error;
				}
			}
			if (ready==nodef) /* we found the matching '(' */
			{
				long newlen;
				const char* name;

				upper--;

				while (upper>=obj->line && (*upper==' ' || *upper=='\t'))
					upper--;

				lower=StrNRBrk(obj->line, " \t*)", upper);

				if (!lower)
					lower=obj->line;
				else
					lower++;

				for (name=lower; name<=upper; name++)
					if (!isalnum(*name) && *name!='_')
					{
						fF_SetError(obj, nodef);
						return NULL;
					}

				newlen=upper-lower+1;
				buf=malloc(newlen+1);

				if (buf)
				{
					strncpy(buf, lower, newlen);
					buf[newlen]='\0';
				}
				else
					fprintf(stderr, "no mem for fF_FuncName");
			}
		}
	}
	else
		illparams("fF_FuncName");
	return buf;
}

static INLINE char
fF_GetPrivate(const fdFile* obj)
{
	if (obj)
		return obj->private;
	illparams("fF_GetPrivate");
	return 0;
}

/*********************
 *    CLASS fdDef    *
 *********************/

typedef struct
{
	char*	name;
	char*	type;
	long	offset;
	regs	reg[REGS];
	char*	param[REGS];
	char*	proto[REGS];
	regs	funcpar; /* number of argument that has type "pointer to function" */
} fdDef;

fdDef*
fD_ctor				(void);
void
fD_dtor				(fdDef* obj);
static void
fD_NewName			(fdDef* obj, const char* newname);
void
fD_NewParam			(fdDef* obj, shortcard at, const char* newstr);
void
fD_NewProto			(fdDef* obj, shortcard at, char* newstr);
static void
fD_NewReg			(fdDef* obj, shortcard at, regs reg);
static void
fD_NewType			(fdDef* obj, const char* newstr);
static void
fD_SetOffset		(fdDef* obj, long off);
Error
fD_parsefd			(fdDef* obj, fdFile* infile);
Error
fD_parsepr			(fdDef* obj, fdFile* infile);
static const char*
fD_GetName			(const fdDef* obj);
static long
fD_GetOffset		(const fdDef* obj);
static const char*
fD_GetParam			(const fdDef* obj, shortcard at);
static regs
fD_GetReg			(const fdDef* obj, shortcard at);
static const char*
fD_GetRegStr		(const fdDef* obj, shortcard at);
static const char*
fD_GetType			(const fdDef* obj);
static shortcard
fD_ParamNum			(const fdDef* obj);
static shortcard
fD_ProtoNum			(const fdDef* obj);
static shortcard
fD_RegNum			(const fdDef* obj);
int
fD_cmpName			(const void* big, const void* small);
void
fD_write				(FILE* outfile, const fdDef* obj);
static shortcard
fD_GetFuncParNum	(const fdDef* obj);
static void
fD_SetFuncParNum	(fdDef* obj, shortcard at);
static void
fD_adjustargnames(fdDef *obj);

fdDef **arrdefs;
long fds;

char *fD_nostring="";

fdDef*
fD_ctor(void)
{
	fdDef *result;
	regs count;

	result=malloc(sizeof(fdDef));

	if (result)
	{
		result->name=fD_nostring;
		result->type=fD_nostring;
		result->funcpar=illegal;

		for (count=d0; count<illegal; count++ )
		{
			result->reg[count]=illegal;
			result->param[count]=fD_nostring; /* if (!strlen) dont't free() */
			result->proto[count]=fD_nostring;
		}
	}
	return result;
}

/* free all resources and make the object as illegal as possible */

void
fD_dtor(fdDef* obj)
{
	regs count;

	if (obj)
	{
		if (!obj->name)
			fprintf(stderr, "fD_dtor: null name");
		else
			if (obj->name!=fD_nostring)
				free(obj->name);

		if (!obj->type)
			fprintf(stderr, "fD_dtor: null type");
		else
			if (obj->type!=fD_nostring)
				free(obj->type);

		obj->name=obj->type=NULL;

		for (count=d0; count<illegal; count++)
		{
			obj->reg[count]=illegal;

			if (!obj->param[count])
				fprintf(stderr, "fD_dtor: null param");
			else
				if (obj->param[count]!=fD_nostring)
					free(obj->param[count]);

			if (!obj->proto[count])
				fprintf(stderr, "fD_dtor: null proto");
			else
				if (obj->proto[count]!=fD_nostring)
					free(obj->proto[count]);

			obj->param[count]=obj->proto[count]=NULL;
		}

		free(obj);
	}
	else
		fprintf(stderr, "fd_dtor(NULL)\n");
}

static INLINE void
fD_NewName(fdDef* obj, const char* newname)
{
	if (obj && newname)
	{
		if (obj->name && obj->name!=fD_nostring)
			free(obj->name);
		if (!NewString(&obj->name, newname))
			obj->name=fD_nostring;
	}
	else
		illparams("fD_NewName");
}

void
fD_NewParam(fdDef* obj, shortcard at, const char* newstr)
{
	char *pa;

	if (newstr && obj && at<illegal)
	{
		pa=obj->param[at];

		if (pa && pa!=fD_nostring)
			free(pa);

		while (*newstr==' ' || *newstr=='\t')
			newstr++;

		if (NewString(&pa, newstr))
			obj->param[at]=pa;
		else
			obj->param[at]=fD_nostring;
	}
	else
		illparams("fD_NewParam");
}

/* get first free *reg or illegal */

static INLINE shortcard
fD_RegNum(const fdDef* obj)
{
	shortcard count;

	if (obj)
	{
		for (count=d0; count<illegal && obj->reg[count]!=illegal; count++);
		return count;
	}
	else
	{
		illparams("fD_RegNum");
		return illegal;
	}
}

static INLINE void
fD_NewReg(fdDef* obj, shortcard at, regs reg)
{
	if (obj && at<illegal && reg>=d0 && reg<=illegal)
		obj->reg[at]=reg;
	else
		illparams("fD_NewReg");
}

static INLINE regs
fD_GetReg(const fdDef* obj, shortcard at)
{
	if (obj && at<illegal)
		return obj->reg[at];
	else
	{
		illparams("fD_GetReg");
		return illegal;
	}
}

static INLINE shortcard
fD_GetFuncParNum(const fdDef* obj)
{
	if (obj)
		return (shortcard)obj->funcpar;
	else
	{
		illparams("fD_GetFuncParNum");
		return illegal;
	}
}

static INLINE void
fD_SetFuncParNum(fdDef* obj, shortcard at)
{
	if (obj && at<illegal)
		obj->funcpar=at;
	else
		illparams("fD_SetFuncParNum");
}

void
fD_NewProto(fdDef* obj, shortcard at, char* newstr)
{
	char *pr;

	if (newstr && obj && at<illegal)
	{
		char *t, arr[200]; /* I hope 200 will be enough... */
		int numwords=1;
		pr=obj->proto[at];

		if (pr && pr!=fD_nostring)
			free(pr);

		while (*newstr==' ' || *newstr=='\t')
			newstr++; /* Skip leading spaces */

		t=arr;
		while ((*t++=*newstr)!=0)
		{
			/* Copy the rest, counting number of words */
			if ((*newstr==' ' || *newstr=='\t') && newstr[1] && newstr[1]!=' ' &&
			newstr[1]!='\t')
				numwords++;
			newstr++;
		}

		t=arr+strlen(arr)-1;
		while (*t==' ' || *t=='\t')
			t--;
		t[1]='\0'; /* Get rid of tailing spaces */
		if (at!=fD_GetFuncParNum(obj))
		{
			if (numwords>1) /* One word - must be type */
				if (*t!='*')
				{
					/* '*' on the end - no parameter name used */
					while (*t!=' ' && *t!='\t' && *t!='*')
						t--;
					t++;
					if (strcmp(t, "char") && strcmp(t, "short") && strcmp(t, "int")
					&& strcmp(t, "long"))
					{
						/* Not one of applicable keywords - must be parameter name.
							Get rid of it. */
						t--;
						while (*t==' ' || *t=='\t')
							t--;
						t[1]='\0';
					}
				}
		}
		else
		{
			/* Parameter of type "pointer to function". */
			char *end;
			t=strchr(arr, '(');
			while (*t++!='*');
			end=strchr(t, ')');
			memmove(t+2, end, strlen(end)+1);
			*t='%';
			t[1]='s';
		}

		if (NewString(&pr, arr))
		{
			obj->proto[at]=pr;
			while (*pr==' ' || *pr=='\t')
				pr++;
			if (!stricmp(pr, "double"))
			{
				/* "double" needs two data registers */
				int count, regs=fD_RegNum(obj);
				for (count=at+1; count<regs; count++)
					fD_NewReg(obj, count, fD_GetReg(obj, count+1));
			}
		}
		else
			obj->proto[at]=fD_nostring;
	}
	else
		illparams("fD_NewProto");
}

static INLINE void
fD_NewType(fdDef* obj, const char* newtype)
{
	if (obj && newtype)
	{
		if (obj->type && obj->type!=fD_nostring)
			free(obj->type);
		if (!NewString(&obj->type, newtype))
			obj->type=fD_nostring;
	}
	else
		illparams("fD_NewType");
}

static INLINE void
fD_SetOffset(fdDef* obj, long off)
{
	if (obj)
		obj->offset=off;
	else
		illparams("fD_SetOffset");
}

static INLINE const char*
fD_GetName(const fdDef* obj)
{
	if (obj && obj->name)
		return obj->name;
	else
	{
		illparams("fD_GetName");
		return fD_nostring;
	}
}

static INLINE long
fD_GetOffset(const fdDef* obj)
{
	if (obj)
		return obj->offset;
	else
	{
		illparams("fD_GetOffset");
		return 0;
	}
}

static INLINE const char*
fD_GetProto(const fdDef* obj, shortcard at)
{
	if (obj && at<illegal && obj->proto[at])
		return obj->proto[at];
	else
	{
		illparams("fD_GetProto");
		return fD_nostring;
	}
}

static INLINE const char*
fD_GetParam(const fdDef* obj, shortcard at)
{
	if (obj && at<illegal && obj->param[at])
		return obj->param[at];
	else
	{
		illparams("fD_GetParam");
		return fD_nostring;
	}
}

static INLINE const char*
fD_GetRegStr(const fdDef* obj, shortcard at)
{
	if (obj && at<illegal)
		return RegStr(obj->reg[at]);
	else
	{
		illparams("fD_GetReg");
		return RegStr(illegal);
	}
}

static INLINE const char*
fD_GetType(const fdDef* obj)
{
	if (obj && obj->type)
		return obj->type;
	else
	{
		illparams("fD_GetType");
		return fD_nostring;
	}
}

/* get first free param or illegal */

static INLINE shortcard
fD_ParamNum(const fdDef* obj)
{
	shortcard count;

	if (obj)
	{
		for (count=d0; count<illegal && obj->param[count]!=fD_nostring;
		count++);
		return count;
	}
	else
	{
		illparams("fD_ParamNum");
		return illegal;
	}
}

static INLINE shortcard
fD_ProtoNum(const fdDef* obj)
{
	shortcard count;

	if (obj)
	{
		for (count=d0; count<illegal && obj->proto[count]!=fD_nostring;
		count++);
		return count;
	}
	else
	{
		illparams("fD_ProtoNum");
		return illegal;
	}
}

/******************************************************************************
 *    fD_parsefd
 *
 *  parse the current line. Needs to copy input, in order to insert \0's
 *  RETURN
 *    fF_GetError(infile):
 *	false = read a definition.
 *	nodef = not a definition on line (so try again)
 *	error = real error
 ******************************************************************************/

Error
fD_parsefd(fdDef* obj, fdFile* infile)
{
	enum parse_info { name, params, regs, ready } parsing;
	char *buf, *bpoint, *bnext;
	ulong index;

	if (obj && infile && fF_GetError(infile)==false)
	{
		parsing=name;

		if (!NewString(&buf, infile->line))
		{
			fprintf(stderr, "no mem for line %lu\n", infile->lineno);
			fF_SetError(infile, real_error);
		}
		bpoint=buf; /* so -Wall keeps quiet */

		/* try to parse the line until there's an error or we are done */

		while (parsing!=ready && fF_GetError(infile)==false)
		{
			switch (parsing)
			{
				case name:
					switch (buf[0])
					{
						case '#':
							if (strncmp("##base", buf, 6)==0)
							{
								bnext=buf+6;
								while (*bnext==' ' || *bnext=='\t' || *bnext=='_')
									bnext++;
								strcpy(BaseName, bnext);
								BaseName[strlen(BaseName)-1]='\0';
							}
							else
								if (strncmp("##bias", buf, 6)==0)
								{
									if (!sscanf(buf+6, "%ld", &infile->offset))
									{
										fprintf(stderr, "illegal ##bias in line %lu: %s\n",
											infile->lineno, infile->line);
										fF_SetError(infile, real_error);
										break; /* avoid nodef */
									}
									else
									{
										if (fF_GetOffset(infile)>0)
											fF_SetOffset(infile, -fF_GetOffset(infile));
										DBP(fprintf(stderr, "set offset to %ld\n",
											fFGetOffset(infile)));
									}
								}
								else
								{
									if (strncmp("##private", buf, 9)==0)
										fF_SetPrivate(infile, 1);
									else
										if (strncmp("##public", buf, 8)==0)
											fF_SetPrivate(infile, 0);
								}
							/* drop through for error comment */

						case '*':
							/* try again somewhere else */
							fF_SetError(infile, nodef);
								break;

						default:
							/* assume a regular line here */
							if (fF_GetPrivate(infile))
							{
								/* don't store names of privates */
								fF_SetError(infile, nodef);
								fF_SetOffset(infile, fF_GetOffset(infile)-6);
								break;
							}
							parsing=name; /* switch (parsing) */
							for (index=0; buf[index] && buf[index]!='('; index++);

							if (!buf[index])
							{
								/* oops, no fd ? */
								fprintf(stderr, "not an fd, line %lu: %s\n",
									infile->lineno, buf /* infile->line */);
								fF_SetError(infile, nodef);
							} /* maybe next time */
							else
							{
								buf[index]=0;

								fD_NewName(obj, buf);
								fD_SetOffset(obj, fF_GetOffset(infile));

								bpoint=buf+index+1;
								parsing=params; /* continue the loop */
							}
					}
					break;

				case params:
				{
					char *bptmp; /* needed for fD_NewParam */

					/* look for parameters now */

					for (bnext = bpoint; *bnext && *bnext!=',' && *bnext!=')';
					bnext++);

					if (*bnext)
					{
						bptmp=bpoint;

						if (*bnext == ')')
						{
							if (bnext[1] != '(')
							{
								fprintf(stderr, "registers expected in line %lu: %s\n",
									infile->lineno, infile->line);
								fF_SetError(infile, nodef);
							}
							else
							{
								parsing=regs;
								bpoint=bnext+2;
							}
						}
						else
							bpoint = bnext+1;

						/* terminate string and advance to next item */

						*bnext='\0';
						fD_NewParam(obj, fD_ParamNum(obj), bptmp);
					}
					else
					{
						fF_SetError(infile, nodef);
						fprintf(stderr, "param expected in line %lu: %s\n",
							infile->lineno, infile->line);
					}
					break;  /* switch parsing */
				}

				case regs:
					/* look for parameters now */

					for (bnext=bpoint; *bnext && *bnext!='/' && *bnext!=',' &&
					*bnext!=')'; bnext++);

					if (*bnext)
					{
						if (')'==*bnext)
						{
							/* wow, we've finished */
							fF_SetOffset(infile, fF_GetOffset(infile)-6);
							parsing=ready;
						}
						*bnext = '\0';

						bpoint[0]=tolower(bpoint[0]);

						if ((bpoint[0]=='d' || bpoint[0]=='a') && bpoint[1]>='0' &&
						bpoint[1]<='8' && bnext==bpoint+2)
							fD_NewReg(obj, fD_RegNum(obj),
								bpoint[1]-'0'+(bpoint[0]=='a'? 8 : 0));
						else
							if (bnext!=bpoint)
							{
								/* it is when our function is void */
								fprintf(stderr, "illegal register %s in line %ld\n",
									bpoint, infile->lineno);
								fF_SetError(infile, nodef);
							}
						bpoint = bnext+1;
					}
					else
					{
						fF_SetError(infile, nodef);
						fprintf(stderr, "reg expected in line %lu\n",
							infile->lineno);
					}
					break; /* switch parsing */

				case ready:
					fprintf(stderr, "internal error, use another compiler.\n");
					break;
			}
		}

		free(buf);
		return fF_GetError(infile);
	}
	else
	{
		illparams("fD_parsefd");
		return real_error;
	}
}

static void
fD_adjustargnames(fdDef *obj)
{
	int parnum;

	if (output_mode!=NEW)
		return;

	/* For #define-base output mode, we have to check if argument names are not
		the same as some words in type names. We check from the first argument
		to the last, resolving conflicts by changing argument names, if
		necessary. */

	for (parnum=0; parnum<fD_ParamNum(obj); parnum++)
	{
		const char *parname=fD_GetParam(obj, parnum);
		int finished;
		do
		{
			int num;
			const char *type=fD_GetType(obj);
			char *str;
			finished=1;

			if ((str=strstr(type, parname))!=0 && (str==type ||
			(!isalnum(str[-1]) && str[-1]!='_')) &&
			(!*(str+=strlen(parname)) || (!isalnum(*str) && *str!='_')))
			{
				char buf[300]; /* Hope will be enough... */
				strcpy(buf, parname);
				strcat(buf, "_");
				fD_NewParam(obj, parnum, buf);
				finished=0;
			}
			else
				for (num=0; num<fD_ParamNum(obj); num++)
				{
					const char *name=fD_GetParam(obj, num);
					const char *proto=fD_GetProto(obj, num);
					if ((num<parnum && strcmp(name, parname)==0) ||
					((str=strstr(proto, parname))!=0 && (str==proto ||
					(!isalnum(str[-1]) && str[-1]!='_')) &&
					(!*(str+=strlen(parname)) || (!isalnum(*str) && *str!='_'))))
					{
						char buf[300]; /* Hope will be enough... */
						strcpy(buf, parname);
						strcat(buf, "_");
						fD_NewParam(obj, parnum, buf);
						finished=0;
						break;
					}
				}
		} while (!finished);
	}
}

Error
fD_parsepr(fdDef* obj, fdFile* infile)
{
	char	*buf;		/* a copy of infile->line							*/
	char	*bpoint,	/* cursor in buf										*/
			*bnext,	/* looking for the end								*/
			*lowarg;	/* beginning of this argument						*/
	long	obraces;	/* count of open braces								*/
	regs	count,	/* count parameter number							*/
			args;		/* the number of arguments for this function */

	if (!(obj && infile && fF_GetError(infile)==false))
	{
		illparams("fD_parsepr");
		fF_SetError(infile, real_error);
		return real_error;
	}
	if (!NewString(&buf, infile->line))
	{
		fprintf(stderr, "no mem for fD_parsepr\n");
		fF_SetError(infile, real_error);
		return real_error;
	}
	fF_SetError(infile, false);

	bpoint=strchr(buf, '(');
	while (--bpoint>=buf && strstr(bpoint, fD_GetName(obj))!=bpoint);
	if (bpoint>=buf)
	{
		while (--bpoint >= buf && (*bpoint==' ' || *bpoint=='\t'));
		*++bpoint='\0';

		fD_NewType(obj, buf);

		while (bpoint && *bpoint++!='('); /* one beyond '(' */

		lowarg=bpoint;
		obraces=0;

		for (count=0, args=fD_RegNum(obj); count<args; bpoint=bnext+1)
		{
			while (*bpoint && (*bpoint==' ' || *bpoint=='\t')) /* ignore spaces */
				bpoint++;

			bnext=strpbrk(bpoint, "(),");

			if (bnext)
			{
				switch (*bnext)
				{
					case '(':
						if (!obraces)
						{
							if (fD_GetFuncParNum(obj)!=illegal &&
							fD_GetFuncParNum(obj)!=count)
								fprintf(stderr, "Warning: two parameters of type "
									"pointer to function are used.\nThis is not "
									"supported!\n");
							fD_SetFuncParNum(obj, count);
						}
						obraces++;
						DBP(fprintf(stderr, "< (%ld%s >", obraces, bnext));
						break;

					case ')':
						if (obraces)
						{
							DBP(fprintf(stderr, "< )%ld%s >", obraces, bnext));
							obraces--;
						}
						else
						{
							*bnext='\0';
							DBP(fprintf(stderr, "< )0> [LAST PROTO=%s]", lowarg));
							fD_NewProto(obj, count, lowarg);
							lowarg=bnext+1;

							if (count!=args-1)
							{
								DBP(fprintf(stderr, "%s needs %u arguments and got %u.\n",
									fD_GetName(obj), args, count+1));
								fF_SetError(infile, nodef);
							}
							count++;
						}
						break;

					case ',':
						if (!obraces)
						{
							*bnext='\0';
							DBP(fprintf(stderr, " [PROTO=%s] ", lowarg));
							fD_NewProto(obj, count, lowarg);
							lowarg=bnext+1;
							count++;
						}
						break;

					default:
						fprintf(stderr, "faulty strpbrk in line %lu.\n",
							infile->lineno);
				}
			}
			else
			{
				DBP(fprintf(stderr, "faulty argument %u in line %lu.\n", count+1,
					infile->lineno));
				count=args; /* this will effectively quit the for loop */
				fF_SetError(infile, nodef);
			}
		}
		if (fD_ProtoNum(obj)!=fD_RegNum(obj))
			fF_SetError(infile, nodef);
	}
	else
	{
		fprintf(stderr, "fD_parsepr was fooled in line %lu\n", infile->lineno);
		fprintf(stderr, "function , definition %s.\n",
			/* fD_GetName(obj),*/ infile->line);
		fF_SetError(infile, nodef);
	}

	free(buf);

	fD_adjustargnames(obj);

	return fF_GetError(infile);
}

int
fD_cmpName(const void* big, const void* small) /* for qsort and bsearch */
{
	return strcmp(fD_GetName(*(fdDef**)big), fD_GetName(*(fdDef**)small));
}

const static char *TagExcTable[]=
{
	"BuildEasyRequestArgs",	"BuildEasyRequest",
	"DoDTMethodA",				"DoDTMethod",
	"DoGadgetMethodA",		"DoGadgetMethod",
	"EasyRequestArgs",		"EasyRequest",
	"MUI_MakeObjectA",		"MUI_MakeObject",
	"MUI_RequestA",			"MUI_Request",
	"PrintDTObjectA",			"PrintDTObject",
	"UMSVLog",					"UMSLog",
	"VFWritef",					"FWritef",
	"VFPrintf",					"FPrintf",
	"VPrintf",					"Printf",
};

const char*
taggedfunction(const fdDef* obj)
{
	shortcard numregs=fD_RegNum(obj);
	unsigned int count;
	const char *name=fD_GetName(obj);
	static char newname[200];	/* Hope will be enough... static because used
											out of the function. */
	const char *lastarg;
	const static char *TagExcTable2[]=
	{
		"ApplyTagChanges",
		"CloneTagItems",
		"FindTagItem",
		"FreeTagItems",
		"GetTagData",
		"PackBoolTags",
		"PackStructureTags",
		"RefreshTagItemClones",
		"UnpackStructureTags",
	};

	if (!numregs)
		return NULL;

	for (count=0; count<sizeof TagExcTable/sizeof TagExcTable[0]; count+=2)
		if (strcmp(name, TagExcTable[count])==0)
			return TagExcTable[count+1];

	for (count=0; count<sizeof TagExcTable2/sizeof TagExcTable2[0]; count++)
		if (strcmp(name, TagExcTable2[count])==0)
			return NULL;

	lastarg=fD_GetProto(obj, numregs-1);
	if (strncmp(lastarg, "struct", 6))
		return NULL;
	lastarg+=6;
	while (*lastarg==' ' || *lastarg=='\t')
		lastarg++;
	if (strncmp(lastarg, "TagItem", 7))
		return NULL;
	lastarg+=7;
	while (*lastarg==' ' || *lastarg=='\t')
		lastarg++;
	if (strcmp(lastarg, "*"))
		return NULL;

	strcpy(newname, name);
	if (newname[strlen(newname)-1]=='A')
		newname[strlen(newname)-1]='\0';
	else
		if (strlen(newname)>7 && !strcmp(newname+strlen(newname)-7, "TagList"))
			strcpy(newname+strlen(newname)-4, "s");
		else
			strcat(newname, "Tags");
	return newname;
}

const char*
aliasfunction(const char* name)
{
	const static char *AliasTable[]=
	{
		"AllocDosObject",	"AllocDosObjectTagList",
		"CreateNewProc",	"CreateNewProcTagList",
		"NewLoadSeg",		"NewLoadSegTagList",
		"System",			"SystemTagList",
	};
	unsigned int count;
	for (count=0; count<sizeof AliasTable/sizeof AliasTable[0]; count++)
		if (strcmp(name, AliasTable[count])==0)
			return AliasTable[count+(count%2 ? -1 : 1)];
	return NULL;
}

void
fD_write(FILE* outfile, const fdDef* obj)
{
	shortcard count, numregs;
	const char *chtmp, *tagname, *name, *rettype;
	int vd=0, a45=0, d7=0;

	DBP(fprintf(stderr, "func %s\n", fD_GetName(obj)));

	numregs=fD_RegNum(obj);

	if ((rettype=fD_GetType(obj))==fD_nostring)
	{
		fprintf(stderr, "%s has no prototype.\n", fD_GetName(obj));
		return;
	}
	if (!stricmp(rettype, "void"))
		vd = 1; /* set flag */
	for (count=d0; count<numregs; count++)
	{
		const char *reg=fD_GetRegStr(obj, count);
		if (strcmp(reg, "a4")==0 || strcmp(reg, "a5")==0)
			if (!a45)
				a45=(strcmp(reg, "a4") ? 5 : 4); /* set flag */
			else /* Security check */
				fprintf(stderr, "Warning: both a4 and a5 are used. This is not "
					"supported!\n");
		if (strcmp(reg, "d7")==0) /* Used only when a45!=0 */
			d7=1;
	}
	if (a45 && d7) /* Security check */
		fprintf(stderr, "Warning: d7 and a4 or a5 are used. This is not "
			"supported!\n");

	name=fD_GetName(obj);

	if (fD_ProtoNum(obj)!=numregs)
	{
		fprintf(stderr, "%s gets %d fd args and %d proto%s.\n", name, numregs,
			fD_ProtoNum(obj), fD_ProtoNum(obj)!= 1 ? "s" : "");
		return;
	}

	if (output_mode==NEW)
	{
		fprintf(outfile, "#define %s(", name);

		if (numregs>0)
		{
			for (count=d0; count<numregs-1; count++)
				fprintf(outfile, "%s, ", fD_GetParam(obj, count));
			fprintf(outfile, "%s", fD_GetParam(obj, count));
		}

		fprintf(outfile, ") \\\n\tLP%d%s%s%s%s(0x%lx, ", numregs,
			(vd ? "NR" : ""), (a45 ? (a45==4 ? "A4" : "A5") : ""),
			(BaseName[0] ? "" : "UB"),
			(fD_GetFuncParNum(obj)==illegal ? "" : "FP"), -fD_GetOffset(obj));
		if (!vd)
			fprintf(outfile, "%s, ", rettype);
		fprintf(outfile, "%s, ", name);

		for (count=d0; count<numregs; count++)
		{
			chtmp=fD_GetRegStr(obj, count);
			if (a45 && (strcmp(chtmp, "a4")==0 || strcmp(chtmp, "a5")==0))
				chtmp="d7";
			fprintf(outfile, "%s, %s, %s%s", (fD_GetFuncParNum(obj)==count ?
				"__fpt" : fD_GetProto(obj, count)), fD_GetParam(obj, count),
				chtmp, (count==numregs-1 && !BaseName[0] ? "" : ", "));
		}

		if (BaseName[0]) /* was "##base" used? */
			fprintf(outfile, "\\\n\t, %s_BASE_NAME", BaseNamU);
		if (fD_GetFuncParNum(obj)!=illegal)
		{
			fprintf(outfile, ", ");
			fprintf(outfile, fD_GetProto(obj, fD_GetFuncParNum(obj)), "__fpt");
		}
		fprintf(outfile, ")\n\n");
	}
	else
	{
		fprintf(outfile, "%s__inline %s\n%s(%s",
			(output_mode==STUBS ? "" : "extern "), rettype, name,
			(BaseName[0] ? (numregs ? "BASE_PAR_DECL " : "BASE_PAR_DECL0") : ""));

		for (count=d0; count<numregs; count++)
		{
			chtmp=fD_GetProto(obj, count);
			if (fD_GetFuncParNum(obj)==count)
				fprintf(outfile, chtmp, fD_GetParam(obj, count));
			else
				fprintf(outfile, "%s%s%s", chtmp, (*(chtmp+strlen(chtmp)-1)=='*' ?
					"" : " "), fD_GetParam(obj, count));
			if (count<numregs-1)
				fprintf(outfile, ", ");
		}

		fprintf(outfile, ")\n{\n%s", (BaseName[0] ? "   BASE_EXT_DECL\n" : ""));
		if (!vd)
			fprintf(outfile, "   register %s%sres __asm(\"d0\");\n", rettype,
				(*(rettype+strlen(rettype)-1)=='*' ? "" : " "));

		if (BaseName[0])
			fprintf(outfile, "   register struct %s *a6 __asm(\"a6\") = BASE_NAME;\n",
				StdLib);

		for (count=d0; count<numregs; count++)
		{
			chtmp=fD_GetRegStr(obj, count);
			if (a45 && (strcmp(chtmp, "a4")==0 || strcmp(chtmp, "a5")==0))
				chtmp="d7";
			if (fD_GetFuncParNum(obj)==count)
			{
				fprintf(outfile, "   register ");
				fprintf(outfile, fD_GetProto(obj, count), chtmp);
				fprintf(outfile, " __asm(\"%s\") = %s;\n", chtmp, fD_GetParam(obj,
					count));
			}
			else
			{
				const char *proto=fD_GetProto(obj, count);
				fprintf(outfile, "   register %s%s%s __asm(\"%s\") = %s;\n",
					proto, (*(proto+strlen(proto)-1)=='*' ? "" : " "), chtmp,
					chtmp, fD_GetParam(obj, count));
			}
		}
		if (a45)
			fprintf(outfile, "   __asm volatile (\"exg d7,%s\\n\\t"
				"jsr a6@(-0x%lx:W)\\n\\texg d7,%s\"\n", (a45==4 ? "a4" : "a5"),
				-fD_GetOffset(obj), (a45==4 ? "a4" : "a5"));
		else
			fprintf(outfile, "   __asm volatile (\"jsr a6@(-0x%lx:W)\"\n",
				-fD_GetOffset(obj));

		fprintf(outfile, (vd ? "   : /* No Output */\n" : "   : \"=r\" (res)\n"));

		fprintf(outfile, "   : ");
		if (BaseName[0])
			fprintf(outfile, "\"r\" (a6)%s", (numregs ? ", ": ""));

		for (count=d0; count<numregs; count++)
		{
			chtmp=fD_GetRegStr(obj, count);
			if (a45 && (strcmp(chtmp, "a4")==0 || strcmp(chtmp, "a5")==0))
				chtmp="d7";
			fprintf(outfile, "\"r\" (%s)%s", chtmp, (count<numregs-1 ? ", " : ""));
		}
		fprintf(outfile, "\n   : \"d0\", \"d1\", \"a0\", \"a1\", \"fp0\", \"fp1\"");

		if (vd)
			fprintf(outfile, ", \"cc\", \"memory\");\n}\n\n"); /* { */
		else
			fprintf(outfile, ", \"cc\", \"memory\");\n   return res;\n}\n\n");
	}

	if ((tagname=aliasfunction(fD_GetName(obj)))!=0)
	{
		fprintf(outfile, "#define %s(", tagname);
		for (count=d0; count<numregs-1; count++)
			fprintf(outfile, "a%d, ", count);
		fprintf(outfile, "a%d) %s (", count, name);
		for (count=d0; count<numregs-1; count++)
			fprintf(outfile, "(a%d), ", count);
		fprintf(outfile, "(a%d))\n\n", count);
	}

	if ((tagname=taggedfunction(obj))!=0)
	{
		if (output_mode!=STUBS)
		{
			fprintf(outfile, "#ifndef NO_INLINE_STDARG\n#define %s(", tagname);

			for (count=d0; count<numregs-1; count++)
				fprintf(outfile, "a%d, ", count);

			fprintf(outfile, "tags...) \\\n\t({ULONG _tags[] = { tags }; %s(",
				name);

			for (count=d0; count<numregs-1; count++)
				fprintf(outfile, "(a%d), ", count);

			fprintf(outfile, "(%s)_tags);})\n#endif /* !NO_INLINE_STDARG */\n\n",
				fD_GetProto(obj, fD_RegNum(obj)-1));
		}
		else
		{
			fprintf(outfile, "%s %s(", rettype, tagname);

			for (count=d0; count<numregs-1; count++)
			{
				chtmp=fD_GetProto(obj, count);
				if (count==fD_GetFuncParNum(obj))
					fprintf(outfile, chtmp, fD_GetParam(obj, count));
				else
					fprintf(outfile, "%s%s%s", chtmp,
						(*(chtmp+strlen(chtmp)-1)=='*' ? "" : " "),
						fD_GetParam(obj, count));
				fprintf(outfile, ", ");
			}

			fprintf(outfile, "int tag, ...)\n{\n   ");
			if (!vd)
				fprintf(outfile, "return ");

			fprintf(outfile, "%s(", name);
			for (count=d0; count<numregs-1; count++)
				fprintf(outfile, "%s, ", fD_GetParam(obj, count));

			fprintf(outfile, "(%s)&tag);\n}\n\n", fD_GetProto(obj, fD_RegNum(obj)-1));
		}
	}

	if (strcmp(name, "DoPkt")==0)
	{
		fdDef *objnc=(fdDef*)obj;
		char newname[7]="DoPkt0";
		objnc->name=newname;
		for (count=2; count<7; count++)
		{
			regs reg=objnc->reg[count];
			char *proto=objnc->proto[count];
			objnc->reg[count]=illegal;
			objnc->proto[count]=fD_nostring;
			fD_write(outfile, objnc);
			objnc->reg[count]=reg;
			objnc->proto[count]=proto;
			newname[5]++;
		}
		objnc->name=(char*)name;
	}
}

int
varargsfunction(const char* proto, const char* funcname)
{
	const char *end=proto+strlen(proto)-1;
	while (isspace(*end))
		end--;
	if (*end--==';')
	{
		while (isspace(*end))
			end--;
		if (*end--==')')
		{
			while (isspace(*end))
				end--;
			if (!strncmp(end-2, "...", 3))
			{
				/* Seems to be a varargs function. Check if it will be recognized
					as "tagged". */
				unsigned int count;
				char fixedname[200]; /* Hope will be enough... */
				fdDef *tmpdef;

				for (count=0; count<sizeof TagExcTable/sizeof TagExcTable[0];
				count+=2)
					if (strcmp(funcname, TagExcTable[count+1])==0)
						return 1;

				if (!(tmpdef=fD_ctor()))
				{
					fprintf(stderr, "No mem for FDs\n");
					exit(EXIT_FAILURE);
				}

				strcpy(fixedname, funcname);
				if (strlen(funcname)>4 &&
				!strcmp(funcname+strlen(funcname)-4, "Tags"))
				{
					/* Might be either nothing or "TagList". */
					fixedname[strlen(fixedname)-4]='\0';
					fD_NewName(tmpdef, fixedname);
					if (bsearch(&tmpdef, arrdefs, fds, sizeof arrdefs[0],
					fD_cmpName))
						return 1;

					strcat(fixedname, "TagList");
					fD_NewName(tmpdef, fixedname);
					if (bsearch(&tmpdef, arrdefs, fds, sizeof arrdefs[0],
					fD_cmpName))
						return 1;
				}
				else
				{
					strcat(fixedname, "A");
					fD_NewName(tmpdef, fixedname);
					if (bsearch(&tmpdef, arrdefs, fds, sizeof arrdefs[0],
					fD_cmpName))
						return 1;
				}
			}
		}
	}
	return 0;
}

int
ishandleddifferently(const char* proto, const char* funcname)
{
	/* First check if this is a vararg call? */
	if (varargsfunction(proto, funcname))
		return 1;

	/* It might be a dos.library "alias" name. */
	if (aliasfunction(funcname))
		return 1;

	/* It might be one from dos.library/DoPkt() family. */
	if (strlen(funcname)==6 && !strncmp(funcname, "DoPkt", 5) &&
	funcname[5]>='0' && funcname[6]<='4')
		return 1;

	/* Finally, it can be intuition.library/ReportMouse1(). */
	return !strcmp(funcname, "ReportMouse1");
}

void
printusage(const char* exename)
{
	fprintf(stderr,
		"Usage: %s [options] fd-file clib-file [[-o] output-file]\n"
		"Options:\n"
		"--new\t\tpreprocessor based (default)\n"
		"--old\t\tinline based\n"
		"--stubs\t\tlibrary stubs\n"
		"--proto\t\tbuild proto files (no clib-file required)\n"
		"--version\tprint version number and exit\n", exename);
}

void output_proto(FILE* outfile)
{
	fprintf(outfile,
		"/* Automatically generated header! Do not edit! */\n\n"
		"#ifndef PROTO_%s_H\n"
		"#define PROTO_%s_H\n\n"
		"#include <clib/%s_protos.h>\n\n"
		"#ifdef __GNUC__\n"
		"#include <inline/%s.h>\n"
		"#endif /* __GNUC__ */\n\n",
		BaseNamU, BaseNamU, BaseNamL, BaseNamL);

	if (BaseName[0])
		fprintf(outfile,
			"#ifndef __NOLIBBASE__\n"
			"extern struct %s *\n"
			"#ifdef __CONSTLIBBASEDECL__\n"
			"__CONSTLIBBASEDECL__\n"
			"#endif /* __CONSTLIBBASEDECL__ */\n"
			"%s;\n"
			"#endif /* !__NOLIBBASE__ */\n\n",
			StdLib, BaseName);

	fprintf(outfile,
		"#endif /* !PROTO_%s_H */\n", BaseNamU);
}

/******************************************************************************/

int
main(int argc, char** argv)
{
	fdDef *tmpdef,			/* a dummy to contain the name to look for */
			*founddef;		/* the fdDef for which we found a prototype */
	fdFile *myfile;
	char *tmpstr;
	FILE *outfile;
	char *fdfilename=0, *clibfilename=0, *outfilename=0;

	int count;
	Error lerror;

	for (count=1; count<argc; count++)
	{
		char *option=argv[count];
		if (*option=='-')
		{
			option++;
			if (strcmp(option, "o")==0)
			{
				if (count==argc-1 || outfilename)
				{
					printusage(argv[0]);
					return EXIT_FAILURE;
				}
				if (strcmp(argv[++count], "-"))
					outfilename=argv[count];
			}
			else
			{
				if (*option=='-') /* Accept GNU-style '--' options */
					option++;
				if (strcmp(option, "new")==0)
					output_mode=NEW;
				else if (strcmp(option, "old")==0)
					output_mode=OLD;
				else if (strcmp(option, "stubs")==0)
					output_mode=STUBS;
				else if (strcmp(option, "proto")==0)
					output_mode=PROTO;
				else if (strcmp(option, "version")==0)
				{
					fprintf(stderr, "fd2inline version " VERSION "\n");
					return EXIT_SUCCESS;
				}
				else
				{
					printusage(argv[0]);
					return EXIT_FAILURE;
				}
			}
		}
		else
		{
			/* One of the filenames */
			if (!fdfilename)
				fdfilename=option;
			else if (!clibfilename)
				clibfilename=option;
			else if (!outfilename)
				outfilename=option;
			else
			{
				printusage(argv[0]);
				return EXIT_FAILURE;
			}
		}
	}

	if (!fdfilename || (!clibfilename && output_mode!=PROTO))
	{
		printusage(argv[0]);
		return EXIT_FAILURE;
	}

	if (!(arrdefs=malloc(FDS*sizeof(fdDef*))))
	{
		fprintf(stderr, "No mem for FDs\n");
		return EXIT_FAILURE;
	}
	for (count=0; count<FDS; count++)
		arrdefs[count]=NULL;

	if (!(myfile=fF_ctor(fdfilename)))
	{
		fprintf(stderr, "Couldn't open file '%s'.\n", fdfilename);
		return EXIT_FAILURE;
	}

	lerror=false;

	for (count=0; count<FDS && lerror==false; count++)
	{
		if (!(arrdefs[count]=fD_ctor()))
		{
			fprintf(stderr, "No mem for FDs\n" );
			return EXIT_FAILURE;
		}
		do
		{
			if ((lerror=fF_readln(myfile))==false)
			{
				fF_SetError(myfile, false);
				lerror=fD_parsefd(arrdefs[count], myfile);
			}
		}
		while (lerror==nodef);
	}
	if (count<FDS)
	{
		count--;
		fD_dtor(arrdefs[count]);
		arrdefs[count]=NULL;
	}
	fds=count;

	qsort(arrdefs, count, sizeof arrdefs[0], fD_cmpName);

	if (output_mode!=NEW)
	{
		unsigned int count2;
		StdLib="Library";

		for (count2=0; count2<sizeof LibExcTable/sizeof LibExcTable[0]; count2+=2)
			if (strcmp(BaseName, LibExcTable[count2])==0)
			{
				StdLib=LibExcTable[count2+1];
				break;
			}
	}

	fF_dtor(myfile);

	if (output_mode!=PROTO)
	{
		if (!(myfile=fF_ctor(clibfilename)))
		{
			fprintf(stderr, "Couldn't open file '%s'.\n", clibfilename);
			return EXIT_FAILURE;
		}

		if (!(tmpdef=fD_ctor()))
		{
			fprintf(stderr, "No mem for FDs\n");
			return EXIT_FAILURE;
		}

		for (lerror=false; lerror==false || lerror==nodef;)
			if ((lerror=fF_readln(myfile))==false)
			{
				fF_SetError(myfile, false); /* continue even on errors */
				tmpstr=fF_FuncName(myfile);

				if (tmpstr)
				{
				   fdDef **res;
					fD_NewName(tmpdef, tmpstr);
					res=(fdDef**)bsearch(&tmpdef, arrdefs, fds, sizeof arrdefs[0],
						fD_cmpName);

					if (res)
					{
						founddef=*res;
						DBP(fprintf(stderr, "found (%s).\n", fD_GetName(founddef)));
						fF_SetError(myfile, false);
						lerror=fD_parsepr(founddef, myfile);
					}
					else
						if (!ishandleddifferently(myfile->line, tmpstr))
							fprintf(stderr, "don't know what to do with <%s> in line %lu.\n",
								tmpstr, myfile->lineno);
					free(tmpstr);
				}
			}

		fD_dtor(tmpdef);

		fF_dtor(myfile);
	}

	if (strlen(fdfilename)>7 &&
	!strcmp(fdfilename+strlen(fdfilename)-7, "_lib.fd"))
	{
		char *str=fdfilename+strlen(fdfilename)-8;
		while (str!=fdfilename && str[-1]!='/' && str[-1]!=':')
			str--;
		strncpy(BaseNamL, str, strlen(str)-7);
		strncpy(BaseNamU, str, strlen(str)-7);
		BaseNamU[strlen(str)-7]='\0';
	}
	else
	{
		/* Shouldn't really happen, but... */
		strcpy(BaseNamU, BaseName);
		if (strlen(BaseNamU)>4 && strcmp(BaseNamU+strlen(BaseNamU)-4, "Base")==0)
			BaseNamU[strlen(BaseNamU)-4]='\0';
	}
	StrUpr(BaseNamU);

	if (outfilename)
	{
		if (!(outfile=fopen(outfilename, "w")))
		{
			fprintf(stderr, "Couldn't open output file.\n");
			return EXIT_FAILURE;
		}
	}
	else
		outfile=stdout;

	if (output_mode==PROTO)
		output_proto(outfile);
	else
	{
		fprintf(outfile,
			"/* Automatically generated header! Do not edit! */\n\n"
			"#ifndef _INLINE_%s_H\n"
			"#define _INLINE_%s_H\n\n"
			"%s\n\n", BaseNamU, BaseNamU, (output_mode==NEW ?
				"#ifndef __INLINE_MACROS_H\n"
				"#include <inline/macros.h>\n"
				"#endif /* !__INLINE_MACROS_H */" :
				"#ifndef __INLINE_STUB_H\n"
				"#include <inline/stubs.h>\n"
				"#endif /* !__INLINE_STUB_H */"));
		if (BaseName[0])
		{
			if (output_mode==NEW)
				fprintf(outfile,
					"#ifndef %s_BASE_NAME\n"
					"#define %s_BASE_NAME %s\n"
					"#endif /* !%s_BASE_NAME */\n\n",
					BaseNamU, BaseNamU, BaseName, BaseNamU);
			else
				fprintf(outfile,
					"#ifndef BASE_EXT_DECL\n"
					"#define BASE_EXT_DECL\n"
					"#define BASE_EXT_DECL0 extern struct %s *%s;\n"
					"#endif /* !BASE_EXT_DECL */\n"
					"#ifndef BASE_PAR_DECL\n"
					"#define BASE_PAR_DECL\n"
					"#define BASE_PAR_DECL0 void\n"
					"#endif /* !BASE_PAR_DECL */\n"
					"#ifndef BASE_NAME\n"
					"#define BASE_NAME %s\n"
					"#endif /* !BASE_NAME */\n\n"
					"BASE_EXT_DECL0\n\n", StdLib, BaseName, BaseName);
		}

		for (count=0; count<FDS && arrdefs[count]; count++)
		{
			DBP(fprintf(stderr, "outputting %ld...\n", count));

			fD_write(outfile, arrdefs[count]);
			fD_dtor(arrdefs[count]);
			arrdefs[count]=NULL;
		}

		if (output_mode==OLD || output_mode==STUBS)
			if (BaseName[0])
				fprintf(outfile,
					"#undef BASE_EXT_DECL\n"
					"#undef BASE_EXT_DECL0\n"
					"#undef BASE_PAR_DECL\n"
					"#undef BASE_PAR_DECL0\n"
					"#undef BASE_NAME\n\n");
		fprintf(outfile, "#endif /* !_INLINE_%s_H */\n", BaseNamU);
	}

	free(arrdefs);

	return EXIT_SUCCESS;
}
