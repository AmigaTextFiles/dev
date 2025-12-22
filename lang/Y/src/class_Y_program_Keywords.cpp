
#include "class_Y_program.hpp"

//+ "int Y_program::do_mem(const char kw)"

#ifdef NOCHECK
int Y_program::do_memN(const char kw)
#else
int Y_program::do_mem(const char kw)
#endif
{
switch(kw)
     {

//+ "    Peek/Poke :;Z - V is also placed in this class"

//  Z siZe_set
      case ':':
#ifndef NOCHECK
               if(d_sc<2){err_uflow();return 0;}
#endif
               {ulword val;ulword adr;
                adr=d_stack[--d_sc];val=d_stack[--d_sc];
                switch(pokesize)
                  {case 1: *(unsigned char *)adr=(unsigned char)val;
                    break;
                   case 2: *(unsigned short *)adr=(unsigned short)val;
                    break;
                   case 4: *(ulword *)adr=val;
                    break;
                   default:break;
                  }
               }
           break;
      case ';':
#ifndef NOCHECK
               if(d_sc<1){err_uflow();return 0;}
#endif
               {ulword val;ulword adr;
                adr=d_stack[--d_sc];
                switch(pokesize)
                  {case 1: val=((ulword)(*(unsigned char *)adr))&0xfful;
                    break;
                   case 2: val=((ulword)(*(unsigned short *)adr))&0xfffful;
                    break;
                   case 4: val=*(ulword *)adr;
                    break;
                   default:break;
                  }
                d_stack[d_sc++]=val;
               }
           break;
      case 'Z':
#ifndef NOCHECK
               if(d_sc<1){err_uflow();return 0;}
#endif
               pokesize=d_stack[--d_sc];
           break;

      case 'V':
#ifndef NOCHECK
               if(d_sc<2){err_uflow(); return 0;}
#endif
               d_stack[d_sc-2]+=4*d_stack[d_sc-1];d_sc--;
           break;

//-

      default:{fprintf(stderr,">>%c<< not implemented!\n",kw);valid=0;return 0;}
     }
return valid;
}

//-

//+ "int Y_program::do_sta(const char kw)"

#ifdef NOCHECK
int Y_program::do_staN(const char kw)
#else
int Y_program::do_sta(const char kw)
#endif
{
switch(kw)
     {

//+ "    Stack manipulators @$\%N"

      case '@':
#ifndef NOCHECK
               if(d_sc<3){err_uflow();return 0;}
#endif
               {ulword a;
                a=d_stack[d_sc-3];
                d_stack[d_sc-3]=d_stack[d_sc-2];
                d_stack[d_sc-2]=d_stack[d_sc-1];
                d_stack[d_sc-1]=a;
               }
           break;
      case '$':
#ifndef NOCHECK
               if(d_sc<1){err_uflow();return 0;}
#endif
#ifndef NOCHECK
               if(d_sc>dsize){err_oflow();return 0;}
#endif
               d_stack[d_sc]=d_stack[d_sc-1];d_sc++;
           break;
      case '\\':
#ifndef NOCHECK
               if(d_sc<2){err_uflow();return 0;}
#endif
               {ulword a;
                a=d_stack[d_sc-1];
                d_stack[d_sc-1]=d_stack[d_sc-2];
                d_stack[d_sc-2]=a;
               }
           break;
      case '%':
#ifndef NOCHECK
               if(d_sc<1){err_uflow();return 0;}
#endif
               --d_sc;
           break;
      case 'N':                    // copy n-th to top
#ifndef NOCHECK
               if(d_sc<2){err_uflow();return 0;}
#endif
               {ulword n;
                n=d_stack[--d_sc];
#ifndef NOCHECK
                if(d_sc<n+1){err_uflow();return 0;}
#endif
                n=d_stack[d_sc-n-1];
                d_stack[d_sc++]=n;
               }
           break;

//-

      default:{fprintf(stderr,">>%c<< not implemented!\n",kw);valid=0;return 0;}
     }
return valid;
}

//-


#ifdef YPAGE_0

