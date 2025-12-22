/*
 *      Small C+ Compiler
 *      Split into parts djm 3/3/99
 *
 *      This part contains various routines to deal with constants
 *      and also finds variable names in the hash tables
 *
 *      $Id: primary.c 1.8 1999/03/22 21:27:18 djm8 Exp $
 */


#include "ccdefs.h"


int primary(lval)
LVALUE *lval;
{
        char sname[NAMESIZE] ;
        SYMBOL *ptr ;
        int k ;

        if ( cmatch('(') ) {
                do k=heir1(lval); while (cmatch(',')) ;
                needchar(')');
                return k;
        }
        /* clear lval array - djm second arg was lval.. now cast, clears lval */
        putint(0, (char *) lval, sizeof(LVALUE) ) ;
        if ( symname(sname) ) {
                if ( strcmp(sname, "sizeof") == 0 ) {
                        size_of(lval) ;
                        return(0) ;
                }
                else if ( (ptr=findloc(sname)) ) {
                        getloc(ptr, 0);
                        lval->symbol = ptr;
                        lval->val_type = lval->indirect = ptr->type;
                        lval->flags = ptr->flags;
                        lval->ident = ptr->ident;
                        lval->ptr_type=0;
                        ltype=ptr->type;
                        if ( ptr->type == STRUCT )
                                lval->tagsym = tagtab + ptr->tag_idx ;
                        if ( ptr->ident == POINTER ) {
                                lval->ptr_type = ptr->type;
/* djm long pointers */
                                lval->indirect=lval->val_type = (ptr->flags&FARPTR ? CPTR : CINT);
                                ltype=lval->indirect;
                        }
                        if ( ptr->ident == ARRAY ||
                                                (ptr->ident == VARIABLE && ptr->type == STRUCT) ) {
                                /* djm pointer? */
                                lval->ptr_type = ptr->type ;
                                lval->val_type = (ptr->flags&FARPTR ? CPTR : CINT );
                                return(0) ;
                        }
                        else return(1);
                }
/* djm search for local statics */
                ptr=findstc(sname);
                if (!ptr) ptr=findglb(sname);
                if ( ptr ) {
                        if ( ptr->ident != FUNCTION ) {
                                lval->symbol = ptr ;
                                lval->indirect = 0 ;
                                lval->val_type = ptr->type ;
                                lval->flags = ptr->flags ;
                                lval->ident = ptr->ident;
                                lval->ptr_type = 0;
                                ltype=ptr->type;
                                if ( ptr->type == STRUCT )
                                        lval->tagsym = tagtab + ptr->tag_idx ;
                                if ( ptr->ident != ARRAY &&
                                                        (ptr->ident != VARIABLE || ptr->type != STRUCT) ) {
                                        if ( ptr->ident == POINTER ) {
                                          lval->ptr_type = ptr->type;
                                          lval->val_type = (ptr->flags&FARPTR ? CPTR : CINT);
                                          ltype=lval->indirect;
                                        }
                                        return(1);
                                }
/* Handle arrays... */
                                address(ptr);
/* djm sommat here about pointer types? */
                                lval->indirect = lval->ptr_type = ptr->type ;
                                lval->val_type = (ptr->flags&FARPTR ? CPTR : CINT);
                                return(0) ;
                        }
                }
                else {
                        /* assume it's a function we haven't seen yet */
                        /* NB value set to 0 */
                        ptr = addglb(sname,FUNCTION,CINT,0,STATIK,0,0);
                        ptr->size=0;
                        ptr->prototyped=0; /* No parameters known */
                        ptr->args[0]=CalcArgValue(CINT, FUNCTION, 0);
                }
                lval->symbol = ptr ;
                lval->indirect = 0 ;
                lval->val_type = CINT ;  /* Null function, always int */
                lval->flags = 0 ;        /* Assume signed, no far */
                return(0) ;
        }
        if ( constant(lval) ) {
                lval->symbol = NULL_SYM ;
                lval->indirect = 0 ;
                lval->ident = VARIABLE;
                return(0) ;
        }
        else {
                error("Invalid expression");
                vconst(0);
                junk();
                return(0);
        }
}

/*
 * flag error if integer constant is found in double expression
 */


void dcerror(lval)
LVALUE *lval ;
{
        if ( lval->val_type == DOUBLE )
                warning("Int const in double expr") ;
}

/*
 * calculate constant expression
 */
