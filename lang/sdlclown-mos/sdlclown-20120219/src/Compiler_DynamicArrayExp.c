/*
   Clown Script Interpreter
      v0.2.5 - Public
    Written by Bl0ckeduser
*/

/*
 * Hack for accessing arrays.
 *
 * Negative addresses in the VM are mapped to "DAE" entries containing :
 * array index value, address of array subscript value
 *
 * Simply put, expressions such as "array[x]" or "array[123]" are
 * each mapped to one DAE entry.
 *
 * No bounds checking has been implemented.
 */

#include "Clown_HEADERS.h"

int AbsoluteIndexes[MEMORY_QTY] = {0};
int IndirectValues[MEMORY_QTY] = {0};

int storage_qty = 0;

int DAE_FetchEntry(int AbsoluteIndex, int IndirectValue)
{
    int i = 0;
    while (++i<=storage_qty)
        if (AbsoluteIndexes[i]==AbsoluteIndex && IndirectValues[i]==IndirectValue)
            return ((i)*(-1))-99;
    return 0;
}

void DAE_CreateEntry(int EncodedRef, int AbsoluteIndex, int IndirectValue)
{
    AbsoluteIndexes[EncodedRef*(-1)-99] = AbsoluteIndex;
    IndirectValues[EncodedRef*(-1)-99] = IndirectValue;
    storage_qty++;
}

int DAE_GetAbsoluteIndex(int EncodedRef)
{
    return AbsoluteIndexes[EncodedRef*(-1)-99];
}

int DAE_GetIndirectValue(int EncodedRef)
{
    return IndirectValues[EncodedRef*(-1)-99];
}