//+ "int Y_program::do_base_pag(const char kw)"

#ifdef NOCHECK
int Y_program::do_base_pagN(const char kw)
#else
int Y_program::do_base_pag(const char kw)
#endif
{
switch(kw)
     {

//+ "    File management & I/O  OCRWETLSGPI"

//  O Open - C Close - R Read - W Write - E EOF - T FTELL - L flushBuffer
//  S Seek - G getc - P putc - I "input" - fgets

      case 'O':              // No arg error checking - a Y user has to know what he's doing!
#ifndef NOCHECK
               if(d_sc<2){err_uflow();return 0;}
#endif
               {ulword fname,fmode;
                static char* modes[]={"r","w","rw","a"};
                fname=d_stack[d_sc-2];
                fmode=d_stack[d_sc-1];
                d_sc-=1;
                d_stack[d_sc-1]=(ulword)fopen((char *)fname,modes[fmode]);
               }
           break;

      case 'C':
#ifndef NOCHECK
               if(d_sc<1){err_uflow();return 0;}
#endif
               fclose((FILE *)(d_stack[--d_sc]));
           break;
      case 'R':
#ifndef NOCHECK
               if(d_sc<3){err_uflow();return 0;}
#endif
               {ulword fhandle,buffer,len;
                len=d_stack[--d_sc];
                buffer=d_stack[--d_sc];
                fhandle=d_stack[--d_sc];
                d_stack[d_sc++]=(ulword)fread((char *)buffer,1,(unsigned int)len,(FILE *)fhandle);
               }
           break;
      case 'W':
#ifndef NOCHECK
               if(d_sc<3){err_uflow();return 0;}
#endif
               {ulword fhandle,buffer,len;
                len=d_stack[--d_sc];
                buffer=d_stack[--d_sc];
                fhandle=d_stack[--d_sc];
                d_stack[d_sc++]=(ulword)fwrite((char *)buffer,1,(unsigned int)len,(FILE *)fhandle);
               }
           break;
      case 'E':
#ifndef NOCHECK
               if(d_sc<1){err_uflow();return 0;}
#endif
               d_stack[d_sc-1]=feof((FILE *)d_stack[d_sc-1])?1:0;
           break;
      case 'T':
#ifndef NOCHECK
               if(d_sc<1){err_uflow();return 0;}
#endif
               d_stack[d_sc-1]=ftell((FILE *)d_stack[d_sc-1]);
           break;
      case 'S':
#ifndef NOCHECK
               if(d_sc<3){err_uflow();return 0;}
#endif
               {ulword fhandle,fpos,mode,fmode;
                mode=d_stack[--d_sc];
                fpos=d_stack[--d_sc];
                fhandle=d_stack[--d_sc];
                fmode=(mode==0)?SEEK_SET:(mode==1)?SEEK_CUR:SEEK_END;
                d_stack[d_sc++]=fseek((FILE *)fhandle,(int)fpos,(int)fmode)?1:0;
               }
           break;
      case 'L':
#ifndef NOCHECK
               if(d_sc<1){err_uflow();return 0;}
#endif
               fflush((FILE *)(d_stack[--d_sc]));
           break;
      case 'G':
#ifndef NOCHECK
               if(d_sc<1){err_uflow();return 0;}
#endif
               d_stack[d_sc-1]=fgetc((FILE *)d_stack[d_sc-1]);
           break;
      case 'P':
#ifndef NOCHECK
               if(d_sc<2){err_uflow();return 0;}
#endif
               d_stack[d_sc-2]=fputc((int)d_stack[d_sc-1],(FILE *)d_stack[d_sc-2]);
               d_sc--;
           break;
      case 'I':
#ifndef NOCHECK
               if(d_sc<3){err_uflow();return 0;}
#endif
               d_stack[d_sc-3]=(ulword)            // FILE BUFFER SIZE
                               (fgets((char *)(d_stack[d_sc-2]),
                                      (int)(d_stack[d_sc-1]),
                                      (FILE *)(d_stack[d_sc-3])
                                     )?1:0);
               d_sc-=2;
           break;

//-

//+ "    Other stuff DKQU"

// D Dice - K Kommandline - U Unixtime
      case 'D':
#ifndef NOCHECK
               if(d_sc<1){err_uflow();return 0;}
#endif
               {lword param;
                param=(lword)d_stack[--d_sc];
                if(param==0)srand((time(0)));    // randomize timer
                else if(param<0)srand((unsigned int)(-param));   // randomize number
                else if(param==1)d_stack[d_sc++]=rand();
                else d_stack[d_sc++]=rand()%param+1;
               }
           break;
      case 'K':
#ifndef NOCHECK
               if(d_sc<1){err_uflow();return 0;}
#endif
               d_stack[d_sc-1]=(ulword)system((char *)d_stack[d_sc-1]);
           break;
      case 'U':
#ifndef NOCHECK
               if(d_sc>dsize){err_oflow(); return 0;}
#endif
               d_stack[d_sc++]=(ulword)time(0);
           break;

//-

//+ "    Memory management AF "

//  A Calloc F Free
      case 'A':
#ifndef NOCHECK
               if(d_sc<1){err_uflow();return 0;}
#endif
               {ulword siz=d_stack[--d_sc];
                d_stack[d_sc++]=(ulword)calloc((unsigned int)siz,1);
               }
           break;
      case 'F':
#ifndef NOCHECK
               if(d_sc<1){err_uflow();return 0;}
#endif
               free((void *)d_stack[--d_sc]);
           break;

//-

      default:{fprintf(stderr,">>%c<< not implemented!\n",kw);valid=0;return 0;}
     }
return valid;
}

