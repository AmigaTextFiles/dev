#define _STRICT_ANSI

#include "defs.h"
#include "cazerrors.h"

/*#define DEBUG2 */	/* internal use for more debugging (print out coded MNE) */
/*#define DEBUG_STRTOINT*/  /* debug strtoint() funktion */


#define MODE_ALL	1		/* Verbose Mode: Print out all source text */
#define MODE_MNE	2		/* Verbose Mode: Print out only MNE text */
#define MODE_OPTION 4		/* if Verbose Mode is set via Commandline Option */

#define ACT_OBJ_ADDR(pobj) (((u_char *)(pobj->objbuffer+(pobj->actbyte-pobj->firstbyte))))

#define COPYRIGHT " ©1992-94 by Carsten Rose, Updated 2002 Chris Young\n"
const char *vers = "\0$VER: CAZM 1.27 (12.01.2002)";

extern char *directives[];		/* declared in File 'cazmne.c' */
extern struct command cmd[];	/* declared in File 'cazmne.c' */

static int 	   init				(struct listheader *plabel,struct objsize *pobj);
static void    symboltable		(struct listheader *plabel);
static int     writesymboltable	(struct listheader *plabel,char *filename);
static char   *ibtoh			(u_char byte,char *pbuf);
static char   *iwtoh			(unsigned short word,char *pbuf);
static void    decodearg		(char *str,u_long pa);
static int 	   strcmp_lany_rupper(char *pany,char *pupper);
static void    cutend			(char *pos);
static char   *skipspace		(char *pos);
static char    validquote		(char quote);
static void    killcomment		(char *pos);
static void    killcomment2		(char *pos,int cchar);
static int 	   expandlist		(struct listheader *plist);
static struct labelitem
			  *insertlabel		(struct listheader *plabel,char *name,int type,u_short value,BOOL valid);
static int 	   dolabel			(struct listheader *plabel,struct objsize *pobjcode,char   *lname);
static int 	   finddirective	(char *pos);
static struct command
			  *findmne			(struct command *pcmd,char *pmne);
static u_long  argtype			(struct listheader *plabel,char *pos,u_short *pshort,int mode);
static int 	   doobjadr			(struct objsize *pobj,int n,int mode);
static u_char  codebits			(u_long mask);
static int 	   writemnedata		(struct objsize *pobj,u_long maskarg,u_short val,u_long maskcmd,u_char pos);
static int 	   fillihbuffer		(int addr,int nbytes,u_char *pbuf);
static int 	   dointelhex		(int addr,int size,u_char *data);
static int 	   makecode			(struct objsize *pobj,struct command *pcmd,int mode,u_long type1,u_short val1,u_long type2,u_short val2);
static int 	   domne			(struct listheader *plabel,struct objsize *pobj,char *ptok,int mode,u_short *pcycle);
static int	   pushfile		    (struct item_file **pstack,char *p_filenamenew,FILE **p_fp);
static int	   popfile			(struct item_file **pstack,FILE **p_fp);
static int 	   setdefaultbase	(char *pbase);
static int 	   dodirective		(struct listheader *plabel,struct objsize *pobj,char *ptok,int direc,int mode,int *orgflag);
static int 	   parseline		(struct listheader *plabel,struct objsize *pobj,char *pwork,int mode);
static int 	   readsrc			(struct listheader *plabel,struct objsize *pobj,char *p_actname);

int            main             (int argc,char *argv[]);

int 	lnr=0,errors=0,
		debugv=FALSE,			/* debug values, set via Commandline option */
		debugf=FALSE,			/* debug functions, set via Commandline option */
		verbose=FALSE,			/* set via Commandline option */
		intelhex=FALSE,			/* set via Commandline option */
		clockcycle=FALSE,		/* set via Commandline option */
		showsymbols=FALSE,		/* set via Commandline option */
      default_num_base;		/* change via DEFNUM directive */
char	errortext[BUFSIZ],		/* Common Buffer for Error Messages */
		line[BUFSIZ],			/* Actual read Source text line (original) */
		work[BUFSIZ],			/* Actual read Source text line (truncated,modified) */
		actfilename[FILENAME_MAX]; /* Actual Filename of assembled Source File */

struct	listheader  ih_head;
struct	listheader label;
struct	objsize    object;
struct  item_file	*file_stack=NULL;

BOOL	endflag=FALSE,			/* Set if END is found */
		assembleflag=TRUE;		/* Normal TRUE, only if 'COND xx' xx==0 then FALSE */
FILE 	*fpin=NULL,*fpout=NULL;


static void showerror(char *errpos, char *fmt , ...)
{
    /*
     * Print parsing error:
     *
     *   xxxx:........................
     *              ^
     *   'Error Description'
     */

        int i;
        va_list pa;
        char buffer[BUFSIZ];

	if(debugf)  puts("showerror");

		/* If there are more than 1 source files - print Filenames */
	if(file_stack)
		fprintf(stderr,"Error in File:%s\n",actfilename);

	fprintf(stderr,"%4d:%s",lnr,line);		/* line number and Source code line */

	i = strlen(line);

	if(!i)				/* not really needed */
		return;

	if(line[i-1]!='\n')
		fputs("\n",stderr);

	if(!errpos)
		errpos=work;

	i = (int)(errpos - work);

	buffer[i]='\0';

	while(i--)
	{
		if(line[i]=='\t')
			buffer[i]='\t';
		else
			buffer[i]=' ';
	}

	fprintf(stderr,"     %s^ ",buffer);		/* mark position */

    va_start(pa,fmt);
	vfprintf(stderr,fmt,pa);				/* Print Errormessage */
	va_end(pa);
	fputs("\n",stderr);
	errors++;						/* count errors */
}

static int init(struct listheader *plabel,struct objsize *pobj)
{
	/*
	 * Init listheader
	 *
	 * RC : NULL if all went fine
	 */


	if(debugf)  puts("init");

	plabel->nitem = 0;
	plabel->actitem = 0;
	plabel->sizeitem = sizeof(struct labelitem);
	plabel->newnitem = NEWITEMOFF;
	plabel->userdata = ERROR;
	plabel->list = NULL;

	ih_head.nitem = 0;
	ih_head.actitem = 0;
	ih_head.sizeitem = sizeof(u_char);
	ih_head.newnitem = 4096;
	ih_head.userdata = ERROR;
	ih_head.list = NULL;

	pobj->firstbyte = ERROR;
	pobj->actbyte   = ERROR;
	pobj->lastbyte  = ERROR;
	pobj->objbuffer = NULL;

	return(NULL);
}

static void symboltable(struct listheader *plabel)
{
	int i;
	struct labelitem *lst;
	char *pltyp;

	if(debugf)  puts("symboltable");

	lst = plabel->list;
	i   = plabel->actitem;
	puts("Lable's:");

	while(i--)
	{
		switch(lst->type)
		{
			case L_EQU:		pltyp = "EQU";
							break;
			case L_DEFL:	pltyp = "DEFL";
							break;
			case L_POSITION:
							pltyp = "POSITION";
							break;
			default:		pltyp = "unknown";
							INTERNAL_ERROR
							break;
		}

	    printf("Name:%-32s  Type:%-8s  Value:0x%X\n",lst->name,pltyp,lst->value);
	    lst++;
	}
}

static int writesymboltable(struct listheader *plabel,char *filename)
{
	/* Write all Labels as EQU definition's with associated values into
     * 'filename'
	 *
	 * RC: NULL if all went fine else
	 *     ERROR
	 */

	int i;
	struct labelitem *lst;
	FILE   *fplabel;

	if(debugf)  puts("writesymboltable");

	lst = plabel->list;
	i   = plabel->actitem;

	if(!(fplabel = fopen(filename,"wb")))	/* open file where to write Label's */
	{
		perror("Can't open file:");
		return(ERROR);
	}

	while(i--)
	{
		if(fprintf(fplabel,"%-32s EQU 0x%X\n",lst->name,lst->value)<0)
		{
			perror("Writing Labelfile failed");
			fclose(fplabel);
			return(ERROR);
		}
	    lst++;
	}

	fclose(fplabel);

	return(NULL);
}


static char *ibtoh(unsigned char byte,char *pbuf)
{
	/* Convert 'byte' in ASCII Hex Notation.
	 *
	 * Write ASCII Hex Code (2 Chars) at '*pbuf'.
	 *
	 * RC: pbuf+2    (points to next free char)
     */

	unsigned char 	low,	/* low 4 Bits of 'byte' */
			high;	/* high 4 Bits of 'byte' (normalized) */

	low = 0x0F&byte;
	high = (0xF0&byte)>>4;

	/* convert Integer to ASCII Hex */
	*pbuf++= (high<=9) ? high+'0' : (high-0x0A)+'A';
	*pbuf++= (low<=9) ? low+'0' : (low-0x0A)+'A';

	return(pbuf);
}

static char *iwtoh(u_short word,char *pbuf)
{
	/* Convert 'word' in ASCII Hex Notation.
	 *
	 * Write ASCII Hex Code (4 Chars) at '*pbuf'.
	 *
	 * RC: pbuf+4    (points to next free char)
     */

	char *pos;
	u_char lowb,highb;

	lowb = (u_char)(word & 0xFF);
	highb = (u_char)(word >> 8);

	pos=ibtoh(highb,pbuf);
	pos=ibtoh(lowb,pos);

	return(pos);
}

