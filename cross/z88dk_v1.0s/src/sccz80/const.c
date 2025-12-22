
/*
 *      Small C+ Compiler
 *      Split into parts 3/3/99 djm
 *
 *      This part deals with the evaluation of a constant
 *
 *      $Id: const.c 1.9 1999/03/22 21:27:18 djm8 Exp $
 *
 *      7/3/99 djm - fixed minor problem in fnumber, which prevented
 *      fp numbers from working properly! Also added a ifdef UNSURE
 *      around exponent-- for -math-z88
 *
 *
 */

#include "ccdefs.h"

/*
 * These two variables used whilst loading constants, makes things
 * a little easier to handle - type specifiers..
 */

char    constype;
char    conssign;

/* Modified slightly to sort have two pools - one for strings and one
 * for doubles..
 */

int constant(lval)
LVALUE *lval ;
{
        constype=CINT;
        conssign=dosigned;
        lval->is_const = 1 ;            /* assume constant will be found */
        if ( fnumber(&lval->const_val) ) {
                lval->val_type=DOUBLE;
                immedlit(dublab);
                outdec(lval->const_val); nl();
                callrts("dload");
                lval->is_const = 0 ;                    /*  floating point not constant */
                lval->flags=0;
                return(1);
        }
        else if ( number(&lval->const_val) || pstr(&lval->const_val) ) {
/* Insert long stuff/long pointer here? */
                lval->val_type = constype ;
                lval->flags = (lval->flags&MKSIGN)|conssign;
                if (constype == LONG) vlongconst(lval->const_val);
                else vconst(lval->const_val);
                return(1);
        }
        else if ( tstr(&lval->const_val) ) {
                lval->is_const = 0 ;                    /* string address not constant */
                lval->ptr_type=CCHAR;   /* djm 9/3/99 */
                lval->val_type=CINT;
                lval->flags=0;
                immedlit(litlab);
        }
        else {
                lval->is_const = 0 ;
                return(0);       
        }
        outdec(lval->const_val);
        nl();
        return(1);
}


int fnumber(val)
long *val;
{
        unsigned char sum[6],scale[6],frcn[6],dig1[6],dig2[6];
        int k;                  /* flag and mask */
        unsigned char minus;     /* is if negative! */
        char *start,    /* copy of pointer to starting point */
                        *s;             /* points into source code */
        if (mathz88) {
                frcn[0]=0;
                frcn[1]=205;
                frcn[2]=frcn[3]=204;
                frcn[4]=76;
                frcn[5]=125;
        } else {
                frcn[0]=205;
                frcn[1]=frcn[2]=frcn[3]=204;
                frcn[4]=76;
                frcn[5]=125;            /* frcn = 0.1 */
        }
        start=s=line+lptr;      /* save starting point */
        k=1;
        minus=1;
        while(k) {
                k=0;
                if(*s=='+') {
                        ++s; k=1;
                }
                if(*s=='-') {
                        ++s; k=1; minus=(-minus);
                }
        }
        
/* djm patch to ignore white space after sign (helps if you have defined
 * something..
 */
        while (*s==' ')  s++;

        while ( numeric(*s) )
                ++s ;
        if ( *s++ != '.' )
                return(0);               /* not floating point */
        while ( numeric(*s) )
                ++s ;
        lptr = (s--) - line ;           /* save ending point */
        sum[0]=sum[1]=sum[2]=sum[3]=sum[4]=sum[5]='\0';
        while ( *s != '.' ) {           /* handle digits to right of decimal */
/* Get the value into a register - all routines dump in second register */
        qfloat( ( *(s--)-'0' ),dig1);
        fltadd(dig1,sum);
        fltmult(frcn,sum);
        }
        qfloat(1,scale);
        while ( --s >= start ) {
                qfloat((*s-'0'),dig1);
                fltmult(scale,dig1);
                fltadd(dig1,sum);
                qfloat(10,dig2);
                fltmult(dig2,scale);
        }

/* Chopped out exponent stuff...for the moment! */
        if(cmatch('e')) {                       /* interpret exponent */
                int neg;                        /* nonzero if exp is negative */
                long expon;                     /* the exponent */

                if(number(&expon)==0) {
                        error("Invalid exponent");
                        expon=0;
                }
                if(expon<0) {
                        neg=1; expon=(-expon);
                }
                else neg=0;
                if(expon>38) {
                        error("Floating overflow");
                        expon=0;
                }
                k=32;   /* set a bit in the mask */
/*                scale=1.;     */
                /* find 10**expon by repeated squaring */
/*                while(k) {
                        scale *= scale;
                        if(k&expon) scale *= 10.;
                        k >>= 1;
                }
                if(neg) sum /= scale;
                else    sum *= scale;   */
        }
/*
 * This negative bit is garbage! The code does a minusfa on loading in
 * anycase!!! (if the number is -ve!!!
 */
        if ( minus != 1) 
                sum[4]=sum[4]|128;

/* Z88 FP numbers have exponent+127, gen has exponent +128
 * Not so sure about this
 */
        if (mathz88) sum[5]--;

        /* get location for result & bump litptr */
        *val = searchdub(sum);
        return(1) ;      /* report success */
}

