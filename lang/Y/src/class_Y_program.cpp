
#ifndef CL_Y_PROGRAM_HPP
#include "class_Y_program.hpp"
#endif


//+ "class statics"

const int Y_program::commandtype[128]=
{ imp,imp,imp,imp, imp,imp,imp,imp,
  imp,imp,imp,imp, imp,imp,imp,imp,
  imp,imp,imp,imp, imp,imp,imp,imp,
  imp,imp,imp,imp, imp,imp,imp,imp,  // 0-31
  imp,                               // space

  imp,imp,imp,sta, sta,bin,imp,imp,
//!   "   #   $    %   &   '   (

  imp,ari,ari,sio, ari,sio,ari,imp,
//)   *   +   ,    -   .   /   0

  imp,imp,imp,imp, imp,imp,imp,imp,
//1   2   3   4    5   6   7   8

  imp,mem,mem,cmp, cmp,cmp,imp,sta,
//9   :   ;   <    =   >   ?   @
  pag,pag,pag,pag, pag,pag,pag,pag,
//A   B   C   D    E   F   G   H

  pag,imp,pag,pag, ari,sta,pag,pag,   // J is ifthenelse, M is an arithmetic command!!!
//I   J   K   L    M   N   O   P

  yyy,pag,pag,pag, pag,yyy,pag,pag,
//Q   R   S   T    U   V   W   X

  yyy,mem,imp,sta, imp,sio,ari,sio,
//Y   Z   [   \    ]   ^   _   `  96

  imp,imp,imp,imp, imp,imp,imp,imp,
//abcd efgh

  imp,imp,imp,imp, imp,imp,imp,imp,
//ijkl mnop

  imp,imp,imp,imp, imp,imp,imp,imp,
//qrst uvwx

  imp,imp,imp,bin, imp,bin,imp       // 0x7f is "end" command.
//y   z   {   |    }   ~   <0x7f>
};


//-

//+ "class privates"

//+ "Constructor/Destructor"

// common constructor initializaion routines

//+ "void Y_program::init_variables(long dsiz, long rsiz)"
void Y_program::init_variables(long dsiz, long rsiz)
{
valid=1;code=0;d_stack=0;r_stack=0;

d_sc=r_sc=0;pokesize=4;
codepage=0;fcomparetolerance=.01f;

dsize=dsiz;rsize=rsiz;

d_stack=new ulword[dsiz];
r_stack=new programcounter[rsiz];
}

//-
//+ "void Y_program::prepare_source(void)"
void Y_program::prepare_source(void)
{
    long cnt=0;

//+ " tidying up source - kill comments, convert strings"
    while(cnt<length)
    switch(code[cnt])
        {case '{':
                while(code[cnt]!='}'&&cnt<length)code[cnt++]=' ';
                if(cnt<length)code[cnt++]=' ';
              break;
         case '\'':
                cnt+=2;
              break;
         case '\"':
                while(code[++cnt]!='\"'&&cnt<length)
                  {}code[cnt++]=0;       // turning closing quote to zero
              break;                     // in loaded source is a tricky way to
                                         // null-termination of strings.
         default:cnt++;
              break;
        }
//-

//+ "  Lexical analysis of source - so that we won't have to worry later on..."
   {ulword i=0;
    static char bstack[1000]; // max. 1000 nested ([('s - who writes such code???
    ulword bptr=0;

    while(valid && i<=length)
     {
      if(code[i]=='\'')
        {if(code[i+1]==0x7f){fprintf(stderr,"Escape at End error!\n");valid=0;}
         i+=2;
        }
      else if(code[i]=='\"')
        {while(code[i]!=0&&code[i]!=0x7f)i++;
         if(code[i]==0x7f)
           {fprintf(stderr,"String error!\n");valid=0;}
        }
      else if(code[i]=='[')
        {bstack[bptr++]='[';
         if(bptr==1001){fprintf(stderr,"1000 nested braces error!\n");valid=0;}
        }
      else if(code[i]=='(')
        {bstack[bptr++]='(';
         if(bptr==1001){fprintf(stderr,"1000 nested braces error!\n");valid=0;}
        }
      else if(code[i]==']')
        {if(bptr==0||bstack[--bptr]!='[')
                       {fprintf(stderr,"Closing Brace error!\n");valid=0;}
        }
      else if(code[i]=='#')
        {if(bptr==0||bstack[bptr-1]!='(')
                       {fprintf(stderr,"While-Brace error!\n");valid=0;}
         bstack[bptr-1]='#';
        }
      else if(code[i]==')')
        {if(bptr==0||bstack[--bptr]!='#')
                       {fprintf(stderr,"Closing Brace error!\n");valid=0;}
        }
      else if(code[i]==0x7f)
        {if(bptr!=0){fprintf(stderr,"Too many braces open error!\n");valid=0;}
        }
      else if(code[i]&0x80)
        {fprintf(stderr,"Character value > 128 found in code!\n");valid=0;
        }
      i++;
     }
   }

//-

}

