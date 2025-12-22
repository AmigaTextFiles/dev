/*
** multidef.c - A program to scan a collection of .o and library files
**		and search for multiply defined symbols.
**		This can catch problems where a symbol is defined in your
**		routine as well as in a scanned library (for example you
**		have a routine "write" that calls printf....). The linker
**		will not catch this type of problem.
**
**		multidef [-r] [-d] files.....
**
**		the -r option will list all symbols referenced in the file.
**		the -d option will list all symbols defined in the file
**		the files can be any collection of unlinked .o and library
**			files. Wild card expansion is done using a Lattice
**			3.10 library routine.
**
**		In addition to any -r or -d output multidef will list any
**		symbols defined in more than one file.
**
**		This only works on .o files, linked executables have hunks
**		in them that this program doesn't understand, besides the
**		symbol information is gone from an executable anyway.
**
**	Copyright (c) 1886, Paul Jatkowski.
*/
#include <stdio.h>
#include <fcntl.h>

/* defines for the different hunk types */

#define HUNK_UNIT	0x3e7	/* start of a program unit */
#define HUNK_NAME	0x3e8	/* name of hunk (optional) */
#define HUNK_CODE	0x3e9	/* block of code, possibly to be relocated */
#define HUNK_DATA	0x3ea	/* block of initialized data, possibly relocated */
#define HUNK_BSS	0x3eb	/* uninitialized data */
#define HUNK_RELOC32	0x3ec	/* 32 bit relocation entries */
#define HUNK_RELOC16	0x3ed	/* 16 bit pc relative relocation entries */
#define HUNK_RELOC8	0x3ee   /*  8 bit pc relative relocation entries */
#define HUNK_EXT	0x3ef	/* external symbol info  ... see below */
#define HUNK_SYMBOL	0x3f0	/* symbol table info, optional, for debuggers */
#define HUNK_DEBUG	0x3f1	/* further debugging info */
#define HUNK_END	0x3f2	/* end of a hunk */
/* lattice 3.1 hunk types */
#define HUNK_DRELOC32	0x3f7	/* 32 bit data section relative relocation */
#define HUNK_DRELOC16	0x3f8	/* 16 bit data section relative relocation */
#define HUNK_DRELOC8	0x3f9	/*  8 bit data section relative relocation */

/* the following hunk defines are for load files */
#define HUNK_HEADER	0x3f3	/* info for loader ... lots of stuff in here */
#define HUNK_OVERLAY	0x3f5	/* overlay table for overlay programs */
#define HUNK_BREAK	0x3f6	/* end of overlay node */


/* defines for HUNK_EXT hunk
** These are the important ones for getting symbol define/reference info
*/

#define EXT_SYMB	0		/* symbol table */
#define EXT_DEF		1		/* relocatable definition */
#define EXT_ABS		2		/* absolute definition */
#define EXT_RES		3		/* resident library definition */
#define EXT_REF32	129		/* 32 bit reference to symbol */
#define EXT_COMMON	130		/* 32 bit reference to COMMON */
#define EXT_REF16	131		/* 16 bit reference to symbol */
#define EXT_REF8	132		/*  8 bit reference to symbol */
/* lattice 3.1 extra defines */
#define EXT_DREF32	133		/* 32 bit base relative to symbol */
#define EXT_DREF16	134		/* 16 bit base relative to symbol */
#define EXT_DREF8	135		/*  8 bit base relative to symbol */


#define	MAXBUF 100	/* buffer for "get_and_flush" and "myread" */
long	buf[MAXBUF];

/* operation flags */
int	pr_def = 0;	/* print symbol definition listing */
int	pr_ref = 0;	/* print symbol reference  listing */
 
/* defines for t_insert routine (binary tree) */
struct t_node {
	struct	tnode	*right;
	struct	tnode	*left;
	char	*key;		/* symbol name */
	char	*aux1;		/* file   name */
	char	*aux2;		/* module name */
};
typedef struct t_node T_node;

/* declarations for forward referenced routines */
T_node	*t_insert();
void	save_def();