//-



//+ "int Y_program::do_int_ari(const char kw)"

#ifdef NOCHECK
int Y_program::do_int_ariN(const char kw)
#else
int Y_program::do_int_ari(const char kw)
#endif
{
switch(kw)
     {
//+ "    Arithmetics /M+-*_"

      case '+':
#ifndef NOCHECK
               if(d_sc<2){err_uflow();return 0;}
#endif
               d_stack[d_sc-2]=d_stack[d_sc-2]+d_stack[d_sc-1];d_sc--;
           break;
      case '-':
#ifndef NOCHECK
               if(d_sc<2){err_uflow();return 0;}
#endif
               d_stack[d_sc-2]=d_stack[d_sc-2]-d_stack[d_sc-1];d_sc--;
           break;
      case '*':
#ifndef NOCHECK
               if(d_sc<2){err_uflow();return 0;}
#endif
               d_stack[d_sc-2]=d_stack[d_sc-2]*d_stack[d_sc-1];d_sc--;
           break;
      case '/':
#ifndef NOCHECK
               if(d_sc<2){err_uflow();return 0;}
#endif
               if(d_stack[d_sc-1]==0)
                 {fprintf(stderr,"DIVISION BY ZERO!\n");valid=0;return 0;}
               d_stack[d_sc-2]=d_stack[d_sc-2]/d_stack[d_sc-1];d_sc--;
           break;
      case 'M':
#ifndef NOCHECK
               if(d_sc<2){err_uflow();return 0;}
#endif
               if(d_stack[d_sc-1]==0)
                 {fprintf(stderr,"DIVISION BY ZERO!\n");valid=0;return 0;}
               d_stack[d_sc-2]=d_stack[d_sc-2]%d_stack[d_sc-1];d_sc--;
           break;
      case '_':                                     // unary minus
#ifndef NOCHECK
               if(d_sc<1){err_uflow();return 0;}
#endif
               d_stack[d_sc-1]=-d_stack[d_sc-1];
           break;
//-

      default:{fprintf(stderr,">>%c<< not implemented!\n",kw);valid=0;return 0;}
     }
return valid;
}

//-

//+ "int Y_program::do_int_bin(const char kw)"

