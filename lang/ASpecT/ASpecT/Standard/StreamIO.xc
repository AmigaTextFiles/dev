#include <stdio.h>
#ifdef NEED_STD_DECL
 extern void EXFUN(free,(char *));
 extern void EXFUN(exit,(unsigned));
#endif

#define BufferMax 255

/*
 Structure of inStream-cells


 stdin-inStream
   Type 0:     0- number of chars read so far           numchars
               1- pointer to buffer                     inStream
               2- index into buffer                     bufIndex


 string-inStream
   Type 1:     0- number of chars read so far           numchars
               1- the string                            theString

 file-inStream
   Type 2:     0- number of chars read so far           numchars
               1- pointer to buffer                     inStream
               2- index into buffer                     bufIndex
               3- pointer to cell with filehandle       file_cell, filehand
 
 special-inStream
   Type 99:    0- number of chars read so far           numchars
               1- the function                          theFunct
               2- running value                         runValue
               3- sortrec of running value              SortValue


 Structure of outStream-cells
                - pointer to the first cell (no-rc)     os_first
                - pointer to the next cell              os_next
                - pointer to the buffer (next invalid)  os_buffer
                - number of chars written so far        os_chars


*/

#define numchars(A)  ((unsigned) (A)->ARGS[0])
#define inStream(A)  ((Stream)   (A)->ARGS[1])
#define theString(A) (           (A)->ARGS[1])
#define theFunct(A)  (           (A)->ARGS[1])
#define bufIndex(A)  ((unsigned) (A)->ARGS[2])
#define runValue(A)  (           (A)->ARGS[2])
#define file_cell(A) (           (A)->ARGS[3])
#define SortValue(A) ((SORTREC)  (A)->ARGS[3])
#define filehand(A)  (FILE *)file_cell(A)->ARGS[0]

#define os_first(A)  (           (A)->ARGS[0])
#define os_next(A)   (           (A)->ARGS[1])
#define os_buffer(A) ((Stream)   (A)->ARGS[2])
#define os_chars(A)  ((unsigned) (A)->ARGS[3])

#define incchars(A)    numchars(A)=(TERM)(numchars(A)+1)
#define os_incchars(A) os_chars(A)=(TERM)(os_chars(A)+1)

typedef struct StreamRec *Stream;
struct StreamRec { Stream   next;
                   unsigned chars;
                   unsigned refcount;
                   char     buffer[1];
                 };
#define StreamSize sizeof(Stream)+2*sizeof(unsigned)+(BufferMax+1)*sizeof(char)
   /* one char greater as needed since conversion of outStream to string
      needs a null-termination.
    */




static unsigned CopiesOfInStream = 0;  
static unsigned CharsOnOutStream = 0;  
static unsigned COPY_stdout_DOUT = 0;

XCOPY(xcopy_StreamIO_inStream)
{
   if (A==(TERM)0) return A;
   switch(OPN(A)) {
    case 0:
      if (inStream(A)==NULL) {
        inStream(A) = (Stream)malloc(StreamSize);
        inStream(A)->next     = NULL;
        inStream(A)->refcount = 1;
        inStream(A)->chars    = 0;
      }
      inStream(A)->refcount++;
      CopiesOfInStream++;
      return MKxx3(0,(TERM)numchars(A),(TERM)inStream(A),(TERM)bufIndex(A));
      break;
    case 1:
      return MKxx2(1,(TERM)numchars(A),copy__RUNTIME_string(theString(A)));
      break;
    case 2:
      if (inStream(A)==NULL) {
        inStream(A) = (Stream)malloc(StreamSize);
        inStream(A)->next     = NULL;
        inStream(A)->refcount = 1;
        inStream(A)->chars    = 0;
      }
      inStream(A)->refcount++;
      return MK(4,2,(TERM)numchars(A),(TERM)inStream(A),(TERM)bufIndex(A),
                    CP(file_cell(A)));
      break;
    case 99:
      return MK(4,99,(TERM)numchars(A),
                      copy_CLOSURE(theFunct(A)),COPY(SortValue(A),runValue(A)),
                      (TERM) SortValue(A));
      break;
   }
}


    static void DEFUN(free_streambuf,(In),Stream In)
    {
       if (In==NULL) return;
       In->refcount--;
       if (In->refcount == 0) {
         free_streambuf(In->next);
         free((char *)In);
       }
    }