//-


// Constructors

//+ "Y_program::Y_program(const char *fname, long dsiz, long rsiz)"
Y_program::Y_program(const char *fname, long dsiz, long rsiz)
{
FILE *handle=0;

init_variables(dsiz,rsiz);

if(  d_stack==0
   ||r_stack==0
   ||(handle=fopen(fname,"r"))==0
  )valid=0;

if(valid)
 {
  fseek(handle,0,SEEK_END);        // let Chris have a look at it.
  length=ftell(handle);
  fseek(handle,0,SEEK_SET);

  if((code=new char[length+1])==0)valid=0;
  else
  {
   pc=code;
   code[length]=0x7f;
   // append end token (one which you won't ordinarily type...)
   fread(code,1,(unsigned int)length,handle);
   fclose(handle);
   prepare_source();
  }
 }

}
//-
//+ "Y_program::Y_program(long dsiz, long rsiz, const char *prog)"
Y_program::Y_program(long dsiz, long rsiz, const char *prog)
{
init_variables(dsiz,rsiz);

if(valid)
 {
  length=strlen(prog);

  if((code=new char[length+1])==0)valid=0;
  else
  {
   pc=code;
   code[length]=0x7f;
    // append end token (one which you won't ordinarily type...)
   strcpy(code,prog);
   prepare_source();
  }
 }

}
//-


//+ "Y_program::~Y_program()"

Y_program::~Y_program()
{
 if(d_stack)delete[] d_stack;
 if(r_stack)delete[] r_stack;
 if(code)delete[] code;
}

//-

//-


//+ "int Y_program::do_keyword(const char kw)"

int Y_program::do_keyword(const char kw)
{

// number parsing and the Y command are the same on all codepages!

if(kw>='a'&&kw<='z')
     {d_stack[d_sc++]=(ulword)(&vars[16*(kw-'a')]);return 1;}

if(kw=='Y')                 // exchange codepage. Place number of previous codepage on stack
     {ulword z;
      if(d_sc<1){err_uflow();return 0;}
      z=codepage;codepage=d_stack[d_sc-1];d_stack[d_sc-1]=z;
      return 1;
     }
if(kw=='Q')
     {return valid=0;}


else switch(codepage)
{
#ifdef YPAGE_0
 case 0:
//+ " Standard Codepage: Memory Management, File Management, I/O, various stuff"
     switch(commandtype[kw])
     {
      case mem:
       return do_mem(kw);
      case sta:
       return do_sta(kw);

      case pag:
       return do_base_pag(kw);
      case ari:
       return do_int_ari(kw);
      case bin:
       return do_int_bin(kw);
      case cmp:
       return do_int_cmp(kw);
      case sio:
       return do_int_sio(kw);

      default:{fprintf(stderr,">>%c<< not implemented!\n",kw);valid=0;return 0;}
     }
//-
  break;
 case 1:
//+ " Standard Codepage without stack checking"
     switch(commandtype[kw])
     {
      case mem:
       return do_memN(kw);
      case sta:
       return do_staN(kw);

      case pag:
       return do_base_pagN(kw);
      case ari:
       return do_int_ariN(kw);
      case bin:
       return do_int_binN(kw);
      case cmp:
       return do_int_cmpN(kw);
      case sio:
       return do_int_sioN(kw);

      default:{fprintf(stderr,">>%c<< not implemented!\n",kw);valid=0;return 0;}
     }
//-
  break;
#endif

#ifdef YPAGE_2
 case 2:
//+ " single precision floatingpoint math - limited range checkings!"
     switch(commandtype[kw])
     {
      case mem:
       return do_mem(kw);
      case sta:
       return do_sta(kw);

      case pag:
       return do_float_pag(kw);
      case ari:
       return do_float_ari(kw);
      case bin:
       return do_int_bin(kw);   // no floatingpoint bin-ops.
      case cmp:
       return do_float_cmp(kw);
      case sio:
       return do_float_sio(kw);

      default:{fprintf(stderr,">>%c<< not implemented!\n",kw);valid=0;return 0;}
     }
//-
  break;
 case 3:
//+ " single precision floatingpoint math - no stack checkings!"
     switch(commandtype[kw])
     {
      case mem:
       return do_memN(kw);
      case sta:
       return do_staN(kw);

      case pag:
       return do_float_pagN(kw);
      case ari:
       return do_float_ariN(kw);
      case bin:
       return do_int_binN(kw);   // no floatingpoint bin-ops.
      case cmp:
       return do_float_cmpN(kw);
      case sio:
       return do_float_sioN(kw);

      default:{fprintf(stderr,">>%c<< not implemented!\n",kw);valid=0;return 0;}
     }
//-
  break;
#endif

 default:
 {fprintf(stderr,"Codepage not Accessible!\n",kw);valid=0;return 0;}
  break;
}

}
//-

