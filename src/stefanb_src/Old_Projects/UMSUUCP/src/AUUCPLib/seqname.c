
/*
 *  SEQNAME.C
 */

#include <stdio.h>
#include <stdlib.h>
#include "config.h"

Prototype char *SeqToName(long);

/*
 *  Convert a sequence number into a numeric/character combination.  Names
 *  are unique and case-insensitive.  The sequence number 0-0xFFFFF will be
 *  converted to a 4 character string each position containing 0-9 a-z,
 *  or base 36 (total of 1.6 million combinations)
 */

char *
SeqToName(long seqNo)
{
    static char Buf[5];
    short i;

    seqNo &= 0xFFFFF;

    for (i = 3; i >= 0; --i) {
        short n = seqNo % 36;
        if (n < 10)
            Buf[i] = n + '0';
        else
            Buf[i] = n - 10 + 'a';
        seqNo /= 36;
    }
    Buf[4] = 0;
    return(Buf);
}

