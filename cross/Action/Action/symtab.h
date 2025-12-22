/*-> (C) 1990 Allen I. Holub                                                */
/* SYMTAB.H:  Symbol-table definitions. Note that <tools/debug.h> and
 *	      <tools/hash.h> must be #included (in that order) before the
 *	      #include for the current file.
 */

#ifndef SYMTAB__H
#define SYMTAB__H

#include "hash.h"
#include "nodeman.h"

#ifdef ALLOC			      /* Allocate variables if ALLOC defined. */
#   define ALLOC_CLS /* empty */

#else
#   define ALLOC_CLS   extern
#endif

#define NAME_MAX  64			    /* Maximum identifier length.     */
#define LABEL_MAX 32			    /* Maximum output-label length.   */

typedef struct symbol			    /* Symbol-table entry.	      */
{
	char   name  [NAME_MAX+1];		/* Input variable name.	      */
	char   rname [NAME_MAX+1];		/* Actual variable name.	      */
	int numb:14;					/*	token value	*/
	unsigned vtype:2;				/*	type of val member	*/
	unsigned level     : 13 ;		/* Declaration lev., field offset.*/
	unsigned implicit  : 1  ;		/* Declaration created implicitly.*/
	unsigned duplicate : 1  ;		/* Duplicate declaration.	      */
	unsigned init		:2;			/* Type of initialization	*/
	int initSize;					/* Nmber of bytes in initialization	*/
	int Token;						/* if zero, we are an identifier	*/
	union {
		int initval;
		char *arrinit;
	}iv;
	struct link *type;		    	/* First link in declarator chain.*/
	struct link *etype;		    	/* Last  link in declarator chain.*/
									/* If a var, the initializer.     */
	struct symbol *next;		    /* Cross link to next variable at */
									/* current nesting level.	      */
	union {
		struct node *n;			/*	pointer to an AST that defines value	*/
		struct value *v;		/*	pointer to a value						*/
		int bitfieldsize;		/*	size of bit field for structure	*/
	}val;
} symbol;

typedef symbol* SYMBOLP	;	//pinter to symbol type

/* values for vtype	*/

#define SYMTAB_VNULL		0	/*	type not defined	*/
#define SYMTAB_VNODE		1	/*	val is an AST pointer	*/
#define SYMTAB_VVALUE		2	/*	val is a value pointer	*/
#define SYMTAB_VFIELD		3	/*	size of bitfield for structure	*/

// values for 'init' field

#define SYMTAB_INIT_NONE	0	/* initval has no meaning	*/
#define SYMTAB_INIT_VALUE	1	/* symbol is initialized to value	*/
#define SYMTAB_INIT_ADDRESS	2	/* Address is defined by user for symbol	*/
#define SYMTAB_INIT_ARRAY	3	/* array is initialized to table of constants	*/

ALLOC_CLS  HASH_TAB  *Symbol_tab;	    /* The actual table. */

#define SYMTAB_POINTER		0		/* Values for declarator.type. 	  */
#define SYMTAB_ARRAY		1
#define SYMTAB_FUNCTION		2
#define SYMTAB_BIT_FIELD	3
#define SYMTAB_PROCEEDURE	4

typedef struct declarator
{
    int dcl_type;			/* POINTER, ARRAY, or FUNCTION	  */
	int string_flag;		/* true if Array is a string	*/
	int num_ele;			/* If class==ARRAY, # of elements */
							/* If bit field, # of bits			*/
	struct symbol *args;	/*	points to chain of symbols specifying arguments	*/
} declarator;


typedef declarator* DECLP;	//pointer to declarator

#define SYMTAB_INT	  0		/* specifier.noun. INT has the value 0 so   */
#define SYMTAB_CHAR	  1		/* that an uninitialized structure defaults */
#define SYMTAB_VOID	  2		/* to int, same goes for EXTERN, below.	    */
#define SYMTAB_STRUCTURE 3
#define SYMTAB_LABEL	  4
#define SYMTAB_BOOL		5	/*	right now, used only for VALUEs	*/
#define SYMTAB_MACRO	6	/*	macro replacement	*/

				/* specifier.sclass			*/
#define SYMTAB_FIXED	  0		/*     At a fixed address.		*/
#define SYMTAB_REGISTER  1		/*     In a register.			*/
#define SYMTAB_AUTO	  2		/*     On the run-time stack.		*/
#define SYMTAB_TYPEDEF	  3		/*     Typedef.				*/
#define SYMTAB_CONSTANT  4		/*     This is a constant.		*/

				/* Output (C-code) storage class	*/
