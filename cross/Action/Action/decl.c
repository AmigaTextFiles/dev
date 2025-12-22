/*-> (C) 1990 Allen I. Holub                                                */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "hash.h"
#include "symtab.h"
#include "value.h"
#include "decl.h"
#include "misc.h"

/* DECL.C	This file contains support subroutines for those actions in c.y
 *		that deal with declarations.
 *
*/
// int yybss(),yydata();

int (*yybss)(const char *,...) = { printf };
int (* yydata)(const char *,...) = {printf};

/*----------------------------------------------------------------------*/

link *new_class_spec(int first_char_of_lexeme )
{
	/* Return a new specifier link with the sclass field initialized to hold
	 * a storage class, the first character of which is passed in as an argument
	 * ('e' for extern, 's' for static, and so forth).
	 */

	link *p  = new_link();
	p->tclass = SYMTAB_SPECIFIER;
	set_class_bit( first_char_of_lexeme, p );
	return p;
}

/*----------------------------------------------------------------------*/

void set_class_bit(int first_char_of_lexeme,link *p )
{
      /* Change the class of the specifier pointed to by p as indicated by the
       * first character in the lexeme. If it's 0, then the defaults are
       * restored (fixed, nonstatic, nonexternal). Note that the TYPEDEF
       * class is used here only to remember that the input storage class
       * was a typedef, the tdef field in the link is set true (and the storage
       * class is cleared) before the entry is added to the symbol table.
       */

      switch( first_char_of_lexeme )
      {
	  case 0:	p->SYMTAB_SCLASS = SYMTAB_FIXED;
		p->SYMTAB_STATIC = 0;
		p->SYMTAB_EXTERN = 0;
		break;

	  case 't': p->SYMTAB_SCLASS  = SYMTAB_TYPEDEF  ;	break;
	  case 'r': p->SYMTAB_SCLASS  = SYMTAB_REGISTER ;	break;
	  case 's': p->SYMTAB_STATIC  = 1        ;	break;
	  case 'e': p->SYMTAB_EXTERN  = 1        ;	break;

      default : yyerror("INTERNAL, set_class_bit: bad storage class '%c'\n",
							  first_char_of_lexeme);
		exit( 1 );
		break;
      }
}

/*----------------------------------------------------------------------*/

link	*new_type_spec(char *lexeme )
{
    /* Create a new specifier and initialize the type according to the indicated
     * lexeme. Input lexemes are: char const double float int long short
     *				  signed unsigned void volatile
     */

    link *p  = new_link();
	p->tclass = SYMTAB_SPECIFIER;

    switch( lexeme[0] )
    {
    case 'c': 	if( lexeme[1]=='h' )			/* char | const	   */
			p->SYMTAB_NOUN = SYMTAB_CHAR ;			/* (Ignore const.) */
		break;
    case 'd':						/* double	 */
    case 'f':	yyerror("No floating point\n");		/* float	 */
		break;

	case 'i':	p->SYMTAB_NOUN	    = SYMTAB_INT;	break;		/* int		 */
	case 'l':	p->SYMTAB_LONG	    = 1;	break;		/* long		 */
	case 'u': 	p->SYMTAB_UNSIGNED = 1;	break;		/* unsigned	 */

    case 'v':	if( lexeme[2] == 'i' )			/* void | volatile */
			p->SYMTAB_NOUN = SYMTAB_VOID;			/* ignore volatile */
		break;
    case 's': 	break;					/* short | signed */
    }							/* ignore both 	  */

    return p;
}