#ifdef NOCHECK
int Y_program::do_int_binN(const char kw)
#else
int Y_program::do_int_bin(const char kw)
#endif
{
switch(kw)
     {
//+ "    Binary |&~"

      case '|':
#ifndef NOCHECK
               if(d_sc<2){err_uflow();return 0;}
#endif
               d_stack[d_sc-2]=(d_stack[d_sc-2]|d_stack[d_sc-1]);d_sc--;
           break;
      case '&':
#ifndef NOCHECK
               if(d_sc<2){err_uflow();return 0;}
#endif
               d_stack[d_sc-2]=(d_stack[d_sc-2]&d_stack[d_sc-1]);d_sc--;
           break;
      case '~':                                     // binary NOT
#ifndef NOCHECK
               if(d_sc<1){err_uflow();return 0;}
#endif
               d_stack[d_sc-1]=d_stack[d_sc-1]?0:1;
           break;

//-

      default:{fprintf(stderr,">>%c<< not implemented!\n",kw);valid=0;return 0;}
     }
return valid;
}

//-

//+ "int Y_program::do_int_cmp(const char kw)"

#ifdef NOCHECK
int Y_program::do_int_cmpN(const char kw)
#else
int Y_program::do_int_cmp(const char kw)
#endif
{
switch(kw)
     {

//+ "    Comparison <>="

      case '>':
#ifndef NOCHECK
               if(d_sc<2){err_uflow();return 0;}
#endif
               d_stack[d_sc-2]=
                 ((lword)d_stack[d_sc-2])>((lword)d_stack[d_sc-1])?1:0;
               d_sc--;
           break;
      case '<':
#ifndef NOCHECK
               if(d_sc<2){err_uflow();return 0;}
#endif
               d_stack[d_sc-2]=
                 ((lword)d_stack[d_sc-2])<((lword)d_stack[d_sc-1])?1:0;
               d_sc--;
           break;
      case '=':
#ifndef NOCHECK
               if(d_sc<2){err_uflow();return 0;}
#endif
               d_stack[d_sc-2]=(d_stack[d_sc-2]==d_stack[d_sc-1])?1:0;d_sc--;
           break;
//-

      default:{fprintf(stderr,">>%c<< not implemented!\n",kw);valid=0;return 0;}
     }
return valid;
}

//-

//+ "int Y_program::do_int_sio(const char kw)"

#ifdef NOCHECK
int Y_program::do_int_sioN(const char kw)
#else
int Y_program::do_int_sio(const char kw)
#endif
{
switch(kw)
     {

//+ "    Standardin/output `,.B^"

      case '`':                                   // putstring
#ifndef NOCHECK
               if(d_sc<1){err_uflow();return 0;}
#endif
               printf("%s",d_stack[--d_sc]);
           break;
      case ',':
#ifndef NOCHECK
               if(d_sc<1){err_uflow();return 0;}
#endif
               printf("%c",d_stack[--d_sc]);
           break;
      case '.':
#ifndef NOCHECK
               if(d_sc<1){err_uflow();return 0;}
#endif
               printf("%ld",d_stack[--d_sc]);
           break;
      case 'B':                                  // stdout flush
               fflush(stdout);
           break;

      case '^':
#ifndef NOCHECK
               if(d_sc>dsize){err_oflow();return 0;}
#endif
               {ulword cc;cc=getchar();
                d_stack[d_sc++]=cc;
               }
           break;

//-


      default:{fprintf(stderr,">>%c<< not implemented!\n",kw);valid=0;return 0;}
     }
return valid;
}

//-

#endif


#ifdef YPAGE_2

//+ "int Y_program::do_float_pag(const char kw)"

