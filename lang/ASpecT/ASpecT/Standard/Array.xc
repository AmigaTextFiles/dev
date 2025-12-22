/* Repraesentation:
   array <- array(integer,codoms,dummy) ; is(integer,codom,array).
   codoms <- [codom,..,codom].
*/

#define array(N,A,D) MKxx3(0,N,A,D)
#define is(N,DD,A) MKxx3(1,N,DD,A)
#define array_malloc(N)  (TERM) malloc( (((unsigned)N)+1) * sizeof(TERM))
#define alloc_array(VAR,N)  if ((int)N < 0        ) goto FAIL;\
                            if ((int)N > BLKSIZE-1) goto FAIL;\
                            if (!(VAR=array_malloc(N)) ) goto FAIL
#define a_size(A) (unsigned)A->ARGS[0]
#define REGISTER register

static unsigned EXFUN(size,(TERM));
static void EXFUN(value,(SORTREC,TERM,TERM,TERM,TERM *,TERM *,INSTREC));

XCOPY(xcopy_Array_array)
{ return CP(A);
}

XFREE(xfree_Array_array)
{ REGISTER unsigned i=0;
  REGISTER unsigned j;
  REGISTER SORTREC  DATA=Array_arrayArray_codom(S);  
#ifdef NEED_STD_DECL
  extern void EXFUN(free,(TERM));
#endif
  if (DZ_REF(A)) {
    if (OPN(A)) { /* is(..) */
      FREE(DATA,A->ARGS[1]);  
      xfree_Array_array(S,A->ARGS[2]);
    }
    else
      if ((j=a_size(A)) > 0) { /* array(..) */ 
        while (i<j) FREE(DATA,A->ARGS[1]->ARGS[i++]);  
      free(A->ARGS[1]);
    }
    MDEALLOC(3,A); 
  }
}

XEQ(x_X61_X61_Array_array)
{ REGISTER TERM     RES;
           TERM     OK;
           TERM     DD;
           TERM     DD1;
  REGISTER unsigned i=0;
  REGISTER unsigned N=size(A1);
   
  if (N != size(A2)) RES=false;
  else {
    RES = true;
    while (i < N) {
      value(S,(TERM)i,  (TERM)0,xcopy_Array_array(S,A1),&OK,&DD, (INSTREC)0);
      value(S,(TERM)i++,(TERM)0,xcopy_Array_array(S,A2),&OK,&DD1,(INSTREC)0);
      if (!_RUNTIME_EQ(Array_arrayArray_codom(S),DD,DD1)) {
        RES = false;
        break;
      }
    }
  }
   
  xfree_Array_array(S,A1);
  xfree_Array_array(S,A2);
  return RES;  
}

