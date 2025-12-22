/* Scheme In One Define.
 
The garbage collector, the name and other parts of this program are

 *                     COPYRIGHT (c) 1989 BY                              *
 *      PARADIGM ASSOCIATES INCORPORATED, CAMBRIDGE, MASSACHUSETTS.       *

Conversion  to  full scheme standard, characters, vectors, ports, complex &
rational numbers, and other major enhancments by

 *      Scaglione Ermanno, v. Pirinoli 16 IMPERIA P.M. 18100 ITALY        * 

Permission  to use, copy, modify, distribute and sell this software and its
documentation  for  any purpose and without fee is hereby granted, provided
that  the  above  copyright  notice appear in all copies and that both that
copyright   notice   and   this  permission  notice  appear  in  supporting
documentation,  and that the name of Paradigm Associates Inc not be used in
advertising or publicity pertaining to distribution of the software without
specific, written prior permission.

PARADIGM  DISCLAIMS  ALL WARRANTIES WITH REGARD TO THIS SOFTWARE, INCLUDING
ALL  IMPLIED  WARRANTIES  OF MERCHANTABILITY AND FITNESS, IN NO EVENT SHALL
PARADIGM  BE  LIABLE  FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR
ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER
IN  AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT
OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

*/

#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <setjmp.h>
#include <signal.h>
#include <time.h>
#include <math.h>

#include "siod.h"

void process_cla(int argc, char **argv)
{int k;
 for(k=1;k<argc;++k)
   {if (strlen(argv[k])<2) continue;
    if (argv[k][0] != '-')
      {printf("bad arg: %s\n",argv[k]);continue;}
    switch(argv[k][1])
      {case 'h':
	 heap_size = atol(&(argv[k][2]));
         if(heap_size<1000)
	    heap_size = 1000;
         break;
       case 'o':
	 obarray_dim = atol(&(argv[k][2])); 
         if(obarray_dim<1)
           obarray_dim=1;
         break;
       case 'f':
	 fixarray_dim = atol(&(argv[k][2])); 
         if(fixarray_dim<1)
           fixarray_dim=1;
         break;
       case 'i':
	 init_file = &(argv[k][2]); break;
       case 'q':
	 quiet = 1;
         break;
       case 's':
	 full_set = 0; break;
       default: printf("bad arg: %s\n",argv[k]);exit(10);}}}

void print_welcome(void)
{printf("\f           SSSSSSSSSS       IIII       OOOOOOOO        DDDDD \n");
 printf("          SSSSSSSSSSSS      IIII      OOOOOOOOOO       DDDDDD \n");
 printf("         SSSS              IIII      OOOO   OOOO      DDDDDDDD\n");
 printf("        SSSS              IIII      OOOO    OOOO      DDDD  DDDD\n");
 printf("        SSSSSSSSSSS       IIII      OOOO    OOOO      DDDD   DDDD\n");
 printf("         SSSSSSSSSSS     IIII      OOOO    OOOO      DDDD    DDDD\n");
 printf("               SSSS      IIII      OOOO    OOOO      DDDD    DDDD\n");
 printf("              SSSS      IIII       OOOO   OOOO      DDDD    DDDD\n");
 printf("      SSSSSSSSSSS      IIII        OOOOOOOOOO      DDDDDDDDDDDD\n");
 printf("     SSSSSSSSSSS       IIII         OOOOOOOO      DDDDDDDDDDDD\n\n");
 printf("                       Scheme In One Define.\n");
 printf("             Based on the original code from Paradigm Inc.\n"); 
 printf("                       Coded by E. Scaglione\n");
 printf("                           Version 2.6\n\n");
}

void print_hs_1(void)
{printf("Heap size is %d cells, %d bytes.\n",
        heap_size,heap_size*sizeof(struct obj));
 printf("Symbol hash table size is %d buckets, %d bytes.\n",
        obarray_dim,obarray_dim*sizeof(struct obj *));
 printf("Integers hash table size is %d buckets, %d bytes.\n",
        fixarray_dim,fixarray_dim*sizeof(struct obj *));
 printf("Loaded a %s set of predefined functions\n",full_set?"full":"small");
 printf("Mode: %s\n",quiet ? "silent":"verbose");}

long no_interrupt(long n)
{long x;
 x = nointerrupt;
 nointerrupt = n;
 if ((nointerrupt == 0) && (interrupt_differed == 1))
   {interrupt_differed = 0;
    err_ctrl_c();}
 return(x);}

void handle_sigfpe(int sig)
{signal(SIGFPE,handle_sigfpe);
 err("floating point exception",NIL,ERR_GEN);}

#ifdef AMIGA

void handle_sigabort(int sig)
{signal(SIGABRT,handle_sigabort);
 err("abnormal termination",NIL,ERR_GEN);}

