/*
 * Encode.c  V1.1.00
 *
 * Encode a MIME messages/header
 *
 * (c) 1994-97 Stefan Becker
 *
 */

#include "umsrfc.h"

/* MIME Encoding line length */
#define MIME_LINELEN 73 /* 76 minus space for one encoded character */

/* Integer 0 .. 15 to hex digit */
#define TO_HEX(d)    (((d) < 10) ? ((d) + '0') : ((d) + 'A' - 10))

/*
 * Encode a MIME message body
 *
 * Supported Encodings: QUOTED-PRINTABLE
 *
 */
void EncodeMessage(UMSRFCOutputFunction func, void *data, char *text,
                   ULONG type, BOOL smtp)
{
 if (type == ENCODE_QUOTED_PRINTABLE) {

  /* Encode with quoted-printable's */
  while (*text) {
   /* Encode one line */
   char c;
   int  count = MIME_LINELEN;

   /* SMTP and '.' as next character (start of line!)? */
   if (smtp && (*text == '.')) {
    /* Quote '.' at start of line */
    (*func)(data, '.');
    count--;
   }

   /* Scan line */
   while ((c = *text++) && (c != '\n') && (count > 0))

    /* Does character need encoding? */
    if ((c < ' ') || (c == '=') || (c > '~')) {
     /* Encode character */
     char d;

     /* '=' <hex digit 1> <hex digit 2> */
     (*func)(data, '=');
     d = (c & 0xF0) >> 4;
     (*func)(data, TO_HEX(d));
     d = c & 0x0F;
     (*func)(data, TO_HEX(d));

     /* Three characters added */
     count -= 3;

     /* SPACE at the end of line? */
    } else if ((c == ' ') && (count == 1)) {

     /* Yes, encode it */
     pfputs(func, data, "=20");
     count--;

     /* TAB at the end of line? */
    } else if ((c == '\t') && (count == 1)) {

     /* Yes, encode it */
     pfputs(func, data, "=09");
     count--;

     /* Nothing to encode */
    } else {
     (*func)(data, c);
     count--;
    }

   /* End of line reached? */
   if (c != '\n') {

    /* No, line length exceeded. Add soft line break */
    (*func)(data, '=');

    /* Move pointer back   */
    text--;
   }

   /* Add line terminator */
   pfputs(func, data, "\r\n");
  }
 } else {

  /* Encode with base64 */
 }
}
