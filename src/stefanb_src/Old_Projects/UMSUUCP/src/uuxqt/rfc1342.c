/*
 * rfc1342.c  V0.5
 *
 * decode a RFC 1342 header line
 *
 * (c) 1992-93 Stefan Becker
 *
 */

#include "uuxqt.h"

/*
 * Decode one RFC 1342 line
 *
 * Format: '=?' <char set> '?' <encoding> '?' <encoded data> '?='
 *
 * Supported char sets: US-ASCII, ISO-8859-1
 * Supported encodings: Q (Quoted printable)
 *
 */
void DecodeRFC1342Line(char *line)
{
 char *lp;

 /* Search first starting delimiter "=?" */
 if (lp=strstr(line,"=?")) {
  /* Line may be encoded, start decoding */
  char *dlp=lp;
  char c;

  while (c=*lp++) {
   /* Starting delimiter? */
   if ((c=='=') && (*lp=='?')) {
    char *csp=lp+1;

    /* Supported character set and valid encoding line? */
    if ((!strnicmp(csp,"us-ascii",8) || !strnicmp(csp,"iso-8859-1",10)) &&
        (csp=strchr(csp+8,'?')) && (*(csp+2)=='?') && strstr(csp+3,"?="))
     /* Get encoding method */
     switch (*++csp) {
      case 'q':
      case 'Q': /* Quoted printable encoding */
                lp=csp+2; /* Start of encoded data */

                /* Decode data */
                while ((c=*lp++)!='?') {
                 /* Encoded character? */
                 if (c=='=') {
                  /* Yes, decode it */
                  char d;

                  /* '=' <hex digit 1> <hex digit 2> --> 8 Bit character */
                  d=*lp++;
                  c=(d - ((d>'9') ? ((d>'F') ? 87 : 55) : 48))<<4;
                  d=*lp++;
                  c|=d - ((d>'9') ? ((d>'F') ? 87 : 55) : 48);

                 /* "Space"? */
                 } else if (c=='_')
                  c=0x20;

                 /* Set character */
                 *dlp++=c;
                }

                /* Correct line pointer */
                lp++;
                if (*lp==' ') lp++; /* Skip trailing space */

                /* Decoding complete, next character */
                continue;
                break;
      /* No other encoding method supported */
     }
   }

   /* Next character */
   *dlp++=c;
  }

  /* Add string terminator */
  *dlp='\0';
 }
}
