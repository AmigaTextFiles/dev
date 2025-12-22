OPT MODULE
OPT EXPORT



/**************************************************
 *
 *
 *              PPCLoadElfObjectTags(
 *
 *
 **************************************************/


CONST     TAG_UTENTE = 			$80000000
CONST	PPCELFLOADOBJECTTAG_DUMMY = TAG_UTENTE + $23300

/* pointer to a filename of the elf file */
CONST	PPCELFLOADTAG_ELFNAME = PPCELFLOADOBJECTTAG_DUMMY + $0

/* pointer to the elf stream resident in memory. */
CONST	PPCELFLOADTAG_ELFADDRESS	= PPCELFLOADOBJECTTAG_DUMMY + $1

/* length of the elf stream. This tag is optional  */
CONST	PPCELFLOADTAG_ELFLENGTH = PPCELFLOADOBJECTTAG_DUMMY + $2

CONST	PPCELFLOADTAG_HOOK = PPCELFLOADOBJECTTAG_DUMMY + $3

/* Load an ElfObject as a SharedLib Module */
CONST	PPCELFLOADTAG_LIBRARY = PPCELFLOADOBJECTTAG_DUMMY + $4

/* File Ptr */
CONST	PPCELFLOADTAG_FILE = PPCELFLOADOBJECTTAG_DUMMY + $5

/* pointer to THE name of the elf lib */
CONST	PPCELFLOADTAG_ELFLIBNAME = PPCELFLOADOBJECTTAG_DUMMY + $6

/* Ask for at least version x of a SharedLib Module */ 
CONST	PPCELFLOADTAG_LIBVERSION	= PPCELFLOADOBJECTTAG_DUMMY + $7

/* Ask for at least revision x of a SharedLib Module*/
CONST	PPCELFLOADTAG_LIBREVISION = PPCELFLOADOBJECTTAG_DUMMY + $8

/* Ask for the specific version of a SharedLib Module */
CONST	PPCELFLOADTAG_LIBEXACTVERSION	= PPCELFLOADOBJECTTAG_DUMMY + $9
CONST	PPCELFLOADTAG_LIBEXACTREVISION = PPCELFLOADOBJECTTAG_DUMMY + $a




OBJECT elfstreammsg
	type;
	arg1;	/* Open->No Meaning,Close->No Meaning,Read->Address,Seek->Offset */
	arg2;	/* Open->No Meaning,Close->No Meaning,Read->Length,Seek->Type */
ENDOBJECT

/* The Result must be a Handle */
CONST	PPCELFLOADTYPE_OPEN	= 0
/* The Result must be a boolean */
CONST	PPCELFLOADTYPE_CLOSE = 1
/* The Result must be the read length or -1 */
CONST	PPCELFLOADTYPE_READ	= 2
/* The Result must be the old offset or -1 */
CONST	PPCELFLOADTYPE_SEEK	= 3

/**************************************************
 *
 *
 *              PPCGetElfInfos() Tags
 *
 *
 **************************************************/

CONST	PPCELFINFOTAG_DUMMY	= TAG_UTENTE + $23000

/* Returns the name of an elfobject */
CONST	PPCELFINFOTAG_NAME = PPCELFINFOTAG_DUMMY + $0
CONST	PPCELFINFOTAG_RELOC	= PPCELFINFOTAG_DUMMY + $1
CONST	PPCELFINFOTAG_GLOBAL = PPCELFINFOTAG_DUMMY + $2


/* Define this Hook if you wanna get informations about every
   Symbol in a specific ElfObject or in all.
   (ElfObject==NULL || PPCELFINFOTAG_GLOBAL=TRUE)
   That`s the way how the PPCGetObjectInfo() calls your hook.
   MyInfo contains the passed infos, so you could show all
   important symbols or relocs if possible.

   CallHookPkt(ScanSymbolHook,
               (APTR) ElfSubStructure, // Not really useful
               (APTR) MyInfo);

 */
CONST	PPCELFINFOTAG_SCANSYMBOLHOOK = PPCELFINFOTAG_DUMMY + $3



OBJECT	ppcobjectinfo

	address
	name:PTR TO CHAR
	type
	subtype
	binding
	size
ENDOBJECT

CONST	PPCELFINFOTYPE_SECTION =		0
CONST	PPCELFINFOTYPE_SYMBOL =		1
CONST	PPCELFINFOTYPE_COMSYMBOL =	2
CONST	PPCELFINFOTYPE_RELOC =		3



/*------------------------------------------------------------------------*/
/*  definition of the symbol types`	 	                                   */
/*------------------------------------------------------------------------*/

CONST	STT_NOTYPE=	0
CONST	STT_OBJECT=	1
CONST	STT_FUNC=	2
CONST	STT_SECTION=	3
CONST	STT_FILE=	4
CONST	STT_LOPROC=	13
CONST	STT_HIPROC=	15


/*------------------------------------------------------------------------*/
/*  definition of the symbol bindings 	                                   */
/*------------------------------------------------------------------------*/

CONST	STB_LOCAL	=	0
CONST	STB_GLOBAL=		1
CONST	STB_WEAK	=	2
CONST	STB_LOPROC=		13
CONST	STB_HIPROC=		15


/*------------------------------------------------------------------------*/
/*  definition of the supported elf.rela types                            */
/*------------------------------------------------------------------------*/

CONST  R_PPC_NONE=			0
CONST  R_PPC_ADDR32	=		1
CONST  R_PPC_ADDR24	=		2
CONST  R_PPC_ADDR16	=		3
CONST  R_PPC_ADDR16_L=			4
CONST  R_PPC_ADDR16_HI=		5
CONST  R_PPC_ADDR16_HA	=	6
CONST  R_PPC_ADDR14	=		7
CONST  R_PPC_ADDR14_BRTAKEN=		8
CONST  R_PPC_ADDR14_BRNTAKEN=		9
CONST  R_PPC_REL24	=		10
CONST  R_PPC_REL14	=		11
CONST  R_PPC_REL14_BRTAKEN=		12
CONST  R_PPC_REL14_BRNTAKEN=		13
CONST  R_PPC_GOT16	=		14
CONST  R_PPC_GOT16_LO=			15
CONST  R_PPC_GOT16_HI=			16
CONST  R_PPC_GOT16_HA=			17
CONST  R_PPC_PLTREL24=			18
CONST  R_PPC_COPY	=		19
CONST  R_PPC_GLOB_DAT=			20
CONST  R_PPC_JMP_SLOT	=		21
CONST  R_PPC_RELATIVE	=		22
CONST  R_PPC_LOCAL24PC	=	23
CONST  R_PPC_UADDR32=			24
CONST  R_PPC_UADDR16=			25
CONST  R_PPC_REL32=			26
CONST  R_PPC_PLT32=			27
CONST  R_PPC_PLTREL32=			28
CONST  R_PPC_PLT16_LO=			29
CONST  R_PPC_PLT16_HI=			30
CONST  R_PPC_PLT16_HA=			31
CONST  R_PPC_SDAREL16=			32
CONST  R_PPC_SECTOFF=			33
CONST  R_PPC_SECTOFF_LO	=	34
CONST  R_PPC_SECTOFF_HI	=	35
CONST  R_PPC_SECTOFF_HA	=	34