static void decodearg(char *str,u_long pa)
{
	char pos[256];

	if(debugf)  puts("decodearg");

	pos[0]='\0';

	if( (pa^BRA)&BRA)
	{
		if(!( (pa&REG8)^REG8))
			strcat(pos,"REG8   ");
		else if(!( (pa&REG16)^REG16))
			strcat(pos,"REG16  ");
		else
		{
			if(pa&REG_A)  strcat(pos,"REG_A  ");
			if(pa&REG_B)  strcat(pos,"REG_B  ");
			if(pa&REG_C)  strcat(pos,"REG_C  ");
			if(pa&REG_D)  strcat(pos,"REG_D  ");
			if(pa&REG_F)  strcat(pos,"REG_F  ");
			if(pa&REG_H)  strcat(pos,"REG_H  ");
			if(pa&REG_I)  strcat(pos,"REG_I  ");
			if(pa&REG_L)  strcat(pos,"REG_L  ");
			if(pa&REG_R)  strcat(pos,"REG_R  ");
			if(pa&REG_AF) strcat(pos,"REG_AF ");
			if(pa&REG_BC) strcat(pos,"REG_BC ");
			if(pa&REG_DE) strcat(pos,"REG_DE ");
			if(pa&REG_HL) strcat(pos,"REG_HL ");
			if(pa&REG_SP) strcat(pos,"REG_SP ");
			if(pa&REG_IX) strcat(pos,"REG_IX ");
			if(pa&REG_IY) strcat(pos,"REG_IY ");
		}
	}
	else if(pa&BRA)
	{
		if(!( (pa & BRANCH8) ^ BRANCH8))
			strcat(pos, "BRA8  ");
		else if(!( (pa & BRANCH8) ^ BRANCH4))
			strcat(pos, "BRA4  ");
		else
		{
			if(pa&BRA_Z )  strcat(pos,"BRA_Z  ");
			if(pa&BRA_NZ)  strcat(pos,"BRA_NZ ");
			if(pa&BRA_C )  strcat(pos,"BRA_C  ");
			if(pa&BRA_NC)  strcat(pos,"BRA_NC ");
			if(pa&BRA_PO)  strcat(pos,"BRA_PO ");
			if(pa&BRA_PE)  strcat(pos,"BRA_PE ");
			if(pa&BRA_P )  strcat(pos,"BRA_P  ");
			if(pa&BRA_M )  strcat(pos,"BRA_M  ");
		}
	}
	if(pa&IND	)
		strcat(pos,"IND	 ");
	if(pa&UNM3	)
		strcat(pos,"U3	 ");
	if(pa&UNM8	)
		strcat(pos,"U8   ");
	if(pa&UNM16	)
		strcat(pos,"U16  ");
	if(pa&OFF	)
		strcat(pos,"OFF	 ");

	if(pa&RST	)
		strcat(pos,"RST	 ");
	if(pa&JMPREL	)
		strcat(pos,"JMPR ");


	if(! ((pa&IMODE2)^IMODE0))
		strcat(pos,"IMODE0 ");
	if(! ((pa&IMODE2)^IMODE1))
		strcat(pos,"IMODE1 ");
	if(! ((pa&IMODE2)^IMODE2))
		strcat(pos,"IMODE2 ");

	fprintf(stderr,"%s:%s\n",str,pos);
}

/*
static int prtallcmd()
{
	struct command *pcmd;
	char par1[BUFSIZ],par2[BUFSIZ];

	if(debugf)  puts("prtallcmd");

	pcmd = cmd;
	while(pcmd->name)
	{
		par1[0] = par2[0] = '\0';
		fprintf(stderr,"MNE:%s | %s , %s | LE:%X | BY:%d BI:%d , BY:%d BI:%d | %X %X %X %X\n",
				pcmd->name,
				decodearg(pcmd->pa1,par1),
				decodearg(pcmd->pa2,par2),
				MNELEN(pcmd->order1),
				BYTE(pcmd->order1),BIT(pcmd->order1),
				BYTE(pcmd->order2),BIT(pcmd->order2),
				pcmd->obj[0],pcmd->obj[1],pcmd->obj[2],pcmd->obj[3]);
		pcmd++;
	}
}
*/


/*
 * Translate first String to upper and compare with second string.
 * RC: NULL if they identical, else
 *     !=NULL if they differ.
 */
static int strcmp_lany_rupper(char *pany,char *pupper)
{
	int i=0;
	char c;

	while( pupper[i])
	{
		c = toupper(pany[i]);

		if(pupper[i]!=c)
			return(c-pupper[i]);

		i++;
	}

	return(pany[i]);
}


static void  cutend(char *pos)
{
	/*
	 *	Remove spaces/CR from end of String
	 *
	 *	No RC
	 */

	int n;
	char *tmp;

	if(debugf)  puts("cutend");

	if(!pos)
		INTERNAL_ERROR

	n   = strlen(pos);

	if(!n)
		return;

	tmp = pos + n - 1;

	while(n-- && ((isspace(*tmp))||(*tmp=='\n')) )
		*tmp--='\0';
}

static char *skipspace(char *pos)
{
	/*
	 *	Skip spaces at top of String
	 *
	 *	Pointer to start of string ,or
	 *	NULL if the string only contains spaces
	 */

	if(debugf)  puts("skipspace");

	while( *pos && isspace(*pos) )
		pos++;

	if(*pos)
		return(pos);
	else
		return(NULL);
}

static char validquote(char quote)
{
	/*
	 *  Check if 'quote' is a valid Z80 Assemnler quote delimiter.
	 *
	 *  RC: 'quote' if it's valid, else
	 *       NULL
	 */

	switch(quote)
	{
		case '\'':
		case '"':
		case '/': return(quote);

		default : return((char)NULL);
	}
}

static void killcomment(char *pos)
{
	/*
	 *	Look for a comment token ( ';'  ) and replace it with '\0'.
	 * Hashes are now also comments...
	 *	No RC
	 */

	killcomment2(pos,';');
	killcomment2(pos,'#');
}

static void killcomment2(char *pos,int cchar)
{
	char *comment;
	char *pt1;	/* take care that's ';' isn't inside a Text definition */

	if(debugf)  puts("killcomment");

	if(!(comment=strchr(pos,cchar)))
	return; 	/* No Commentsign found - do nothing */

	if(!(pt1=strpbrk(pos,"\'\"/")))
	{
		*comment='\0';
		return;
	}

	if(pt1>comment)
	{
		*comment='\0';
		return;
	}

	if(pt1=strchr(pt1+1,*pt1))
	{
		killcomment(pt1+1);
		return;
	}

	*comment='\0';
}

struct labelitem *getlabel(struct listheader *plabel,char *name)
{
	/*
	 *	Search for the label 'name' in label list.
	 *
	 *  RC = if 'name' found, a pointer to the item , else
	 *       NULL
	 */

	int n,i;
	struct labelitem *pitem;
	static struct labelitem ad_cnt = {0,TRUE,L_POSITION,"$"};  /* Simulate Address Counter Label */

	if(debugf)  puts("getlabel");

	if( (strlen(name)==1) && (*name == '$'))
	{
		ad_cnt.value = object.actbyte; /* set actual Address Counter */
		return(&ad_cnt);
	}

	n = plabel->actitem;						/* get count of items */
	pitem = (struct labelitem *)plabel->list;	/* get first item */

	for(i=0;i<n;i++,pitem++)					/* check all items */
	{
		if(!(strcmp(name,pitem->name)))			/* compare 'name' with item */
			return(pitem);						/* Success */
	}
	return(NULL);								/* Failed */
}

static int expandlist(struct listheader *plist)
{
	/*
	 * Increase table size. Delta Increase and old table are specified
     * in struct 'listheader'
     *
     * RC: NULL if OK
     *     SERIOUS if realloc fails
     */

	if(debugf)  puts("expandlist");

					/* expand table */
	if(plist->list)
	{
		if(!(plist->list=realloc(plist->list,(plist->newnitem+plist->nitem) * plist->sizeitem )))
		{
			fputs("Can't allocate memory for table\n",stderr);
			return(SERIOUS);
		}
	}
	else
	{
		if(!(plist->list=malloc(plist->newnitem * plist->sizeitem)))
		{
			fputs("Can't allocate memory for table\n",stderr);
			return(SERIOUS);
		}
	}

    plist->nitem += plist->newnitem;	/* actualize count of tableitems */

	return(NULL);
}

static struct labelitem *insertlabel(struct listheader *plabel,char *name,int type,u_short value,BOOL valid)
{
	/*
	 *	Insert a new item in list.
	 *
	 *	RC:	Pointer to new list element, or
	 *		SERIOUS if expandlist() failed
	 */

	struct labelitem *pitem;

	if(debugf)  puts("insertlabel");

	if(plabel->actitem >= plabel->nitem)
		if(expandlist(plabel))
			return((struct labelitem*)SERIOUS);

	pitem = (struct labelitem *)plabel->list + plabel->actitem;
	strcpy(pitem->name,name);
	pitem->type = type;
	if(pitem->valid = valid)
		pitem->value = value;
	else
		pitem->value = 0xFFFF;
	(plabel->actitem)++;

	return(pitem);
}

static int dolabel(struct listheader *plabel,struct objsize *pobjcode,char   *lname)
{
	/*
	 * Search for a label. 'pline' must point to supposed label without append ':'.
	 * Insert label name and it's objectcode position in list 'label'.
	 *
	 *	An error can occure in some of the follwing conditions:
	 *	  if -	the name is too long (MAXLABEL),
	 *			declared twice,
	 *			declared before any objectcode adress is set
	 *
	 * 	RC: NULL if all went fine, else
	 *		ERROR if any described error ocured, or
	 *		SERIOUS if insertlabel() failed
	 */

	if(debugf)  puts("dolabel");

	if(strlen(lname)>MAXLABEL)
	{
		showerror(lname,LABEL_TOO_LONG,MAXLABEL);
		return(ERROR);
	}

	if(getlabel(plabel,lname))
	{
		showerror(lname,LABEL_DECL_TWICE);
		return(ERROR);
	}

	if(pobjcode->firstbyte == ERROR)
	{
		showerror(lname,NO_ORG);
		return(ERROR);
	}
	    /* insert label item in list */
	if((int)insertlabel(plabel,lname,L_POSITION,(u_short)pobjcode->actbyte,TRUE) == SERIOUS)
		return(SERIOUS);
	else
		return(NULL);
}

static int finddirective(char *pos)
{
	/*
	 * compare 'pos' with all directives
	 *
	 * RC: indize of directive, or
     *     ERROR if not found
     */

	int i;

	if(debugf)  puts("finddirective");

	i= -1;
	while(directives[++i])		/* determine directive type */
	{
		if(!strcmp_lany_rupper(pos,directives[i]))
			return(i);
	}
	return(ERROR);
}

static struct command *findmne(struct command *pcmd,char *pmne)
{
	/*
	 *	Compare 'pmne' with Mnemomics. Starts at 'pcmd'.
	 *
	 *	RC: Pointer to command structure or
	 *		NULL if nothing found.
	 */

	if(debugf)  puts("findmne");

	while(pcmd->name && strcmp_lany_rupper(pmne,pcmd->name) )	/* search token in 'command' array */
		pcmd++;