XREAD(xread_Array_array)
{          TERM     N;
  REGISTER TERM     TMP;
  REGISTER SORTREC  DATA=Array_arrayArray_codom(S);
  REGISTER unsigned I;
  REGISTER unsigned J = 1;
           unsigned K;
  extern char * EXFUN(malloc,(unsigned));
  extern int    EXFUN(strcmp,(CONST char *,CONST char *));
#ifdef NEED_STD_DECL
  extern void   EXFUN(free,(TERM));
#endif
  *SYSO = SYSI;
  if (!READ_IDENTIFIER()) goto FAIL;
  if (strcmp(ID,"array")) goto FAIL;
  if (!READ_LP())         goto FAIL;
  read__RUNTIME_integer((TERM)0,SYSI,OK,&N,SYSO); 
  if (!(unsigned)*OK) goto FAIL;
  alloc_array(TMP,N);
  for (I=0; I<(unsigned)N;) { FOURBYTES FPOS;
    if (!READ_COMMA()) goto FAIL0;
    FPOS=mark_POS();
    EAT_WHITESPACE();
    if (LAST_CH == '{') { /* {n,codom} */
      drop_POS(FPOS);
      read__RUNTIME_integer((TERM)0,SYSI,OK,(TERM *)&K,SYSO); 
      if (!READ_COMMA()) goto FAIL0;
      _RUNTIME_READ(DATA,(TERM)0,SYSI,OK,&(TMP->ARGS[I]),SYSO);
      if (!(unsigned)*OK) goto FAIL0;
      J=1; while (J<K) TMP->ARGS[I+(J++)] = COPY(DATA,TMP->ARGS[I]);
      I += K;
      EAT_WHITESPACE();
      if (LAST_CH != '}') goto FAIL0;
    } else {
      to_POS(FPOS);
      _RUNTIME_READ(DATA,(TERM)0,SYSI,OK,&(TMP->ARGS[I]),SYSO);
      if (!(unsigned)*OK) goto FAIL0;
      else I++;
    }
  }
  if (!READ_RP()) {
    if ((unsigned) N > 0)
      goto FAIL0;
    else
      goto FAIL;
  }
  *OK=true;
  *RES = array(N,TMP,MT);
  if (A) xfree_Array_array(S,A);
  return;
  
FAIL0:
  J=0; while(J<I) FREE(DATA,TMP->ARGS[J++]);
  free(TMP);

FAIL:
  *OK = false;
  *RES = A;
}


XWRITE(xwrite_Array_array)
{ SORTREC DATA=Array_arrayArray_codom(S);
  unsigned I;
  unsigned N=size(A);
  unsigned J=1; 
  TERM     DD;
  TERM     DD1;
  
  S_OUT("array(");
  write__RUNTIME_integer((TERM)N,SYSI,OK,SYSO);
  for (I=0; I <= N; I++) {
    if (I < N)
      value(S,(TERM)I,(TERM)0,xcopy_Array_array(S,A),OK,&DD1,(INSTREC)0);
    if (I) {
      if (I < N && _RUNTIME_EQ(DATA,COPY(DATA,DD),COPY(DATA,DD1))) {
        J++;
        FREE(DATA,DD1);
      }
      else {
        C_OUT(',');
        if (J > 1) {
          C_OUT('{');
          write__RUNTIME_integer((TERM)J,SYSI,OK,SYSO);
          C_OUT(',');
          _RUNTIME_WRITE(DATA,DD,SYSI,OK,SYSO);
          C_OUT('}');
          J=1;
        }
        else 
          _RUNTIME_WRITE(DATA,DD,SYSI,OK,SYSO);
        DD=DD1;
      }
    }
    else DD=DD1;
  }
  C_OUT(')');
  xfree_Array_array(S,A);
}


/* maxsize -> integer. */
TERM
DEFUN_VOID(Arraymaxsize_0)
{ 
  return (TERM)(BLKSIZE-1);
}


static TERM MemFail[] = {(TERM)ONE,(TERM)26,(TERM)"array could not be created"};
/* mt :: integer -> array. */
TERM
DEFUN(_Arraymt_0,(N,IR), 
      TERM    N  AND
      INSTREC IR)
{
  REGISTER unsigned i = 0;
  REGISTER TERM     RES;
  REGISTER TERM     Err;
  extern char * EXFUN(malloc,(unsigned));

  alloc_array(RES,N);
  Err = Arrayerrorval_0();
  while (i<(unsigned)N) RES->ARGS[i++] = copy_Array_codom(Err);
  free_Array_codom(Err);
  return array(N,RES,MT);

FAIL:
  return _Errorerror_0((TERM)MemFail,
                      ((INSTREC)((INSTREC)IR)->inst[5]));
}

static unsigned
DEFUN(size,(A),
      TERM A)
{ REGISTER TERM A1=A;
  while(OPN(A1)) A1=A1->ARGS[2];
  return a_size(A1);
}

/* size(array) -> integer. */
TERM
DEFUN(_Arraysize_0,(A,IR),
      TERM    A  AND
      INSTREC IR)
{ REGISTER TERM RES = (TERM) size(A);
  xfree_Array_array(_SArray_array,A);
  return RES;
}