XFREE(xfree_StreamIO_inStream)
{
   if (A==(TERM)0) return;
   switch(OPN(A)) {
    case 0:
      free_streambuf(inStream(A));
      MDEALLOC(3,A);
      CopiesOfInStream--;
      return;
      break;
    case 1:
      free__RUNTIME_string(theString(A));
      MDEALLOC(2,A);
      return;
      break;
    case 2:
      free_streambuf(inStream(A));
      if (DZ_REF(file_cell(A))) {
        fclose(filehand(A));
        MDEALLOC(1,file_cell(A));
      }
      MDEALLOC(4,A);
      return;
      break;
    case 99:
      free_CLOSURE(theFunct(A));
      FREE(SortValue(A),runValue(A));
      MDEALLOC(4,A);
      return;
      break;
   }
}

XEQ(x_X61_X61_StreamIO_inStream)
{
  free_StreamIO_inStream(A1);
  free_StreamIO_inStream(A2);
  return false;
}

XREAD(xread_StreamIO_inStream)
{
  *OK = false;
  *RES = A;
  *SYSO = SYSI;
}


XWRITE(xwrite_StreamIO_inStream)
{ 
  free_StreamIO_inStream(A);
  *OK = true;
  *SYSO = SYSI;
   S_OUT("\'inStream\'");
}

static void DEFUN_VOID(FATAL_USE) {
  printf("\n\n");
  printf("*** An attempt to copy an direct outstream (doutStream)\n");
  printf("*** results in a fatal program failure.\n");
  exit(255);
}


XCOPY(xcopy_StreamIO_doutStream)
{
  if (A==(TERM)0) return A;
  if (A==(TERM)1) { COPY_stdout_DOUT++; return A; }
  return CP(A);
}

XFREE(xfree_StreamIO_doutStream)
{
   if (A==(TERM)0) return;
   if (A==(TERM)1) { 
     if(COPY_stdout_DOUT == 0) {CharsOnOutStream=0; return; }
     COPY_stdout_DOUT--;
     return;
   }
   if(DZ_REF(A)) {
     fclose((FILE *)A->ARGS[0]);
     MDEALLOC(2,A);
   }
}

XEQ(x_X61_X61_StreamIO_doutStream)
{
  free_StreamIO_doutStream(A1);
  free_StreamIO_doutStream(A2);
  return false;
}

XREAD(xread_StreamIO_doutStream)
{
  *OK = false;
  *RES = A;
  *SYSO = SYSI;
}


XWRITE(xwrite_StreamIO_doutStream)
{ 
  free_StreamIO_doutStream(A);
  *OK = true;
  *SYSO = SYSI;
   S_OUT("\'doutStream\'");
}


XCOPY(xcopy_StreamIO_outStream)
{
  return CP(A);
}

XFREE(xfree_StreamIO_outStream)
{
  if (DZ_REF(A)) {
     TERM h,h2;
     h = os_first(A);
     while (h!=NULL) {
        if(os_buffer(h)!=NULL) {
          os_buffer(h)->refcount--;
          if(os_buffer(h)->refcount==0) {
            free(os_buffer(h));
          }
        }
        h2 = os_next(h);
        MDEALLOC(4,h);
        h = h2;
     }
  }
}

XEQ(x_X61_X61_StreamIO_outStream)
{
  free_StreamIO_outStream(A1);
  free_StreamIO_outStream(A2);
  return false;
}

XREAD(xread_StreamIO_outStream)
{
  *OK = false;
  *RES = A;
  *SYSO = SYSI;
}


XWRITE(xwrite_StreamIO_outStream)
{ 
  free_StreamIO_outStream(A);
  *OK = true;
  *SYSO = SYSI;
   S_OUT("\'outStream\'");
}


