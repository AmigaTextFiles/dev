/*-> (C) 1990 Allen I. Holub                                                */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "hash.h"
#include "symtab.h"
#include "value.h"
#include "label.h"
#include "misc.h"
#include "temp.h"


/*  VALUE.C:	Routines to manipulate lvalues and rvalues. */

static value *Value_free = NULL;
#define VCHUNK	8		/* Allocate this many structure at a time. */

/*----------------------------------------------------------------------*/

value	*new_value(void)
{
    value *p;

	p = (value *)malloc(sizeof(value));
    memset( p, 0, sizeof(value) );
    return p;
}

/*----------------------------------------------------------------------*/

void discard_value(value *p )
{				 		/* and any associated links.  */
    if( p )
    {
		if(p->ValLoc == VALUE_IN_TMP)	//temp variable?
		{
			ReleaseTemp(p);
		}
		if( p->type )
		 discard_link_chain( p->type );
		free(p);
   }
}

/*----------------------------------------------------------------------*/

void	release_value(value *val )
{				/* used for an associated temporary variable. */
    if( val )
    {
//	if( val->is_tmp )
//	    tmp_free( val->offset );
	discard_value( val );
    }
}

value  *make_icon(char *yytext,int numeric_val )
{
    /* Make an integer-constant rvalue. If yytext is NULL, then numeric_val
     * holds the numeric value, otherwise the second argument is not used and
     * the string in yytext represents the constant.
     */

    value *vp;
    link  *lp;

    vp		= make_int();
    lp		= vp->type;
	lp->SYMTAB_SCLASS  = SYMTAB_CONSTANT;

	lp->V_INT = numeric_val;
	 lp->SYMTAB_UNSIGNED = 1;
	 lp->SYMTAB_LONG     = 1;
	vp->ValLoc = VALUE_IS_CONSTANT;
    return vp;
}

/*----------------------------------------------------------------------*/

value *make_int()
{					/* Make an unnamed integer rvalue. */
    link  *lp;
    value *vp;

    lp		= new_link();
	lp->tclass   = SYMTAB_SPECIFIER;
	lp->SYMTAB_NOUN    = SYMTAB_INT;
    vp		= new_value();		/* It's an rvalue by default. */
    vp->type	= vp->etype = lp;
    return vp;
}

value *make_scon()
{
    link *p;
    value *synth;
    static unsigned label = 0;

    synth 	 = new_value();
    synth->type  = new_link();

    p		 = synth->type;
	p->SYMTAB_DCL_TYPE  = SYMTAB_POINTER;
    p->next      = new_link();

    p 		 = p->next;
	p->tclass     = SYMTAB_SPECIFIER;
	p->SYMTAB_NOUN      = SYMTAB_CHAR;
	p->SYMTAB_SCLASS    = SYMTAB_CONSTANT;
    p->V_INT     = ++label;

    synth->etype  = p;
    sprintf( synth->name, "%s%d", L_STRING, label );
    return synth;
}