int calc(left, oper, right)
int left;
void (*oper)();
int right;
{
        if (oper == zor)        return (left | right) ;
        else if (oper == zxor)  return (left ^ right) ;
        else if (oper == zand)  return (left & right) ;
        else if (oper == mult)  return (left * right) ;
        else if (oper == zdiv)   return (left / right) ;
        else if (oper == asr)   return (left >> right) ;
        else if (oper == asl)   return (left << right) ;
        else if (oper == zmod)  return (left % right) ;
        else if (oper == zeq)   return (left == right) ;
        else if (oper == zne)   return (left != right) ;
        else if (oper == zle)   return (left <= right) ;
        else if (oper == zge)   return (left >= right) ;
        else if (oper == zlt)   return (left <  right) ;
        else if (oper == zgt)   return (left >  right) ;
        else return(calc2(left,oper,right)) ;
}

int calc2(left,oper,right)
unsigned int left;
void (*oper)();
unsigned int right;
{
        if (oper == zdivun)      return (left / right );
        else if (oper == zmodun) return (left % right );
        else if (oper == ule)    return (left <= right) ;
        else if (oper == uge)    return (left >= right) ;
        else if (oper == ult)    return (left <  right) ;
        else if (oper == ugt)    return (left >  right) ;
        else if (oper == asr_un) return (left >> right) ;
        else return(0);
}


/* Complains if an operand isn't int */
void intcheck(lval, lval2)
LVALUE *lval, *lval2 ;
{
        if( lval->val_type==DOUBLE || lval2->val_type==DOUBLE )
                error("Operands must be int");
}

/* Forces result, having type t2, to have type t1 */
/* Must take account of sign in here somewhere, also there is a problem    possibly with longs.. */
void force(t1,t2,sign1, sign2,lconst)
int t1,t2;
char sign1, sign2;
int lconst;
{
        if(t1==DOUBLE) {
                if(t2!=DOUBLE) {
                        if (mathz88 && t2!=LONG) {
                                if (sign2) const2(0);
                                else callrts("l_int2long_s");
                        }
                        if (sign2 == NO) callrts("float");
                        else callrts("ufloat");
                        return;
                }
        }
        else {
           if (t2==DOUBLE && t1!=DOUBLE ) {
                callrts("ifix");
                return;
           }

        }
/* t2 =source, t1=dest */
/* int to long, if signed, do sign, if not ld de,0 */
/* Check to see if constant or not... */
        if(t1==LONG) {
                if (t2!=LONG && (!lconst)) {
                      if (sign2==NO && sign1==NO) callrts("l_int2long_s");
                        else const2(0); /* ld de,0 */
                }
                return;
        }
/* Converting long to int, if signed do something, if not don't */
        else if (t2==LONG){
                if (t1!=LONG) {
                        if (sign1==NO && sign2==NO)
                                callrts("long2int_s");
                }
                return;
        }
        if (t1==CPTR && t2==CINT) const2(0);
        else if (t2==CPTR && t1==CINT) warning("Converting far ptr to near ptr");
}

/*
 * If only one operand is DOUBLE, converts the other one to
 * DOUBLE.  Returns 1 if result will be DOUBLE
 *
 * Maybe should an operand in here for LONG?
 */
int widen(lval, lval2)
LVALUE *lval, *lval2 ;
{
        if ( lval2->val_type == DOUBLE ) {
                if ( lval->val_type != DOUBLE ) {
                        dpush2();               /* push 2nd operand UNDER 1st */
                        mainpop() ;
                        callrts("float") ;
                        callrts("dswap") ;
                        lval->val_type = DOUBLE ;       /* type of result */
                }
                return(1);
        }
        else {
                if ( lval->val_type == DOUBLE ) {
                        if (lval->flags&UNSIGNED) callrts("ufloat");
                        else callrts("float");
                        return(1);
                }
                else return(0);
        }
}

void widenlong(lval, lval2)
LVALUE *lval, *lval2;
{
        if ( lval2->val_type == LONG ) {
/* Second operator is long */
                if ( lval->val_type != LONG ) {
                        doexx();          /* Preserve other operator */
                        mainpop() ;
                        force(LONG,lval->val_type,lval->flags&UNSIGNED, lval->flags&UNSIGNED, 0 );
                        lpush();        /* Put the new expansion on stk*/
                        doexx();          /* Get it back again */
                        lval->val_type = LONG;
                }
                return;
        }



        if ( lval->val_type == LONG) {
                if (lval2->val_type != LONG && lval2->val_type != CPTR) {
/* Unsigned conversion - 1st oper is long, 2nd is an integer */
                        if ( ((lval->flags&UNSIGNED) && (lval2->flags&UNSIGNED)) || (!(lval->flags&UNSIGNED) && (lval->flags&UNSIGNED)) ) {
/* If both unsigned, we can just load with 0  or long signed, int unsigned*/
                                const2(0);
                        } else if ( (!(lval->flags&UNSIGNED) && !(lval->flags&UNSIGNED) )|| ( (lval->flags&UNSIGNED) && !(lval2->flags&UNSIGNED)) ) {
/* both signed, extend or long unsigned+int signed*/
                                callrts("l_int2long_s");
                        }
                }
        }
}


