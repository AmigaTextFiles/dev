/*
 * cc4.c - fourth part of Small-C/Plus compiler
 *         routines for recursive descent
 *
 * $Id: expr.c 1.7 1999/03/22 21:27:18 djm8 Exp $
 *
 */

/* 9/9/98 djm - Modified plnge2a to use unsigned functions for unsigned
 *              variables, seems to be fine..
 *
 * Have added parameter to addconst, so to not do long add for stack ops
 *
 */

/* 14/9/98 Some conditional long pointer stuff inserted
 *
 * 5/10/98 Some simple prototyping 
 *
 *13/11/98 Radically changed handling of longs - now they are pushed onto
 *         the stack instead of being held in alternate register set
 */

#include "ccdefs.h"






int expression(con, val)
int *con, *val ;
{
        LVALUE lval ;
        char    type;

        if ( heir1(&lval) ) {
                rvalue(&lval) ;
        }
        fnflags=lval.flags;
        if ( lval.ptr_type ) { type=lval.ptr_type; lval.ident=POINTER; }
        else type=lval.val_type;
        fnargvalue=CalcArgValue(type, lval.ident ,lval.flags);
        margtag = 0;
        if (lval.tagsym) margtag=(lval.tagsym-tagtab);
        *con = lval.is_const ;
        *val = lval.const_val ;
        return lval.val_type ;
}

int heir1(lval)
LVALUE *lval ;
{
        char *before, *start ;
        LVALUE lval2, lval3 ;
        void (*oper)(), (*doper)(), (*uoper)() ;
        int k;

        setstage(&before, &start) ;
        k = plnge1(heir1a, lval);
        if ( lval->is_const ) {
                if (ltype == LONG) {
                      vlongconst(lval->const_val);

//                      vconst(lval->const_val-(65536*(lval->const_val/65536)));
//                      const2(lval->const_val/65536);
//                      lval->flags=lval->flags|UNSIGNED;
                }
                else vconst(lval->const_val) ;
        }
        doper = 0 ;
        if ( cmatch('=') ) {
                if ( k == 0 ) {
                        needlval() ;
                        return 0 ;
                }
                if ( lval->indirect ) smartpush(lval, before);
                if ( heir1(&lval2) ) rvalue(&lval2);
/* Now our type checking so we can give off lots of warnings about
 * type mismatches etc..
 */
                if (lval2.val_type == VOID ) 
                        warning("Getting value from void function");

#ifdef SILLYWARNING
                if ((lval->ptr_type) && (!(lval2.ptr_type) && !(lval2.is_const) ) )
                        warning("Illegal int/ptr conversion");
                if ((lval2.ptr_type) && (!(lval->ptr_type) && !(lval->is_const) ) )
                        warning("Illegal ptr/int conversion");
                if ( ((lval->flags&UNSIGNED) != (lval2.flags&UNSIGNED)) && ( !(lval2.is_const) && !(lval->ptr_type) && !(lval2.ptr_type) ) ) 
                        warning("Equating of different signedness");
#endif

                force(lval->val_type, lval2.val_type, lval->flags&UNSIGNED, lval2.flags&UNSIGNED,lval2.is_const);
                smartstore(lval);
                return 0;
        }
        else if ( match("|=") ) uoper = oper = zor;
        else if ( match("^=") ) uoper = oper = zxor;
        else if ( match("&=") ) uoper = oper = zand;
        else if ( match("+=") ) { uoper = oper = zadd; doper = dadd; }
        else if ( match("-=") ) { uoper = oper = zsub; doper = dsub; }
        else if ( match("*=") ) { uoper = oper = mult; doper = dmul; }
        else if ( match("/=") ) { uoper = zdivun; oper = zdiv; doper = ddiv; }
        else if ( match("%=") ) { uoper = zmodun; oper = zmod; }
        else if ( match(">>=") ) { uoper=asr_un; oper = asr; }
        else if ( match("<<=") ) uoper = oper = asl;
        else return k;

        /* if we get here we have an oper= */
        if ( k == 0 ) {
                needlval() ;
                return 0 ;
        }
        lval3.symbol = lval->symbol ;
        lval3.indirect = lval->indirect ;
        lval3.flags = lval->flags;
        /* don't clear address calc we need it on rhs */
        if ( lval->indirect ) smartpush(lval, 0);
        rvalue(lval) ;
        if ( oper==zadd || oper==zsub )
                plnge2b(heir1, lval, &lval2, oper, doper) ;
        else
                plnge2a(heir1, lval, &lval2, oper, uoper, doper) ;
        smartstore(&lval3) ;
        return 0 ;
}