	if(!pcmd->name)
		return(NULL);		/* sorry nothing found */
	else
		return(pcmd);
}

int strtoint(struct listheader *plabel,char *pstr,u_short *pu_short,int mode)
{
	/*
	 *	Convert 'pos' to a u_short. 'pos' could be a value , with one of the
	 *  following Syntax:
	 *		- binary      : % at the beginning or b/B at the end
	 *		- octal       : o/O at the end
	 *		- decimal     : without any special character or d/D at the end
	 *		- hexadecimal : x/X/0x/0X/#/$ at the beginning or h/H at the end
     *      - $           : Address Counter
	 *  Or 'pos' could be a symbol name (constant definition) - so substitute them.
	 *
	 *  RC : NULL if the substitution were successfully
	 *       ERROR else
	 */

	char *tail,work[BUFSIZ],*pos;
	int len,base=0,tmp=0,extension=FALSE;
	struct labelitem *pitem;

	if(debugf)  puts("strtoint");

	strcpy(work,pstr);
	pos = work;

	if(!(len=strlen(pos)))	/* a zerolength word is wrong Parameter */
		return(ERROR);

	if( strpbrk(pos,"+-*/()"))	/* mathematical expression ? */
	{
		tmp = calcexpr(plabel,pos,pu_short);

		if(mode==PARSE2)
			return(tmp);
		else
			return(NULL);
	}

		/* Is there an ASCII char ? */
	if(validquote(*pos))
	{
		if(pos[0]==pos[2])	/* must be quoted like '?' , "?" or /?/ */
		{
			*pu_short=(u_short)pos[1];
			return(NULL);
		}
	}

	if(pitem=getlabel(plabel,pos))	/* is the word a label ? */
	{
		if(mode == PARSE2)
		{
			if(!(pitem->valid))
				return(ERROR);	/* Label exist, but is invalid */
		}
		*pu_short = pitem->value;
		return(NULL);
	}

	if(len==1)				/* length =1 -> must be a decimal value */
	{
		if(!isdigit(*pos))	/* value ? */
			return(ERROR);	/*  NO, so no number (perhaps a Register)*/
	}

	switch(pos[len-1])				/* are there any known extensions ? */
	{
/* I've taken this bit out because it is looked for below anyway, and this doesn't have enough exclusions ***
		case 'b':   	* A 'b' at the end could also be be a HEX 'b': check this *
		case 'B': if( toupper(pos[0])=='X' || ( (pos[0]=='0') && (toupper(pos[1])=='X')) )
                  {
                    base = 16;
                    tmp = 2;
                  }
				  else
				  {
				  	extension=TRUE;
				    base = 2;
				  }
				  break;
*/
		case 'o':
		case 'O': base = 8;
				  extension=TRUE;
				  break;
		case 'h':
		case 'H': base = 16;
				  extension=TRUE;
				  break;
	}


#ifdef DEBUG_STRTOINT
	if(base)
		fprintf(stderr,"strtoint(): base=%d\n",base);
#endif

	if(!base)
	{								/* no extensions found, so look at the beginning */
		switch(pos[0])
		{
			case '$' :
			case '#' :
			case 'x' :
			case 'X' : 	base = 16;
					   	tmp = 1;
					   	break;
			case '0' : 	if( pos[1] == 'x' || pos[1] == 'X')
					   	{
					   		base = 16;
					   		tmp = 2;
					   	}
					   	break;
			case '%' :	base = 2;
						tmp = 1;
						break;
			default	 : 	if(toupper(pos[len-1])=='B')
							base = 2;
						break;
		}
	}

	if(extension)
		pos[--len]='\0';			/* cut the extension */

	if(!base)
		base = default_num_base; /* no base specified -> take default */

#ifdef DEBUG_STRTOINT
	fprintf(stderr,"strtoint(): base=%d, number=%s\n",base,&pos[tmp]);
#endif

	if(!(*pu_short=(u_short)strtol(&pos[tmp],&tail,base)))	/* convert */
    {
		while(tmp<len)				/* NULL -> there could be a failure */
		{
			if(pos[tmp++]!='0')		/* if one char is not 0, that's a failure */
				return(ERROR);
		}
	}
	return(NULL);					/* all went fine */
}

static u_long argtype(struct listheader *plabel,char *pos,u_short *pu_short,int mode)
{
	/*
	 *	Check type of 'pos' and fill 'pu_short' with data.
	 *
	 *a)pos= numeric value => set pu_short to value
	 *  pos= constant definition => set pu_short to value of constant
	 *  pos= numeric expression  => set pu_short to result of expression
     *
	 *b)pos is enclosed in brackets: => pos is 'IND'
	 *  pos is a 16-Bit Register
	 *  all other like a)
	 *
	 *c)pos (with or without 'IND') is IX,IY with '+' Offset, set OFF.
     *  calculate Offset like an expression in a)
	 *
	 *	RC: Parameter type of 'pos', or
	 *		NULL if not found.
	 */

	u_long flag = 0L;
	int  len;
	char *poff,work[BUFSIZ],*pwork;

	if(debugf)  puts("argtype");

	strcpy(work,pos);
	pwork=work;

	cutend(pwork);							/* remove trailing spaces */
	if(work[0] == '(')							/* could it be indirekt ? */
	{
		len=strlen(work);
		if( work[len-1] != ')'  )	/* look for closing bracket */
		{
			showerror(pos+len-1,NO_CLOSE_BRACKET);
			return(NULL);
		}

		work[len-1] = '\0';			/* delete end bracket from String */
		cutend(pos);				/* remove trailing spaces */

		if(!(pwork=skipspace(&pwork[1])))/* skip start bracket and leading spaces */
		{
			showerror(pos,NO_EXPR_INSIDE);
			return(NULL);
		}
		flag |= IND;						/* remark INDIREKT		*/
#ifdef DEBUG2
	fprintf(stderr,"Argument:'%s' is Indirekt, work continued with:'%s'\n",pos,pwork);
#endif
	}

	if(poff=strchr(pwork,'+'))				/* look for an offset */
	{
		*poff='\0';
		cutend(pwork);
		if(!strcmp_lany_rupper(pwork,"IX"))
		   flag|=REG_IX|OFF;
		else if(!strcmp_lany_rupper(pwork,"IY"))
		   flag|=REG_IY|OFF;
		else
		{	/* No Offset expression, so restore all */
			strcpy(work,pos);
			if(flag&IND)
			{
				pwork=skipspace(&work[1]);
				work[strlen(work)-1]='\0';
				cutend(pwork);
			}
			else
				pwork = work;
		}
		if(flag&OFF)
			if(!(pwork=skipspace(poff+1)))
			{
				showerror(pos,NO_EXPR_FOLLOWED);
				return(NULL);
			}
	}

/* negative offsets are people too */

	if(poff=strchr(pwork,'-'))				/* look for an offset */
	{
		*poff='\0';
		cutend(pwork);
		if(!strcmp_lany_rupper(pwork,"IX"))
		   flag|=REG_IX|OFF;
		else if(!strcmp_lany_rupper(pwork,"IY"))
		   flag|=REG_IY|OFF;
		else
		{	/* No Offset expression, so restore all */
			strcpy(work,pos);
			if(flag&IND)
			{
				pwork=skipspace(&work[1]);
				work[strlen(work)-1]='\0';
				cutend(pwork);
			}
			else
				pwork = work;
		}
		if(flag&OFF)
			if(!(pwork=skipspace(poff+1)))
			{
				showerror(pos,NO_EXPR_FOLLOWED);
				return(NULL);
			}
	}

		/* Check if it's an integer (or Label - substitute them) */
	if(!strtoint(plabel,pwork,pu_short,mode))	/* Integer, so check the size */
	{
		if(debugv) fprintf(stderr,"partype: ARG:%s VALUE:%d\n",pwork,*pu_short);

		flag|=NBR|UNM16|UNM8|UNM3|RST;			/* set No Branch */
		if(*pu_short > 255)
			flag &= ~(UNM8|UNM3|RST);
		else if(*pu_short > 7  )
			flag &= ~UNM3;
		else
		{
			switch(*pu_short)		/* needed for Mnemomic 'IM 0/1/2' */
			{
				case 0: flag|=IMODE0; break;
				case 1: flag|=IMODE1; break;
				case 2: flag|=IMODE2; break;
			}
		}
			/* check if is Offset < 256 */
		if( (flag&OFF) && (*pu_short>255))
		{
			showerror(pos,OFFSET_OUT_OF_RANGE);
			return(NULL);
		}
	}

	if(!(flag&~IND)) /* Until yet nothing found -> check if it is a Register/Branch */
	{
		*pwork = toupper(*pwork);
		len  = strlen(pwork);

		/* kludge to allow AF' etc registers */
		if(len==3)
		{
			if(pwork[2]=='\'') len=2;
		}

		switch(len)
		{
		case 1:
			switch(*pwork)
			{
				case 'A': flag |= REG_A|NBR; break;
				case 'B': flag |= REG_B|NBR; break;
				case 'C': flag |= REG_C|NBR|BRA; break;
				case 'D': flag |= REG_D|NBR; break;
				case 'E': flag |= REG_E|NBR; break;
				case 'F': flag |= REG_F|NBR; break;
				case 'H': flag |= REG_H|NBR; break;
				case 'I': flag |= REG_I|NBR; break;
				case 'L': flag |= REG_L|NBR; break;
				case 'M': flag |= BRA_M|BRA; break;
				case 'P': flag |= BRA_P|BRA; break;
				case 'R': flag |= REG_R|NBR; break;
				case 'Z': flag |= BRA_Z|BRA; break;
				default: 	showerror(pos,UNKNOWN_OPTION);
							return(NULL);
			}
			break;

		case 2:
			pwork[1] = toupper(pwork[1]);
			switch(pwork[0])
			{
				case 'A':	if( pwork[1]=='F' ) flag |= REG_AF|NBR; else flag=U_ERROR; break;
				case 'B': 	if( pwork[1]=='C' ) flag |= REG_BC|NBR; else flag=U_ERROR; break;
				case 'D': 	if( pwork[1]=='E' ) flag |= REG_DE|NBR; else flag=U_ERROR; break;
				case 'H': 	if( pwork[1]=='L' ) flag |= REG_HL|NBR; else flag=U_ERROR; break;
				case 'I': 	if( pwork[1]=='X' ) flag |= REG_IX|NBR; else
							if( pwork[1]=='Y' ) flag |= REG_IY|NBR; else flag=U_ERROR; break;
				case 'N': 	if( pwork[1]=='C' ) flag |= BRA_NC|BRA; else
							if( pwork[1]=='Z' ) flag |= BRA_NZ|BRA; else flag=U_ERROR; break;
				case 'P': 	if( pwork[1]=='O' ) flag |= BRA_PO|BRA; else
							if( pwork[1]=='E' ) flag |= BRA_PE|BRA; else flag=U_ERROR; break;
				case 'S': 	if( pwork[1]=='P' ) flag |= REG_SP|NBR; else flag=U_ERROR; break;
				default: 	showerror(pos,SYNTAX_ERROR);
							return(NULL);
			}
			break;

		default: if(mode==PARSE1)
					return(flag|UNM16|UNM8|UNM3|NBR);
				 else
				 {
					showerror(pos,UNKNOWN_ARG);
					return(NULL);
				 }
		}
	}
	if(!flag)
		flag=NOPAR;	/* no flag -> NOPAR */

	return(flag);
}

