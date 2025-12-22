/*-> (C) 1990 Allen I. Holub                                                */
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include "hash.h"
#include "symtab.h"	   /* Symbol-table definitions.			      */
#include "value.h"	   /* Value definitions.			      */
#include "label.h"	   /* Labels to use for compiler-generated symbols.   */
#include "misc.h"

/*----------------------------------------------------------------------*/

static symbol	  *Symbol_free = NULL; /* Free-list of recycled symbols.    */
static link	  *Link_free   = NULL; /* Free-list of recycled links.	    */
static structdef *Struct_free = NULL; /* Free-list of recycled structdefs. */
static int SymsAllocated,LinksAllocated;

static void psym(symbol *sym_p,FILE *fp );
static	void pstruct(structdef *sdef_p,FILE *fp );

#define LCHUNK	10	    /* new_link() gets this many nodes at one shot.*/
/*----------------------------------------------------------------------*/

symbol *JoinSymbolChains(symbol *s1, symbol *s2)
{
	/*
		This function joins s2 to the end of
		the symbol chain specified by s1
		returns s1
		This function added by Jim Patchell
		Feb 22, 2010
	*/
	symbol *pChain = s1;

	if(pChain)
	{
		//find the end of the chain
		while(pChain->next)
			pChain = pChain->next;
		pChain->next = s2;
	}
	return s1;
}

/*----------------------------------------------------------------------*/

symbol	*new_symbol(char *name,int scope )
{
    symbol *sym_p;

    if( !Symbol_free )					/* Free list is empty.*/
		sym_p = (symbol *) newsym( sizeof(symbol) );
    else						/* Unlink node from   */
    {							/* the free list.     */
		sym_p 	    = Symbol_free;
		Symbol_free = Symbol_free->next ;
		memset( sym_p, 0, sizeof(symbol) );
    }

    strncpy( sym_p->name, name, sizeof(sym_p->name) );
    sym_p->level = scope;
    return sym_p;
}

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/

void	discard_symbol(symbol *sym )
{
    /* Discard a single symbol structure and any attached links and args. Note
     * that the args field is recycled for initializers, the process is
     * described later on in the text (see value.c in the code), but you have to
     * test for a different type here. Sorry about the forward reference.
     */

	if( sym )
	{
		if( IS_FUNCT( sym->type ) )
			discard_symbol_chain( sym->type->SYMTAB_ARGS );	/* Function arguments. */
		else if (sym->vtype == SYMTAB_VNODE)
		{
			DiscardTree(sym->val.n);		/*	discard AST	*/
		}
		else if (sym->vtype == SYMTAB_VVALUE)
		{
			discard_value(sym->val.v);		/* If an initializer.  */
		}
		discard_link_chain( sym->type );				/* Discard type chain. */

		sym->next   = Symbol_free;						/* Put current symbol */
		Symbol_free = sym;			      				/* in the free list.  */
	}
}

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/

void discard_symbol_chain(symbol *sym)   /* Discard an entire cross-linked */
{
symbol *p = sym;

	while( sym )
	{
		p = sym->next;
		discard_symbol( sym );
		sym = p;
	}
}

/*----------------------------------------------------------------------*/

link *new_link( )
{
    /* Return a new link. It's initialized to zeros, so it's a declarator.
     * LCHUNK nodes are allocated from malloc() at one time.
     */

    link *p;
 
	LinksAllocated++;
	p = (link *)malloc(sizeof(link));
    memset( p, 0, sizeof(link) );
    return p;
}

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/

void discard_link_chain(link *p )
{
    /* Discard all links in the chain. Nothing is removed from the structure
     * table, however. There's no point in discarding the nodes one at a time
     * since they're already linked together, so find the first and last nodes
     * in the input chain and link the whole list directly.
     */

    link *start ;

	if(p)
	{
		do
		{
			start = p->next;
			discard_link(p);
			p = start;
		}while(p);
	}
}

/*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

void discard_link(link *p )		 /* Discard a single link. */
{
	LinksAllocated--;
	free(p);
}