void DEFUN(xx_StreamIOstdin_0,(SysI,Ok,InStream,SysO),
           TERM SysI      AND
           TERM *Ok       AND
           TERM *InStream AND
           TERM *SysO)
{
   if (CopiesOfInStream) {
     *Ok = false;
     *InStream = (TERM)0;
     *SysO = SysI;
   } else { 
     *Ok = true;
     CopiesOfInStream++;
     *InStream = MKxx3(0,(TERM)0,(TERM)NULL,(TERM)0);
     *SysO = SysI;
   }
}


void DEFUN(xx_StreamIOchar_0,(InI,Ok,Ch,InO),
           TERM InI    AND
           TERM *Ok    AND
           TERM *Ch    AND
           TERM *InO)
{
   if (InI==(TERM)0) {
     /* this is not a valid inStream */
     *Ok  = false;
     *Ch  = (TERM)0;
     *InO = InI;
     return;
   }
   
   if (OPN(InI)==1) { TERM rest;
     Stringhd_2(copy__RUNTIME_string(theString(InI)),Ok,Ch,&rest);
     if (*Ok==true) {
       free__RUNTIME_string(theString(InI));
       incchars(InI);
       theString(InI)=rest;
     } else {
       free__RUNTIME_string(rest);
       free__RUNTIME_char(*Ch);
       *Ch = (TERM)0;
     }
     *InO = InI;
     return;
   }

   if (OPN(InI)==99) { TERM Int,dummy;
     dummy=
     _RUNTIMEcall_0(FALSE,4,copy_CLOSURE(theFunct(InI)),
                            runValue(InI),Ok,Ch,&Int);
     incchars(InI);
     runValue(InI) = Int;
     *InO = InI;
     return;
   }

   if (inStream(InI)==NULL) {
     /* unbuffered input */
     unsigned ch;
     if(OPN(InI)==2) ch=getc(filehand(InI));
                else ch=getc(stdin);

     if (ch == EOF) {
       /* EOF input */
       *Ok  = false;
       *Ch  = (TERM)0;
       *InO = InI;
     } else {
       *Ok  = true;
       incchars(InI);
       *Ch  = (TERM) ch;
     }
     *InO = InI;
     return;
   }
   
   /* buffered input */
   
   /* need to get a char from file ? */

   if (bufIndex(InI) == inStream(InI)->chars) {
     unsigned ch;

     if(OPN(InI)==2) ch=getc(filehand(InI));
                else ch=getc(stdin);

     if (ch == EOF) {
       *Ok  = false;
       *Ch  = (TERM)0;
       *InO = InI;
       return;
     }

     incchars(InI);

     if (inStream(InI)->refcount==1) {
       /* no buffering needed, we are exclusive */
       *Ok  = true;
       *Ch  = (TERM) ch;
       *InO = InI;
       return;
     }
     
     /* char into buffer, since we are not exclusive */

     inStream(InI)->buffer[bufIndex(InI)++]=(char)ch;
     inStream(InI)->chars++;
     if (inStream(InI)->chars == BufferMax) {
       /* this buffer is full now - generate continuation */
       inStream(InI)->next = (Stream)malloc(StreamSize);
       inStream(InI)->next->next = NULL;
       inStream(InI)->next->refcount = 2; /* one for continuation */
       inStream(InI)->next->chars = 0;
       /* ... and set InI on that */
       bufIndex(InI) = 0;
       inStream(InI)->refcount--; /* now its at least 1 */
       inStream(InI) = inStream(InI)->next;
     }
     *Ok  = true;
     *Ch  = (TERM) ch;
     *InO = InI;
     return;
   }

   /* no, we can get the char from buffer */
   
   *Ok  = true;
   *Ch  = (TERM)(int)(inStream(InI)->buffer[bufIndex(InI)++]);
   incchars(InI);
   *InO = InI;
   
   /* check if change of buffer is needed */

   if (bufIndex(InI) == BufferMax) {
     if (inStream(InI)->next != NULL) {
       Stream p = inStream(InI);
       /* switch to next buffer now */
       bufIndex(InI) = 0;
       inStream(InI) = p->next;
       inStream(InI)->refcount++;
       p->refcount--;
       if (p->refcount==0) {
         p->next->refcount--; /* now its at least 1 due InI */
         free((char *) p);
       }   
     } else {
       /* should not occur */
       printf("FATAL ERROR while handling inStream.\n");
       exit(1);
     }
   }
}