static int doobjadr(struct objsize *pobj,int n,int mode)
{
	/*
	 *	Set virtual objectbuffer position.
	 *
	 *	RC: NULL if all went fine, else
	 *		ERROR if 'n' < 0 or
	 * 			 'mode' == OBJADREL && pobj->firstbyte == ERROR
	 */

	if(debugf)  puts("doobjadr");

	if(n < 0)
	{
		fprintf(stderr,"Internal ERROR.  LINE=%d\nObject Adress %d corrupt (mode=%s)",__LINE__,n,(mode==OBJADABS) ? "OBJADABS" : "OBJADREL");
		return(ERROR);
	}

	switch(mode)
	{
		case OBJADABS:	if(pobj->firstbyte == ERROR)
						{
							pobj->firstbyte = n;
							pobj->actbyte   = n;
							pobj->lastbyte  = n;
							break;
						}
						else if (pobj->firstbyte >= n)
						{
							pobj->firstbyte = n;
							pobj->actbyte   = n;
							break;
						}
						else if (pobj->firstbyte < n)
						{
							pobj->actbyte   = n;
							if (pobj->lastbyte < n)
								pobj->lastbyte   = n;
							break;
						}
						else
							INTERNAL_ERROR
						break;
		case OBJADREL:	if(pobj->firstbyte == ERROR)
						{
							showerror(work,NO_ORG);
							return(ERROR);
						}
						pobj->actbyte += n;
						if(pobj->actbyte > pobj->lastbyte)
							pobj->lastbyte = pobj->actbyte;
						break;
		default:		INTERNAL_ERROR
						return(ERROR);
	}
	return(NULL);
}

static u_char codebits(u_long mask)
{
	u_char code=0;

	if(debugf)  puts("codebits");

	if(mask&BRA)
	{
		switch(mask&BRANCH8)
		{
			case BRA_NZ	: code = 0; break;
			case BRA_Z	: code = 1; break;
			case BRA_NC	: code = 2; break;
			case BRA_C	: code = 3; break;
			case BRA_PO	: code = 4; break;
			case BRA_PE	: code = 5; break;
			case BRA_P	: code = 6; break;
			case BRA_M 	: code = 7; break;
			default		: INTERNAL_ERROR
		}
	}
	else if(mask&NBR)
	{
		switch(mask&REG)
		{
			case REG_A	: code = 7; break;
			case REG_B	: code = 0; break;
			case REG_C	: code = 1; break;
			case REG_D	: code = 2; break;
			case REG_E	: code = 3; break;
			case REG_H	: code = 4; break;
			case REG_L	: code = 5;	break;

			case REG_BC	: code = 0; break;
			case REG_DE	: code = 1; break;
			case REG_HL	: code = 2; break;
			case REG_SP	: code = 3; break;

			case REG_F	:
			case REG_I	:
			case REG_R	:
			case REG_AF	:
			case REG_IX	:
			case REG_IY	: code = 0;
						  INTERNAL_ERROR
						  break;
			default		: code = 0;
						  INTERNAL_ERROR
		}
	}
	else
		INTERNAL_ERROR

	return(code);
}

static int writemnedata(struct objsize *pobj,u_long maskarg,u_short val,u_long maskcmd,u_char pos)
{
	/*
	 *	Write coded Data to Objectbuffer.
	 *
	 *	-Calculate adress of byte of objectbuffer.
	 *	-If 'maskcmd' is UNM16, write a Word in Lo/Hi order .
	 *	-If 'maskcmd' is UNM8, write a Byte.
	 *	-If 'maskcmd' is bit coded , determine bit position and write.
	 *
	 *	RC:	NULL if all went fine , else
	 *		ERROR
	 */

	u_char *tmpobj,code=0;
	int off;

	if(debugf)  puts("writemnedata");

#	ifdef DEBUG2
		fprintf(stderr,"--- pos:%X\n",pos);
#	endif

	if(NOE & pos)
		return(NULL);

	tmpobj = ACT_OBJ_ADDR(pobj) + BYTE(pos);

	if(maskarg&maskcmd&UNM16)
	{
		if(maskcmd&JMPREL)			/* UNM16 only set to generate jmp offset */
		{
			off=val - pobj->actbyte-2;	/* Destination - Source */
			if( off>129 || off<-126)	/* jmp not to big ? */
			{
				showerror(NULL,JUMP_NOT_RANGE);
				return(ERROR);
			}
			*tmpobj=(char)off;
			return(NULL);
		}
		else
		{
			*tmpobj++ = LOBYTE(val);	/* write LO Byte */
			*tmpobj   = HIBYTE(val);	/* write HI Byte */
			return(NULL);
		}
	}
	if(maskcmd & RST)
	{
		code= val & 0x38;	/* extract RST bits */
		if(code^(u_char)val)
		{
			showerror(NULL,ILLEGAL_RST);
			return(ERROR);
		}
		*tmpobj |= (code>>3)<<BIT(pos);
		return(NULL);
	}

	if( (maskarg&maskcmd)&(UNM8|OFF) )
	{
		*tmpobj=(u_char)val;	/* write Byte */
		return(NULL);
	}
	if( maskcmd&maskarg&UNM3)
		code = (u_char)val;
	else
		code = codebits(maskarg);

	*tmpobj |= code<<BIT(pos);

	return(NULL);
}

static int fillihbuffer(int addr,int nbytes,u_char *pbuf)
{
	/*
	 * Make a complete row in INTELHEX format.
	 * Code: ':nnaaaadddd...dddcc\n
	 * Where: nn		- number of data bytes
	 *        aaaa		- address
	 *        dd..dd	- data bytes
	 *        cc		- checksum = 0x100 - (aa + aa + nn + dd + .. + dd)
	 * Everything is in ASCII, 'intelhexbuffer' is dynamically allocated.
	 *
	 * RC: NULL if all went fine,
	 *	   ERROR else.
	 */

#define NCTRLBYTES	12 /* :nnaaaasspp\n = 12 */

	int datasum;
	char *pos;

	if(debugf)  puts("fillihbuffer");

	if(!nbytes)
	{
		fprintf(stderr,"Internal ERROR: nbytes=0  LINE=%d\n",__LINE__);
		return(ERROR);
	}

		/* take care to have enough space */
	if(ih_head.actitem+nbytes*2+NCTRLBYTES >= ih_head.nitem)
	{
		if(expandlist(&ih_head))
			return(SERIOUS);	/* should never be happen */
	}
		/* next free Position */
	pos=(char *)(((char *)ih_head.list)+ih_head.actitem);

	*pos++=':'; 								/* Set Start Marker */
	pos = ibtoh((unsigned char)nbytes,pos); 					/* Write data counter */
	pos = ibtoh((unsigned char)(addr>>8),pos);  	/* Write High Byte Address */
	pos = ibtoh((unsigned char)(0xFF&addr),pos); /* Write Low Byte Address */
	pos = ibtoh((u_char)0,pos); 					/* Write status */

	datasum=(0xFF&(addr>>8))+(0xFF&addr)+nbytes; /* part of chksum */

	while(nbytes--)
	{
		datasum+=(int)*pbuf;
		pos = ibtoh(*pbuf++,pos);			/* Write databyte */
	}

	datasum=0x100-(0xFF&datasum);			/* finish chksum */
	pos = ibtoh((u_char)datasum,pos);		/* Write chksum */
	*pos++ = '\n';							/* Close String */
	*pos = '\0';							/* Close String */

	ih_head.actitem=(int)pos-(int)ih_head.list;

	return(NULL);
}

static int dointelhex(int addr,int size,u_char *data)
{
	/*
	 *	Collect Data to generate INTELHEX Format.
	 *  Collect a row (Maximum Databytes = MAXBYTESIH).
	 *	If the row is full or is there a skip in addressing
	 *   call 'fillihbuffer()' to flush buffer.
	 *
	 *	RC:	NULL if all went fine,
	 *	    ERROR else.
	 */

	static int rowaddr=ERROR,rownbytes=0;
	static u_char rowdata[MAXBYTESIH];

	u_char *prowdata;

	if(debugf)  puts("dointelhex");

		/* Flush Buffer, write ENDLINE */
	if(addr==ERROR)
	{
		if(rownbytes)
			fillihbuffer(rowaddr,rownbytes,rowdata);

			/* take care to have enough space */
		if(ih_head.actitem+13 >= ih_head.nitem)
		{
			if(expandlist(&ih_head))
				return(SERIOUS);	/* should never be happen */
		}
		strcpy((char *)ih_head.list+ih_head.actitem,":00000001FF\n");
		ih_head.actitem+=12;
		rowaddr=ERROR;
		rownbytes=0;
		return(NULL);
	}

		/* If 'addr' not continous, start a new row */
	if(addr!=(rowaddr+rownbytes))
	{
		if((rowaddr!=ERROR) && (rownbytes))
			fillihbuffer(rowaddr,rownbytes,rowdata);
		rowaddr=addr;
		rownbytes=0;
	}

	while(size)
	{
		prowdata= &rowdata[rownbytes];

			/* fill data in 'rowdata' */
		while(	(rownbytes<MAXBYTESIH) && size)
		{
			size--;
			rownbytes++;
			*prowdata++= *data++;
		}

			/* row full ? */
		if(rownbytes>=MAXBYTESIH)
		{
				/* finish row, open new */
			fillihbuffer(rowaddr,rownbytes,rowdata);
			rowaddr+=rownbytes;
			rownbytes=0;
		}
	}
	return(NULL);
}

