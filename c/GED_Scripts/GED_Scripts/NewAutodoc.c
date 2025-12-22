/* -----------------------------------------------------------------------------

  Scan handler looking for Autodoc nodes. This handler simply looks for
  formfeeds and therefore won't work with all Autodocs (Commodore's Autodocs
  are handled properly).

  Scan handlers are plain functions (loadSeg()'ed): no standard C startup
  code and no library calls permitted. We have to put string constants into
  the code segment (DICE compiler: option -ms1).

  DICE:

  dcc autodocslow.c -// -l0 -md -mRR -o golded:etc/scanner/autodocslow

  ------------------------------------------------------------------------------
*/

#include <exec/types.h>

#define REG(x) register __##x
#define FORMFEED 12

ULONG ScanHandlerGuide(REG(d0) ULONG len, REG(a0) char **text, REG(a1) ULONG *line)
{
    const char version[] = "$VER: NewADoc 1.1 (24.02.99)";

    static UBYTE buffer[255];
    static ULONG inbuffer;

    UBYTE *next;
    ULONG  length;

    // buffer length for later use

    length = len;

    // clear "last result" buffer if we start parsing a new document

    if (line == 0)
        *buffer = 0;


    if (**text == FORMFEED) {

        // look for beginning of header string (e.g. "Dos.Library/Open")

        while (len && (**text <= ' ')) {

            ++*text;
            --len;
        }

        // ignore first part of header string

        while (len && (**text != '/')) {

            ++*text;
            len--;
        }

        // extract node name

        if (len) {

            ULONG letters;

            ++*text;
            --len;

            for (letters = 0; len && ((*text)[letters] >= '.'); --len)
                ++letters;

            if (letters)
               {
                  // buffer result

                  buffer[letters] = 0;

                  len = letters;

                  while (len--)
                     buffer[len] = (*text)[len];

                  inbuffer = letters;

                  return(letters);
               }
            else
               return FALSE;
        }
    }


    // did one of the previous lines produce a result ?

    if (*buffer) {

        next = *text;

        // look for "alternative version" mentioned in the text

        while (length) {

            // skip white space

            while (length && (*next < 'A')) {

                --length;

                ++next;
            }

            // check next word

            if (length) {

                ULONG keylen;

                // set (possible) result string

                *text = next;

                // determine length of next word

                for (keylen = 0; length && (*next >= 'A'); ++next) {

                    ++keylen;

                    --length;
                }

                // close match found ?

                if (**text == *buffer) {

                    // only last letter may differ; eg. DrawBevelBox vs. DrawBevelBoxA

                    if ((keylen == (inbuffer + 1)) || (keylen == (inbuffer - 1))) {

                        ULONG compare = (keylen < inbuffer) ? keylen : inbuffer;

                        // does one of both end with 'A'?

                        if ((*text)[compare] != 'A' && buffer[compare] != 'A')
                           return FALSE;

                        while (compare--) {

                            if ((*text)[compare] != buffer[compare])
                                break;

                            else if (compare == 0) {

                                // stop searching for alternative versions

                                *buffer = 0;

                                // return result

                                return(keylen);
                            }
                        }
                    }
                }
            }
        }
    }

    return(FALSE);
}