/*
 * heir1a - conditional operator
 */
int heir1a(lval)
LVALUE *lval ;
{
        int falselab, endlab, skiplab ;
        LVALUE lval2 ;
        int k ;

        k = heir2a(lval) ;
        if ( cmatch('?') ) {
                /* evaluate condition expression */
                if ( k ) rvalue(lval) ;
                /* test condition, jump to false expression evaluation if necessary */
                force(CINT, lval->val_type, dosigned, lval->flags&UNSIGNED,0) ;
                testjump(falselab=getlabel()) ;
                /* evaluate 'true' expression */
                if ( heir1(&lval2) ) rvalue(&lval2) ;
                needchar(':') ;
                jump(endlab=getlabel()) ;
                /* evaluate 'false' expression */
                postlabel(falselab) ;
                if ( heir1(lval) ) rvalue(lval) ;
                /* check types of expressions and widen if necessary */
                if ( lval2.val_type == DOUBLE && lval->val_type != DOUBLE ) {
/* If defined as mathz88 then if are value isn't a long we want to
 * extend it out... */
                        if (mathz88 && (lval->val_type != LONG)) {
                                if (lval->flags&UNSIGNED) const2(0);
                                else callrts("l_int2long_s");
                        }
                        if (!(lval->flags&UNSIGNED)) callrts("float");
                        else callrts("ufloat") ;
                        lval->val_type = DOUBLE ;
                        postlabel(endlab) ;
                }
                else if ( lval2.val_type != DOUBLE && lval->val_type == DOUBLE ) {
                        jump(skiplab=getlabel()) ;
                        postlabel(endlab) ;
/* If isn't a long and we're math z88 extend it out */

                        if (mathz88 && (lval2.val_type != LONG)) {
                                if (lval2.flags&UNSIGNED) const2(0);
                                else callrts("l_int2long_s");
                        }
                        if ( (lval2.flags&UNSIGNED) == NO) callrts("float");
                        else callrts("ufloat") ;
                        postlabel(skiplab) ;
                }
/* 12/8/98 Mod by djm to convert long types - it's nice when someone
 * else has had to do it before! */
                else if ( lval2.val_type == LONG && lval->val_type != LONG ) {
/* Check for signed, if both signed convert properly, if one/neither signed
 * then we have dodgy equating in anycase, so treat as unsigned
 */
                        widenlong(&lval2,lval);
/*
                        if (lval2.flags&UNSIGNED == NO && !(lval->flags&UNSIGNED))
                                callrts("l_int2long_s");
                        else    const2(0);     
*/
                        lval->val_type = LONG ;
                        postlabel(endlab) ;
                }
                else if ( lval2.val_type != LONG && lval->val_type == LONG ) {
                        jump(skiplab=getlabel()) ;
                        postlabel(endlab) ;
                        widenlong(lval,&lval2);
                        lval->val_type = LONG;
/*
                        callrts("l_int2long") ;
                        if (lval2.flags&UNSIGNED == NO && !(lval->flags&UNSIGNED))
                                callrts("l_int2long_s");
                        else    const2(0);     
*/

                        postlabel(skiplab) ;
                }
                else
                        postlabel(endlab) ;
                /* result cannot be a constant, even if second expression is */
                lval->is_const = 0 ;
                return 0 ;
        }
        else
                return k ;
}


