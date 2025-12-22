/*
 * decode.c  V1.1.00
 *
 * decode a MIME message/header
 *
 * (c) 1994-97 Stefan Becker
 *
 */

#include "umsrfc.h"

/* Hex digit to integer 0 .. 15 */
#define IS_HEX(c)   ((((c) >= '0') && ((c) <= '9')) || \
                     (((c) >= 'A') && ((c) <= 'F')) || \
                     (((c) >= 'a') && ((c) <= 'f')))
#define FROM_HEX(c) ((c) - (((c) > '9') ? \
                           (((c) > 'F') ? 'a' - 10 : 'A' - 10 ) : '0'))

/*
 * Decode a MIME message
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
BOOL DecodeMessage(const char *type, const char *encoding, char *text)
{
 BOOL rc = FALSE;

 /* Check content type */
 if (!type || (strnicmp(type, "text", 4) == 0)) {

  /* Content type "TEXT". Check subtype */
  if (!type || (strnicmp(type + 5, "plain", 5) == 0)) {

   /* Type and subtype OK. */
   char *csp = NULL;

   /* Search for "charset" parameter */
   if (type && (csp = strstr(type + 10, "charset"))) {

    /* Skip white space, '=' and '"' */
    csp += 7;
    while ((*csp == ' ') || (*csp == '\t') || (*csp == '=') || (*csp == '\"'))
     csp++;
   }

   /* No "charset" parameter (default: "us-ascii") or supported char set? */
   if (!csp || (strnicmp(csp, "us-ascii",    8) == 0) ||
               (strnicmp(csp, "iso-8859-1", 10) == 0))

    /* Check encoding type */
    if (!encoding || (strnicmp(encoding, "7bit",   4) == 0) ||
                     (strnicmp(encoding, "8bit",   4) == 0) ||
                     (strnicmp(encoding, "binary", 6) == 0))

     /* Nothing to decode */
     rc = TRUE;

    else if (strnicmp(encoding, "quoted-printable", 16) == 0) {

     /* Scan text line by line */
     csp = text;
     while (text) {
      char  c;
      char *lp = text;

      /* Remove trailing white space from end of line */
      {
       char *ep;

       /* Look for end of line */
       if (ep = strchr(lp, '\n')) {
        text = ep + 1;
        ep--;
       } else {
        ep   = lp + strlen(lp) - 1;
        text = NULL;                /* End of text reached */
       }

       /* Remove trailing white space */
       while ((ep >= lp) && (((c = *ep) == ' ') || (c == '\t'))) ep--;

       /* Set string terminator */
       *(ep + 1) = '\0';
      }

      /* Scan line */
      do {

       switch (c = *lp++) {
        case '\0': /* Line end reached. Add line end (only while in text) */
         if (text) *csp++ = '\n';
         break;

        case '=':  /* Encoded character */
          /* End of line reached? (-> soft line break!) */
          if (c = *lp) {
           char d = *(lp + 1);

           /* Sanity check */
           if (IS_HEX(c) && IS_HEX(d)) {

            /* Decode two hex digit to 8-Bit characters */
            *csp++ = (FROM_HEX(c) << 4) | FROM_HEX(d);

            /* Move line pointer */
            lp += 2;

           } else
            /* The '=' was not followed by two hex digits. This is actually */
            /* a violation of the standard. We put the '=' into the decoded */
            /* text and continue decoding after the '»' character.          */
            *csp++ = '=';
          }
         break;

        default:   /* Normal character */
         *csp++ = c;
         break;
       }
      } while (c);
     }

     /* Add string terminator */
     *csp = '\0';
     rc   = TRUE;

    } /* All other transfer encodings are unsupported... */
  }
 }
 return(rc);
}

/*
 * Decode one MIME header
 *
 * Format: '=?' <char set> '?' <encoding> '?' <encoded data> '?='
 *
 * Supported char sets: US-ASCII, ISO-8859-1
 * Supported encodings: Q (Quoted printable)
 *
 */
void DecodeHeaderLine(char *line)
{
 char *lp;

 /* Search first starting delimiter "=?" */
 if (lp = strstr(line, "=?")) {

  /* Line may be encoded, start decoding */
  char *dlp = lp;
  char c;

  while (c = *lp++) {

   /* Starting delimiter? */
   if ((c == '=') && (*lp == '?')) {
    char *csp = lp + 1;

    /* Supported character set and valid encoding line? */
    if (((strnicmp(csp, "us-ascii", 8) == 0) ||
         (strnicmp(csp, "iso-8859-1", 10) == 0)) &&
        (csp = strchr(csp + 8, '?')) &&
        (*(csp + 2) == '?') &&
        strstr(csp + 3, "?="))

     /* Get encoding method */
     switch (*++csp) {
      case 'q':
      case 'Q': /* Quoted printable encoding */
                lp = csp + 2; /* Start of encoded data */

                /* Decode data */
                while ((c = *lp++) != '?') {

                 /* Encoded character? */
                 if (c == '=') {
                  char d;

                  /* Yes, decode it */
                  c = *lp;
                  d = *(lp + 1);

                  /* Sanity check */
                  if (IS_HEX(c) && IS_HEX(d)) {

                   /* Decode two hex digit to 8-Bit characters */
                   c = (FROM_HEX(c) << 4) | FROM_HEX(d);

                   /* Move line pointer */
                   lp += 2;

                  } else
                   /* The '=' was not followed by two hex digits. This is  */
                   /* actually a violation of the standard. We put the '=' */
                   /* into the decoded text and continue decoding after    */
                   /* the '»' character.                                   */
                   c = '=';

                 /* "Space"? */
                 } else if (c == '_')
                  c = 0x20;

                 /* Set character */
                 *dlp++ = c;
                }

                /* Correct line pointer */
                lp++;
                if (*lp == ' ') lp++; /* Skip trailing space */

                /* Decoding complete, next character */
                continue;
                break;
      /* No other encoding method supported */
     }
   }

   /* Next character */
   *dlp++ = c;
  }

  /* Add string terminator */
  *dlp = '\0';
 }
}
