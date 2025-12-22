/*
 *      Small C+ String Library
 *
 *      Taken from c68 archive
 *
 *      Added to Small C+ archive 1/3/99 djm
 */





/*
 *          s t r s t r i p
 *
 *  Routine to remove any occurrences of the given character(s)
 *  from the front of a string, moving string up if necessary.
 *
 *  AMENDMENT HISTORY
 *  ~~~~~~~~~~~~~~~~~
 *  25 OCT 96   DJW   - First version
 *
 *   1 Mar 99   djm   - Converted to Small C
 */

#pragma proto HDRPRTYPE

extern char *strstrip();
extern char *strcpy();

#pragma unproto HDRPRTYPE

#asm
        LIB     strcpy
#endasm




strstrip(unsigned char *s, unsigned char ch)
{
    unsigned char *ptr;
    ptr = s;

    while (*ptr == ch)
    {
        ptr++;
    }
    if (ptr != s)
    {
        strcpy (s, ptr);
    }
    return s;
}