int heir2a(lval)
LVALUE *lval ;
{
        return skim("||", eq0, 1, 0, heir2b, lval);
}

int heir2b(lval)
LVALUE *lval ;
{
        return skim("&&", testjump, 0, 1, heir2, lval);
}

int heir234(lval, heir, opch, oper)
LVALUE *lval;
int (*heir)() ;
char opch ;
void (*oper)(void) ;
{
        LVALUE lval2 ;
        int k ;

        k = plnge1(heir, lval);
        blanks();
        if ((ch() != opch) || (nch() == '=') || (nch() == opch)) return k;
        if ( k ) rvalue(lval);
        while(1) {
                if ( (ch() == opch) && (nch() != '=') && (nch() != opch) ) {
                        inbyte();
                        plnge2a(heir, lval, &lval2, oper, oper, 0) ;
                }
                else return 0;
        }
}

int heir2(lval)
LVALUE *lval ;
{
        return heir234(lval, heir3, '|', zor) ;
}

int heir3(lval)
LVALUE *lval ;
{
        return heir234(lval, heir4, '^', zxor) ;
}

int heir4(lval)
LVALUE *lval ;
{
        return heir234(lval, heir5, '&', zand) ;
}

int heir5(lval)
LVALUE *lval ;
{
        LVALUE lval2 ;
        int k ;

        k = plnge1(heir6, lval) ;
        blanks() ;
        if((streq(line+lptr,"==")==0) &&
                (streq(line+lptr,"!=")==0))return k;
        if ( k ) rvalue(lval) ;
        while(1) {
                if (match("==")) {
                        plnge2a(heir6, lval, &lval2, zeq, zeq, deq) ;
                }
                else if (match("!=")) {
                        plnge2a(heir6, lval, &lval2, zne, zne, dne) ;
                }
                else return 0;
        }
}

int heir6(lval)
LVALUE *lval ;
{
        LVALUE lval2 ;
        int k ;

        k = plnge1(heir7, lval) ;
        blanks() ;
        if ( ch() != '<' && ch() != '>' &&
                (streq(line+lptr,"<=")==0) &&
                (streq(line+lptr,">=")==0) ) return k ;
        if ( streq(line+lptr,">>") ) return k ;
        if ( streq(line+lptr,"<<") ) return k ;
        if ( k ) rvalue(lval) ;
        while(1) {
                if (match("<=")) {
                        plnge2a(heir7, lval, &lval2, zle, ule, dle) ;
                }
                else if (match(">=")) {
                        plnge2a(heir7, lval, &lval2, zge, uge, dge) ;
                }
                else if ( ch() == '<' && nch() != '<' ) {
                        inbyte();
                        plnge2a(heir7, lval, &lval2, zlt, ult, dlt) ;
                }
                else if ( ch() == '>' && nch() != '>' ) {
                        inbyte();
                        plnge2a(heir7, lval, &lval2, zgt, ugt, dgt) ;
                }
                else return 0;
        }
}

int heir7(lval)
LVALUE *lval ;
{
        LVALUE lval2 ;
        int k ;

        k = plnge1(heir8, lval) ;
        blanks();
        if((streq(line+lptr,">>")==0) &&
                (streq(line+lptr,"<<")==0))return k;
        if ( streq(line+lptr, ">>=") ) return k ;
        if ( streq(line+lptr, "<<=") ) return k ;
        if ( k ) rvalue(lval) ;
        while(1) {
                if ((streq(line+lptr,">>") == 2) &&
                        (streq(line+lptr,">>=") == 0) ) {
                        inbyte();
                        inbyte();
                        plnge2a(heir8, lval, &lval2, asr, asr_un, 0) ;
                }
                else if ((streq(line+lptr,"<<") == 2) &&
                        (streq(line+lptr,"<<=") == 0) ) {
                        inbyte();
                        inbyte();
                        plnge2a(heir8, lval, &lval2, asl, asl, 0) ;
                }
                else return 0;
        }
}

