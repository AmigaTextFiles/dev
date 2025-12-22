/*
 * rfc1341.c  V0.8.01
 *
 * decode a RFC 1341 (MIME) message
 *
 * (c) 1992-94 Stefan Becker
 *
 */

#include "uuxqt.h"

/*
 * Decode a RFC 1341 (MIME) message
 *
 * Supported Types: <nothing> (defaults to text/plain; charset=us-ascii)
 *
 *                  text
 *                   - Subtypes: plain
 *                   - Parameters: charset (US-ASCII, ISO-8859-1)
 *
 * Supported Encodings: <nothing>        (defaults to 7BIT)
 *                      7BIT/8BIT/BINARY (nothing to decode)
 *                      QUOTED-PRINTABLE
 *
 */
BOOL DecodeRFC1341Message(char *type, char *encoding, char *text)
{
 BOOL rc=FALSE;

 /* Check content type */
 if (!type || !strnicmp(type,"text",4)) {

  /* Content type "TEXT". Check subtype */
  if (!type || !strnicmp(type+5,"plain",5)) {
   /* Type and subtype OK. */
   char *csp=NULL;

   /* Search for "charset" parameter */
   if (type && (csp=strstr(type+10,"charset"))) {
    /* Skip white space and "=" */
    csp+=7;
    while ((*csp==' ') || (*csp=='\t') || (*csp=='=')) csp++;
   }

   /* No "charset" parameter (default: "us-ascii") or supported char set? */
   if (!csp || !strnicmp(csp,"us-ascii",8) ||
               !strnicmp(csp,"iso-8859-1",10))
    /* Check encoding type */
    if (!encoding || !strnicmp(encoding,"7bit",4) ||
        !strnicmp(encoding,"8bit",4) || !strnicmp(encoding,"binary",6))
     /* Nothing to decode */
     rc=TRUE;

    else if (!strnicmp(encoding,"quoted-printable",16)) {
     char *ep=text,c;

     /* Scan text */
     csp=text;
     while (c=*ep++) {
      /* Encoding command? */
      if (c=='=')

       /* Yes, get next character. End of text? */
       if (c=*ep++)

        /* No, soft line break? */
        if (c=='\n')
         /* Yes. Remove it and skip to next character */
         continue;

        else {
         /* No, encoded character */
         char d;

         /* '=' <hex digit 1> <hex digit 2> --> 8 Bit character */
         c=(c - ((c>'9') ? ((c>'F') ? 87 : 55) : 48))<<4;
         d=*ep++;
         c|=d - ((d>'9') ? ((d>'F') ? 87 : 55) : 48);
        }

       /* Yes, end of text reached */
       else break;

      /* Put character */
      *csp++=c;
     }

     /* Add string terminator */
     *csp='\0';
     rc=TRUE;
    } /* All other transfer encodings are unsupported... */
  }
 }
 return(rc);
}