void	add_spec_to_decl(link *p_spec,symbol *decl_chain )
{
    /* p_spec is a pointer either to a specifier/declarator chain created
     * by a previous typedef or to a single specifier. It is cloned and then
     * tacked onto the end of every declaration chain in the list pointed to by
     * decl_chain. Note that the memory used for a single specifier, as compared
     * to a typedef, may be freed after making this call because a COPY is put
     * into the symbol's type chain.
     *
     * In theory, you could save space by modifying all declarators to point
     * at a single specifier. This makes deletions much more difficult, because
     * you can no longer just free every node in the chain as it's used. The
     * problem is complicated further by typedefs, which may be declared at an
     * outer level, but can't be deleted when an inner-level symbol is
     * discarded. It's easiest to just make a copy.
     *
     * Typedefs are handled like this: If the incoming storage class is TYPEDEF,
     * then the typedef appeared in the current declaration and the tdef bit is
     * set at the head of the cloned type chain and the storage class in the
     * clone is cleared; otherwise, the clone's tdef bit is cleared (it's just
     * not copied by clone_type()).
     */

    link *clone_start, *clone_end ;

    for( ; decl_chain ; decl_chain = decl_chain->next )
    {
		if( !(clone_start = clone_type(p_spec, &clone_end)) )
		{
			yyerror("INTERNAL, add_typedef_: Malformed chain (no specifier)\n");
			exit( 1 );
		}
		else
		{
			if( !decl_chain->type )			  /* No declarators. */
				decl_chain->type = clone_start ;
			else
				decl_chain->etype->next = clone_start;

			decl_chain->etype = clone_end;

			if( IS_TYPEDEF(clone_end) )
			{
				set_class_bit( 0, clone_end );
				decl_chain->type->tdef = 1;
			}
		}
    }
}

void RemoveSymbols(symbol *sym)
{
	/*
	** this function removes the symbol chain from the symbol table but
	** it does not destroy them
	*/
	symbol *exists;
	int loop;

	while(sym)
	{
		exists = (symbol *)findsym(Symbol_tab,sym->name);
		if(!exists)
			loop=0;
		else
			loop = 1;
		while(loop)
		{
			if(exists == sym)
			{
				delsym(Symbol_tab,sym);		/*	remove symbol	*/
				loop=0;
			}
			else
			{
				exists = (symbol *)nextsym(Symbol_tab,exists);
				if(!exists)
				{
					loop = 0;
					yyerror("Internal Error:RemoveSymbol(%s)\n",sym->name);
				}
			}
		}
		sym = sym->next;
	}
}

void add_symbols_to_table(symbol *sym )
{
    /* Add declarations to the symbol table.
     *
     * Serious redefinitions (two publics, for example) generate an error
     * message. Harmless redefinitions are processed silently. Bad code is
     * generated when an error message is printed. The symbol table is modified
     * in the case of a harmless duplicate to reflect the higher precedence
     * storage class: (public == private) > common > extern.
     *
     * The sym->rname field is modified as if this were a global variable (an
     * underscore is inserted in front of the name). You should add the symbol
     * chains to the table before modifying this field to hold stack offsets
     * in the case of local variables.
     */

    symbol *exists;		/* Existing symbol if there's a conflict.    */
    int    harmless;
    symbol *new;

    for(new = sym; new ; new = new->next )
    {
	exists = (symbol *) findsym(Symbol_tab, new->name);

	if( !exists || exists->level != new->level )
	{
	    sprintf ( new->rname, "_%1.*s", sizeof(new->rname)-2, new->name);
	    addsym  ( Symbol_tab, new );
	}
	else
	{
	    harmless	   = 0;
	    new->duplicate = 1;

	    if( the_same_type( exists->type, new->type, 0) )
	    {
		if( exists->etype->SYMTAB_OCLASS==EXT || exists->etype->SYMTAB_OCLASS==COM )
		{
		    harmless = 1;

			if( new->etype->SYMTAB_OCLASS != EXT )
		    {
				exists->etype->SYMTAB_OCLASS = new->etype->SYMTAB_OCLASS;
				exists->etype->SYMTAB_SCLASS = new->etype->SYMTAB_SCLASS;
				exists->etype->SYMTAB_EXTERN = new->etype->SYMTAB_EXTERN;
				exists->etype->SYMTAB_STATIC = new->etype->SYMTAB_STATIC;
		    }
		}
	    }
	    if( !harmless )
		yyerror("Duplicate declaration of %s\n", new->name );
	}
    }
}

/*----------------------------------------------------------------------*/