/*----------------------------------------------------------------------*/

structdef *new_structdef(char *tag )		/* Allocate a new structdef. */
{
    structdef *sdef_p;

    if( !Struct_free )
	sdef_p = (structdef *) newsym( sizeof(structdef) );
    else
    {
	sdef_p 	    = Struct_free;
	Struct_free = (structdef *)(Struct_free->fields);
	memset( sdef_p, 0, sizeof(structdef) );
    }
    strncpy( sdef_p->tag, tag, sizeof(sdef_p->tag) );
    return sdef_p;
}

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
#ifdef STRUCTS_ARE_DISCARDED  /* they aren't in the present compiler */

void discard_structdef(structdef *sdef_p )
{
    /* Discard a structdef and any attached fields, but don't discard linked
     * structure definitions.
     */

    if( sdef_p )
    {
	discard_symbol_chain( sdef_p->fields );

	sdef_p->fields = (symbol *)Struct_free ;
	Struct_free    = sdef_p;
	}
}

#endif

void add_declarator(symbol *sym,int type )
{
	/* Add a declarator link to the end of the chain, the head of which is
	 * pointed to by sym->type and the tail of which is pointed to by
	 * sym->etype. *head must be NULL when the chain is empty. Both pointers
	 * are modified as necessary.
	 */

	link *link_p;

	if( type == SYMTAB_FUNCTION && IS_ARRAY(sym->etype) )
	{
		yyerror("Array of functions is illegal, assuming function pointer\n");
		add_declarator( sym, SYMTAB_POINTER );
	}

	link_p = new_link();	  /* The default class is DECLARATOR. */
	link_p->SYMTAB_DCL_TYPE = type;

	if( !sym->type )
		sym->type = sym->etype = link_p;
	else
	{
		sym->etype->next = link_p;
		sym->etype       = link_p;
	}
}

void AddDeclaratorChain(symbol *sym,link *l)
{
	/*
	** This function is copyright (c) 1994 by Jim Patchell
	** Attatches declarator chain l to the end of the type chain
	** in sym
	*/
	link *e;

	e = l;
	if(l != NULL);
	while(e->next != NULL)
		e = e->next;	/*	find end of declarator chain	*/
	if(sym->etype != NULL)
	{
		sym->etype->next = l;
		sym->etype = e;
	}
	else
	{
		sym->type = l;	/*	no chain to add to	*/
		sym->etype = e;
	}
}

symbol *InsertDeclaratorChain(symbol *s,link *d)
{
	/* inserts a declarator chain at the end of the declarator type chain	*/
	/*	Boy is this a kluge
	** Copyright (c) 1994 by Jim Patchell
	*/
	link *l,*m;

	l = d;
	while(l->next != NULL)
		l = l->next;
	if(s->type == NULL)
	{
		m = s->type;
	}
	else
	{
		m = s->type;
		while((m->next != NULL) && (IS_DECLARATOR(m->next)) )
		{
			m = m->next;
		}
	}
	if(s->etype == NULL)
	{
		s->etype = l;
		l->next = s->type;
		s->type = d;
	}
	else
	{
		if(m->next == NULL)
		{
			m->next = d;
			s->etype = l;
		}
		else
		{
			l->next = s->etype;
			m->next = d;
		}
	}
	return s;
}

void spec_cpy(link *dst,link *src )     /* Copy all initialized fields in src to dst.*/
{

	if( src->SYMTAB_NOUN 	) dst->SYMTAB_NOUN	= src->SYMTAB_NOUN     ;
	if( src->SYMTAB_SCLASS	) dst->SYMTAB_SCLASS	= src->SYMTAB_SCLASS   ;
	if( src->SYMTAB_LONG 	) dst->SYMTAB_LONG	= src->SYMTAB_LONG     ;
	if( src->SYMTAB_UNSIGNED	) dst->SYMTAB_UNSIGNED = src->SYMTAB_UNSIGNED ;
	if( src->SYMTAB_STATIC	) dst->SYMTAB_STATIC  	= src->SYMTAB_STATIC   ;
	if( src->SYMTAB_EXTERN	) dst->SYMTAB_EXTERN   = src->SYMTAB_EXTERN   ;
    if( src->tdef	) dst->tdef     = src->tdef     ;

	if( src->SYMTAB_SCLASS == SYMTAB_CONSTANT || src->SYMTAB_NOUN == SYMTAB_STRUCTURE)
	memcpy( &dst->VALUE, &src->VALUE, sizeof(src->VALUE) );
}