int heir8(lval)
LVALUE *lval ;
{
        LVALUE lval2 ;
        int k ;

        k = plnge1(heir9, lval) ;
        blanks();
        if ( ch()!='+' && ch()!='-' ) return k;
        if (nch()=='=') return k;
        if ( k ) rvalue(lval) ;
        while(1) {
                if (cmatch('+')) {
                        plnge2b(heir9, lval, &lval2, zadd, dadd) ;
                }
                else if (cmatch('-')) {
                        plnge2b(heir9, lval, &lval2, zsub, dsub) ;
                }
                else return 0 ;
        }
}

int heir9(lval)
LVALUE *lval ;
{
        LVALUE lval2 ;
        int k ;

        k = plnge1(heira, lval) ;
        blanks();
        if ( ch() != '*' && ch() != '/' && ch() != '%' ) return k;
        if ( nch() == '=' ) return k ;
        if ( k ) rvalue(lval) ;
        while(1) {
                if (cmatch('*')) {
                        plnge2a(heira, lval, &lval2, mult, mult, dmul);
                }
                else if (cmatch('/')) {
                        plnge2a(heira, lval, &lval2, zdiv, zdivun, ddiv);
                }
                else if (cmatch('%')) {
                        plnge2a(heira, lval, &lval2, zmod, zmodun, 0);
                }
                else return 0;
        }
}

/*
 * perform lval manipulation for pointer dereferencing/array subscripting
 */

/* djm, I can't make this routine distinguish between ptr->ptr and ptr
 * so if address loads dummy de,0 to ensure everything works out
 */

#ifndef SMALL_C
SYMBOL *
#endif

deref(lval)
LVALUE *lval ;
{
        char    flags;
        flags=lval->flags;
        if (flags&FARPTR) flags=flags|FARACC;
        /* NB it has already been determind that lval->symbol is non-zero */
        if ( lval->symbol->more == 0 ) {
                /* array of/pointer to variable */
                lval->val_type = lval->indirect = lval->symbol->type ;
                lval->flags=flags;
                lval->symbol = NULL_SYM ;                       /* forget symbol table entry */
                lval->ptr_type = 0 ;                            /* flag as not symbol or array */
        }
        else {
                /* array of/pointer to pointer */
                lval->symbol = dummy_sym[(int) lval->symbol->more] ;
/* djm long pointers */
                lval->ptr_type = lval->symbol->type ;
/* 5/10/98 restored lval->val_type */
                lval->indirect = lval->val_type = (flags&FARPTR ? CPTR : CINT );
                lval->flags=flags;
                if ( lval->symbol->type == STRUCT )
                        lval->tagsym = tagtab + lval->symbol->tag_idx ;
        }
        return lval->symbol ;
}


