/*
 *      Small C+ Compiler
 *
 *      Plunging routines
 *
 *      $Id: plunge.c 1.4 1999/03/22 21:27:18 djm8 Exp $
 */


#include "ccdefs.h"

/*
 * skim over text adjoining || and && operators
 */
int skim(opstr, testfunc, dropval, endval, heir, lval)
char *opstr;
void (*testfunc)();
int dropval, endval, (*heir)() ;
LVALUE *lval ;
{
        int droplab, endlab, hits, k ;

        hits = 0 ;
        while (1) {
                k = plnge1(heir, lval) ;
                if ( streq(line+lptr, opstr) == 2 ) {
                        inbyte() ;
                        inbyte() ;
                        if (hits == 0) {
                                hits = 1 ;
                                droplab = getlabel() ;
                        }
                        dropout(k, testfunc, droplab, lval) ;
                }
                else if (hits) {
                        dropout(k, testfunc, droplab, lval) ;
                        vconst(endval) ;
                        jump(endlab=getlabel()) ;
                        postlabel(droplab);
                        vconst(dropval);
                        postlabel(endlab) ;
                        lval->indirect = lval->ptr_type = lval->is_const =
                                lval->const_val = 0 ;
                        lval->stage_add = NULL_CHAR ;
                        return (0) ;
                }
                else return k ;
        }
}

/*
 * test for early dropout from || or && evaluations
 */
void dropout(k, testfunc, exit1, lval)
int k, exit1;
void (*testfunc)();
LVALUE *lval ;
{
        if ( k )
                rvalue(lval) ;
        else if ( lval->is_const )
                vconst(lval->const_val) ;
        (*testfunc)(exit1) ;            /* jump on false */
}

/*
 * unary plunge to lower level
 */
int plnge1(heir, lval)
int (*heir)() ;
LVALUE *lval ;
{
        char *before, *start ;
        int k ;

        setstage(&before, &start) ;
        k = (*heir)(lval) ;
        if ( lval->is_const ) {
                /* constant, load it later */
                clearstage( before, 0 ) ;
        }
        return (k) ;
}

/*
 * binary plunge to lower level (not for +/-)
 */
void plnge2a(heir, lval, lval2, oper, uoper, doper)
int (*heir)() ;
LVALUE *lval, *lval2 ;
void (*oper)(), (*uoper)(), (*doper)();
{
        char *before, *start ;

        setstage(&before, &start) ;
        lval->stage_add = 0 ;           /* flag as not "..oper 0" syntax */
        if ( lval->is_const ) {
                /* constant on left not loaded yet */
                if ( plnge1(heir, lval2) )
                        rvalue(lval2) ;
                if ( lval->const_val == 0 )
                        lval->stage_add = stagenext ;
                const2(lval->const_val) ;
                dcerror(lval2) ;
        }
        else {
                /* non-constant on left */
                if ( lval->val_type == DOUBLE ) dpush() ;
                else {
                        if ( lval->val_type == LONG || lval->val_type==CPTR) { lpush(); }
                        else zpush();
                }
                if( plnge1(heir,lval2) ) rvalue(lval2);
                if ( lval2->is_const ) {
                        /* constant on right, load primary */
                        if ( lval2->const_val == 0 ) lval->stage_add = start ;
/* djm, load double reg for long operators */
                        if (lval->val_type == LONG)
                        {
                              vlongconst(lval2->const_val);
                              lval2->val_type=LONG;
                        }
                        else vconst(lval2->const_val) ;
                        dcerror(lval) ;
                }
                if ( lval->val_type != DOUBLE && lval2->val_type != DOUBLE && lval->val_type != LONG && lval2->val_type !=LONG )
/* Dodgy? */
                        zpop() ;
        }
        lval->is_const &= lval2->is_const ;
        /* ensure that operation is valid for double */
        if ( doper == 0 ) intcheck(lval, lval2) ;
        if ( widen(lval, lval2) ) {
                (*doper)();
                /* result of comparison is int */
                if( doper != dmul && doper != ddiv )
                        lval->val_type = CINT;
                return;
        }
/* Attempt to compensate width, so that we are doing double oprs if
 * one of the expressions is a double
 */
        widenlong(lval, lval2);
        opertype=CINT;
        if (lval->val_type == LONG || lval2->val_type == LONG ) opertype=LONG;
        if ( lval->ptr_type || lval2->ptr_type ) {
                (*uoper)();
                if (lval->val_type == CPTR) zpop(); /* rest top bits */
                lval->binop = (void *) uoper ;
                return;
        }
/* Moved unsigned thing to below, so can fold expr correctly! */

        if ( (lval2->symbol && lval2->symbol->ident == POINTER) ) {
                    (*uoper)();
                    lval->binop = (void *) uoper ;
                    return;
        }
        if ( lval->is_const ) {
                /* both operands constant taking respect of sign now,
                 * unsigned takes precedence.. 
                 */
                if ( (lval->flags&UNSIGNED) || (lval2->flags&UNSIGNED) )
                        lval->const_val = calc(lval->const_val, uoper, lval2->const_val) ;
                else
                        lval->const_val = calc(lval->const_val, oper, lval2->const_val) ;
                clearstage(before, 0) ;
        }
        else {
                /* one or both operands not constant */


/* djm, if we have a constant and a proper lvalue, then set the flags of
 * const to equal the signedness of the lvalue. This *will* cause 
 * problems if we allow specifiers after numbers
 */
        if (lval->is_const) lval->flags=(lval->flags&MKSIGN)|(lval2->flags&UNSIGNED);
        if (lval2->is_const) lval2->flags=(lval2->flags&MKSIGN)|(lval->flags&UNSIGNED);

/* There's some weird precedence happening here! If the ->& bits are
 * not placed in brackets then this expression sometime comes out to
 * be false when it should be true : i.e. 0 != 1 -> false, 1 != 0 -> true
 */
                if ((lval->flags&UNSIGNED) !=( lval2->flags&UNSIGNED) && (oper==zmod || oper==mult || oper==zdiv)) 
                        warning("Operation on different signedness!");

/* Special case for multiplication by constant... */

                if (oper==mult && (lval2->is_const) && (lval->val_type ==CINT || lval->val_type==CCHAR) ){
                        clearstage(before,0);
                        quikmult(lval2->const_val);
                        return;
                }

                if (lval2->flags&UNSIGNED) {
                        (*uoper)();
                        lval->binop=(void *) uoper;
                } else {
                        (*oper)();
                        lval->binop =(void *) oper ;
                }
        }
}