link *clone_type(link *tchain,link **endp)
/* link  *tchain;		 input:  Type chain to duplicate.         	  */
/* link  **endp;		 output: Pointer to last node in cloned chain.  */
/* if mode is true, then copy constant info	*/
{
    /* Manufacture a clone of the type chain in the input symbol. Return a
     * pointer to the cloned chain, NULL if there were no declarators to clone.
     * The tdef bit in the copy is always cleared.
     */

    link  *last, *head = NULL;

    for(; tchain ; tchain = tchain->next )
    {
		if( !head )					/* 1st node in chain. */
			head = last = new_link();
		else						/* Subsequent node.   */
		{
			last->next = new_link();
			last       = last->next;
		}

		memcpy( last, tchain, sizeof(*last) );
		last->next = NULL;
		last->tdef = 0;
    }

    *endp = last;
    return head;
}

/*----------------------------------------------------------------------*/

int	the_same_type(link *p1,link *p2,int relax )
{
    /* Return 1 if the types match, 0 if they don't. Ignore the storage class.
     * If "relax" is true and the array declarator is the first link in the
     * chain, then a pointer is considered equivalent to an array.
     */

     if( relax && IS_PTR_TYPE(p1) && IS_PTR_TYPE(p2) )
     {
	p1 = p1->next;
	p2 = p2->next;
     }

     for(; p1 && p2 ; p1 = p1->next, p2 = p2->next)
     {
	if( p1->tclass != p2->tclass )
	    return 0;

	if( p1->tclass == SYMTAB_DECLARATOR )
	{
		if( (p1->SYMTAB_DCL_TYPE != p2->SYMTAB_DCL_TYPE) ||
			(p1->SYMTAB_DCL_TYPE==SYMTAB_ARRAY && (p1->SYMTAB_NUM_ELE != p1->SYMTAB_NUM_ELE)) )
		return 0;
	}
	else						/* this is done last */
	{
		if( (p1->SYMTAB_NOUN     == p2->SYMTAB_NOUN     ) && (p1->SYMTAB_LONG == p2->SYMTAB_LONG ) &&
			(p1->SYMTAB_UNSIGNED == p2->SYMTAB_UNSIGNED ) )
	    {
		return ( p1->SYMTAB_NOUN==SYMTAB_STRUCTURE ) ? p1->V_STRUCT == p2->V_STRUCT
					       : 1 ;
	    }
	    return 0;
	}
     }

     yyerror("INTERNAL the_same_type: Unknown link class\n");
     return 0;
}

/*----------------------------------------------------------------------*/

int	get_sizeof(link *p )
{
    /* Return the size in bytes of an object of the the type pointed to by p.
     * Functions are considered to be pointer sized because that's how they're
     * represented internally.
     */

    int size;

	if( p->tclass == SYMTAB_DECLARATOR )
	{
		if(IS_BIT_FIELD (p) )
			size = ISIZE;
		else
			size = (p->SYMTAB_DCL_TYPE==SYMTAB_ARRAY) ? p->SYMTAB_NUM_ELE * get_sizeof(p->next) : PSIZE;
	}
	else
    {
		switch( p->SYMTAB_NOUN )
		{
			case SYMTAB_CHAR:	size = CSIZE;  			break;
			case SYMTAB_INT:	size = p->SYMTAB_LONG ? LSIZE : ISIZE;	break;
			case SYMTAB_STRUCTURE:	size = p->V_STRUCT->size;	break;
			case SYMTAB_VOID:	size = 0;  			break;
			case SYMTAB_LABEL:	size = 0;  			break;
		}
    }

    return size;
}