void
myread(fd,ptr,sz)
int	fd,sz;
char	*ptr;
{
	if (read(fd,ptr,sz) != sz)
	{
		printf("short read: aborting\n");
		exit(10);
	}
}

/* read n LONGS from the object file, used to flush unnecessary sections.
** I suppose that a seek would work also...... */
void
get_and_flush(objfile,n)
int	objfile,n;
{
	int	n1;
	n *= 4;
	while (n > 0)
	{
		n1 = n > MAXBUF ? MAXBUF : n;
		n -= n1;
		myread(objfile,buf,n1);
	}
}
/*
** given a object or library file name, read it and find symbol entries.
** print references or definitions if the flags are set. Collect the
** to look for multiple defines
*/
void
procfile(fname)
char	*fname;
{
	int	moretodo = 1;	
	long	d1 = -1 ,d2;
	int	ext_type;
	char	curhunk[100];
	char	curname[100];
	int	hunkend = 0;
	int	objfile;

	if (pr_def || pr_ref)
		printf("\t=========== processing %s ============\n",fname);
		
	if ( (objfile = open(fname,O_RDONLY)) < 0)
	{
		perror("can't open input file");
		poserr("amiga error");
		return;
	}
	
	while (moretodo)
	{
		/* read what is hopefully a hunk type */
		if (read(objfile,(char *)&d1,sizeof(d1)) != sizeof(d1))
		{
			if (!hunkend)
				printf("Unexpected end of file! (no hunk end)\n");
			moretodo = 0;
			continue;
		}
		hunkend = 0;
		switch(d1)
		{
		case HUNK_UNIT:		/* 3e7  Start of program unit */
			myread(objfile,&d1,sizeof(d1));
			myread(objfile,buf,d1*4);
			buf[d1] = 0;
			strcpy(curhunk,(char *)buf);
#ifdef DEBUG
			printf("hunk unit: %s\n",curhunk);
#endif
			break;
								
		case HUNK_NAME:		/* 3e8  Name of a hunk */
			myread(objfile,&d1,sizeof(d1));
			myread(objfile,buf,d1*4);
			buf[d1] = 0;
			strcpy(curname,(char *)buf);
#ifdef DEBUG
			printf("hunk name: %s\n",curname);
#endif
			break;

		case HUNK_CODE:		/* 3e9  Code segment */
		case HUNK_DATA:		/* 3ea  Initialized Data segment */
			myread(objfile,&d1,sizeof(d1));
#ifdef DEBUG
			printf("code/data hunk length=%d\n",d1);
#endif	
			get_and_flush(objfile,d1);
			break;

		case HUNK_BSS:		/* 3eb  Unitialized Data segment */
			myread(objfile,&d1,sizeof(d1));
#ifdef DEBUG
			printf("bss section length=%d\n",d1);
#endif
			break;			

		case HUNK_RELOC32:	/* 3ec  32-bit relocation list */
		case HUNK_RELOC16:	/* 3ed  16-bit PC-relative relocation info */
		case HUNK_RELOC8:	/* 3ee  8-bit PC-relative relocation info */
		case HUNK_DRELOC32:
		case HUNK_DRELOC16:
		case HUNK_DRELOC8:
#ifdef DEBUG
			printf("reloc hunk type 0x%x\n",d1);
#endif
			myread(objfile,&d1,sizeof(d1));
			while (d1 != 0)
			{
				myread(objfile,&d2,sizeof(d2));
				get_and_flush(objfile,d1);
				myread(objfile,&d1,sizeof(d1));
			}
			break;
							
		case HUNK_EXT:		/* 3ef  External symbol info */
#ifdef DEBUG
			printf("hunk ext\n");
#endif
			myread(objfile,&d1,sizeof(d1));
 			while (d1 != 0)
			{
				ext_type = (d1 >> 24) & 0xff;
				d1 &= 0xffffff;
				switch(ext_type)
				{
				case EXT_SYMB:	/* symbol table */
					get_and_flush(objfile,d1+1);
					break;
				case EXT_DEF:	/* reloc def */
				case EXT_ABS:	/* abs def */
				case EXT_RES:	/* resident lib */
					myread(objfile,buf,d1*4);
					buf[d1] = 0;
					if (pr_def)
						printf("DEF %-45.45s: %s\n",(char *)buf,curhunk);
					save_def(fname,curhunk,(char *)buf);
					get_and_flush(objfile,1);
					break;
				case EXT_REF32:	/* 32 bit ref */
				case EXT_REF16:	/* 16 bit ref */
				case EXT_REF8:	/*  8 bit ref */
				case EXT_DREF32:
				case EXT_DREF16:
				case EXT_DREF8:
					myread(objfile,buf,d1*4);
					buf[d1] = 0;
					if (pr_ref)
						printf("REF %-45.45s: %s\n",(char *)buf,curhunk);

					myread(objfile,&d1,sizeof(d1));
					get_and_flush(objfile,d1);
					break;
				case EXT_COMMON:	/* 32 bit ref */
					myread(objfile,buf,d1*4);
					buf[d1] = 0;
					if (pr_def)
						printf("COM %-45.45s: %s\n",(char *)buf,curhunk);
					save_def(fname,curhunk,(char *)buf);

					myread(objfile,&d1,sizeof(d1));
					myread(objfile,&d1,sizeof(d1));
					get_and_flush(objfile,d1);
					break;
				default:
					printf("ERROR: unknown HUNK_EXT 0x%x\n",d1);
				}
				myread(objfile,&d1,sizeof(d1));
			}
			break;
			
		case HUNK_SYMBOL:	/* 3f0  Symbol table info */
			myread(objfile,&d1,sizeof(d1));
			while (d1 != 0)
			{
				get_and_flush(objfile,d1+1);
				myread(objfile,&d1,sizeof(d1));
			}
			break;
			
		case HUNK_DEBUG:	/* 3f1	Debug data */
			myread(objfile,&d1,sizeof(d1));
			get_and_flush(objfile,d1);
			break;
			
		case HUNK_END:		/* 3f2  End of this hunk */
			hunkend++;
			break;
		case HUNK_HEADER:	/* 3f3  hunk summary info for loader */
		case HUNK_OVERLAY:	/* 3f5  overlay table info */
		case HUNK_BREAK:	/* 3f6  end of overlay node */
		default:
			printf("ERROR: can't handle hunk 0x%x\n",d1);
		}
		
	}
	close(objfile);
}