static int makecode(struct objsize *pobj,struct command *pcmd,int mode,u_long type1,u_short val1,u_long type2,u_short val2)
{
	/*
	 *	If mode==PARSE1 then
	 *		calculate object size and increase 'pobj'
	 *	If mode==PARSE2
	 *		Generates Object Code and write it to objbuffer
	 *
	 *	RC:	NULL if all went fine, else
	 *		ERROR
	 */

	int size,i;
	u_char dummy;

	if(debugf)  puts("makecode");

	size = MNELEN(pcmd->order1);				/* How much Bytes to write */

	if(mode==PARSE1)
	{
		return(doobjadr(pobj,size,OBJADREL));	/* Only increase Objectbuffer */
	}
	else if(mode==PARSE2)
	{
		for(i=0;i<size;i++)
		{
			if(dummy= *(ACT_OBJ_ADDR(pobj)+i) )
			{
				showerror(NULL,DATA_OVERWRITE);
				return(ERROR);
			}
			*(ACT_OBJ_ADDR(pobj)+i)=pcmd->obj[i];	/* copy Object Code */
		}

#		ifdef DEBUG2
			fprintf(stderr,"pcmd[%d]\n",(int)((char *)pcmd-(char *)cmd)/sizeof(struct command));
			fprintf(stderr,"---pcmd->order1:%X\n",pcmd->order1);
#		endif

		writemnedata(pobj,type1,val1,pcmd->pa1,pcmd->order1);	/* set Register/Branch Bits (Argu.1)*/

#       ifdef DEBUG2
			fprintf(stderr,"---pcmd->order2:%X\n",pcmd->order2);
#       endif

		writemnedata(pobj,type2,val2,pcmd->pa2,pcmd->order2);	/* set Register/Branch Bits (Argu.2)*/

		if(doobjadr(pobj,size,OBJADREL))			/* increase Objectbuffer */
			return(ERROR);
	}
	else
		INTERNAL_ERROR;

	return(NULL);
}

static int domne(struct listheader *plabel,struct objsize *pobj,char *ptok,int mode,u_short *pcycle)
{
	/*
	 *	Search for mnemomic 'ptok'.
	 *	First compare mnemomic name
	 *	Check arguments (if they are allowed)
	 *	if mode==PARSE1
	 *		increase 'pobj' about the size of mnemomic
	 *	else if mode==PARSE2
	 *		fill objbuffer with generated code
	 *
	 *	RC: NULL if a mnemomic was found, regardless if the parsing for successfully
	 *      ERROR if no mnemomic was found
	 */

	struct command *pcmd;	/* Pointer to actual MNE in 'caz' MNE-Array */
	char 	*ptok2,			/* second Argument */
			*pend,			/* points behind last Argument (for missing arguments)*/
			*pmne;			/* points to Sourcetext MNE */
	u_long	type1,tmp1,		/* classes of 1. parsed argument */
	        type2,tmp2,		/* classes of 2. parsed argument */
			f1,f2,f3,f4;	/* just for debugv */
	u_short	val1,val2;		/* if 1./2. argument is a value */

			/* Just to report more detailed Error Messages */
	int		arg1_ex,arg2_ex,	/* Flag if MNE need Argument1,Argumnt2 */
			arg1_nex,arg2_nex,	/* Flag if MNE don't need Argument1,Argument2 */
			arg1_ok,arg2_ok;	/* Flag if MNE Arguments and Sourcetext Arguments match */

	arg1_ex=arg2_ex=arg1_nex=arg2_nex=arg1_ok=arg2_ok=FALSE;

	if(debugf)  puts("domne");

#	ifdef DEBUG2
		u_long fuck1,fuck2;
#	endif

	pmne = ptok;				/* Mnemomic Name */
	type1 = type2 = NOPAR;

		/* check all appropriate prozessor mnemomics */
	if(pcmd=findmne(cmd,pmne))
	{
			/* get Arguments (type) and their value (if they have one) */
		if(ptok=strtok(NULL,","))
		{
			ptok=skipspace(ptok);
			if(ptok2=strtok(NULL,"\n"))
			{
				ptok2=skipspace(ptok2);
				type2=argtype(plabel,ptok2,&val2,mode);
				pend = ptok2+strlen(ptok2);
			}
			else
				pend = ptok+strlen(ptok);

			type1=argtype(plabel,ptok,&val1,mode);
		}
		else
			pend = pmne+strlen(pmne);

		tmp1 = type1; /* saved to restore */
		tmp2 = type2; /* saved to restore */
		do {
				/* Just to report more detailed Error Messages */
			if(pcmd->pa1&NOPAR)
				arg1_nex=TRUE;
			else if(pcmd->pa1&~NOPAR)
				arg1_ex=TRUE;

			if(pcmd->pa2&NOPAR)
				arg2_nex=TRUE;
			else if(pcmd->pa2&~NOPAR)
				arg2_ex=TRUE;

				/* first delete all flags which not needed */
			type2&=~IMODE2;

			if(!(pcmd->pa1&IMODE2))
				type1&=~IMODE2;

			if(!(pcmd->pa1&BRA))
			{
				type1&=~BRA;
				type2&=~BRA;
			}
			if(!(pcmd->pa1&NBR))
			{
				type1&=~NBR;
				type2&=~NBR;
			}
				/* check if bitpattern match with 'pcmd' */
			if(debugv)
			{
				decodearg("Type1",type1);
				decodearg("Cmd1",pcmd->pa1);
				decodearg("Type2",type2);
				decodearg("Cmd2",pcmd->pa2);
				fputs("\n",stderr);
			}

/* There are two types of flags: */
/* a) flags which must be equal (masked with EXMASK) */
/* b) flags which could be equal */

			/* this flags determine the classes */
			/* f1,f2 are true if the classes matches */
			f1 = pcmd->pa1&type1&~EXMASK;
			f2 = pcmd->pa2&type2&~EXMASK;


#			ifdef DEBUG2
				/* This flags must be equal */
				fuck1 = pcmd->pa1&EXMASK;
				fuck2 = type1&EXMASK;
#			endif

			/* if 'f3' is true, the flags differs */
			f3 = (pcmd->pa1&(EXMASK))^(type1&(EXMASK));

#           ifdef DEBUG2
				/* This flags must be equal */
				fuck1 = pcmd->pa2&EXMASK;
				fuck2 = type2&EXMASK;
#           endif

			/* if 'f4' is true, the flags differs */
			f4 = (pcmd->pa2&EXMASK&~(BRA|NBR))^(type2&EXMASK&~(BRA|NBR));

				/* Just to report more detailed Error Messages */
			if(f1 &&(!f3))
				arg1_ok = TRUE;
			if(f2 &&(!f4))
				arg2_ok = TRUE;

			if( f1 && f2 && (!f3) && (!f4) )
			{
#			ifdef DEBUG2
				fprintf(stderr,"--- found:%s,order1:%X\n",pcmd->name,pcmd->order1);
#			endif

				if(!makecode(pobj,pcmd,mode,type1,val1,type2,val2))
					*pcycle=pcmd->cycle;		/* copy Clock Cycle */
			 	return(NULL);
			}
			type1 = tmp1;
			type2 = tmp2;
		} while(pcmd=findmne(++pcmd,pmne));

	/* This explains the User what's wrong */

		/* Easier handling if flag NOPAR is cleared */
		type1&=~NOPAR;
		type2&=~NOPAR;

/* All 'arg' - Flags: If True, the condition could be True, but don't have to be True */
		if(!arg1_ex && !arg2_ex)
		{  /* No Arguments allowed */
			if(type1 || type2)
				showerror(ptok,TOO_MUCH_ARGUMENT);
		}
		else if(arg1_ex && !arg1_nex && !arg2_ex)
		{  /* exact 1 argument */
			if(!type1)
				showerror(pend,NEED_ARGUMENT);
			else if(type2)
                showerror(ptok2,TOO_MUCH_ARGUMENT);
			else
				showerror(ptok,WRONG_ARGUMENT);
		}
		else if(arg1_ex && !arg1_nex && arg2_ex && !arg2_nex )
		{  /* exact 2 arguments */
			if(!type1)
				showerror(pend,NEED_2ARGUMENT);
			else if(!type2)
				showerror(pend,NEED_A2ARGUMENT);
			else if(arg1_ok && arg2_ok)
				showerror(ptok,W_ARG_COMBINATION);
			else if(!arg2_ok)
				showerror(ptok2,WRONG_ARGUMENT);
			else if(!arg1_ok)
				showerror(ptok,WRONG_ARGUMENT);
			else
				INTERNAL_ERROR 		/* Do I forget a case ? */
		}
		else if(arg1_ex && !arg2_ex)
		{  /* minimal 0 arguments, maximal 1 argument */
			showerror(ptok,WRONG_ARGUMENT);
		}
		else if(!arg1_nex && arg1_ex && arg2_ex )
		{  /* minimal 1 Argument, maximal 2 arguments */
			if(!type1)
				showerror(pend,NEED_ARGUMENT);
			else if(type2 && !arg2_ok)
				showerror(ptok2,WRONG_ARGUMENT);
			else
				showerror(ptok,WRONG_ARGUMENT);
		}
		else if(arg1_ex && arg2_ex )
		{  /* minimal 0 arguments, maximal 2 arguments */
			if(arg1_ok && arg2_ok)
				showerror(ptok,W_ARG_COMBINATION);
			else if(!arg2_ok)
				showerror(ptok2,WRONG_ARGUMENT);
			else if(!arg1_ok)
				showerror(ptok,WRONG_ARGUMENT);
			else
				showerror(ptok,WRONG_ARGUMENT);
		}
		else
			INTERNAL_ERROR 		/* Do I forget a case ? */

		return(NULL);	/* If any MNE was found , rc=NULL */
	}
	return(ERROR);		/* If no MNE was found , rc=ERROR */
}

