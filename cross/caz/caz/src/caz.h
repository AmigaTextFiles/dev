#define MAXLABEL 32
#define MAXDIRECTIVE MAXLABEL
#define MAXCMD	5
#define MAXOBCODE 0xFFFF
#define NEWITEMOFF 5		/* should be greater in future (64) */
#define MAXBYTESIH 16		/* maximum of Data Bytes in any INTELHEX row */

#define FILL_CHAR 0xff		/* character to fill DEFS space */

#define MAX(a,b) ((a)>(b)?(a):(b))
#define MIN(a,b) ((a)<(b)?(a):(b))
#define ABS(x) ((x<0)?(-(x)):(x))

#define ERROR -1
#define U_ERROR 0xFFFFFFFF
#define SERIOUS -2
#define TRUE 1
#define FALSE 0

#define RETURN_OK			    0  /* No problems, success */
#define RETURN_WARN			    5  /* A warning only */
#define RETURN_ERROR			   10  /* Something wrong */
#define RETURN_FAIL			   20  /* Complete or severe failure*/

struct item_file
{
	struct item_file *prev;						/* Previous Item */
	char              filename[FILENAME_MAX];	/* Filename of pushed/poped File */
	long			  filepos;					/* Absolute Filepostion (seek) */
	long			  lnr;						/* Actual linenumber in this file */
};

struct labelitem
{
	u_short 	value;
	BOOL	valid;
    int		type;
	char	name[MAXLABEL+1];
};

struct listheader
{
	int		nitem;		/* Total number of item's in list */
	int		actitem;	/* Next/First unused item */
	int		sizeitem;	/* Size of one item */
	int		newnitem;	/* Size of list to small ? => Alloc 'n' new items */
	int 	userdata;	/* until yet not used */
	void    *list;		/* data */
};

/* Note: Size of Objectcode is 'lastbyte-firstbyte', so unfilled ranges
         generated with 'ORG' directives are also counted.
		 To get actual 'objbuffer' address you must always subtract 'firstbyte' !
*/		 
struct objsize
{
	int		firstbyte;  /* Start address of used Range */
	int		actbyte;	/* Actual address */
	int		lastbyte;	/* End address */
	u_char  *objbuffer;	/* Pointer to object buffer */
};

#define OBJADABS	1	/* set Object Adress absolute */
#define OBJADREL	2	/* set Object Adress relativ */

/* Label Types */
#define L_EQU		1	/* directive type : EQU, constant declaration */
#define L_DEFL		2	/* directive type : EQU, constant declaration */
#define L_POSITION	3	/* directive type : Adress/Memory assignment */

#define PARSE1		1	/* flag */
#define PARSE2		2

#define ORG  		0        	
#define EQU  		L_EQU    	
#define DEFL 		L_DEFL    	
#define DEFB 		3        	
#define DEFW 		4 	       	
#define DEFS 		5       	
#define DEFM 		6        	
#define INCLUDE 	7
#define END			8
#define LIST		9
#define LIST_OFF	10
#define LIST_ON		11
#define COND		12
#define ENDC		13
#define EJECT		14
#define MACLIST		15
#define HEADING		16
#define MACRO		17
#define ENDM		18
#define DEFBASE		19


/*
 *	Definitions for Commands
 */

#define BRA_Z		0x00000001
#define BRA_NZ		0x00000002	
#define BRA_C		0x00000004	/* same as REG_C */	
#define BRA_NC		0x00000008	
#define BRA_PO		0x00000010			
#define BRA_PE		0x00000020			
#define BRA_P		0x00000040		
#define BRA_M 		0x00000080		

#define REG_A		0x00000001	
#define REG_B		0x00000002
#define REG_C		0x00000004	/* same as BRA_C */
#define REG_D		0x00000008
#define REG_E		0x00000010
#define REG_F		0x00000020
#define REG_H		0x00000040
#define REG_I		0x00000080
#define REG_L		0x00000100
#define REG_R		0x00000200
#define REG_AF		0x00000400
#define REG_BC		0x00000800	
#define REG_DE		0x00001000	
#define REG_HL		0x00002000
#define REG_SP		0x00004000
#define REG_IX		0x00008000
#define REG_IY		0x00010000

#define BRA			0x00020000	/* Mne makes a branch (means flags) */
#define NBR			0x00040000	/* Mne uses all other than branches */
#define OFF			0x00080000
#define IND			0x00100000	/* Indirekt Adressing */	
#define	IMODE0		0x00200000	/* works together with UNM3 */
#define	IMODE1		0x00400000	/* works together with UNM3 */
#define	IMODE2		(IMODE0|IMODE1)	/* works together with UNM3 */

#define EXMASK		(IND|IMODE2|OFF|NBR|BRA) /* Bits with must be equivalent with argument */

#define RST			0x04000000	/* only for RST Mnemomic */
#define JMPREL		0x08000000	/* Jump Offset must be relativ to current position */
#define UNM3		0x10000000	
#define UNM8		0x20000000
#define UNM16		0x40000000	

#define NOPAR		0x80000000

#define REG8 		(REG_A|REG_B|REG_C|REG_D|REG_E|REG_H|REG_L)
#define REG16 		(REG_BC|REG_DE|REG_HL|REG_SP)
#define REG			(REG8|REG16|REG_F|REG_I|REG_R|REG_AF|REG_IX|REG_IY)
#define BRANCH4		(BRA_NZ|BRA_Z|BRA_NC|BRA_C)
#define BRANCH8		(BRANCH4|BRA_PO|BRA_PE|BRA_P|BRA_M)
#define UNM			(UNM3|UNM8|UNM16)

#define BYTE1		0x00
#define BYTE2		0x01
#define BYTE3		0x02
#define BYTE4		0x03

#define BYTE(A)		((A)&0x03)

#define BIT0		0x00
#define BIT1		0x04
#define BIT2		0x08
#define BIT3		0x0C
#define BIT4		0x10
#define BIT5		0x14
#define BIT6		0x18
#define BIT7		0x1C

#define BIT(A)		(((A)&0x1C)>>2)

#define MNELE1		0x00	/* Length of the Mnemomic */
#define MNELE2		0x20
#define MNELE3		0x40
#define MNELE4		0x60

#define MNELEN(A)	((((A)&0x60)>>5)+1)

#define NOE			0x80

#define LOBYTE(A)	((u_char)(A))	
#define HIBYTE(A)	((u_char)((A)>>8))

struct command 
{
	char 	*name;		/* name of Mnemomic */
	u_long 	pa1,		/* first Parameter */
			pa2;		/* second Parameter */
	u_char	order1,		/* 0,1:Byte Nr / 2,3,4:Bit position/ 5,6:Mnemomic Length */
			order2;		/* 0,1:Byte Nr / 2,3,4:Bit position */
	u_char 	obj[4];		/* Object Code */
	u_short	cycle;		/* Number of Clock Cycles */
};