#ifdef NOCHECK
int Y_program::do_float_pagN(const char kw)
#else
int Y_program::do_float_pag(const char kw)
#endif
{
switch(kw)
     {

//+ "    float/Int conversion FI"

      case 'F':
#ifndef NOCHECK
               if(d_sc<1){err_uflow();return 0;}
#endif
               (((float *)d_stack))[d_sc-1]=(float)d_stack[d_sc-1];
           break;
      case 'I':
#ifndef NOCHECK
               if(d_sc<1){err_uflow();return 0;}
#endif
               d_stack[d_sc-1]=(lword)((((float *)d_stack))[d_sc-1]);
           break;

//-

//+ "    Functions RSCTEPALDBG"

      case 'R':
#ifndef NOCHECK
               if(d_sc<1){err_uflow();return 0;}
#endif
               (((float *)d_stack))[d_sc-1]=(float)sqrt((((float *)d_stack))[d_sc-1]);
           break;
      case 'S':
#ifndef NOCHECK
               if(d_sc<1){err_uflow();return 0;}
#endif
               (((float *)d_stack))[d_sc-1]=(float)sin((((float *)d_stack))[d_sc-1]);
           break;
      case 'C':
#ifndef NOCHECK
               if(d_sc<1){err_uflow();return 0;}
#endif
               (((float *)d_stack))[d_sc-1]=(float)cos((((float *)d_stack))[d_sc-1]);
           break;
      case 'T':                       // tangens without range checking!
#ifndef NOCHECK
               if(d_sc<1){err_uflow();return 0;}
#endif
               (((float *)d_stack))[d_sc-1]=(float)tan((((float *)d_stack))[d_sc-1]);
           break;
      case 'E':
#ifndef NOCHECK
               if(d_sc<1){err_uflow();return 0;}
#endif
               (((float *)d_stack))[d_sc-1]=(float)exp((((float *)d_stack))[d_sc-1]);
           break;
      case 'A':
#ifndef NOCHECK
               if(d_sc<1){err_uflow();return 0;}
#endif
               (((float *)d_stack))[d_sc-1]=(float)atan((((float *)d_stack))[d_sc-1]);
           break;
      case 'L':
#ifndef NOCHECK
               if(d_sc<1){err_uflow();return 0;}
#endif
               (((float *)d_stack))[d_sc-1]=(float)log((((float *)d_stack))[d_sc-1]);
           break;
      case 'D':
#ifndef NOCHECK
               if(d_sc<1){err_uflow();return 0;}
#endif
               (((float *)d_stack))[d_sc-1]=(float)(float)log10((((float *)d_stack))[d_sc-1]);
           break;
      case 'G':
#ifndef NOCHECK
               if(d_sc<1){err_uflow();return 0;}
#endif
               {
                static float E=(float)exp(1.0);
                float n,y;
                n=(((float *)d_stack))[d_sc-1];
                y=(float)(pow(n/E,n)*sqrt(2*PI*n)*(1.0+1.0/(12.0*n)+1.0/(288.0*n*n)));
                (((float *)d_stack))[d_sc-1]=y;
               }
           break;
      case 'P':
#ifndef NOCHECK
               if(d_sc<2){err_uflow();return 0;}
#endif
               (((float *)d_stack))[d_sc-2]=(float)pow((((float *)d_stack))[d_sc-2],(((float *)d_stack))[d_sc-1]);d_sc--;
           break;


//-

//+ "    Set Comparison tolerance H"
      case 'H':
#ifndef NOCHECK
               if(d_sc<1){err_uflow();return 0;}
#endif
               fcomparetolerance=(((float *)d_stack))[d_sc-1];
           break;
//-

      default:{fprintf(stderr,">>%c<< not implemented!\n",kw);valid=0;return 0;}
     }
return valid;
}

//-


//+ "int Y_program::do_float_ari(const char kw)"