#define MAXEXP 100

void
main(argc,argv)
int	argc;
char	*argv[];
{
	int	i,j;
	int	matches;
	char	names[3000];	/* for expanded file names */
	char	*namep[MAXEXP];	/* array for pointers to file names */
	
	/* parse args, set global flags */

	if ( argc < 2)
	{
		printf("usage: %s [-d] [-r] objfile1 ojbfile2 ...\n",argv[0]);
		exit(1);
	}
	/*
	** Arg processing, nothing great, but sufficient.	
	*/
	for (i = 1 ; i < argc ; i++)
	{
		if (strcmp(argv[i],"-r") == 0)
		{
			pr_ref = 1;
			continue;
		}
		if (strcmp(argv[i],"-d") == 0)
		{
			pr_def = 1;
			continue;
		}
		/*
		** not an arg, must be an object file. 
		** Lattice 3.10 provides the getfnl routine that will take
		** an amigados pattern and build a list of matching files.
		** It this is not available, the input file name could be
		** passed directly to procfile, but the wild card expansion
		** is nice.
		*/
		matches = getfnl(argv[i],names,sizeof(names),0);
		if (matches > 0)
		{
			/* set up pointer array to point to each string */
			if (strbpl(namep,MAXEXP,names) != matches)
			{
				printf("%s - expansion overflow\n",argv[i]);
				continue;
			}
			/* sort the pointers, just to be nice */
			strsrt(namep,matches);
			
			/* process the files .... */
			for ( j = 0 ; j < matches ; j++)
				procfile(namep[j]);
		}
		else
		{
			printf("expansion failed for %s\n",argv[i]);
		}
	}
}