/*
 * binary plunge to lower level (for +/-)
 */
void plnge2b(heir, lval, lval2, oper, doper)
int (*heir)() ;
LVALUE *lval, *lval2 ;
void (*oper)(), (*doper)() ;
{
        char *before, *start, *before1, *start1 ;
        int val ;

        opertype=lval->val_type;
        setstage(&before, &start) ;
        if ( lval->is_const ) {
                /* constant on left not yet loaded */
                if ( plnge1(heir, lval2) ) rvalue(lval2) ;
                val = lval->const_val ;
                if ( dbltest(lval2, lval) ) {
                        /* are adding lval to pointer, adjust size */
                        cscale(lval2->ptr_type, lval2->tagsym, &val) ;
                }
                const2(val) ;
                dcerror(lval2) ;
        }
        else {
                /* non-constant on left */
                setstage(&before1, &start1) ;
                if ( lval->val_type == DOUBLE ) dpush() ;
                else if (lval->val_type == LONG) lpush() ;
/* Long ptrs? */
                else zpush() ;
                if ( plnge1(heir, lval2) ) rvalue(lval2) ;
                if ( lval2->is_const ) {
                        /* constant on right */
                        val = lval2->const_val ;
                        if ( dbltest(lval, lval2) ) {
                                /* are adding lval2 to pointer, adjust size */
                                cscale(lval->ptr_type, lval->tagsym, &val) ;
                        }
                        if ( oper == zsub ) {
                                /* addition on Z80 is cheaper than subtraction */
                                val = (-val) ;
                                /* skip later diff scaling - constant can't be pointer */
                                oper = zadd ;
                        }
                        /* remove zpush and add int constant to int */
                        clearstage(before1, 0) ;
                        Zsp += 2 ; 
                        if ( lval->val_type == LONG ) Zsp +=2;
                        addconst(val,0,0) ;
                        dcerror(lval) ;
                }
                else {
                        /* non-constant on both sides or double +/- int const */
                        if (dbltest(lval,lval2))
                        scale(lval->ptr_type, lval->tagsym);
                        if ( widen(lval, lval2) ) {
                                /* floating point operation */
                                (*doper)();
                                lval->is_const = 0 ;
                                return ;
                        }
                        else {
                        widenlong(lval, lval2) ;
                                /* non-constant integer operation */
                        if (lval->val_type != LONG ) zpop();
                                if ( dbltest(lval2, lval) ) {
                                swap();
                                        scale(lval2->ptr_type, lval2->tagsym) ;
                                        /* subtraction not commutative */
                                        if (oper == zsub) swap();
                                }
                        }
                }
        }
        if ( lval->is_const &= lval2->is_const ) {
                /* both operands constant */
                if (oper == zadd) lval->const_val += lval2->const_val ;
                else if (oper == zsub) lval->const_val -= lval2->const_val ;
                else lval->const_val = 0 ;
                clearstage(before, 0) ;
        }
        else if (lval2->is_const == 0) {
                /* right operand not constant */
        (*oper)();
        }
        if (oper == zsub) {
                /* scale difference between pointers */
/* djm...preserve our pointer high 8 bits? */
                if( lval->ptr_type == CINT && lval2->ptr_type == CINT ) {
                        swap();
                        vconst(1) ;
                        asr(); /*  div by 2  */
                }
                else if( lval->ptr_type == LONG && lval2->ptr_type == LONG) {
                        swap();
                        vconst(2);
                        asr();  /* div by 4 */
                }
                else if( lval->ptr_type == DOUBLE && lval2->ptr_type == DOUBLE ) {
                        swap();
                        vconst(6) ;
                        zdivun(); /* div by 6 */
                }
                else if ( lval->ptr_type == STRUCT && lval2->ptr_type == STRUCT ) {
                        swap() ;
                        vconst(lval->tagsym->size) ;
                        zdivun() ;
                }
        }
    result(lval,lval2);
}
