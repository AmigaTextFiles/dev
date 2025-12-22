/*
   Clown Script Interpreter
      v0.2.5 - Public
    Written by Bl0ckeduser
*/

#ifndef COMPILER_DYNAMICARRAYEXP_H_INCLUDED
#define COMPILER_DYNAMICARRAYEXP_H_INCLUDED

extern void DAE_CreateEntry(int EncodedRef, int AbsoluteIndex, int IndirectValue);
extern int DAE_GetAbsoluteIndex(int EncodedRef);
extern int DAE_GetIndirectValue(int EncodedRef);
extern int DAE_FetchEntry(int AbsoluteIndex, int IndirectValue);

#endif /* COMPILER_DYNAMICARRAYEXP_H_INCLUDED */


