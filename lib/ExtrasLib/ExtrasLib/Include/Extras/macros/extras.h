#ifndef EXTRAS_MACROS_EXTRAS_H
#define EXTRAS_MACROS_EXTRAS_H

#define LIMIT(mx,x,mn)  {x=max(x,mn); x=min(x,mx);}

/* Macro for processing a double null terminated string array (NNStr) */
//#define nns_ProcessNNStr(NNStr,Str)   for(Str=NNStr;Str;Str=nns_NextNNStr(Str))
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


#endif /* EXTRAS_MACROS_EXTRAS_H */