/* Search through the literal queue searching for a match with our
 * number - saves space etc etc
 */

int searchdub(char *num)
{
        char *tempdub;
        int dubleft, k,match;
        
        dubleft=dubptr;
        tempdub=dubq;
        while( dubleft ){
                /* Search through.... */
                match=0;
                for ( k = 0 ; k < 6 ; k++) {
                        if (*tempdub++ == num[k]) match++;
                }
                if (match == 6 ) return (dubptr-dubleft);
                 dubleft -= 6;
        }
/* Put it in the double queue now.. */
        if ( dubptr+6 >= FNMAX ) {
                error("Double space exhausted");
                return(0);
        }

        for (k=0 ; k< 6 ; k++){
                *tempdub++=num[k];
        }
        dubptr += 6;
        return (dubptr-6);
}



int number(val)
long *val;
{
        char c ;
        int minus;
        long  k ;
/*
 * djm, set the type specifiers to normal
 */
        k = minus = 1 ;
        while ( k ) {
                k = 0 ;
                if ( cmatch('+') ) k = 1 ;
                if ( cmatch('-') ) {
                        minus = (-minus) ;
                        k = 1 ;
                }
        }
        if( ch() == '0' && raise(nch()) == 'X' ) {
                gch() ;
                gch() ;
                if ( hex(ch()) == 0 ) return(0) ;
                while ( hex(ch()) ) {
                        c = inbyte() ;
                        if ( c <= '9' )
                                k = (k << 4) + (c-'0') ;
                        else
                                k = (k << 4) + ((c&95) - '7') ;
                }
                *val = k ;
                return(1) ;
        }
        if ( numeric(ch()) == 0 )
                return(0);
        while ( numeric(ch()) ) {
                c = inbyte() ;
                k = k*10+(c-'0') ;
        }
        if ( minus < 0 ) k = (-k) ;
        *val = k ;
        if ( cmatch('L') ) constype=LONG;
        if ( cmatch('U') ) conssign=YES;        /* unsigned */
        else if ( cmatch('S') ) conssign=NO;
        return(1) ;
}

int hex(c)
char c ;
{
        char c1 ;

        c1 = raise(c) ;
        return( (c1>='0' && c1<='9') || (c1>='A' && c1<='F') ) ;
}

/* djm, seems to load up literal address? */

void address(ptr)
SYMBOL *ptr ;
{
        immed() ;
        outname(ptr->name,dopref(ptr)) ;
        nl();
/* djm if we're using long pointers, use of e=0 means absolute address,
 * this covers up a bit of a problem in deref() which can't distinguish
 * between ptrtoptr and ptr
 */
        if (ptr->flags&FARPTR) { ol("ld\tde,0"); }
}

int pstr(long *val)
{
        int k ;

        constype=CINT;
        constype=dosigned;
        if (cmatch('\'')) {
                k = 0 ;
                while ( ch() != 39 )
                        k = (k&255)*256 + litchar() ;
                ++lptr ;
                *val = k ;
                return(1) ;
        }
        return(0) ;
}

/* Scan in literals within function into temporary buffer and then
 * check to see if present elsewhere, if so do the merge as for doubles
 */

int tstr(long *val)
{
        int k,j;

        j=k=0;
        if ( cmatch('"') == 0 ) return(0) ;
        do {
                while ( ch() !='"' ) {
                        if ( ch() == 0 ) break ;
                        tempq[k]=litchar();
                        k++;    /* counter */
                }
                gch();
        } while (cmatch('"'));
        tempq[k]= 0;
        k++;
        return(storeq(k,tempq,val));
}