/*----------------------------------------------------------------------*/

symbol	*reverse_links(symbol *sym )
{
    /* Go through the cross-linked chain of "symbols", reversing the direction
     * of the cross pointers. Return a pointer to the new head of chain
     * (formerly the end of the chain) or NULL if the chain started out empty.
     */

    symbol *previous, *current, *next;

    if( !sym )
	return NULL;

    previous = sym;
    current  = sym->next;

    while( current )
    {
	next		= current->next;
	current->next	= previous;
	previous	= current;
	current		= next;
    }

    sym->next = NULL;
    return previous;
}

char *sclass_str(int sclass )	/* Return a string representing the */
								/* indicated storage class.	    */
{
	return sclass==SYMTAB_CONSTANT   ? "CON" :
	   sclass==SYMTAB_REGISTER   ? "REG" :
	   sclass==SYMTAB_TYPEDEF    ? "TYP" :
	   sclass==SYMTAB_AUTO       ? "AUT" :
	   sclass==SYMTAB_FIXED      ? "FIX" : "BAD SCLASS" ;
}

/*----------------------------------------------------------------------*/

char *oclass_str(int oclass )	/* Return a string representing the */
								/* indicated output storage class.  */
{
	return oclass==PUB ? "PUB"  :
	   oclass==PRI ? "PRI"  :
	   oclass==COM ? "COM"  :
	   oclass==EXT ? "EXT"  :  "(NO OCLS)" ;
}

/*----------------------------------------------------------------------*/

char *noun_str(int noun )	/* Return a string representing the */
							/* indicated noun.		    */
{
	return noun==SYMTAB_INT	    ? "int"    :
	   noun==SYMTAB_CHAR	    ? "char"   :
	   noun==SYMTAB_VOID	    ? "void"   :
	   noun==SYMTAB_LABEL	    ? "label"  :
	   noun==SYMTAB_STRUCTURE  ? "struct" :
	   noun==SYMTAB_MACRO      ? "macro" : "BAD NOUN" ;
}

/*----------------------------------------------------------------------*/

char *attr_str(specifier *spec_p )	/* Return a string representing all */
									/* attributes in a specifier other  */
{					/* than the noun and storage class. */
    static char str[5];

    str[0] = ( spec_p->_unsigned ) ? 'u' : '.' ;
    str[1] = ( spec_p->_static   ) ? 's' : '.' ;
    str[2] = ( spec_p->_extern   ) ? 'e' : '.' ;
    str[3] = ( spec_p->_long     ) ? 'l' : '.' ;
    str[4] = '\0';

    return str;
}

/*----------------------------------------------------------------------*/

char *type_str (link *link_p )
					   /* Return a string representing the    */
{				       /* type represented by the link chain. */
    int		i;
    static char target [ 80 ];
    static char	buf    [ 64 ];
    int		available  = sizeof(target) - 1;

    *buf    = '\0';
    *target = '\0';

    if( !link_p )
	return "(NULL)";

    if( link_p->tdef )
    {
	strcpy( target, "tdef " );
	available -= 5;
    }

    for(; link_p ; link_p = link_p->next )
    {
	if( IS_DECLARATOR(link_p) )
	{
		switch( link_p->SYMTAB_DCL_TYPE )
	    {
		case SYMTAB_POINTER:    i = sprintf(buf, "*" );			break;
		case SYMTAB_ARRAY:	     i = sprintf(buf, "[%d]", link_p->SYMTAB_NUM_ELE);	break;
		case SYMTAB_FUNCTION:   i = sprintf(buf, "()" ); 			break;
		case SYMTAB_BIT_FIELD:	 i = sprintf(buf, ":%d",link_p->SYMTAB_NUM_ELE);	break;
		case SYMTAB_PROCEEDURE:	i = sprintf(buf,"()");				break;
		default: 	     i = sprintf(buf, "BAD DECL %d",link_p->SYMTAB_DCL_TYPE );	        break;
	    }
	}
	else  /* it's a specifier */
	{
		i = sprintf( buf, "%s %s %s %s",    noun_str  ( link_p->SYMTAB_NOUN     ),
							sclass_str( link_p->SYMTAB_SCLASS   ),
							oclass_str( link_p->SYMTAB_OCLASS   ),
					        attr_str  ( &link_p->select.s));

		if( link_p->SYMTAB_NOUN==SYMTAB_STRUCTURE  || link_p->SYMTAB_SCLASS==SYMTAB_CONSTANT  )
	    {
		strncat( target, buf, available );
		available -= i;

		if( link_p->SYMTAB_NOUN != SYMTAB_STRUCTURE )
		    continue;
		else	//DON'T need this in ACTION!
		    i = sprintf(buf, " %s", link_p->V_STRUCT->tag ?
					    link_p->V_STRUCT->tag : "untagged");
	    }
	}

	strncat( target, buf, available );
	available -= i;
    }

    return target;
}