symbol	*remove_duplicates(symbol *sym )
{
    /* Remove all nodes marked as duplicates from the linked list and free the
     * memory. These nodes should not be in the symbol table. Return the new
     * head-of-list pointer (the first symbol may have been deleted).
     */

    symbol *prev  = NULL;
    symbol *first = sym;

    while( sym )
    {
	if( !sym->duplicate )		    /* Not a duplicate, go to the     */
	{				    /* next list element.	      */
	    prev = sym;
	    sym  = sym->next;
	}
	else if( prev == NULL )		    /* Node is at start of the list.  */
	{
	    first = sym->next;
	    discard_symbol( sym );
	    sym = first;
	}
	else			    	    /* Node is in middle of the list. */
	{
	    prev->next = sym->next;
	    discard_symbol( sym );
	    sym = prev->next;
	}
    }
    return first;
}


/*----------------------------------------------------------------------*/


int  illegal_struct_def(structdef *cur_struct,symbol *fields )
{
    /* Return true if any of the fields are defined recursively or if a function
     * definition (as compared to a function pointer) is found as a field.
     */

    for(; fields; fields = fields->next )
    {
	if( IS_FUNCT(fields->type) )
	{
	    yyerror("struct/union member may not be a function");
	    return 1;
	}
	if( IS_STRUCT(fields->type) &&
			 !strcmp( fields->type->V_STRUCT->tag, cur_struct->tag))
	{
	    yyerror("Recursive struct/union definition\n");
	    return 1;
	}
    }
    return 0;
}
/*----------------------------------------------------------------------*/

int  figure_struct_offsets(symbol *p,int is_struct )
/* symbol	*p;				 Chain of symbols for fields.	*/
/* int	is_struct;			 0 if a union. 		*/
{
    /* Figure the field offsets and return the total structure size. Assume
     * that the first element of the structure is aligned on a worst-case
     * boundary. The returned size is always an even multiple of the worst-case
     * alignment. The offset to each field is put into the "level" field of the
     * associated symbol.
     */

    int	 obj_size;
    int  offset = 0;

    for( ; p ; p = p->next )
    {
		if( !is_struct )			/* It's a union. */
		{
			offset   =  get_sizeof( p->type );
//
//			offset   = max( offset, get_sizeof( p->type ) );
			p->level = 0;
		}
		else
		{
				obj_size   = get_sizeof    ( p->type );
				p->level  = offset;
				offset   += obj_size ;
		}
    }
    /* Return the structure size: the current offset rounded up to the	    */
    /* worst-case alignment boundary. You need to waste space here in case  */
    /* this is an array of structures.					    */

//    while( offset % ALIGN_WORST )
//		++offset ;
    return offset;
}
/*----------------------------------------------------------------------*/

int	get_alignment(link *p )
{
    /* Returns the alignment--the number by which the base address of the object
     * must be an even multiple. This number is the same one that is returned by
     * get_sizeof(), except for structures which are worst-case aligned, and
     * arrays, which are aligned according to the type of the first element.
     */

    int size;

    if( !p )
    {
		yyerror("INTERNAL, get_alignment: NULL pointer\n");
		exit( 1 );
	}
	if( IS_BIT_FIELD( p ) ) return ALIGN_WORST;
    if( IS_ARRAY( p )		) return get_alignment( p->next );
    if( IS_STRUCT( p )		) return ALIGN_WORST;
	if( size = get_sizeof( p )	) return size;

    yyerror("INTERNAL, get_alignment: Object aligned on zero boundary\n");
	exit( 1 );
    return(0);
}