int storeq(int length, unsigned char *queue,long *val)
{
        int     j,k,len;
/* Have stashed it in our temporary queue, we know the length, so lets
 * get checking to see if one exactly the same has already been placed
 * in there...
 */
        k=length;
        len=litptr-k;   /* Amount of leeway to search through.. */
        j=0;
        while (len >= j) {
                if (strncmp(queue,litq+j,k) == 0) {*val=j; return(1);} /*success!*/
                j++;
        }
/* If we get here, then dump it in the queue as per normal... */
        *val=(long) litptr;
        for (j=0; j<k; j++) {
/* Have to dump it in our special queue here for function literals */
                if ( (litptr+1) >= FNMAX ) {
                        error("Literal queue overflow");
                        ccabort();
                }
                *(litq+litptr)=*(queue+j);
                litptr++ ;
        }
        return(k);
}


int qstr(long *val)
{
        int cnt;
        cnt=0;
        if ( cmatch('"') == 0 ) return(0) ;
        *val = (long) gltptr ;
        while ( ch() != '"' ) {
                if ( ch() == 0 ) break ;
                cnt++;
                stowlit(litchar(), 1) ;
        }
        gch() ;
        glbq[gltptr++] = 0 ;
        return(cnt);
}

/* store integer i of size size bytes in global var literal queue */
void stowlit(value, size)
int value, size ;
{
        if ( (gltptr+size) >= LITMAX ) {
                error("Literal queue overflow");
                ccabort();
        }
        putint(value, glbq+gltptr, size);
        gltptr += size ;
}




/* Return current literal char & bump lptr */
char litchar()
{
        int i, oct ;

        if ( ch() != 92 ) return(gch()) ;
        if ( nch() == 0 ) return(gch()) ;
        gch() ;
        switch( ch() ) {
                case 'b': {++lptr; return  8;} /* BS */
                case 't': {++lptr; return  9;} /* HT */
                case 'l': {++lptr; return 10;} /* LF */
                case 'f': {++lptr; return 12;} /* FF */
                case 'n': {++lptr; return 13;} /* CR */
                case 34 : {++lptr; return 34;} /* "  */
                case 39 : {++lptr; return 39;} /* '  */
        }
        i=3; oct=0;
        while ( i-- > 0 && ch() >= '0' && ch() <= '7' )
                oct=(oct<<3)+gch()-'0';
        if(i==2)return(gch());
        else return(oct);
}

/*
 * find size of type (on variable now as well)
 */
#ifndef SMALL_C
void 
#endif
size_of(lval)
LVALUE *lval ;
{
        char sname[NAMESIZE] ;
        int  length;
        TAG_SYMBOL *otag ;

        needchar('(') ;
        if ( amatch("unsigned") || amatch("signed") ) lval->const_val=2;
        if ( amatch("struct") || amatch("union") ) {
                if ( symname(sname) == 0 )
                        illname() ;
                else if ( (otag=findtag(sname)) )
                        lval->const_val = otag->size ;
                else
                        error("Unknown struct") ;
        }
        else if ( amatch("int") )
                lval->const_val = 2 ;
        else if ( amatch("char") )
                lval->const_val = 1 ;
        else if ( amatch("long") )
                lval->const_val = 4;
        else if ( amatch("double") )
                lval->const_val = 6 ;
/*
 * djm mod to do sizeof on string
 */
        else if ( cmatch('"') ) {
                length=1;       /* Always terminated by a \0 */
                while (!cmatch('"')) {
                        length++;
                        litchar();
                } ;
                lval->const_val=length;
        } else {
/*
 * djm mod to do sizeof on an array etc
 */
                char sname[NAMEMAX+1];
                int   j;
                SYMBOL *ptr;
                j=0;
                blanks();
                while ( alpha(ch()) && j<NAMEMAX ) {
                        sname[j]=litchar();
                        j++;
                }
                if ( j ) {      /* We have got something.. */
                        sname[j]=0;
                        if ( (ptr = findglb(sname)) || (ptr=findloc(sname)) || (ptr=findstc(sname)) ) {
                        /* Actually found sommat..very good! */
                                if ( ptr->ident!=FUNCTION && ptr->ident!=MACRO) lval->const_val=ptr->size;
                                else {
                                        warning("Illegal sizeof operation (on function)");
                                        /* good enough default? */
                                        lval->const_val=2;
                                }
                        }
                }

        }
        needchar(')') ;
        lval->is_const = 1 ;
        lval->val_type = CINT ;
        vconst(lval->const_val) ;
}