void DEFUN(xx_StreamIOopen_0,(Name,SysI,Ok,InStream,SysO),
           TERM Name      AND
           TERM SysI      AND
           TERM *Ok       AND
           TERM *InStream AND
           TERM *SysO)
{ char *FNC;
  FILE *fopen(), *fp;
  unsigned LEN=(unsigned)Stringlength_0(copy__RUNTIME_string(Name));
  FNC = (char *)malloc(LEN+1);
  if (FNC==NULL) {
    *Ok = false;
    *InStream = (TERM)0;
  } else {
    STRING_TERM_to_CHAR_ARRAY(Name,LEN,FNC);
    if ((fp=fopen(FNC,"r")) == NULL) {
      *Ok = false;
      *InStream = (TERM)0;
    } else {
      *Ok = true;
      *InStream = MK(4,2,(TERM)0,(TERM)NULL,(TERM)0,MKxx1(0,(TERM)fp));
    }
    free(FNC);
  }
  *SysO = SysI;
  free__RUNTIME_string(Name);
}


TERM DEFUN(xx_StreamIOinStream_0,(String),
           TERM String)
{  
  return MKxx2(1,(TERM)0,String);
}


TERM DEFUN(xx_StreamIOchars_0,(InStream),
           TERM InStream)
{  unsigned n=0;
   if (InStream!=(TERM)0) n = numchars(InStream);
   free_StreamIO_inStream(InStream);
   return (TERM)n;
}


static TERM
DEFUN(to_string,(Stream),TERM InStream)
{ char block[MAXSTR];
  unsigned I,J;
  TERM curr,root;
  char *DEST;
  TERM ch,ok;
  TERM firstBlock=true;

  while (TRUE) {
    for (I=0; I < MAXSTR; I++) {
      StreamIOchar_0(InStream,&ok,&ch,&InStream);
      if (ok == false) break;
      block[I] = __tchar(ch);
    }
    if (I) {
      if (I == MAXSTR) {
	if (firstBlock) {
	  root = MK_string(MAXSTR,MT);
	  curr = root;
	  firstBlock = false;
	}
	else {
	  curr->ARGS[0]=MK_string(MAXSTR,MT);
	  curr=curr->ARGS[0];
	}
	DEST = (char *) &(curr->ARGS[1]);
	for (J=0; J<MAXSTR; J++) *DEST++ = block[J];
      }
      else {
	if (firstBlock) {
	  root = MK_string(I,MT);
	  curr=root;
	}
	else {
	  curr->ARGS[0]=MK_string(I,MT);
	  curr=curr->ARGS[0];
	}
	DEST = (char *) &(curr->ARGS[1]);
	for (J=0; J<I; J++) *DEST++ = block[J];

	return root;
      }
    }
    else
      if (firstBlock) return MT;
      else return root;
  }
}



TERM DEFUN(xx_StreamIOstring_0,(InStream),
           TERM InStream)
{  TERM STR;
   if (InStream==(TERM)0) return MT;
   if (OPN(InStream) == 1) STR = copy__RUNTIME_string(theString(InStream));
   else STR = to_string(InStream);
   free_StreamIO_inStream(InStream);
   return STR;
}


void DEFUN(xx_StreamIOstdout_0,(SysI,Ok,Out,SysO),
           TERM SysI   AND
           TERM *Ok    AND
           TERM *Out   AND
           TERM *SysO)
{ 
  *SysO = SysI;
  if (CharsOnOutStream==0) {
    *Ok = true;
    *Out = (TERM)1;
    CharsOnOutStream++;
  } else {
    *Ok = false;
    *Out = (TERM)0;
  }
}