//-


//+ "int Y_program::step(void)"

int Y_program::step(void)
{
ulword x=0;

if(valid==0)return 0;
if(pc>=&code[length]){valid=0;return 0;}
if(d_sc>=dsize||r_sc>=rsize){err_oflow();return 0;}

while(*pc<=' ')pc++;        // spaces/cr's etc. are not stepped.
if(pc>=&code[length]){valid=0;return 0;}

#ifdef DEBUG
printf("PC:<\x1b[33m%8.8s\x1b[31m>\n",pc);
printf("Stack:%d\n",r_sc);
{for(int i=0;i<r_sc;i++){printf("%x\n",r_stack[i]);}}
#endif

if(*pc>='0' && *pc<='9')    // if number
  {
   do
     {x*=10;x+=*pc++-'0';
     } while(*pc>='0'  &&  *pc<='9');
   d_stack[d_sc++]=x;
  }

else switch(*pc)               // otherwise
      {
       case '\'':                                           // ASCII-ESCAPE
                  d_stack[d_sc++]=(0xffL & *++pc);pc++;
                break;
       case '\"':                                           // Left Quote
                  d_stack[d_sc++]=(ulword)(++pc);
                  while(*pc++){} // go on after \000
                break;
       case '[':                                            // Lambda function
                  {
                   d_stack[d_sc++]=(ulword)(++pc);
                   int lev=1;             // brace level
                   while(lev)
                    { if(*pc=='\'')pc=&pc[2];
                      else if(*pc=='\"')while(*pc++){}
                      else if(*pc=='['){pc++;lev++;}
                      else if(*pc==']'){lev--;pc++;}
                      else pc++;
                    }
                  }
                break;
       case ']':         // closing brace not fast-skipped => RETURN
                  pc=r_stack[--r_sc];
                break;
       case '!':                                   // subroutine call
                  if(d_sc<1){err_uflow();return 0;}
                  // place our return address on stack only if no return is
                  // immediately following the subroutine call.
                  // otherwise, we'll perform a simple jump and use the RTS of
                  // subroutine as our RTS. (tail recursion removal)

                  {const char *i=&pc[1];
                   while(*i<=' ')i++;
                   if(*i!=']')
                   r_stack[r_sc++]=&pc[1];
                  }
                   pc=(programcounter)d_stack[--d_sc];

                break;
       case '?':                                   // "if"
                  if(d_sc<2){err_uflow();return 0;}
                  {ulword f,b;
                   f=d_stack[--d_sc];
                   b=d_stack[--d_sc];
                   if(b!=0)
                   {
                    // Since an if also is a call, we will also have to do
                    // tail recursion removal here.
                    {const char *i=&pc[1];
                     while(*i<=' ')i++;
                     if(*i!=']')
                     r_stack[r_sc++]=&pc[1];
                    }
                    pc=(programcounter)(f);
                   }
                   else pc++;
                  }
                break;

       case 'J':                                   // "if then else"
                  if(d_sc<3){err_uflow();return 0;}
                  {ulword at,af,tv; // address true, address false, truthvalue
                   at=d_stack[--d_sc];
                   af=d_stack[--d_sc];
                   tv=d_stack[--d_sc];

                    // tail recursion removal!
                    {const char *i=&pc[1];
                     while(*i<=' ')i++;
                     if(*i!=']')
                     r_stack[r_sc++]=&pc[1];
                    }
                    pc=(programcounter)(tv?at:af);

                  }
                break;

       case ')':
                  pc=r_stack[r_sc-1];
                break;
       case '(':
                  pc++;
                  {
                   ulword lev=1;
                   programcounter posc=pc;
                   while(lev)
                    { if(*posc=='\'')posc=&posc[2];
                      else if(*posc=='\"')while(*posc++){}
                      else if(*posc=='('){posc++;lev++;}
                      else if(*posc==')'){lev--;posc++;}
                      else posc++;
                    }
                   r_stack[r_sc++]=posc;
                  }
                  r_stack[r_sc++]=pc;

                break;
      case '#':                                   // "while" --- do a clean loop exit
                  if(d_sc<1){err_uflow();return 0;}
                   if(d_stack[--d_sc]==0)
                   {r_sc--;pc=r_stack[--r_sc];}
                   else pc++;
                break;

       default:
                return do_keyword(*pc++);
      }

return valid;
}

//-