#define NO_OCLASS 0		/*	No output class (var is auto).  */
#define PUB	  1		/*	public				*/
#define PRI	  2		/*	private				*/
#define EXT	  3		/*	extern				*/
#define COM	  4		/*	common				*/


typedef struct specifier
{
    unsigned noun      :3;    /* CHAR INT STRUCTURE LABEL          	 */
    unsigned sclass    :3;    /* REGISTER AUTO FIXED CONSTANT TYPEDEF  	 */
    unsigned oclass    :3;    /* Output storage class: PUB PRI COM EXT.  */
    unsigned _long     :1;    /* 1=long.      0=short.		  	 */
    unsigned _unsigned :1;    /* 1=unsigned.  0=signed.	  		 */
    unsigned _static   :1;    /* 1=static keyword found in declarations. */
    unsigned _extern   :1;    /* 1=extern keyword found in declarations. */
    union
	{						/* Value if constant:			  */
		int	       v_int;	/* Int & char values. If a string const., */
							/* is numeric component of the label.	  */
		unsigned   v_uint;  /* Unsigned int constant value.		  */
		long	   v_long;  /* Signed long constant value.		  */
		unsigned long v_ulong; /* Unsigned long constant value.	  */
		char *v_string;		/* string constant	*/
		struct structdef *v_struct; /* If this is a struct, points at a	*/
									/* structure-table element.		*/
    } const_val;


} specifier;

typedef specifier* SPECP;	//pointer to specifier

#define SYMTAB_DECLARATOR	0
#define SYMTAB_SPECIFIER	1

typedef struct link
{
	unsigned tclass: 1;		/* DECLARATOR or SPECIFIER 	      */
	unsigned tdef  : 1;	    /* For typedefs. If set, current link */
							/* chain was created by a typedef.    */
    union
    {
		specifier     s;		/* If class == DECLARATOR	      */
		declarator    d;		/* If class == SPECIFIER	      */
    }
    select ;
    struct link  *next;		       /* Next element of chain.	      */

} link;


typedef link* LINKP;	//pointer to link structure

/*----------------------------------------------------------------------
 * Use the following p->XXX where p is a pointer to a link structure.
 */

#define SYMTAB_NOUN			select.s.noun
#define SYMTAB_SCLASS		select.s.sclass
#define SYMTAB_LONG			select.s._long
#define SYMTAB_UNSIGNED		select.s._unsigned
#define SYMTAB_EXTERN		select.s._extern
#define SYMTAB_STATIC		select.s._static
#define SYMTAB_OCLASS		select.s.oclass

#define SYMTAB_DCL_TYPE		select.d.dcl_type
#define SYMTAB_NUM_ELE		select.d.num_ele
#define SYMTAB_ARGS			select.d.args

#define VALUE				select.s.const_val
#define V_INT				VALUE.v_int
#define V_UINT				VALUE.v_uint
#define V_LONG				VALUE.v_long
#define V_ULONG				VALUE.v_ulong
#define V_STRING			VALUE.v_string
#define V_STRUCT			VALUE.v_struct

/*----------------------------------------------------------------------
 * Use the following XXX(p) where p is a pointer to a link structure.
 */

#define IS_SPECIFIER(p)  ( (p)->tclass == SYMTAB_SPECIFIER )
#define IS_DECLARATOR(p) ( (p)->tclass == SYMTAB_DECLARATOR )
#define IS_ARRAY(p)    	 ( (p)->tclass == SYMTAB_DECLARATOR && (p)->SYMTAB_DCL_TYPE==SYMTAB_ARRAY   )
#define IS_BIT_FIELD(p)	 ( (p)->tclass == SYMTAB_DECLARATOR && (p)->SYMTAB_DCL_TYPE==SYMTAB_BIT_FIELD)
#define IS_POINTER(p)  	 ( (p)->tclass == SYMTAB_DECLARATOR && (p)->SYMTAB_DCL_TYPE==SYMTAB_POINTER )
#define IS_FUNCT(p)    	 ( (p)->tclass == SYMTAB_DECLARATOR && (p)->SYMTAB_DCL_TYPE==SYMTAB_FUNCTION )
#define IS_STRUCT(p) 	 ( (p)->tclass == SYMTAB_SPECIFIER  && (p)->SYMTAB_NOUN == SYMTAB_STRUCTURE )
#define IS_LABEL(p)      ( (p)->tclass == SYMTAB_SPECIFIER  && (p)->SYMTAB_NOUN == SYMTAB_LABEL     )