void DEFUN(xx_StreamIO_cr_ap_0,(mode,File,SysI,Ok,Out,SysO),
           char *mode  AND
           TERM File   AND
           TERM SysI   AND
           TERM *Ok    AND
           TERM *Out   AND
           TERM *SysO)
{
  char *FNC;
  FILE *fopen(), *fp;
  unsigned LEN=(unsigned)Stringlength_0(copy__RUNTIME_string(File));
  FNC = (char *)malloc(LEN+1);
  if (FNC==NULL) {
    *Ok = false;
    *Out = (TERM)0;
  } else {
    STRING_TERM_to_CHAR_ARRAY(File,LEN,FNC);
    if ((fp=fopen(FNC,mode)) == NULL) {
      *Ok = false;
      *Out = (TERM)0;
    } else {
      *Ok = true;
      *Out = MKxx2(0,(TERM)fp,(TERM)0);
    }
    free(FNC);
  }
  *SysO = SysI;
  free__RUNTIME_string(File);
}

void DEFUN(xx_StreamIOcreate_0,(File,SysI,Ok,Out,SysO),
           TERM File   AND
           TERM SysI   AND
           TERM *Ok    AND
           TERM *Out   AND
           TERM *SysO)
{
  xx_StreamIO_cr_ap_0("w",File,SysI,Ok,Out,SysO);
}


void DEFUN(xx_StreamIOappend_0,(File,SysI,Ok,Out,SysO),
           TERM File   AND
           TERM SysI   AND
           TERM *Ok    AND
           TERM *Out   AND
           TERM *SysO)
{
  xx_StreamIO_cr_ap_0("a",File,SysI,Ok,Out,SysO);
}


void DEFUN(xx_StreamIOout_0,(OutI,Char,Ok,OutO),
           TERM OutI   AND
           TERM Char   AND
           TERM *Ok    AND
           TERM *OutO)
{
  *OutO = OutI;
  if(OutI==(TERM)0) {
    *Ok = false;
    free__RUNTIME_char(Char);
    return;
  } else
  if(OutI==(TERM)1) {
    if(COPY_stdout_DOUT!=0) FATAL_USE();
    *Ok = true;
    putc(__tchar(Char),stdout);CharsOnOutStream++;
    free__RUNTIME_char(Char);
    return;
  } else {
    *Ok = true;
    if(ONE_REF(OutI)) {
     putc(__tchar(Char),(FILE *)OutI->ARGS[0]);
     OutI->ARGS[1] = (TERM)((unsigned)OutI->ARGS[1]+1);
     free__RUNTIME_char(Char);
     return;
    } else
     FATAL_USE();
  }
}


void DEFUN(xx_StreamIOout_1,(OutI,String,Ok,OutO),
           TERM OutI   AND
           TERM String AND
           TERM *Ok    AND
           TERM *OutO)
{
  *OutO = OutI;
  if(OutI==(TERM)0) {
    *Ok = false;
    free__RUNTIME_string(String);
    return;
  } else
  if(OutI==(TERM)1) { TERM H=String; unsigned I,LEN; char *SC;
    if(COPY_stdout_DOUT!=0) FATAL_USE();
    *Ok = true;
    while (LEN=OPN(H)) {
      if (LEN > MAXSTR) { SC = (char *)(H->ARGS[1]); LEN -= MAXSTR; }
      else { SC = (char *) &(H->ARGS[1]); }
      for (I=0; I < LEN; I++) { CharsOnOutStream++; putc(*SC++,stdout); }
      H = H->ARGS[0];
    }
    SC = (char *)(H->ARGS[1]);
    while (*SC) { CharsOnOutStream++; putc(*SC++,stdout); }
    free__RUNTIME_string(String);
    return;
  } else { TERM H=String; unsigned I,LEN; char *SC;
           FILE     *out = (FILE *)     OutI->ARGS[0];
           unsigned *num = (unsigned *) &(OutI->ARGS[1]);
    *Ok = true;
    if(!ONE_REF(OutI)) FATAL_USE();
    while (LEN=OPN(H)) {
      if (LEN > MAXSTR) { SC = (char *)(H->ARGS[1]); LEN -= MAXSTR; }
      else { SC = (char *) &(H->ARGS[1]); }
      for (I=0; I < LEN; I++) { *num++; putc(*SC++,out); }
      H = H->ARGS[0];
    }
    SC = (char *)(H->ARGS[1]);
    while (*SC) { *num++; putc(*SC++,out); }
    free__RUNTIME_string(String);
    return;
  }
}