static int pushfile(struct item_file **pstack,char *p_filenamenew,FILE **p_fp)
{
	/* Push item on stack. Set 'pstack' to new top of stack .
	 *
	 * RC: NULL if all went fine,
	 *     ERROR if malloc() failed() or new file can't be opened;
	 */

	struct item_file *pnode;
	FILE *fptmp;


	if(!(fptmp=fopen(p_filenamenew,"r")))
	{
		showerror(p_filenamenew,CANT_OPEN_FILE,p_filenamenew);
		return(ERROR);
	}

	if(!(pnode=(struct item_file *)malloc(sizeof(struct item_file))))
	{
		fprintf(stderr,NO_MEMORY);
		return(ERROR);
	}

	pnode->prev = *pstack;
	strcpy(pnode->filename,actfilename);  /* save old filename (to be push) */
	strcpy(actfilename,p_filenamenew);	  /* set new filename */
	pnode->filepos = ftell(*p_fp);		  /* save old fileposition */
	pnode->lnr     = lnr;				  /* save old linenumber */
	*pstack     = pnode;				  /* set new item on top of stack */

	lnr = 0;

	fclose(*p_fp);		/* close old (pushed) file */
	*p_fp=fptmp;		/* set stackpointer to new first item */

	return(NULL);
}

static int popfile(struct item_file **pstack,FILE **p_fp)
{
	/* Get topmost Element from stack. Set 'pstack' to new topmost element.
	 *
	 * RC: NULL if all went fine, else
	 *     ERROR if 'pstack' is empty.
	 */

	struct item_file *itemtmp;
	FILE *fptmp;

		/* Empty Stack is not allowed */
	if(!*pstack)
		return(NULL);

		/* Open old (previous pushed) File */
	if(!(fptmp=fopen( (*pstack)->filename,"r"))) /* Open New file */
	{
		showerror(NULL,CANT_OPEN_FILE,(*pstack)->filename);
		return(ERROR);
	}
		/* Set Filepointer to old position */
	if(NULL!=fseek(fptmp,(*pstack)->filepos,SEEK_SET))
	{
		showerror(NULL,CANT_SEEK_FILE,(*pstack)->filepos,(*pstack)->filename);
		fclose(fptmp);
		return(ERROR);
	}

	fclose(*p_fp);	/* Close old File */

	*p_fp=fptmp;	/* Copy new FilePointer */

	strcpy(actfilename, (*pstack)->filename);	/* get old filename */
	lnr = (*pstack)->lnr;						/* get old linenumber */

	itemtmp   =(*pstack)->prev;		/* get pointer to next item */
	free(*pstack);					/* free topmost element */
	*pstack=itemtmp;				/* set to new topmost element */

	return(NULL);
}


static int setdefaultbase(char *pbase)
{
	/*
	 * Determine default number base.
	 *
	 * RC: NULL if all ok, else
	 *     ERROR
	 */

	switch(toupper(*pbase))
	{
		case 'H': 	default_num_base = 16;
					break;
		case 'D': 	default_num_base = 10;
					break;
		case 'O': 	default_num_base = 8;
					break;
		case 'B': 	default_num_base = 2;
					break;
		default:	showerror(pbase,UNKNOWN_BASE);
					return(ERROR);
	}
	return(NULL);
}


static int dodirective(struct listheader *plabel,struct objsize *pobj,char *ptok,int direc,int mode,int *orgflag)
{
	/*
	 *	If mode==PARSE1
	 *		increase 'pobj' about the needed space
	 *	else if mode==PARSE2
	 *		fill objbuffer
	 *	'*orgflag' ist set to TRUE, if 'directive' is 'ORG'. This is done
	 *  to determine in 'parseline()' if there is a skip in the object buffer.
	 *
	 *	RC: NULL if all went fine, else
	 *      ERROR
	 */

	u_short   adr,expr;
	char    *ntok;
	int		size=0,i,tmp,type;
	char	quote;
	u_char dummy;

	if(debugf)  puts("dodirective");

	*orgflag=FALSE;

	switch(direc)
	{
		case ORG : 	ptok=strtok(NULL,"\n");	/* get Pointer to Adress */
					ptok=skipspace(ptok);
					if(strtoint(plabel,ptok,&adr,mode))	/* substitude Adress */
					{
						showerror(ptok,SYNTAX_ERROR);
						return(ERROR);
					}
					if(doobjadr(pobj,(int)adr,OBJADABS))	/* set objectbuffer */
						return(ERROR);

						/* needed in parseline() to determine valid Object range */
					*orgflag=TRUE;

					if(mode==PARSE1)
						return(NULL);
					else if(mode==PARSE2)
					{
							/* check if Buffer is empty at new position */
						if(dummy= *ACT_OBJ_ADDR(pobj))
						{
							if(pobj->actbyte == pobj->lastbyte) /* special case: org at buffer end and no code */
								return(NULL);

							showerror(ptok,DATA_OVERWRITE);
							return(ERROR);
						}
						return(NULL);
					}
					break;
		case DEFS:	ptok=strtok(NULL,"\n");	/* get Pointer to Size */
					ptok=skipspace(ptok);
					if(strtoint(plabel,ptok,&adr,mode))	/* substitude Adress */
					{
						showerror(ptok,SYNTAX_ERROR);
						return(ERROR);
					}
					size=adr;
					if(mode==PARSE2)
					{
							/* check if Buffer is empty at new position */
						for(i=0;i<size;i++)
						{
							if(dummy= *(ACT_OBJ_ADDR(pobj)+i))
							{
								showerror(ptok,DATA_OVERWRITE);
								return(ERROR);
							}
						}
						memset(ACT_OBJ_ADDR(pobj),FILL_CHAR,size);
					}
					return(doobjadr(pobj,size,OBJADREL));	/* increase objectbuffer */
					break;
		case DEFW:	size=1;	/* Word == 2 Byte */
		case DEFB:	size++; /* Byte == 1 Byte */
					i=0;
					ntok=ptok+strlen(ptok);
					while(ptok=strtok(NULL,","))	/* count more Bytes */
					{
						if(mode==PARSE2)
						{
						    ptok=skipspace(ptok);
							cutend(ptok); /* V1.24 hinzugefügt um mögliche Freiplätze nach einer 0-Zahl zuzulassen */
							if(strtoint(plabel,ptok,&adr,mode))	/* substitude Adress */
							{
								showerror(ptok,SYNTAX_ERROR);
								doobjadr(pobj,(i+1)*size,OBJADREL); /* successfull converted data still valid */
								return(ERROR);
							}
							if(dummy= *(ACT_OBJ_ADDR(pobj)+i))
							{
								showerror(ptok,DATA_OVERWRITE);
								return(ERROR);
							}

							*(ACT_OBJ_ADDR(pobj)+i)=LOBYTE(adr);

							if(size==2)
							{
								if(dummy= *(ACT_OBJ_ADDR(pobj)+i+1))
								{
									showerror(ptok,DATA_OVERWRITE);
									return(ERROR);
								}
								*(ACT_OBJ_ADDR(pobj)+i+1)=HIBYTE(adr);
							}
						}
						i+=size;
					}
					if(!i)
					{
						showerror(ntok,NEED_ARGUMENT);
						return(ERROR);
					}
					return(doobjadr(pobj,i,OBJADREL));	/* increase objectbuffer */
					break;

		case DEFM:	ptok=skipspace(ptok+strlen(ptok)+1); /* set ptok,ntok behind directive DEFM */

					while(ptok)	/* step through a sequence of strings and values */
					{
						/* Check first char == QUOTE -> STRING */
						if(quote=validquote(*ptok))
						{
							/* determine endequote */
							if(!(ntok=strchr(ptok+1,quote)))
							{
								showerror(ptok,NO_END_QUOTE);
								return(ERROR);
							}

							/* add string length to sizecounter */
							if(!(size=ntok-ptok-1))
							{
								showerror(ptok,NO_EXPR_INSIDE);
								return(ERROR);
							}

							if(mode==PARSE2)
							{
								for(tmp=0;tmp<size;tmp++)
								{
									if(dummy= *(ACT_OBJ_ADDR(pobj)+tmp))
									{
										showerror(ptok,DATA_OVERWRITE);
										return(ERROR);
									}
								}
								strncpy(ACT_OBJ_ADDR(pobj),ptok+1,size);
							}

							ptok=skipspace(ntok+1);    /* points to comma or NULL */
							if(ptok)
							{
								if(*ptok!=',') /* further arguments ? */
								{
									showerror(ptok,EXPECT_COMMA);
									return(ERROR);
								}
								if(!(ptok=skipspace(ptok+1)))    /* next argument */
								{
									showerror(ntok,NEED_ARGUMENT);
									return(ERROR);
								}
							}
						}
						else
						{          /* No String -> it must be a value */
							size=1;
							if(ntok=strchr(ptok,',')) /* cut folowing arguments */
							{
								*ntok='\0'; /* cut string */
								cutend(ptok);

								if(!(ntok=skipspace(ntok+1))) /* next argument */
								{   /* ERROR: comma without an folowing argument */
									showerror(ptok,NEED_ARGUMENT);
									doobjadr(pobj,1,OBJADREL); /* successfull converted data still valid */
									return(ERROR);
								}

							}

							if(mode==PARSE2)
							{
								if(strtoint(plabel,ptok,&adr,mode))	/* substitude Adress */
								{
									showerror(ptok,SYNTAX_ERROR);
									doobjadr(pobj,1,OBJADREL); /* successfull converted data still valid */
									return(ERROR);
								}
								*(ACT_OBJ_ADDR(pobj))=LOBYTE(adr);
							}
							ptok=ntok;
						}
							/* Increment Object Buffer */
						if(tmp=doobjadr(pobj,size,OBJADREL))
							return(tmp);
					}

					return(NULL);
					break;
		case INCLUDE:
					ptok=strtok(NULL,"\n");	/* get Pointer to Filename */
					ptok=skipspace(ptok);
					return(pushfile(&file_stack,ptok,&fpin));
					break;
		case END:	endflag=TRUE;
					return(NULL);
					break;
		case LIST:		/* Switch LIST (verbose) ON or OFF */
					ptok=strtok(NULL,"\n");	/* get switch LIST_ON or LIST_OFF */
					ptok=skipspace(ptok);
							/* search directive ON or OFF */
					if(!ptok || ((type=finddirective(ptok))==ERROR) || (type!=LIST_OFF && type!=LIST_ON) )
					{
						showerror(ptok,EXP_LIST_ON_OFF);
						return(ERROR);
					}
						/* check if 'verbose' already set via Commandline Option */
					if( (verbose&MODE_OPTION) || clockcycle )
						return(NULL); /* Commandline Options has a greater Priority */

					if(type==LIST_ON)
						verbose=MODE_ALL;
					else if(type==LIST_OFF)
						verbose=0; /*NULL;*/
					else
						INTERNAL_ERROR
					return(NULL);
					break;
		case COND:	ptok=strtok(NULL,"\n");	/* get expression */
					ptok=skipspace(ptok);
					if(strtoint(plabel,ptok,&expr,PARSE2))
					{
						if(ntok = strpbrk(ptok,"+-*/"))
						{
							showerror(ptok,CANT_RESOLVE);
							return(ERROR);
						}
						else
							expr = FALSE;
					}

					assembleflag=(BOOL)expr; /* <>0 -> TRUE, Assemble */
					return(NULL);
					break;
		case ENDC:	assembleflag=TRUE;
					return(NULL);
					break;
		case EJECT:	if(verbose || clockcycle)
						fputs("\f",stdout);
					return(NULL);
					break;
		case DEFBASE: return(setdefaultbase(strtok(NULL,"\n")));
					break;
		case MACLIST:
		case HEADING:
		case MACRO:
		case ENDM:	showerror(ptok,NOT_IMPLEMENTED);
					return(ERROR);
					break;
	}
	INTERNAL_ERROR
	return(ERROR);
}