#define IS_CHAR(p)       ( (p)->tclass == SYMTAB_SPECIFIER  && (p)->SYMTAB_NOUN == SYMTAB_CHAR )
#define IS_INT(p)        ( (p)->tclass == SYMTAB_SPECIFIER  && (p)->SYMTAB_NOUN == SYMTAB_INT  )
#define IS_UINT(p)	 ( IS_INT(p) && (p)->SYMTAB_UNSIGNED 		 	 )
#define IS_LONG(p)       ( IS_INT(p) && (p)->SYMTAB_LONG 		 	 )
#define IS_ULONG(p)	 ( IS_INT(p) && (p)->LONG && (p)->SYMTAB_UNSIGNED	 )
#define IS_UNSIGNED(p)	 ( (p)->SYMTAB_UNSIGNED				 )


#define IS_AGGREGATE(p)	 ( IS_ARRAY(p) || IS_STRUCT(p)    )
#define IS_PTR_TYPE(p)	 ( IS_ARRAY(p) || IS_POINTER(p)   )

#define	IS_CONSTANT(p)     (IS_SPECIFIER(p) && (p)->SYMTAB_SCLASS == SYMTAB_CONSTANT	)
#define	IS_TYPEDEF(p)      (IS_SPECIFIER(p) && (p)->SYMTAB_SCLASS == SYMTAB_TYPEDEF	)
#define	IS_INT_CONSTANT(p) (IS_CONSTANT(p)  && (p)->SYMTAB_NOUN   == SYMTAB_INT	)

typedef struct structdef
{
    char          tag[NAME_MAX+1];  /* Tag part of structure definition.      */
    unsigned char level;	    /* Nesting level at which struct declared.*/
    symbol        *fields;	    /* Linked list of field declarations.     */
    unsigned      size;		    /* Size of the structure in bytes.	      */

} structdef;

typedef structdef* STRUCTDEFP;


ALLOC_CLS HASH_TAB  *Struct_tab;   /* The actual table.		*/

#define CSIZE	BYTE_WIDTH	/* char */
#define CTYPE	"byte"

#define ISIZE	WORD_WIDTH	/* int */
#define ITYPE	"word"

#define LSIZE	LWORD_WIDTH	/* long */
#define LTYPE	"lword"

#define PSIZE	PTR_WIDTH	/* pointer: 32-bit (8086 large model) */
#define PTYPE	"ptr"

#define STYPE	"record"	/* structure, size undefined */
#define ATYPE	"array"		/* array,     size undefined */

/*****************************************************************
**
** function prototypes
**
*****************************************************************/

#ifdef __cplusplus
extern "C" {
#endif

extern symbol *JoinSymbolChains(symbol *s1, symbol *s2);
extern symbol *new_symbol(char *name,int scope );
extern void discard_symbol(symbol *sym );
extern void discard_symbol_chain(symbol *sym);
extern link *new_link(void );
extern void discard_link_chain(link *p );
extern void discard_link(link *p );
extern structdef *new_structdef(char *tag );
#ifdef STRUCTS_ARE_DISCARDED  /* they aren't in the present compiler */
extern void discard_structdef(structdef *sdef_p );
#endif
extern void add_declarator(symbol *sym,int type );
extern symbol *InsertDeclaratorChain(symbol *s,link *d);
extern void AddDeclaratorChain(symbol *sym,link *l);
extern void spec_cpy(link *dst,link *src );
extern link *clone_type(link *tchain,link **endp );
extern int	the_same_type(link *p1,link *p2,int relax );
extern int	get_sizeof(link *p );
extern symbol	*reverse_links(symbol *sym );
//--------------------------
// symbol table printing routines
//--------------------------
extern char *sclass_str(int sclass );
extern char *oclass_str(int oclass );
extern char *noun_str(int noun );
extern char *attr_str(specifier *spec_p );
extern char *type_str (link *link_p );
extern char *tconst_str(link *type );
extern char *sym_chain_str(symbol *chain );
extern void print_syms(FILE *fp );		/* Print the entire symbol table to   */

#ifdef __cplusplus
}
#endif


#endif

