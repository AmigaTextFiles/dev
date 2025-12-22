/*
 * misc.c V1.1.00
 *
 * misc. stuff
 *
 * (c) 1994-97 Stefan Becker
 */

#include "umsrfc.h"

#ifdef _DCC
char *PrivateUMSReadConfigTags(struct Library *UMSBase, UMSAccount acc,
                               Tag tag1, ...)
{
 return(UMSReadConfig(acc, (struct TagItem *) &tag1));
}

BOOL PrivateUMSReadMsgTags(struct Library *UMSBase, UMSAccount acc,
                           Tag tag1, ...)
{
 return(UMSReadMsg(acc, (struct TagItem *) &tag1));
}

UMSMsgNum PrivateUMSWriteMsgTags(struct Library *UMSBase, UMSAccount acc,
                                 Tag tag1, ...)
{
 return(UMSWriteMsg(acc, (struct TagItem *) &tag1));
}

UMSMsgNum PrivateUMSSearchTags(struct Library *UMSBase, UMSAccount acc,
                                 Tag tag1, ...)
{
 return(UMSSearch(acc, (struct TagItem *) &tag1));
}

void PrivateUMSLog(struct Library *UMSBase, UMSAccount acc, LONG level,
                   STRPTR fmt, ...)
{
 UMSVLog(acc, level, fmt, ((ULONG *) &fmt) + 1);
}

void UMSRFCLog(struct UMSRFCData *urd, const char *format, ...)
{
 UMSRFCVLog(urd, format, ((ULONG *) &format) + 1);
}
#endif

/* simple sprintf() clone */
int pvsprintf(char *buf, const char *fmt, ULONG *args)
{
 char *op = buf;
 char c;

 /* Scan format string */
 while (c = *fmt++)

  /* Place holder? */
  if (c == '%')

   /* Yes, get argument type */
   switch (*fmt++) {
    case 'd': /* Decimal */
              {
               ULONG n = *args++;

               if (n) {
                ULONG len = 0;
                char NumberBuffer[12];
                char *cp  = NumberBuffer;

                while (n) {
                 *cp++  = (n % 10) + '0';
                 n     /= 10;
                 len++;
                }

                /* Copy conversion buffer */
                while (len--) *op++ = *--cp;

                /* Handle "0" as a special case */
               } else *op++ = '0';
              }
              break;

    case 's': /* String */
              {
               char *sp = *(char **)(args++);

               /* Copy string */
               while (*op++ = *sp++);
               op--;
              }
              break;
   }

  /* Normal character, copy it */
  else *op++ = c;

 /* Add string terminator */
 *op = '\0';

 return(op - buf);
}

/* simple sprintf() clone */
int psprintf(char *buf, const char *fmt, ...)
{
 return(pvsprintf(buf, fmt, ((ULONG *) &fmt) + 1));
}

/* Simple fputs() clone */
void pfputs(UMSRFCOutputFunction func, void *data, const char *s)
{
 char c;

 /* Print string */
 while (c = *s++) (*func)(data, c);
}

/* Simple fprintf() clone */
void pfprintf(UMSRFCOutputFunction func, void *data, const char *fmt, ...)
{
 va_list ap;
 char c;

 /* Start variable arguments scanning */
 va_start(ap, fmt);

 /* Scan format string */
 while (c = *fmt++)

  /* Place holder? */
  if (c == '%')

   /* Yes, get argument type */
   switch (*fmt++) {
    case 'c': /* Character */
              (*func)(data, va_arg(ap, int));
              break;

    case 'd': /* Decimal */
              {
               ULONG n = va_arg(ap, ULONG);

               if (n) {
                ULONG len = 0;
                char NumberBuffer[12];
                char *cp  = NumberBuffer;

                while (n) {
                 *cp++  = (n % 10) + '0';
                 n     /= 10;
                 len++;
                }

                /* Copy conversion buffer */
                while (len--) (*func)(data, *--cp);

                /* Handle "0" as a special case */
               } else (*func)(data, '0');
              }
              break;

    case 's': /* String */
              {
               char *sp = va_arg(ap, char *);
               char c;

               /* Copy string */
               while (c = *sp++) (*func)(data, c);
              }
              break;
   }

  /* Normal character, copy it */
  else (*func)(data, c);

 /* End variable arguments scanning */
 va_end(ap);
}

/* Create temporary file name (maximum length: TEMPNAMESIZE) */
const char *CreateTempName(struct PrivateURD *purd, ULONG id, char *buf)
{
 psprintf(buf, "T:UMSRFC_%d_%d", purd, id);
 return(buf);
}