static int parseline(struct listheader *plabel,struct objsize *pobj,char *pwork,int mode)
/* List of all Label's */
/* Structure for start,end,actual position of objectbuffer */
/* Textline to parse */
/* PARSE1 or PARSE2 */
{
	/*
	 *	Parse a line for mnemomics or directives.
	 *	Dependent if 'mode'==PARSE1 no objectcode is generated (only the size is counted)
	 *			  else if 'mode'==PARSE2 objectcode is generated.
	 *
	 *	- if comments exist, cut them.
	 * 	- if labels exists, note them in 'plabel' (PARSE1)
	 *	- parse the command, check the correctness, determine the needed size,
	 *	  increment the objectbuffer and if 'mode'==PARSE2 generate the code
	 *
	 *	If any errors found in the string, they will be report by 'showerror()'
	 *
	 *	RC: NULL or
	 *		ERROR if any serious ERRORS ocured
	 *
	 *		BTW: A wrong 'source line' isn't an error for this function.
	 *			 Syntax Error's will report by showerror() during the parsing.
	 */

#	define POSOBJ 5		/* String Postition of 'Object Code' */
#	define POSCYCLE 5	/* String Postition of 'Clock Cycle' */
#	define POSSRCV 18	/* String Postition of 'Sourceline' (verbose) */
#	define POSSRCC 12	/* String Postition of 'Sourceline' (clockcycle) */

	char 	*ptok,
			*tmp=NULL,
			clockbuf[BUFSIZ],
			verbbuf[BUFSIZ];

	int direc,nmne,orgflag;

	u_short value=0;
	u_short cycle=0;				/* if MNE found, MNE Clock Cycle */
	struct labelitem *pitem;
	BOOL  invalid=TRUE;			/* Flag to show if a Constant definition is invalid */

	int i,startpos;

	if(debugf)  puts("parseline");

		/* needed in 'verbose','intelhex' or 'clockcycle' mode */
	if(mode==PARSE2 && assembleflag)
	{
		startpos= pobj->actbyte;

		if(verbose)
		{
			tmp=iwtoh((u_short)startpos,verbbuf);	/* Generate Objectaddress */
			strcpy(tmp,":              ");	/* Append ':' and clean Space */
			strcpy(&verbbuf[POSSRCV],pwork);	/* save line to print out in verbose mode */
		}
		if(clockcycle)
		{
			tmp=iwtoh((u_short)lnr,clockbuf);	/* Generate Objectaddress */
			strcpy(tmp,":              ");	/* Append ':' and clean Space */
			strcpy(&clockbuf[POSSRCC],pwork);	/* save line to print out in clockcycle mode */
		}
	}

	killcomment(pwork);				/* remove all comments */
	cutend(pwork);
	if(!(ptok = strtok(pwork," \t")))		/* first token, No token there ? */
	{										/*  NO token, so finish */
		if(verbose&MODE_ALL)
			goto ENDPARSELINE;		/* print out Comment */
		if(clockcycle&MODE_ALL)
			goto ENDPARSELINE;		/* print out Comment */
		return(NULL);				/* nothing there to parse */
	}

	tmp = ptok + strlen(ptok) - 1;

	/*** is there a label ? ***/
	if(*tmp == ':')
	{
		if( (mode==PARSE1) && assembleflag)
		{
			*tmp = '\0';						/* cut ':' */
			if(dolabel(plabel,pobj,ptok))		/* manage label */
			    return(ERROR);
		}
		if(!(ptok = strtok(NULL," \t")))	/* next token */
			goto ENDPARSELINE;				/* nothing more there to parse */
	}

	/*** is there a directive ***/
	if( (direc=finddirective(ptok)) != ERROR)		/* search directives */
	{
		if( (direc == EQU || direc == DEFL))	/* EQU/DEFL need at first a symbol name */
		{									/* they will be handled a few lines down */
			if(!assembleflag)
				return(NULL);  				/* don't assemble -> ignore ERRORS */

			showerror(ptok,NO_SYMBOL_NAME,ptok);
			return(NULL);
		}
		else
		{
			if(dodirective(plabel,pobj,ptok,direc,mode,&orgflag))
				return(ERROR);

				/* all done this round ? */
			if( (!assembleflag) || (mode==PARSE1) || ( (!verbose) && (!intelhex) && (!clockcycle) ) )
				return(NULL);

				/* do 'verbose' or 'intelhex' stuff */
			nmne=pobj->actbyte-startpos;

			if(orgflag)
			{
				startpos= pobj->actbyte;
				nmne = 0;
			}

			if(intelhex&&nmne)
				dointelhex(startpos,nmne,ACT_OBJ_ADDR(pobj)-nmne);

				/* less or equal 4 Bytes could be shown in actual line */
			if(verbose)
			{
				if(nmne<=4)
				{
					tmp= &verbbuf[POSOBJ];
					for(i=0;i<nmne;i++)
					{
						*tmp=' ';
						tmp=ibtoh(*(ACT_OBJ_ADDR(pobj)+i-nmne),++tmp);
					}
					*tmp=' ';
				}
				else
				{
						/* more than 4 Bytes -> show in a new row */
					puts(verbbuf);	/* show line with source Text, but without Bytes*/
					tmp= &verbbuf[POSOBJ];
					for(i=0;i<nmne&& (tmp<(&verbbuf[BUFSIZ]-3));i++)
					{
						*tmp=' ';
						tmp=ibtoh(*(ACT_OBJ_ADDR(pobj)+i-nmne),++tmp);
					}
					*tmp='\0';
				}
			}
				/* check if there is something to print out */
			if(verbose || clockcycle)
				goto ENDPARSELINE;
			else
				return(NULL);
		}
	}

	if(!assembleflag)
		return(NULL);	/* don't assemble -> do nothing */

	tmp = ptok; /* safe old start of begin parsing for second directive search */

	/*** Is there Z80 Mnemomic ? ***/
	if( !(domne(plabel,pobj,ptok,mode,&cycle)))	/* look for Mnemomics, parse them */
	{
		if(mode==PARSE2)
		{
			nmne = pobj->actbyte-startpos;

			if(intelhex&&nmne)
				dointelhex(startpos,nmne,ACT_OBJ_ADDR(pobj)-nmne);

			if(verbose)
			{
				tmp= &verbbuf[POSOBJ];
				for(i=0;i<nmne;i++)
				{
					*tmp=' ';
					tmp=ibtoh(*(ACT_OBJ_ADDR(pobj)+i-nmne),++tmp);
				}
				*tmp=' ';
			}

			if(clockcycle)
			{
				if(cycle<0xff)	/* branch ? */
				{   /* NO */
					sprintf(&clockbuf[POSCYCLE]," %2d",cycle);
					clockbuf[POSCYCLE+3]=' ';
				}
				else
				{   /* Yes */
					sprintf(&clockbuf[POSCYCLE]," %2d/%2d",(cycle&0xff00)>>8,cycle&0xff);
					clockbuf[POSCYCLE+6]=' ';
				}
			}

		}
		goto ENDPARSELINE;
	}

	/*** EQU/DEFL ***/

	strcpy(pwork,line+(tmp-pwork));			/* restore sourceline (cutted through 'domne()' */
	killcomment(pwork);
	cutend(pwork);
	ptok=strtok(pwork," \t");				/* first token (is also 'pwork') */
	if(!(ptok=strtok(NULL," \t")))			/* second token (assummed directive) */
	{
		showerror(ptok,UNKNOWN_COMMAND,pwork);
		return(NULL);
	}

	if( (direc=finddirective(ptok)) != ERROR)		/* search directives */
	{
		if(direc != EQU && direc != DEFL)		/* 'direc' must be EQU or DEFL */
		{
			showerror(ptok,UNKNOWN_COMMAND);
			return(NULL);
		}
		if(!(ptok=strtok(NULL,"\n")))			/* third token (constant assummed) */
		{
			showerror(pwork,EXPECT_CONSTANT);
			return(NULL);
		}
		ptok=skipspace(ptok);

		invalid = strtoint(plabel,ptok,&value,mode);

		if(mode==PARSE2)
		{
			if(invalid)		/* convert to int */
			{
				/* Just to report a more detailed error message */
				strtok(ptok," \t");	/* clear everything behind token */
				if(getlabel(plabel,ptok))	/* check if Symbol name exists */
					showerror(ptok,CANT_RESOLVE);
				else
					showerror(ptok,SYNTAX_ERROR);
				return(NULL);
			}
		}

		if(pitem=getlabel(plabel,pwork))	/* check if Symbol name exists */
		{
			if( direc!=DEFL || pitem->type != L_DEFL )	/* directive type = EQU ? */
			{
				if( direc != pitem->type )
				{
					showerror(pwork,LABEL_DECL_EQUDEFL);	/* EQU definition can't */
					return(NULL);								/*  redefined */
				}
				if(mode==PARSE1)	/* first parse -> error */
				{
					showerror(pwork,LABEL_DECL_TWICE);	/* EQU definition can't */
					return(NULL);								/*  redefined */
				}
			}
			if(pitem->valid = !invalid)
				pitem->value = value;		/* -> direc == DEFL. take new value */
			goto ENDPARSELINE;
		}
		else								/* Symbol name is new */
		{
			if(mode==PARSE2)
			{
					/* this should never be happen */
				INTERNAL_ERROR
				return(ERROR);
			}
			if(SERIOUS==(int)insertlabel(plabel,pwork,direc,value,!invalid)) /* insert constant definition */
			{
				showerror(pwork,NO_MEMORY);
				return(ERROR);
			}
			goto ENDPARSELINE;
		}
	}
	else
	{
		showerror(ptok,UNKNOWN_COMMAND);
		return(NULL);
	}

ENDPARSELINE:
	if(!assembleflag)
		return(NULL);

	if( (mode==PARSE2) && verbose)
		puts(verbbuf);
	if( (mode==PARSE2) && clockcycle)
		puts(clockbuf);
	return(NULL);
}