/*
 * true if val1 -> int pointer or int array and
 * val2 not ptr or array
 */
int dbltest(lval, lval2)
LVALUE *lval, *lval2 ;
{
        if ( lval->ptr_type ) {
                if ( lval->ptr_type == CCHAR ) return(0);
                if ( lval2->ptr_type ) return(0);
                return(1);
        }
        else return(0);
}

/*
 * determine type of binary operation
 */
void result(lval,lval2)
LVALUE *lval, *lval2 ;
{
        if ( lval->ptr_type && lval2->ptr_type )
                lval->ptr_type = 0 ;                    /* ptr-ptr => int */
        else if ( lval2->ptr_type ) {           /* ptr +- int => ptr */
                lval->symbol = lval2->symbol ;
                lval->indirect = lval2->indirect ;
                lval->ptr_type = lval2->ptr_type ;
        }
}

/*
 * prestep - preincrement or predecrement lvalue
 */


void prestep(lval, n, step, longstep)
LVALUE *lval ;
int n;
void (*step)(), (*longstep)() ;
{
        if ( heira(lval) == 0 ) {
                needlval();
        }
        else {
                if(lval->indirect) {
                        addstk(lval);
                        if (lval->flags&FARACC) zpushde();
                        zpush();
                }
                rvalue(lval);
                intcheck(lval,lval);
                switch ( lval->ptr_type ) {
                case DOUBLE :
                        addconst(n*6,1,lval->symbol->flags&FARPTR);
                        break ;
                case STRUCT :
                        addconst(n*lval->tagsym->size,1,lval->symbol->flags&FARPTR) ;
                        break ;
                case LONG :
                        (*step)() ;
                case CPTR :
                        (*step)() ;
                case CINT :
                        (*step)() ;
                default :
                        if (ltype == LONG) (*longstep)();
                        else (*step)() ;
                        break ;
                }
                store(lval);
        }
}

/*
 * poststep - postincrement or postdecrement lvalue
 */
void poststep(k, lval, n, step, unstep)
int k ;
LVALUE *lval ;
int n;
void (*step)(), (*unstep)() ;
{
        if ( k == 0 ) {
                needlval() ;
        }
        else {
                if(lval->indirect) {
                        addstk(lval);
                        if (lval->flags&FARACC) zpushde();
                        zpush();
                }
                rvalue(lval);
                intcheck(lval,lval);
                switch ( lval->ptr_type ) {
                case DOUBLE :
                        nstep(lval, n*6);
                        break ;
                case STRUCT :
                        nstep(lval, n*lval->tagsym->size) ;
                        break ;
                case LONG:
                        nstep(lval,n*4) ;
                        break;
                case CPTR:
                        nstep(lval,n*3) ;
                        break;
                case CINT :
                        (*step)() ;
                default :
                        (*step)();
                        store(lval);
                        (*unstep)();
                        if ( lval->ptr_type == CINT )
                                (*unstep)();
                        break ;
                }

        }
}

/*
 * generate code to postincrement by n
 * no need to change for long pointers since we're going to have
 * memory pools..
 */
void nstep(lval, n)
LVALUE *lval ;
int n ;
{
        zpush() ;
        addconst(n,1,lval->symbol->flags&FARPTR) ;
        store(lval) ;
        mainpop() ;
}

void store(lval)
LVALUE *lval;
{
        if (lval->indirect == 0) putmem(lval->symbol) ;
        else putstk(lval->indirect) ;
}

/*
 * push address only if it's not that of a two byte quantity at TOS
 * or second TOS.  In either of those cases, forget address calculation
 * This should be followed by a smartstore()
 */
void smartpush(lval, before)
LVALUE *lval ;
char *before ;
{
        if ( lval->indirect != CINT || lval->symbol == 0 ||
                                                        lval->symbol->storage != STKLOC ) {
                addstk(lval);
                if (lval->symbol && lval->symbol->storage==FAR) zpushde();
                zpush();
        }
        else {
                switch ( lval->symbol->offset.i - Zsp ) {
                        case 0:
                        case 2:
                                if ( before )
                                        clearstage(before, 0) ;
                                break ;
                        default:
                                addstk(lval);
                                if (lval->symbol && lval->symbol->storage==FAR) zpushde();
                                zpush() ;
                }
        }
}

/*
 * store thing in primary register at address taking account
 * of previous preparation to store at TOS or second TOS
 */
void smartstore(lval)
LVALUE *lval ;
{
        if ( lval->indirect != CINT || lval->symbol == 0 ||
                                                        lval->symbol->storage != STKLOC )
                store(lval) ;
        else {
                switch ( lval->symbol->offset.i - Zsp ) {
                case 0 :
                        puttos();
                        break ;
                case 2 :
                        put2tos();
                        break ;
                default:
                        store(lval) ;
                }
        }
}