void _CXOVF()
{raise(SIGABRT);}

#endif

void handle_sigint(int sig)
{signal(SIGINT,handle_sigint);
 if (nointerrupt == 1)
   interrupt_differed = 1;
 else
   err_ctrl_c();}

void err_ctrl_c(void)
{err("control-c interrupt",NIL,ERR_GEN);}

LISP eof_valp(LISP x)
{if(EQ(x,eof_val))
   return(truth);
 return(NIL);}

void err(char *message, LISP x, int type)
{FILE *out;
 if(type & ERR_FIRST)
   sprintf(tkbuffer,"ERROR: 1st arg to %s",message);
 else if(type & ERR_SECOND)
   sprintf(tkbuffer,"ERROR: 2nd arg to %s",message);
 else if(type & ERR_THIRD)
   sprintf(tkbuffer,"ERROR: 3rd arg to %s",message);
 else if(type & ERR_GEN_ARG)
   sprintf(tkbuffer,"ERROR: arg to %s",message);
 if((type & ERR_GEN)||(type & ERR_MEM))
   sprintf(tkbuffer,"ERROR: %s",message);
 else if(type & ERR_IND_RAN)
   sprintf(tkbuffer,"ERROR: index out of range to %s",message);
 else if(type & ERR_NFIL)
   sprintf(tkbuffer,"ERROR: could not open file %s",message);
 else if(type & ERR_NSYM)
   strcat(tkbuffer," must be a symbol");
 else if(type & ERR_NINT)
   strcat(tkbuffer," must be an integer");
 else if(type & ERR_NPRO)
   strcat(tkbuffer," must be a procedure");
 else if(type & ERR_NNUM)
   strcat(tkbuffer," must be a number");
 else if(type & ERR_NENV)
   strcat(tkbuffer," must be an environment");
 else if(type & ERR_NPOR)
   strcat(tkbuffer," must be a port");
 else if(type & ERR_NPAI)
   strcat(tkbuffer," must be a pair");
 else if(type & ERR_NCHA)
   strcat(tkbuffer," must be a character");
 else if(type & ERR_NSTR)
   strcat(tkbuffer," must be a string");
 else if(type & ERR_NVEC)
   strcat(tkbuffer," must be a vector");
 else
   sprintf(tkbuffer,"ERROR: type %d message: %s",type,message);
 if (errjmp_ok == 1) 
  {strncpy(SNAME(sym_err_string),tkbuffer,128);
   setv(sym_errobj,x);
   setv(cintern("*lasterr*"),sym_err_string);
   setv(cintern("*cargs*"),cur_exp);
   setv(cintern("*cenv*"),cur_env);
   apply_proc(VCELL(sym_err_han),NIL,NIL);
   setv(cintern("*cargs*"),NIL);
   setv(cintern("*cenv*"),NIL);
   longjmp(errjmp,1);}
 if((heap==NULL)||(obarray==NULL)||(fixarray==NULL)||(chararray==NULL))
    fprintf(stderr,"Suggested heap or symbol table size too large\n",tkbuffer);
 else
   {fprintf(stderr,"%s\n",tkbuffer);
    fprintf(stderr,"FATAL ERROR\n");}
 exit(20);}

LISP error_han(void)
{FILE *out;
 if(NPORTP(cdr(val_output_port)))
   {if(PORTP(VCELL(sym_standard_output)))
      CDR(val_output_port) = VCELL(sym_standard_output);
    else
      {fprintf(stderr,"FATAL ERROR: wrong standard output\n");
       exit(10);}}
 if(NPORTP(cdr(val_input_port)))
   {if(PORTP(VCELL(sym_standard_input)))
      CDR(val_input_port) = VCELL(sym_standard_input);
    else
      {fprintf(stderr,"FATAL ERROR: wrong standard input\n");
       exit(10);}}
 out = PORTPTR(CDR(val_output_port));
 clearerr(out);
 clearerr(PORTPTR(CDR(val_input_port)));
 fflush(NULL);
 fput_st(out,SNAME(sym_err_string));
 fput_st(out,(NULLP(VCELL(sym_errobj)) ? "\n" : " (see errobj)\n"));
 if(VCELL(sym_debug_mode)==truth)
    apply_proc(VCELL(sym_inspect),NIL,NIL);
 return(NIL);}

LISP lerr(LISP args)
{LISP message,irritant;
 message=car(args);
 irritant=cdr(args);
 if (NSTRINGP(message)) err("error",message,ERR_GEN_ARG | ERR_NSTR);
 if NULLP(cdr(irritant))
   err(SNAME(message),car(irritant),ERR_GEN);
 err(SNAME(message),irritant,ERR_GEN);
 return(NIL);}