#ifdef NOCHECK
int Y_program::do_float_ariN(const char kw)
#else
int Y_program::do_float_ari(const char kw)
#endif
{
switch(kw)
     {

//+ "    Arithmetics /M+-*_"

      case '+':
#ifndef NOCHECK
               if(d_sc<2){err_uflow();return 0;}
#endif
               (((float *)d_stack))[d_sc-2]=(((float *)d_stack))[d_sc-2]+(((float *)d_stack))[d_sc-1];d_sc--;
           break;
      case '-':
#ifndef NOCHECK
               if(d_sc<2){err_uflow();return 0;}
#endif
               (((float *)d_stack))[d_sc-2]=(((float *)d_stack))[d_sc-2]-(((float *)d_stack))[d_sc-1];d_sc--;
           break;
      case '*':
#ifndef NOCHECK
               if(d_sc<2){err_uflow();return 0;}
#endif
               (((float *)d_stack))[d_sc-2]=(((float *)d_stack))[d_sc-2]*(((float *)d_stack))[d_sc-1];d_sc--;
           break;
      case '/':
#ifndef NOCHECK
               if(d_sc<2){err_uflow();return 0;}
#endif
               if((((float *)d_stack))[d_sc-1]==0)
                 {fprintf(stderr,"DIVISION BY ZERO!\n");valid=0;return 0;}
               (((float *)d_stack))[d_sc-2]=(((float *)d_stack))[d_sc-2]/(((float *)d_stack))[d_sc-1];d_sc--;
           break;
      case 'M':
#ifndef NOCHECK
               if(d_sc<2){err_uflow();return 0;}
#endif
               if((((float *)d_stack))[d_sc-1]==0)
                 {fprintf(stderr,"DIVISION BY ZERO!\n");valid=0;return 0;}
                 (((float *)d_stack))[d_sc-2]=(float)fmod((((float *)d_stack))[d_sc-2],(((float *)d_stack))[d_sc-1]);d_sc--;
           break;
      case '_':                                     // unary minus
#ifndef NOCHECK
               if(d_sc<1){err_uflow();return 0;}
#endif
               (((float *)d_stack))[d_sc-1]=-(((float *)d_stack))[d_sc-1];
           break;


//-

      default:{fprintf(stderr,">>%c<< not implemented!\n",kw);valid=0;return 0;}
     }
return valid;
}

//-

//+ "int Y_program::do_float_cmp(const char kw)"

#ifdef NOCHECK
int Y_program::do_float_cmpN(const char kw)
#else
int Y_program::do_float_cmp(const char kw)
#endif
{
switch(kw)
     {

//+ "    Comparison <>="

      case '>':
#ifndef NOCHECK
               if(d_sc<2){err_uflow();return 0;}
#endif
               d_stack[d_sc-2]=
                 ((((float *)d_stack))[d_sc-2])>((((float *)d_stack))[d_sc-1])?1:0;
               d_sc--;
           break;
      case '<':
#ifndef NOCHECK
               if(d_sc<2){err_uflow();return 0;}
#endif
               d_stack[d_sc-2]=
                 ((((float *)d_stack))[d_sc-2])<((((float *)d_stack))[d_sc-1])?1:0;
               d_sc--;
           break;
      case '=':
#ifndef NOCHECK
               if(d_sc<2){err_uflow();return 0;}
#endif
               d_stack[d_sc-2]=
                 fabs(((((float *)d_stack))[d_sc-2])-((((float *)d_stack))[d_sc-1]))<fcomparetolerance?1:0;
               d_sc--;
           break;
//-

      default:{fprintf(stderr,">>%c<< not implemented!\n",kw);valid=0;return 0;}
     }
return valid;
}

//-

//+ "int Y_program::do_float_sio(const char kw)"

#ifdef NOCHECK
int Y_program::do_float_sioN(const char kw)
#else
int Y_program::do_float_sio(const char kw)
#endif
{
switch(kw)
     {
//+ "    Standardin/output `,.B^"

      case '`':                                   // putstring
#ifndef NOCHECK
               if(d_sc<1){err_uflow();return 0;}
#endif
               printf("%s",d_stack[--d_sc]);
           break;
      case ',':
#ifndef NOCHECK
               if(d_sc<1){err_uflow();return 0;}
#endif
               printf("%c",d_stack[--d_sc]);
           break;
      case '.':
#ifndef NOCHECK
               if(d_sc<1){err_uflow();return 0;}
#endif
               printf("%f",((float *)d_stack)[--d_sc]);
           break;
      case 'B':                                  // stdout flush
               fflush(stdout);
           break;

      case '^':
#ifndef NOCHECK
               if(d_sc>dsize){err_oflow();return 0;}
#endif
               {float ff;scanf("%f",&ff);
                (((float *)d_stack))[d_sc++]=ff;
               }
           break;

//-

      default:{fprintf(stderr,">>%c<< not implemented!\n",kw);valid=0;return 0;}
     }
return valid;
}

//-

#endif