void rvalue(lval)
LVALUE *lval;
{
        if( lval->symbol && lval->indirect == 0 )
                getmem(lval->symbol);
        else indirect(lval->indirect,lval->flags);
#if DEBUG_SIGN
        if (lval->flags&UNSIGNED) ol("; unsigned");
        else ol("; signed");
#endif
}

void test(label, parens)
int label, parens;
{
        char *before, *start ;
        LVALUE lval ;
        void (*oper)() ;

        if (parens) needchar('(');
        while(1) {
                setstage( &before, &start ) ;
                if ( heir1(&lval) ) rvalue(&lval) ;
                if ( cmatch(',') )
                        clearstage( before, start) ;
                else break ;
        }
        if (parens) needchar(')');
        if ( lval.is_const ) {          /* constant expression */
                clearstage(before,0) ;
                if ( lval.const_val ) {
                        /* true constant, perform body */
                        return ;
                }
                /* false constant, jump round body */
                jump(label) ;
                return ;
        }
        if ( lval.stage_add ) {         /* stage address of "..oper 0" code */
                oper = (void *)  lval.binop ;             /* operator function pointer */
                if ( oper == zeq || oper == ule ) zerojump(eq0, label, &lval) ;
                else if ( oper == zne || oper == ugt )
                                                                zerojump(testjump, label, &lval) ;
                else if ( oper == zgt ) zerojump(gt0, label, &lval) ;
                else if ( oper == zge ) zerojump(ge0, label, &lval) ;
                else if ( oper == uge ) clearstage(lval.stage_add, 0) ;
                else if ( oper == zlt ) zerojump(lt0, label, &lval) ;
                else if ( oper == ult ) zerojump(jump, label, &lval) ;
                else if ( oper == zle ) zerojump(le0, label, &lval) ;
                else testjump(label) ;
        }
        else testjump(label);
        clearstage(before,start);
}

/*
 * evaluate constant expression
 * return TRUE if it is a constant expression
 */
int constexpr(val)
long *val ;
{
        char *before, *start ;
        int con, valtemp ;

        setstage(&before, &start) ;
        expression(&con, &valtemp) ;
        *val=(long) valtemp;
        clearstage(before, 0) ;         /* scratch generated code */
        if (con == 0)
                error("Expecting constant expression") ;
        return con ;
}

/*
 * Load long into hl and de 
 * Takes respect of sign, so if signed and high word=0 then
 * print 65535 else print whats there..could possibly come unstuck!
 * this is so that -1 -> -32768 are correcly represented
 *
 * djm 21/2/99 fixed, so that sign is disregarded! this allows us
 * to have -1 entered correctly
 */

void vlongconst(unsigned long val)
{
        vconst(val%65536);
        const2(val/65536);
}


/*
 * load constant into primary register
 */
void vconst(val)
int val ;
{
        immed();
        outdec(val);
        nl();
}

/*
 * load constant into secondary register
 */
void const2(val)
int val ;
{
        immed2();
        outdec(val);
        nl();
}

/*
 * scale constant value according to type
 */
void cscale(type, tag, val)
int type ;
TAG_SYMBOL *tag ;
int *val ;
{
        switch ( type ) {
        case CINT:
                *val *= 2 ;
                break ;
        case CPTR:
                *val *= 3 ;
                break;
        case LONG:
                *val *= 4 ;
                break;
        case DOUBLE:
                *val *= 6 ;
                break ;
        case STRUCT :
                *val *= tag->size ;
                break ;
        }
}

/*
 * add constant to primary register
 *
 * changed quite a bit...using bc to get offset to add to, was
 * going to take account of far and then push/pop, but maybe this
 * will work just as well?
 */
void addconst(val,opr,zfar)
int val ;
int opr;
char zfar;       /* If far we have to take care about this one */
{
        if (!opr) opertype=ltype;
        if (ltype == LONG && (!opr) ) {
                lpush();
                vlongconst(val);
                zadd();
        }
        else 
/* Theory is that for long pointers,its only hl that will need adjusting */
        switch(val) {

                case -3 :       dec() ;
                case -2 :       dec() ;
                case -1 :       dec() ;
                case  0 :       break ;

                case  3 :       inc() ;
                case  2 :       inc() ;
                case  1 :       inc() ;
                                        break ;

                default :       
                                ot("ld\tbc,");
                                outdec(val);
                                outstr("\n\tadd\thl,bc\n");
/* Old version of add used de as reg to add, now use bc! 
                                const2(val) ;
                                        zadd() ;
*/
        }
}