/*
** build a tree node and call t_insert to put it into the tree of defs.
** if t_insert returns  0, this is the only definition of the symbol.
** if t_insert returns -1, there was some unexpected error in t_insert.
** if t_insert returns anything else, it's a pointer to a node containing
**	the first definiton of the symbol. The current entry is not saved
**	in the tree.
*/
void
save_def(fname,hunk,sym)
char	*fname, *hunk, *sym;
{
	/* this routine does the work of building an internal symbol table */
	static T_node t1;
	static T_node *tree = (T_node *)0;
	T_node *rval;
	
	t1.key = sym;
	t1.aux1 = fname;
	t1.aux2 = hunk;
	t1.right = (T_node *)0;
	t1.left  = (T_node *)0;
	rval = t_insert(&tree,&t1);
	if ((int) rval != 0 && (int)rval != -1)
	{
		printf("%s defined in %s(%s) and %s(%s)\n",
			sym,rval->aux1,rval->aux2,fname,hunk);
	}
}

/*
** Insert a node into a binary tree. The tree built is never walked so only
** the insert routine is needed
*/
T_node *
t_insert(head,node)
T_node	**head;  /* note double indirection, this simplfies the code later */
T_node	*node;
{
	T_node  *newnode;
	static char *O_aux1 = (char *)0;
	static char *O_aux2 = (char *)0;
	int	result;
#ifdef DEBUG
	printf("key=%s aux1=%s aux2=%s\n",node->key,node->aux1,node->aux2);	
#endif
	/* check for null head pointer, if so create first node */
	if (*head == (T_node *)0)
	{
		newnode = (T_node *)malloc(sizeof(T_node));
		if (newnode == (T_node *)0)
			return((T_node *)-1);

		newnode->key =
			 (char *) malloc(strlen(node->key)+1);
		strcpy(newnode->key,node->key);
		
		newnode->aux1 = O_aux1 = (char *)malloc(strlen(node->aux1)+1);
		strcpy(newnode->aux1,node->aux1);

		newnode->aux2 = O_aux2 = (char *)malloc(strlen(node->aux2)+1);
		strcpy(newnode->aux2,node->aux2);
#ifdef DEBUG
		printf ("newnode =0x%x\n",newnode);
#endif
		newnode->right = (T_node *)0;
		newnode->left  = (T_node *)0;
		*head = newnode;
		return(0);
	}
	/* walk the tree to find a good spot */
	while (*head != (T_node *)0)
	{
#ifdef DEBUG
		printf ("TOL: head=0x%x *head=0x%x compare <%s> <%s>\n",
			head,*head,(*head)->key,node->key);
#endif
		if ( (result = strcmp((*head)->key,node->key)) == 0)
		{
			return(*head);	/* return pointer to dup node */
		}
#ifdef DEBUG
		printf ("result=%d\n",result);
#endif
		if (result >0)
			head = (T_node **)&(*head)->right;
		else
			head = (T_node **)&(*head)->left;
	}
#ifdef DEBUG
	printf ("EOL: head=0x%x *head=0x%x\n",head,*head);
#endif
	/* didn't find it, link it in....
	** only allocate new space for file and module name if different than
	** last one remembered, otherwise use the previous string */
	if ( (*head = (T_node *)malloc(sizeof(T_node))) == (T_node *)0)
	{
		printf("can't allocate space for node!\n");
		return((T_node *)0);
	}
	(*head)->key = (char *)malloc(strlen(node->key)+1);
	strcpy((*head)->key,node->key);
	
	if (strcmp(node->aux1,O_aux1) == 0)
		(*head)->aux1 = O_aux1;		/* same thing! */
	else
	{
		(*head)->aux1 = (char *)malloc(strlen(node->aux1)+1);
		strcpy((*head)->aux1,node->aux1);
	}
	if (strcmp(node->aux2,O_aux2) == 0)
		(*head)->aux2 = O_aux2;		/* same thing! */
	else
	{
		(*head)->aux2 = (char *)malloc(strlen(node->aux2)+1);
		strcpy((*head)->aux2,node->aux2);
	}
	(*head)->right = (T_node *)0;
	(*head)->left  = (T_node *)0;
	return((T_node *)0);
}