/*----------------------------------------------------------------------*/

char *tconst_str(link *type )
				   /* Return a string representing the value  */
{				   /* field at the end of the specified type  */
    static char buf[80];	   /* (which must be char*, char, int, long,  */
				   /* unsigned int, or unsigned long). Return */
    buf[0] = '?';	   	   /* "?" if the type isn't any of these.     */
    buf[1] = '\0';

    if( IS_POINTER(type)  &&  IS_CHAR(type->next) )
    {
	sprintf( buf, "%s%d", L_STRING, type->next->V_INT );
    }
    else if( !(IS_AGGREGATE(type) || IS_FUNCT(type)) )
    {
	switch( type->SYMTAB_NOUN )
	{
	case SYMTAB_CHAR:	sprintf( buf, "'%s' (%d)", bin_to_ascii(
					type->SYMTAB_UNSIGNED ? type->V_UINT
						     : type->V_INT,1),
					type->SYMTAB_UNSIGNED ? type->V_UINT
						     : type->V_INT,1	);
			break;

	case SYMTAB_INT:	if( type->SYMTAB_LONG )
			{
				if( type->SYMTAB_UNSIGNED )
				sprintf(buf, "%luL", type->V_ULONG);
			    else
				sprintf(buf, "%ldL", type->V_LONG );
			}
			else
			{
				if( type->SYMTAB_UNSIGNED )
				sprintf( buf, "%u", type->V_UINT);
			    else
				sprintf( buf, "%d", type->V_INT );
			}
			break;
	}
    }

    if( *buf == '?' )
	yyerror("Internal, tconst_str: Can't make constant for type %s\n",
							    type_str( type ));
    return buf;
}

/*----------------------------------------------------------------------*/

char	*sym_chain_str(symbol *chain )
{
    /* Return a string listing the names of all symbols in the input chain (or
     * a constant value if the symbol is a constant). Note that this routine
     * can't call type_str() because the second-order recursion messes up the
     * buffers. Since the routine is used only for occasional diagnostics, it's
     * not worth fixing this problem.
     */

    int		i;
    static char buf[80];
    char	*p	= buf;
    int 	avail	= sizeof( buf ) - 1;

    *buf = '\0';
    while( chain && avail > 0 )
    {
	if( IS_CONSTANT(chain->etype) )
	    i = sprintf( p, "%0.*s", avail - 2, "const" );
	else
	    i = sprintf( p, "%0.*s", avail - 2, chain->name );

	p     += i;
	avail -= i;

	if( chain = chain->next )
	{
	    *p++ = ',' ;
	    i -= 2;
	}
    }

    return buf;
}


/*----------------------------------------------------------------------*/

static link *IsAFunction(link *l)
{
	while(l != NULL)
	{
		if(IS_FUNCT(l))
		{
			goto exit;
		}
		l = l->next;
	}
exit:
	return l;
}

static const char *InitStrTypes[] = {
		"",/* initval has no meaning	*/
		"VALUE",	/* symbol is initialized to value	*/
		"ADDRESS",	/* Address is defined by user for symbol	*/
		"ARRAY"	/* array is initialized to table of constants	*/
};

