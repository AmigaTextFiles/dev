/*******************************************************************************

 hd :: string -> (boolean,char).
 
*/

void
DEFUN(xx_Stringhd_1,(S,B,C),
      TERM S  AND
      TERM *B AND
      TERM *C)
{ unsigned I,LEN=OPN(S);
  char *SOURCE, *DEST;
  TERM H;

  if(LEN == 0) {
    *C = (TERM)(int) *((char *) (S->ARGS[1]));
    *B = (*C) ? true : false;
  }
  else {
     *B = true;
     if(LEN > MAXSTR)
        *C = (TERM)(int) *((char *)  (S->ARGS[1]));
     else
        *C = (TERM)(int) *((char *) &(S->ARGS[1]));
     free__RUNTIME_string(S);
  }
}


/*******************************************************************************

 compare :: string -> string -> comparison.

*/

TERM
DEFUN(xx_Stringcompare_0,(S1,S2),
      TERM S1 AND
      TERM S2)
{ int RES = compare_string(S1,S2);
  free__RUNTIME_string(S1); free__RUNTIME_string(S2);
  if (RES < 0) return co__Comparisonless_0;
  if (RES > 0) return co__Comparisongreater_0;
  return co__Comparisoneq_0;
}

/*******************************************************************************

 string ++ string :: string.
 
*/

TERM
DEFUN(xx_String_X43_X43_0,(S1,S2),
      TERM S1 AND
      TERM S2)
{ unsigned I,WORDS,LEN;
  TERM P_RES,RES=false,S=S1;

  while (LEN=OPN(S)) {
    if(LEN > MAXSTR) /* type C */ {
      if(RES) {
        P_RES->ARGS[0] = MK(2,LEN,TNULL,S->ARGS[1]);
        P_RES = P_RES->ARGS[0];
      }
      else {
        RES            = MK(2,LEN,TNULL,S->ARGS[1]);
        P_RES = RES;
      }
    }
    else /* type B */ {
      if(RES) {
        P_RES->ARGS[0] = MK_string(LEN,TNULL);
        P_RES = P_RES->ARGS[0];
      }
      else {
        RES            = MK_string(LEN,TNULL);
        P_RES = RES;
      }
      WORDS = (LEN+3) >> 2;
      for (I=1; I <= WORDS; I++) P_RES->ARGS[I] = S->ARGS[I];
    }
    
    S = S->ARGS[0];
  }
  
  S2 = _RUNTIME_mk1STRING((unsigned)(S->ARGS[0]),
                          (char *)(S->ARGS[1]),
                          S2);
  if(!RES) return S2;
  P_RES->ARGS[0] = S2;
  free__RUNTIME_string(S1);
  return RES;
}

/*******************************************************************************

 length :: string -> integer. 

*/

TERM
DEFUN(xx_Stringlength_0,(S),
      TERM S)
{ FOURBYTES LEN=0,LL; TERM H=S;
  while (LL=OPN(H)) { 
    if(LL > MAXSTR) LL -= MAXSTR;
    LEN += LL; 
    H = H->ARGS[0]; 
  }
  LEN += (unsigned)(H->ARGS[0]);
  free__RUNTIME_string(S); 
  return (TERM) LEN;
} 

/*******************************************************************************

 char : string :: string.

*/

TERM
DEFUN(xx_String_X58_0,(C,S),
      TERM C AND
      TERM S)
{ unsigned I,LEN=OPN(S);
  TERM H;
  char *SOURCE,*DEST;

  if(LEN && LEN < MAXSTR) {
    H = MK_string(LEN+1,CP(S->ARGS[0]));
    SOURCE = (char *) &(S->ARGS[1]);
    DEST = (char *) &(H->ARGS[1]);
    *DEST++ = __tchar((int)C);
    for (I=0; I < LEN; I++) *DEST++ = *SOURCE++;
    free__RUNTIME_string(S);
    return H;
  }
  else /* LEN==0 || LEN >= MAXSTR */ {
    H = MK_string(1,S);
    *(char *)&(H->ARGS[1]) = __tchar((int)C);
    return H;
  }
}

/*******************************************************************************

 hd :: string -> (boolean,char,string).
 
*/