int heira(lval)
LVALUE *lval ;
{
        int k;

        if(match("++")) {
                prestep(lval, 1, inc,inclong) ;
                return 0;
        }
        else if(match("--")) {
                prestep(lval, -1, dec,declong) ;
                return 0;
        }
        else if (cmatch('~')) {
                if (heira(lval)) rvalue(lval) ;
                intcheck(lval, lval) ;
                com() ;
                lval->const_val = ~lval->const_val ;
                lval->stage_add = NULL_CHAR ;
                return 0 ;
        }
        else if (cmatch('!')) {
                if (heira(lval)) rvalue(lval) ;
                if (lval->val_type == DOUBLE) callrts("ifix") ;
/* 12/9/98 djm, convert long to int before finding ! of it 
 *                if (lval->val_type == LONG) callrts("l_long2int");
 * Don't think we need this because lneg returns an int in anycase
 * (result of lneg is either hl=1 or hl=0 
 */
                lneg() ;
                lval->const_val = !lval->const_val ;
                lval->val_type = CINT ;
                lval->stage_add = NULL_CHAR ;
                return 0 ;
        }
        else if (cmatch('-')) {
                if (heira(lval)) rvalue(lval);
                if (lval->val_type == DOUBLE) dneg();
                else {
                        opertype=lval->val_type; /* Kludge for long/int*/
                        neg();
                        lval->const_val = -lval->const_val ;
                }
                lval->stage_add = NULL_CHAR ;
                return 0 ;
        }
        else if ( cmatch('*') ) {                       /* unary * */
                if ( heira(lval) ) rvalue(lval) ;
                if ( lval->symbol == 0 ) {
                        error("can't dereference") ;
                        junk() ;
                        return 0 ;
                }
                else {
                        deref(lval) ;
                }
                lval->is_const = 0 ;    /* flag as not constant */
                lval->const_val = 1 ;   /* omit rvalue() on func call */
                lval->stage_add = 0 ;
                return 1 ;                              /* dereferenced pointer is lvalue */
        }
        else if ( cmatch('&') ) {
                if ( heira(lval) == 0 ) {
                        /* OK to take address of struct */
                        if ( lval->tagsym == 0 || lval->ptr_type != STRUCT ||
                                        ( lval->symbol && lval->symbol->ident == ARRAY ) ) {
                                error("illegal address");
                        }
                        return 0;
                }
                if (lval->symbol) {
                        lval->ptr_type = lval->symbol->type ;
                        lval->val_type = (lval->symbol->flags&FARPTR ? CPTR : CINT);
                } else {
                        warning("Compiler bug - code may not work properly!");
                        warning("Fix soon hopefully! Next warning may be dubious!");
                        lval->ptr_type = 0;
                        lval->val_type = CINT;
                }
                if ( lval->indirect ) return 0 ;
                /* global & non-array */
                address(lval->symbol) ;
                lval->indirect = lval->symbol->type ;
                return 0;
        }
        else {
                k = heirb(lval) ;
                
/*
 * djm 2/3/99 Removed if (k) because heirb returns 0 for a function
 * hopefully this will work, also inserted the check for VOID
 */
                if (k) ltype=lval->val_type;    /* djm 28/11/98 */
                if ( match("++") ) {
                        if (ltype==LONG) poststep(k,lval,1,inclong,declong);
                        else    poststep(k, lval, 1, inc, dec) ;
                        return 0;
                }
                else if ( match("--") ) {
                        if (ltype == LONG) poststep(k,lval,-1,declong,inclong);
                        else    poststep(k, lval, -1, dec, inc ) ;
                        return 0;
                }
                else return k;
        }
}