static int readsrc(struct listheader *plabel,struct objsize *pobj,char *p_actfilename)
{
	/*
	 *	Parse File 'fp' two times.
	 *	First parse: - Count Object code size
	 *				 - Fill list 'plabel' with label name and either a memory
	 *				   position or a constant definition
	 *	Second parse: - Allocate Object code Buffer
	 *				  - fill the buffer with appropriate Object code
	 *				  - use 'label' to reference all symbols
	 *
	 *	RC: number of object bytes if every went fine,else
	 *		NULL and print an error message
	 */

	char *pos;
	u_char *tmp;
	int length;
	BOOL flag=TRUE;

	if(debugf)  puts("readsrc");

	if(!(fpin=fopen(p_actfilename,"r"))) /* Open New file */
	{
		fprintf(stderr,CANT_OPEN_FILE,p_actfilename);
		return(NULL);
	}

	/******************** Parse 1 ********************/
	default_num_base=10;
	fputs("Parse 1\n",stderr);

	while(flag)					/* parse source file */
	{
		if(feof(fpin))			/* no more Data ? */
		{
			if(file_stack)			/* Are there still any source files ? */
			{
				if(popfile(&file_stack,&fpin))
					return(NULL);	/* Error */
			}
			else
				flag=FALSE;				/* No, so quit while() */

			continue;				/* go to while() */
		}

		if(pos=fgets(line,BUFSIZ,fpin))	/* get next line */
		{
			strcpy(work,line);			/* 'work' is work buffer */
			lnr++;						/* line number counting */
			if(parseline(plabel,pobj,work,PARSE1))	/* parse the line */
				return(NULL);			/* something terrible must be happen */

			if(endflag)
			{
				endflag=flag=FALSE;
				while(file_stack)			/* Are there still any source files ? */
				{
					if(popfile(&file_stack,&fpin))
						return(NULL);	/* Error */
				}
			}
		}
	}

	if(errors)
		return(NULL);

	length=pobj->lastbyte - pobj->firstbyte;

	if(length)
	{	/* Just allocate Buffer, if it is really needed */
	 	if(!(tmp=pobj->objbuffer=(u_char *)calloc(sizeof(unsigned char),length)))
		{
			fputs("Error: Can't allocate memory for Objectbuffer\n",stderr);
			return(NULL);
		}
	}
	pobj->actbyte = pobj->firstbyte; /* Set counter to start */

	/******************** Parse 2 ********************/
	default_num_base=10;
	fputs("Parse 2\n",stderr);
	rewind(fpin);
	lnr=0;
	if(clockcycle)
		puts("Line: Cycle Source");

	flag=TRUE;
	while(flag)					/* parse source file */
	{
		if(feof(fpin))			/* no more Data ? */
		{
			if(file_stack)			/* Are there still any source files ? */
			{
				if(popfile(&file_stack,&fpin))
					return(NULL);	/* Error */
			}
			else
				flag=FALSE;				/* No, so quit while() */

			continue;				/* go to while() */
		}

		if(pos=fgets(line,BUFSIZ,fpin))	/* get next line */
		{
			strcpy(work,line);			/* 'work' is work buffer */
			lnr++;						/* line number counting */
			cutend(work);
			if(parseline(plabel,pobj,work,PARSE2))	/* parse the line */
				return(NULL);			/* something terrible must be happen */

			if(endflag)
			{
				flag=FALSE;
				while(file_stack)			/* Are there still any source files ? */
				{
					if(popfile(&file_stack,&fpin))
						return(NULL);	/* Error */
				}
			}
		}
	}
	if(intelhex)
		dointelhex(ERROR,0,NULL);

	if(debugv) fprintf(stderr,"generated Object Bytes:%d\n",length);

	return(length);
}


static void cleanup(void)
{
	struct item_file *p_fs;

	if(ih_head.list)
		free(ih_head.list);

	if(label.list)
		free(label.list);

	if(object.objbuffer)
		free(object.objbuffer);

	if(file_stack)
	{
		do {
			p_fs = file_stack->prev;
			free(file_stack);
			file_stack = p_fs;
		} while(p_fs);
	}

    if(fpin)          	fclose(fpin);
    if(fpout)          	fclose(fpout);

	return;
}

static void handlesig(int sig)
{
	fflush(stdout);
	puts("caz broken");
	cleanup();
	exit(RETURN_WARN);
}

int main(int argc,char *argv[])
{
	char	*outfile="a.out",*intelhexfile=NULL,*labelfile=NULL;
	int		length;


	signal(SIGINT,handlesig);

	actfilename[0] = '\0';

	if(debugf)  puts("main");

	if(argc==1) 		/* check commandline arguments */
		goto USAGE;

	if((argc==2) && (*argv[1]=='?') )
		goto USAGE;

	while(--argc)
	{
		if( (**(++argv)) == '-')
		{
			switch(*((*argv)+1))
			{
				case 'd':	debugv=TRUE;			/* Flag */
							break;
				case 'D':	debugf=TRUE;			/* Flag */
							break;
				case 'v':	verbose = MODE_OPTION+MODE_MNE;
							break;
				case 'V':	verbose = MODE_OPTION+MODE_ALL;		/* Flag */
							break;
				case 'c':	clockcycle = MODE_MNE;
							break;
				case 'C':	clockcycle = MODE_ALL;		/* Flag */
							break;
				case 's':
				case 'S':	showsymbols=TRUE;		/* Flag */
							break;
				case 'o':
				case 'O': 	if(!(--argc))
						  	{
						  		fprintf(stderr,"Missing filename behind '-o'\n");
						  		goto USAGE;
						  	}
						  	outfile = *++argv;
						  	break;
				case 'w':
				case 'W': 	if(!(--argc))
						  	{
						  		fprintf(stderr,"Missing filename behind '-w'\n");
						  		goto USAGE;
						  	}
						  	labelfile = *++argv;
						  	break;
				case 'i':
				case 'I': 	if(!(--argc))
						  	{
						  		fprintf(stderr,"Missing filename behind '-e'\n");
						  		goto USAGE;
						  	}
						  	intelhexfile = *++argv;
							intelhex=TRUE;			/* Flag */
						  	break;
				case 'h':
				case 'H':
				case '?':	goto USAGE1;
							break;
				default:	fprintf(stderr,"Unknown commandline option\n");
						  	goto USAGE;
			}
		}
		else
		{
			if(actfilename[0])
				goto USAGE;
			strcpy(actfilename,*argv);
		}
	}

	fputs(&vers[7],stderr);
	fputs(COPYRIGHT,stderr);

		/* Check if CLOCK & VERBOSE Mode is active */
	if(clockcycle && verbose)
	{
		fputs(CLOCK_OR_VERBOSE,stderr);
		goto LEAVEALL;
	}

	if(init(&label,&object))	/* initialize lists/buffers */
		exit(RETURN_ERROR);

	length=readsrc(&label,&object,actfilename);

	if(errors)
		fprintf(stderr,"\n\nAssembling failed.\nFound %d errors.\n",errors);

	if(showsymbols)
        symboltable(&label);

	if(labelfile)
        writesymboltable(&label,labelfile);


        /* if readsrc() don't generate any Objectcode, quit assembler */
    if(!length)
        goto LEAVEALL;

	if(!(fpout = fopen(outfile,"wb")))	/* open file where to write object code */
	{
		perror("Can't open file:");
		exit(RETURN_WARN);
	}
	if(length!=fwrite(object.objbuffer,1,length,fpout))
	{
		perror("Writing Objectfile failed");
		goto LEAVEALL;
	}
	fclose(fpout);
	fpout=NULL;

	if(intelhex)
	{
		if(!(fpout = fopen(intelhexfile,"wb")))	/* open file where to write INTELHEX Code */
		{
			sprintf(errortext,"Can't open file output File '%s'\n",actfilename);
			perror(errortext);
			exit(RETURN_WARN);
		}
		length=ih_head.actitem;
		if(length!=fwrite(ih_head.list,1,length,fpout))
		{
			perror("Writing INTELHEX File failed");
			goto LEAVEALL;
		}
	}

	goto LEAVEALL;				/* exit */

USAGE:
	fprintf(stderr,"USAGE: 'caz OPTIONS [assembler filename]'\n");
USAGE1:
	fprintf(stderr,
	       "%s"
		   COPYRIGHT
	       "\nOPTIONS are:\n\n"
		   "-o [Output Filename]   File where to write the generated Objectcode.\n"
		   "-d Debug Mode          Just for development of 'caz' (d=Value,D=Function).\n"
		   "-v/V Verbose Mode      Print on 'stdout' generated Objectcode with\n"
		   "                        with Adresses,Mnemomic,Source (v=MNE,V=ALL).\n"
		   "-c/C Clock Cycle       Print on 'stdout' Clock Cycles for every Mnemomic\n"
		   "-w [Filename]          Write out symbol definitions (Z80 Assembler Format).\n"
		   "-s Print Symbol Table  Print out symbol definitions (more detailed). \n"
		   "-i [IntelHex Filename] Generate a complete Object File in 'IntelHex'\n"
		   "                        Format (used by many Eprommer).\n",&vers[7]);
	return(1);

LEAVEALL:
	cleanup();
    exit(RETURN_OK);
}
