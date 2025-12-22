/* -----------------------------------------------------------------------------

  Scan handler looking for C structures.
  
  Scan handlers are plain functions (loadSeg()'ed): no standard C startup
  code and no library calls permitted. We have to put string constants into
  the code segment (DICE compiler: option -ms1).

  DICE:
  
  dcc struct.c -// -l0 -md -mRR -o golded:etc/scanner/struct

  ------------------------------------------------------------------------------
*/

#include <exec/types.h>

#define UPPER(a) ((a) & 95)
#define REG(x) register __##x

ULONG
ScanHandlerStruct(REG(d0) ULONG len, REG(a0) char **text, REG(a1) ULONG *line)
{
    const char *version = "$VER: Struct 1.3 (17.11.98)";

    UBYTE *from = *text;

    if (len > 8) {

        if ((from[0] == 't') && (from[1] == 'y') && (from[2] == 'p') && (from[3] == 'e') && (from[4] == 'd') && (from[5] == 'e') && (from[6] == 'f') && ((from[7] == ' ') || (from[7] == 9))) {

            // ignore typedef keyword

            len  -= 8;
            from += 8;
        }
    }

    if (len > 7) {

        if ((from[0] == 's') && (from[1] == 't') && (from[2] == 'r') && (from[3] == 'u') && (from[4] == 'c') && (from[5] == 't') && ((from[6] == ' ') || (from[6] == 9))) {

            // found struct keyword

            UBYTE *last;

            for (last = from + len - 1; len && ((*last == 32) || (*last == 9)); --len)
               --last;

            from += 7;
            len  -= 7;

            // skip spaces between keyword and name
            while((*from == ' ' || *from == 9) && len)
               {
                  ++from;
                  --len;
               }

            if ((*last != ',') && (*last != '*')) {

                UWORD pos = len;

                // check if there is a ';' in this line

                while (pos--)
                  {
                     if (from[pos] == ';')
                        {
                           if (from[pos - 1] == '}')
                              break;
                           else
                              return(FALSE);
                        }
                  }

                if (*from != '{') {

                    *text = from;

                    for (len = 0; (from <= last) && (*from >= 48); ++len)

                        ++from;

                    return(len);
                }
            }
        }
    }

    return(FALSE);
}