static TERM
DEFUN(crunch,(A,IR),
      TERM    A AND
      INSTREC IR)
{ if (OPN(A)) {
    REGISTER TERM AA = A;
    REGISTER TERM B = crunch(AA->ARGS[2],IR);
    if (!OPN(B)) if(ONE_REF(B)) {
      REGISTER unsigned j;
      free_Array_codom(B->ARGS[1]->ARGS[j=a_size(AA)]);
      B->ARGS[1]->ARGS[j] = AA->ARGS[1];
      AA->ARGS[0] = B->ARGS[0];
      AA->ARGS[1] = B->ARGS[1];
      AA->ARGS[2] = MT;
      AA->NAME--; /* array(..) */ 
      MDEALLOC(3,B);
    }
  }
  return A;
}

/* (array,integer) := codom -> array. */

static TERM IllIndex[] = {(TERM)ONE,(TERM)24,(TERM)"array index out of range"};
TERM
DEFUN(_Array_X58_X61_0,(A,I,D,IR),
      TERM    A    AND
      TERM    I    AND
      TERM    D    AND
      INSTREC IR)
{ REGISTER unsigned N = size(A);
  REGISTER unsigned II=(unsigned)I;  /* cc load/store optimization */
  REGISTER TERM AA = crunch(A,IR);
  if (II >= N) {
    free_Array_codom(D); 
    xfree_Array_array(_SArray_array,AA);
    return _Errorerror_0((TERM)IllIndex,
                        ((INSTREC)((INSTREC)IR)->inst[5]));
  } else {
    if (OPN(AA)) { /* is(..) */
      return is(I,D,AA);
    } else if (ONE_REF(AA)) {
      free_Array_codom(AA->ARGS[1]->ARGS[II]); 
      AA->ARGS[1]->ARGS[II] = D;   
      return AA;
    } else { /* array(..) */
      REGISTER TERM TMP=array((TERM)N,AA->ARGS[1],MT);
      AA->NAME++; /* is(..) */
      AA->ARGS[0] = (TERM) II;
      AA->ARGS[1] = TMP->ARGS[1]->ARGS[II];
      TMP->ARGS[1]->ARGS[II] = D;
      AA->ARGS[2] = xcopy_Array_array(_SArray_array,TMP);
      xfree_Array_array(_SArray_array,AA);
      return TMP;    
    }
  }
}

static void
DEFUN(value,(S,I,D,A,OK,DD,IR),  
      SORTREC S  AND
      TERM    I  AND
      TERM    D  AND
      TERM    A  AND
      TERM    *OK AND
      TERM    *DD AND
      INSTREC IR)
{ REGISTER TERM A1=A;
  REGISTER unsigned II=(unsigned)I;  /* cc load/store optimization */
  while(OPN(A1) && (II != a_size(A1))) A1=A1->ARGS[2];
  if(OPN(A1)) {
    *OK = true;
    if(D!=(TERM)0) free_Array_codom(D); 
    *DD = COPY(Array_arrayArray_codom(S),A1->ARGS[1]);
  }
  else if(II >= a_size(A1)) {
         *OK = false;
         *DD = D;
       } else {
         *OK = true;
         if(D!=(TERM)0) free_Array_codom(D); 
         *DD = COPY(Array_arrayArray_codom(S),A1->ARGS[1]->ARGS[II]);
       }
  xfree_Array_array(S,A);
}

/* array ?! integer -> (boolean,codom). */
void
DEFUN(_Array_X63_X33_0,(A,I,OK,DD,IR),
      TERM A   AND
      TERM I   AND
      TERM *OK AND
      TERM *DD AND
      INSTREC IR)
{
   value(_SArray_array,I,Arrayerrorval_0(),crunch(A,IR),OK,DD,IR);
}


XINITIALIZE(Array_Xinitialize,__XINIT_Array)