int heirb(lval)
LVALUE *lval ;
{
        char *before, *start ;
        char *before1, *start1 ;
        char sname[NAMESIZE] ;
        int con, val, direct, k ;
        SYMBOL *ptr ;

        setstage(&before1, &start1);
        k = primary(lval) ;
        ptr = lval->symbol ;
        blanks();
        if ( ch()=='[' || ch()=='(' || ch()=='.' || (ch()=='-' && nch()=='>') )
        while ( 1 ) {
                if ( cmatch('[') ) {
                        if ( ptr == 0 ) {
                                error("can't subscript");
                                junk();
                                needchar(']');
                                return 0;
                        }
                        else if ( k && ptr->ident == POINTER ) rvalue(lval) ;
                        else if ( ptr->ident != POINTER && ptr->ident != ARRAY ) {
                                error("can't subscript");
                                k=0;
                        }
                        setstage(&before, &start) ;
                        if (lval->flags&FARPTR)  zpushde(); 
                        zpush();
                        expression(&con, &val);
                        needchar(']');
                        if ( con ) {
                                Zsp += 2 ;              /* undo push */
                                if (lval->flags&FARPTR) Zsp += 2;
                                cscale(ptr->type, tagtab+ptr->tag_idx, &val) ;
                                if ( ptr->storage == STKLOC && ptr->ident == ARRAY ) {
                                        /* constant offset to array on stack */
                                        /* do all offsets at compile time */
                                        clearstage(before1, 0) ;
                                        getloc(ptr, val) ;
                                }
                                else {
                                        /* add constant offset to address in primary */
                                        clearstage(before, 0);
                                        addconst(val,1,0) ;
                                }
                        }
                        else {
                                /* non-constant subscript, calc at run time */
                                scale(ptr->type, tagtab+ptr->tag_idx);
                                opertype=0;
                                zpop();         /* Restored djm 28/9/98 */
                                zadd();
/* If long pointer restore upper 24 bits */
                                if (lval->flags&FARPTR) zpop();
                        }
                        ptr = deref(lval) ;
                        k = 1 ;
                }
                else if ( cmatch('(') ) {
                        if ( ptr == 0 ) {
                                callfunction(NULL_SYM);
                        }
                        else if ( ptr->ident != FUNCTION ) {
                                if ( k && lval->const_val == 0 ) rvalue(lval);
                                callfunction(NULL_SYM);
                        }
                        else callfunction(ptr);
                        k = lval->is_const = lval->const_val = 0 ;
                        if ( ptr->more == 0 ) {
                                /* function returning variable */
                                lval->val_type = ptr->type ;
                                ptr = lval->symbol = 0 ;
                        }
                        else {
                                /* function returning pointer */
                                lval->flags=ptr->flags; /* djm */
                                ptr = lval->symbol = dummy_sym[(int) ptr->more] ;
                                lval->indirect = lval->ptr_type = ptr->type ;
/* djm - 24/11/98 */
                                lval->val_type = (lval->flags&FARPTR ? CPTR : CINT);
                                if ( ptr->type == STRUCT ) {
                                        lval->tagsym = tagtab + ptr->tag_idx ;
                                }
                        }
                }
/* Handle structures... come in here with lval holding tehe previous
 * pointer to the struct thing..*/
                else if ( (direct=cmatch('.')) || match("->") ) {
                        if ( lval->tagsym == 0 ) {
                                error("can't take member") ;
                                junk() ;
                                return 0 ;
                        }
                        if ( symname(sname) == 0 || (ptr=findmemb(lval->tagsym,sname)) == 0 ) {
                                error("unknown member") ;
                                junk() ;
                                return 0 ;
                        }

/* If our pointer is far, set our storage mthod to be far, and also are
 * flags to be access via far (lval->flags)
 */
                        lval->flags = ptr->flags;
                        if (lval->symbol->ident==POINTER && lval->symbol->flags&FARPTR) {
                                ptr->storage=FAR; 
                                lval->flags=ptr->flags|(FARACC|UNSIGNED);
                        }

                        if ( k && direct == 0 ) 
                                rvalue(lval) ;
                        addconst(ptr->offset.i,1,ptr->flags&FARPTR) ;
                        lval->symbol = ptr ;
                        lval->indirect = lval->val_type = ptr->type ;
                        lval->ptr_type = lval->is_const = lval->const_val = 0 ;
                        lval->stage_add = NULL_CHAR ;
                        lval->tagsym = NULL_TAG ;
                        lval->binop = NULL_FN ;
                        if ( ptr->type == STRUCT )
                                lval->tagsym = tagtab + ptr->tag_idx ;
                        if ( ptr->ident == POINTER ) {
                                lval->ptr_type = ptr->type ;
/* djm */
                                if (ptr->flags&FARPTR) {
                                        lval->indirect = CPTR ;
                                        lval->val_type = CPTR ;
                                } else {
                                        lval->indirect = CINT ;
                                        lval->val_type = CINT ;
                                }
                        }
                        if ( ptr->ident==ARRAY || (ptr->type==STRUCT && ptr->ident==VARIABLE) ) {
                                /* array or struct */
                                lval->ptr_type = ptr->type ;
/* djm Long pointers here? */

                                lval->val_type = ((ptr->storage==FAR) ? CPTR :CINT) ;
                                k = 0 ;
                        }
                        else k = 1 ;
                }
                else return k ;
        }
        if ( ptr && ptr->ident == FUNCTION ) {
                address(ptr);
                lval->symbol = 0 ;
                return 0;
        }
        return k;
}
