/*
 *      Small C+ String Library
 *
 *      Taken from c68 archive
 *
 *      Added to Small C+ archive 1/3/99 djm
 */



/*
 *      s t r u p r
 *
 * AMENDMENT HISTORY
 * ~~~~~~~~~~~~~~~~~
 *  28 Aug 94   DJW   - Fixed problem with cast needed for character values
 *                      outside the range 0 to 127.
 *
 *   1 Mar 99   djm   - Converted to Small C
 */


/*
 *  A little black magic
 */

#pragma proto HDRPRTYPE

extern char *strupr();
extern int toupper();

#pragma unproto HDRPRTYPE

#asm
        LIB     toupper
#endasm



strupr(string)
unsigned char *string;
{
    unsigned char *p;
    p = string;

    while ((*p = toupper(*p) ) != '\0') {
        p++;
    }
    return(string);
}