TERM DEFUN(xx_StreamIOchars_1,(OutI),
           TERM OutI)
{ TERM Chars;
  if(OutI==(TERM)0) {
    Chars = (TERM)0;
  } else
  if(OutI==(TERM)1) {
    Chars = (TERM)(CharsOnOutStream-1);
  } else {
    Chars = OutI->ARGS[1];
  }
  free_StreamIO_doutStream(OutI);
  return Chars;
}


TERM DEFUN_VOID(xx_StreamIOmt_0)
{
  TERM os;
  os = MK(4,0,(TERM)0,(TERM)0,(TERM)0,(TERM)0);
  os_first(os) = os;
  return os;
}


void DEFUN(xx_StreamIOstdout_1,(OutI,SysI,Ok,SysO),
           TERM OutI   AND
           TERM SysI   AND
           TERM *Ok    AND
           TERM *SysO)
{ TERM h = os_first(OutI);
  *SysO = SysI;
  *Ok = true;
  while(h!=NULL) { unsigned i;
      if(os_buffer(h)!=NULL)
        for(i=0;i<os_buffer(h)->chars;i++)
          putc(os_buffer(h)->buffer[i],stdout);
    h = os_next(h);
  }
  free_StreamIO_outStream(OutI);
}


void DEFUN(xx_StreamIO_cr_ap_1,(mode,File,OutI,SysI,Ok,SysO),
           char *mode  AND
           TERM File   AND
           TERM OutI   AND
           TERM SysI   AND
           TERM *Ok    AND
           TERM *SysO)
{
  TERM h = os_first(OutI);
  char *FNC;
  FILE *fopen(), *fp;
  unsigned LEN=(unsigned)Stringlength_0(copy__RUNTIME_string(File));
  FNC = (char *)malloc(LEN+1);
  if (FNC==NULL) {
    *Ok = false;
  } else {
    STRING_TERM_to_CHAR_ARRAY(File,LEN,FNC);
    if ((fp=fopen(FNC,mode)) == NULL) {
      *Ok = false;
    } else {
      *Ok = true;
    }
    free(FNC);
  }
  *SysO = SysI;
  free__RUNTIME_string(File);
  if (*Ok == true) {
    while(h!=NULL) { unsigned i;
      if(os_buffer(h)!=NULL)
        for(i=0;i<os_buffer(h)->chars;i++)
          putc(os_buffer(h)->buffer[i],stdout);
      h = os_next(h);
    }
    fclose(fp);
  }
  free_StreamIO_outStream(OutI);
}


void DEFUN(xx_StreamIOcreate_1,(File,OutI,SysI,Ok,SysO),
           TERM File   AND
           TERM OutI   AND
           TERM SysI   AND
           TERM *Ok    AND
           TERM *SysO)
{
  xx_StreamIO_cr_ap_1("w",File,OutI,SysI,Ok,SysO);
}


void DEFUN(xx_StreamIOappend_1,(File,OutI,SysI,Ok,SysO),
           TERM File   AND
           TERM OutI   AND
           TERM SysI   AND
           TERM *Ok    AND
           TERM *SysO)
{
  xx_StreamIO_cr_ap_1("a",File,OutI,SysI,Ok,SysO);
}


TERM DEFUN(xx_StreamIOstring_1,(OutI),
           TERM OutI)
{
  TERM h = os_first(OutI);
  TERM str=NULL,tmp=NULL;
  while(h!=NULL) { unsigned i;
      if(os_buffer(h)!=NULL) {
        os_buffer(h)->buffer[os_buffer(h)->chars]=(char)0;
        if(str==NULL) { 
           str = _RUNTIME_mk0STRING(os_buffer(h)->buffer);
        } else {
           tmp = _RUNTIME_mk0STRING(os_buffer(h)->buffer);
           str = String_X43_X43_0(str,tmp);
        }
      }
      h = os_next(h);
  }
  free_StreamIO_outStream(OutI);
  return str;
}