static int DumpArray(char *b, char *d,int n)
{
	int i,j,k;
	int l=0;
	char *s = malloc(256);

	l += sprintf(&b[l],"\n");
	for(i=0,j=0;i<n;++i)
	{
		l += sprintf(&b[l],"%02x%c",d[i],(j==7)?' ':'-');
		s[j] = d[i];
		j++;
		if(j == 8)
		{
			for(j=0;j<8;++j)
			{
				l += sprintf(&b[l],"%c",isprint(s[j])?s[j]:'.');
			}
			l += sprintf(&b[l],"\n");
			j = 0;
		}

	}
	if((k =n % 8) > 0)
	{
		for(i=0;i< ((8-k)*3);++i,++l) b[l] = ' ';
		for(i=0;i<k;++i)
		l += sprintf(&b[l],"%c",isprint(s[i])?s[i]:'.');
	}
	l+= sprintf(&b[l],"\n");
	free(s);
	return l;
}

static char *InitStr(symbol *pSym)
{
	static char buf[4096];
	int l = 0;

	buf[0] = 0;

	if(pSym->init > 0)
	{
		l = sprintf(buf,"\nINIT:%s",InitStrTypes[pSym->init]);
		switch(pSym->init)
		{
			case SYMTAB_INIT_VALUE:	/* symbol is initialized to value	*/
				l+=sprintf(&buf[l],"%d\n",pSym->iv.initval);
				break;
			case SYMTAB_INIT_ADDRESS:	/* Address is defined by user for symbol	*/
				l+=sprintf(&buf[l],"$%04x\n",pSym->iv.initval);
				break;
			case SYMTAB_INIT_ARRAY:	/* array is initialized to table of constants	*/
				l += DumpArray(&buf[l],pSym->iv.arrinit,pSym->initSize);
				break;
		}
	}
	return buf;
}

static void psym(symbol *sym_p,FILE *fp )			/* Print one symbol to fp. */
{
	link *l;
	symbol *sym;

    fprintf(fp, "%-13.13s %2d %s %s\n",
				 sym_p->name,
				 sym_p->level,
				 type_str( sym_p->type ),
				 InitStr(sym_p) );
	if((l = IsAFunction(sym_p->type)) != NULL)	/*	this is a function	*/
	{
		fprintf(fp,"Arguments of %-18.18s\n",sym_p->name);
		sym = l->select.d.args;
		while(sym)
		{
			psym(sym,fp);
			sym = sym->next;	/*	next symbol in chain	*/
		}
		fprintf(fp,"End of Arguments of %-18.18s\n",sym_p->name);
	}
}

/*----------------------------------------------------------------------*/

static	void pstruct(structdef *sdef_p,FILE *fp )	/* Print a structure definition to fp */
													/* including all the fields & types.  */
{
    symbol	*field_p;

    fprintf(fp, "struct <%s> (level %d, %d bytes):\n",
					sdef_p->tag,sdef_p->level,sdef_p->size);

    for( field_p = sdef_p->fields; field_p; field_p=field_p->next )
    {
	fprintf(fp, "    %-20s (offset %d) %s\n",
		       field_p->name, field_p->level, type_str(field_p->type));
    }
}

/*----------------------------------------------------------------------*/

void print_syms(FILE *fp )		/* Print the entire symbol table to   */
								/* the named file. Previous contents  */
{					/* of the file (if any) are destroyed.*/
	fprintf(fp, "Attributes in type field are:   upel\n"   );
	fprintf(fp, "    unsigned (. for signed)-----+|||\n"   );
	fprintf(fp, "    private  (. for public)------+||\n"   );
	fprintf(fp, "    extern   (. for common)-------+|\n"   );
	fprintf(fp, "    long     (. for short )--------+\n\n" );

        fprintf(fp,"name               rname              lev   next   type\n");
	ptab( Symbol_tab, psym, fp, 1 );

	fprintf(fp, "\nStructure table:\n\n");
	if(Struct_tab != NULL)
		ptab( Struct_tab, pstruct, fp, 1 );

}
