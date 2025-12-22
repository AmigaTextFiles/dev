#ifndef EXTRAS_NNSTRING_H
#define EXTRAS_NNSTRING_H

typedef STRPTR NNSTRPTR;

/* Macro for processing a double null terminated string array (NNStr) */



#define nns_ProcessNNStr(NNStr,Str)   for(Str=NNStr;Str;Str=nns_NextNNStr(Str))
/*
  example 
   {
    STRPTR NNStr, str;
    
    ProcessNNStr(NNStr,str)
    {
      printf("%s\n",str);
    }
  }
*/


#endif /* EXTRAS_NNSTRING_H */