TERM static DEFUN(make_copy,(Out),TERM Out)
{
   TERM new, h=os_first(Out);
   new = MK(4,0,(TERM)0,(TERM)0,os_buffer(h),os_chars(h));
   os_first(new) = new;
   if(os_buffer(new)!=NULL) os_buffer(new)->refcount++;
   while(h!=Out) { TERM c;
     h=os_next(h);
     c = MK(4,0,os_first(new),(TERM)0,os_buffer(h),os_chars(h));
     os_next(new) = c;
     new = c;
     if(os_buffer(new)!=NULL) os_buffer(new)->refcount++;
   }
   if(os_buffer(new)!=NULL)
     if(os_buffer(new)->chars != BufferMax) { unsigned i;
       /* copy this buffer physically */
       os_buffer(new)->refcount--;
       os_buffer(new) = (Stream)malloc(StreamSize);
       os_buffer(new)->next     = NULL;
       os_buffer(new)->refcount = 1;
       os_buffer(new)->chars    = os_buffer(Out)->chars;
       for(i=0;i<os_buffer(new)->chars;i++)
          os_buffer(new)->buffer[i] = os_buffer(Out)->buffer[i];
   }
   return new;
}


void DEFUN(xx_StreamIOout_2,(OutI,Char,Ok,OutO),
           TERM OutI   AND
           TERM Char   AND
           TERM *Ok    AND
           TERM *OutO)
{
   if(!(ONE_REF(OutI))) { /* we are not exclusive so we've to copy */
     free_StreamIO_outStream(OutI);
     *OutO = make_copy(OutI);
   } else {
     *OutO = OutI;
   }
   if(os_buffer(*OutO)==NULL) { /* no buffer yet. allocate! */
     if((os_buffer(*OutO) = (Stream)malloc(StreamSize))==NULL) {
       *Ok = false;
       return;
     }
     os_buffer(*OutO)->next     = NULL;
     os_buffer(*OutO)->refcount = 1;
     os_buffer(*OutO)->chars    = 0;
   }
   if(os_buffer(*OutO)->chars==BufferMax) { /* the buffer is full */
     TERM c;
     c = MK(4,0,os_first(*OutO),(TERM)0,(TERM)0,os_chars(*OutO));
     os_next(*OutO) = c;
     *OutO = c;
     if((os_buffer(*OutO) = (Stream)malloc(StreamSize))==NULL) {
       *Ok = false;
       return;
     }
     os_buffer(*OutO)->next     = NULL;
     os_buffer(*OutO)->refcount = 1;
     os_buffer(*OutO)->chars    = 0;
   }
   *Ok = true;
   os_incchars(*OutO);
   os_buffer(*OutO)->buffer[os_buffer(*OutO)->chars++] = __tchar(Char);
}


void DEFUN(xx_StreamIOout_3,(OutI,String,Ok,OutO),
           TERM OutI   AND
           TERM String AND
           TERM *Ok    AND
           TERM *OutO)
{
  TERM H=String; unsigned I,LEN; char *SC;
  *Ok = true;
  while (LEN=OPN(H)) {
      if (LEN > MAXSTR) { SC = (char *)(H->ARGS[1]); LEN -= MAXSTR; }
      else { SC = (char *) &(H->ARGS[1]); }
      for (I=0; I < LEN; I++) {
          StreamIOout_2(OutI,(TERM)(unsigned)*SC++,Ok,OutO);
          if (*Ok==false) { free__RUNTIME_string(String); return; }
          OutI = *OutO;
      }
      H = H->ARGS[0];
  }
  SC = (char *)(H->ARGS[1]);
  while (*SC) {
          StreamIOout_2(OutI,(TERM)(unsigned)*SC++,Ok,OutO);
          if (*Ok==false) { free__RUNTIME_string(String); return; }
          OutI = *OutO;
  }
  free__RUNTIME_string(String);
  return;
}
 

TERM DEFUN(xx_StreamIOchars_2,(OutI),
           TERM OutI)
{
  TERM n = (TERM) os_chars(OutI);
  free_StreamIO_outStream(OutI);
  return n;
}


XINITIALIZE(StreamIO_Xinitialize,__XINIT_StreamIO)


#undef BufferMax
#undef StreamSize
#undef numchars
#undef inStream
#undef theString
#undef theFunct
#undef bufIndex
#undef runValue
#undef file_cell
#undef filehand
#undef os_first
#undef os_next
#undef os_buffer
#undef os_chars

#undef incchars
#undef os_incchars