void do_enum(symbol *sym,int val )
{
    if( conv_sym_to_int_const( sym, val ) )
	addsym( Symbol_tab, sym );
    else
    {
	yyerror( "%s: redefinition", sym->name );
	discard_symbol( sym );
    }
}
/*---------------------------------------------------------------------*/
int	conv_sym_to_int_const(symbol *sym,int val )
{
    /* Turn an empty symbol into an integer constant by adding a type chain
     * and initializing the v_int field to val. Any existing type chain is
     * destroyed. If a type chain is already in place, return 0 and do
     * nothing, otherwise return 1. This function processes enum's.
     */
    link *lp;

    if( sym->type )
	return 0;
    lp	    	= new_link();
	lp->tclass   = SYMTAB_SPECIFIER;
	lp->SYMTAB_NOUN    = SYMTAB_INT;
	lp->SYMTAB_SCLASS  = SYMTAB_CONSTANT;
    lp->V_INT   = val ;
    sym->type   = lp;
    *sym->rname = '\0';
    return 1;
}

void	fix_types_and_discard_syms(symbol *sym )
{
    /* Patch up subroutine arguments to match formal declarations.
     *
     * Look up each symbol in the list. If it's in the table at the correct
     * level, replace the type field with the type for the symbol in the list,
     * then discard the redundant symbol structure. All symbols in the input
     * list are discarded after they're processed.
     *
     * Type checking and automatic promotions are done here, too, as follows:
     *		chars  are converted to int.
     *		arrays are converted to pointers.
     *		structures are not permitted.
     *
     * All new objects are converted to autos.
     */

    symbol *existing, *s;

    while( sym )
    {
	if( !( existing = (symbol *)findsym( Symbol_tab,sym->name) )
					|| sym->level != existing->level )
	{
	    yyerror("%s not in argument list\n", sym->name );
	    exit(1);
	}
	else if( !sym->type ||  !sym->etype )
	{
	    yyerror("INTERNAL, fix_types: Missing type specification\n");
	    exit(1);
	}
	else if( IS_STRUCT(sym->type) )
	{
	    yyerror("Structure passing not supported, use a pointer\n");
	    exit(1);
	}
	else if( !IS_CHAR(sym->type) )
	{
	    /* The existing symbol is of the default int type, don't redefine
	     * chars because all chars are promoted to int as part of the call,
	     * so can be represented as an int inside the subroutine itself.
	     */

	    if( IS_ARRAY(sym->type) ) 		/* Make it a pointer to the */
		sym->type->SYMTAB_DCL_TYPE = SYMTAB_POINTER;  /* first element.	    */

		sym->etype->SYMTAB_SCLASS = SYMTAB_AUTO;		/* Make it an automatic var.  */

	    discard_link_chain(existing->type); /* Replace existing type      */
	    existing->type     = sym->type;	/* chain with the current one.*/
	    sym->type 	       = NULL;		/* Must be NULL for discard_- */
						/* symbol() call, below.      */
	}
	s = sym->next;
	discard_symbol( sym );
	sym = s;
    }
}

/*----------------------------------------------------------------------*/

int	figure_param_offsets(symbol *sym )
{
    /* Traverse the chain of parameters, figuring the offsets and initializing
     * the real name (in sym->rname) accordingly. Note that the name chain is
     * assembled in reverse order, which is what you want here because the
     * first argument will have been pushed first, and so will have the largest
     * offset. The stack is 32 bits wide, so every legal type of object will
     * require only one stack element. This would not be the case were floats
     * or structure-passing supported. This also takes care of any alignment
     * difficulties.
     *
     * Return the number of 32-bit stack words required for the parameters.
     */

    int	 offset = 4;		/* First parameter is always at BP(fp+4). */

    for(; sym ; sym = sym->next )
    {
	if( IS_STRUCT(sym->type) )
	{
	    yyerror("Structure passing not supported\n");
	    continue;
	}

	sprintf( sym->rname, "fp+%d", offset );
	offset += SWIDTH ;
    }

    /* Return the offset in stack elements, rounded up if necessary.  */

    return( (offset / SWIDTH) + (offset % SWIDTH != 0) );
}

/*----------------------------------------------------------------------*/

void	print_offset_comment(symbol *sym,char *label )
{
    /* Print a comment listing all the local variables.  */

    for(; sym ; sym = sym->next )
	printf/*yycode*/( "\t/* %16s = %-16s [%s] */\n", sym->rname, sym->name, label );
}