void
DEFUN(xx_Stringhd_2,(S,B,C,RS),
      TERM S  AND
      TERM *B AND
      TERM *C AND
      TERM *RS)
{ unsigned I,LEN=OPN(S);
  char *SOURCE, *DEST;
  TERM H;

  if(LEN == 0) {
    *C = (TERM)(int) *((char *) (S->ARGS[1]));
    *B = (*C) ? true : false;
    *RS = (*C) ? _RUNTIME_mk1STRING((unsigned)(S->ARGS[0])-1,
                                    (char *)(S->ARGS[1])+1,MT) : MT;
  }
  else if(LEN > MAXSTR) {
    *B = true;
    SOURCE = (char *) (S->ARGS[1]);
    *C = (TERM)(int) *SOURCE++;
    if(*SOURCE)
      *RS = MK(2,LEN-1,CP(S->ARGS[0]),(TERM)SOURCE);
    else *RS = CP(S->ARGS[0]);
    free__RUNTIME_string(S);
  }
  else {
    if(LEN == 1) {
      *B = true;
      *C = (TERM)(int) *((char *) &(S->ARGS[1]));
      *RS = CP(S->ARGS[0]);
      free__RUNTIME_string(S);
    }
    else {
      LEN--;
      H = MK_string(LEN,CP(S->ARGS[0]));
      SOURCE = (char *) &(S->ARGS[1]);
      DEST = (char *) &(H->ARGS[1]);
      *B = true;
      *C = (TERM)(int)*SOURCE++;
      for (I=0; I < LEN; I++) *DEST++ = *SOURCE++;
      *RS = H;
      free__RUNTIME_string(S);
    }
  }
}

/*******************************************************************************

 split :: (integer,string) -> (boolean,string,string). 

*/

void
DEFUN(xx_Stringsplit_1,(N,S,B,RS1,RS2),
      TERM N    AND
      TERM S    AND
      TERM *B   AND
      TERM *RS1 AND
      TERM *RS2)
{ unsigned I,WORDS,LEN=(unsigned) OPN(S);
  TERM H;
  char *SOURCE,*DEST,*REST,C;

  if(LEN == 0) {
    LEN = (unsigned)(S->ARGS[0]);
    SOURCE = (char *)(S->ARGS[1]);
    if((unsigned)N >= LEN) {
      *B = ((unsigned)N == LEN) ? true : false;
      *RS1 = S;
      *RS2 = MT;
    }
    else
      xx_Stringsplit_1(N,_RUNTIME_mkSTRING(SOURCE),B,RS1,RS2);
  }
  else {
    if(LEN > MAXSTR) {
      LEN -= MAXSTR; 
      if((unsigned) N > LEN) {
        Stringsplit_1((TERM)((unsigned)N-LEN),CP(S->ARGS[0]),B,&H,RS2);
        *RS1 = MK(2,1,H,S->ARGS[1]);
        free__RUNTIME_string(S);
      }
      else if((unsigned)N == LEN) {
        H = MK(2,LEN+MAXSTR,MT,S->ARGS[1]);
        *B = true;
        *RS1 = H;
        *RS2 = CP(S->ARGS[0]);
        free__RUNTIME_string(S);
      }
      else /*  N < LEN) */ {
        H = _RUNTIME_mk0STRING((char *)S->ARGS[1]);
        Stringsplit_1(N,H,B,RS1,RS2);
        *RS2 = String_X43_X43_0(*RS2,CP(S->ARGS[0]));
        free__RUNTIME_string(S);
      }
    }
    else {
      if((unsigned) N > LEN) {
        Stringsplit_1((TERM)((unsigned)N-LEN),CP(S->ARGS[0]),B,&H,RS2);
        H = MK_string(LEN,H);
        WORDS = (LEN+3) >> 2;
        for (I=1; I <= WORDS; I++) H->ARGS[I] = S->ARGS[I];
        free__RUNTIME_string(S);
        *RS1 = H;
      }
      else if((unsigned)N == LEN) {
        H = MK_string(LEN,MT);
        WORDS = (LEN+3) >> 2;
        for (I=1; I <= WORDS; I++) H->ARGS[I] = S->ARGS[I];
        *B = true;
        *RS1 = H;
        *RS2 = CP(S->ARGS[0]);
        free__RUNTIME_string(S);
      }
      else /*  N < LEN) */ {
        H = MK_string((unsigned)N,MT);
        SOURCE = (char *) &(S->ARGS[1]);
        DEST = (char *) &(H->ARGS[1]);
        for (I=0; I < (unsigned)N; I++) *DEST++ = *SOURCE++;
        *B = true;
        *RS1 = H;
        LEN -= (unsigned)N;
        H = MK_string(LEN,CP(S->ARGS[0]));
        DEST = (char *) &(H->ARGS[1]);
        for (I=0; I < LEN; I++) *DEST++ = *SOURCE++;
        *RS2 = H;
        free__RUNTIME_string(S);
      }
    }
  }
}  

TERM
DEFUN(xx_Stringhash_0,(S),
      TERM S)
{ unsigned RES=0,LEN,i;
  TERM S2=S;
  char *SOURCE;

  while (LEN=OPN(S2)) {
    if(LEN > MAXSTR) {
      LEN-=MAXSTR;
      SOURCE=(char *)S2->ARGS[1];
    }
    else 
      SOURCE= (char *)&(S2->ARGS[1]);

    for (i=0; i < LEN; i++)
      RES+=(*SOURCE++);
    S2=S2->ARGS[0];
  }
  SOURCE=(char *)S2->ARGS[1];
  while (*SOURCE) RES+=(*SOURCE++);
  
  free__RUNTIME_string(S);
  return (TERM)RES;
}


XINITIALIZE(String_Xinitialize,__XINIT_String)
