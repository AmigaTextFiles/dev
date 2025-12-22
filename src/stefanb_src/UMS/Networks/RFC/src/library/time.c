/*
 * time.c V1.1.00
 *
 * umsrfc.library/UMSRFCPrintTime()
 * umsrfc.library/UMSRFCPrintCurrentTime()
 * umsrfc.library/UMSRFCGetTime()
 *
 * (c) 1994-97 Stefan Becker
 */

#include "umsrfc.h"

/* Constant strings */
/* ClockData->wday  = 0 (Sun) ...  7 (Sat) */
static const char *DayOfWeek[7] = {
 "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"
};
/* ClockData->month = 1 (Jan) ... 12 (Dec) */
static const char *Month[12] = {
 "Jan", "Feb", "Mar", "Apr", "May", "Jun",
 "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
};

/* umsrfc.library/UMSRFCPrintTime()                                      */
/* Print time (specified in seconds since 1-Jan-1978) in RFC date format */
__LIB_PREFIX void UMSRFCPrintTime(
             __LIB_ARG(A0) struct UMSRFCData *urd,
             __LIB_ARG(D0) ULONG              time,
             __LIB_ARG(A1) char              *buffer
             /* __LIB_BASE */)
{
 struct PrivateURD *purd           = (struct PrivateURD *) urd;
 const struct Library *UtilityBase = purd->purd_Bases.urb_UtilityBase;
 struct ClockData cd;

 /* Convert seconds to seconds/minutes/hour... */
 Amiga2Date(time, &cd);

 /*
  * Print time in RFC 822/1123 date format
  *
  * <day of week>, <day> <month> <year> <hour>:<min>:<secs> +/-<GMT offset>
  *
  * Year is printed with 4 digits as specified in RFC 1123.
  *
  */
 strcpy(buffer, DayOfWeek[cd.wday]);      /* wday  = 0 ...  7 */
 buffer[ 3] = ',';
 buffer[ 4] = ' ';
 buffer[ 5] = cd.mday / 10 + '0';
 buffer[ 6] = cd.mday % 10 + '0';
 buffer[ 7] = ' ';
 strcpy(&buffer[8], Month[cd.month - 1]); /* month = 1 ... 12 */
 buffer[11] = ' ';
 {
  ULONG year = cd.year;
  int i;

  for (i = 15; i >= 12; i--) {
   buffer[i]  = year % 10 + '0';
   year      /= 10;
  }
 }
 buffer[16] = ' ';
 buffer[17] = cd.hour / 10 + '0';
 buffer[18] = cd.hour % 10 + '0';
 buffer[19] = ':';
 buffer[20] = cd.min / 10 + '0';
 buffer[21] = cd.min % 10 + '0';
 buffer[22] = ':';
 buffer[23] = cd.sec / 10 + '0';
 buffer[24] = cd.sec % 10 + '0';
 buffer[25] = ' ';
 strcpy(&buffer[26], purd->purd_GMTOffsetString);
}

/* umsrfc.library/UMSRFCPrintCurrentTime() */
/* Print current time in RFC 822/1123 date format   */
__LIB_PREFIX void UMSRFCPrintCurrentTime(
             __LIB_ARG(A0) struct UMSRFCData *urd,
             __LIB_ARG(A1) char              *buffer
             /* __LIB_BASE */)
{
 struct PrivateURD *purd       = (struct PrivateURD *) urd;
 const struct Library *DOSBase = purd->purd_Bases.urb_DOSBase;
 struct DateStamp ds;

 /* Get current time */
 DateStamp(&ds);

 /* Print current time */
 UMSRFCPrintTime((struct UMSRFCData *) purd,
                 ds.ds_Days   * 86400            +
                 ds.ds_Minute * 60               +
                 ds.ds_Tick   / TICKS_PER_SECOND,
                 buffer);
}

/* umsrfc.library/UMSRFCGetTime()        */
/* Create AmigaDate from RFC 822/1123 date string */
__LIB_PREFIX ULONG UMSRFCGetTime(
             __LIB_ARG(A0) struct UMSRFCData *urd,
             __LIB_ARG(A1) char              *time
             /* __LIB_BASE */)
{
 struct PrivateURD *purd  = (struct PrivateURD *) urd;
 int                count = 0;
 ULONG              rc    = 0;

 /* Tokenize date/time string */
 {
  char *ap   = time;
  char **arg = purd->purd_DateTimeArray;
  char c;

  do {

   /* Skip white space */
   while ((c = *ap) && ((c == ' ') || (c == '\t'))) ap++;

   /* Store pointer to next argument */
   arg[count++] = ap;

   /* Skip to next white space */
   while ((c = *ap) && (c != ' ') && (c != '\t')) ap++;

   /* Append string terminator */
   *ap++ = '\0';

  } while (c && (count < MAXDATEARGS));
 }

 DEBUGLOG(kprintf("Time parse: %ld tokens\n", count);)

 /* Enough parameters? */
 if (count >= 4) {
  char **arg = purd->purd_DateTimeArray;
  char *dummy;

  /* Skip optional day of week field */
  if ((*arg)[strlen(*arg)-1] == ',') {
   arg++;
   count--;
  }

  DEBUGLOG(kprintf("Time parse: %ld tokens left\n", count);)

  /* Still enough parameters? */
  if (count >= 4) {
   struct ClockData *cd = &purd->purd_ClockData;

   /* Set day of week to 0 */
   cd->wday = 0;

   /* Get day of month */
   if (cd->mday = strtol(*arg++, &dummy, 10)) {

    DEBUGLOG(kprintf("Time parse: Month day %ld\n", cd->mday);)

    /* Set month to 0 */
    cd->month = 0;

    /* Get month */
    {
     int i = 0;

     do {

      /* Compare names */
      if (stricmp(*arg, Month[i++]) == 0) {
       cd->month = i;
       break;
      }

     } while (i < 12);
    }

    /* Month valid? */
    if (cd->month) {

     DEBUGLOG(kprintf("Time parse: Month %ld\n", cd->month);)

     /* Get year */
     ++arg;
     if (cd->year = strtol(*arg++, &dummy, 10)) {

      DEBUGLOG(kprintf("Time parse: Year %ld\n", cd->year);)

      /* Accept RFC 822 (2 digits) or RFC 1123 (4 digits) year format */
      if (cd->year < 100)
       /* RFC 822 format. Convert to real year number.               */
       /* A little hack for the year 2000. UNIX epoch starts at 1970 */
       cd->year += (cd->year < 70) ? 2000 : 1900;

      /* Get hour */
      cd->hour = strtol(*arg++, &dummy, 10);
      if ((cd->hour <= 24) && (*dummy == ':')) {

       DEBUGLOG(kprintf("Time parse: Hour %ld\n", cd->hour);)

       /* Get minute */
       cd->min = strtol(++dummy, &dummy, 10);
       if ((cd->min <= 59) && ((*dummy == ':') || (*dummy == '\0'))) {

        DEBUGLOG(kprintf("Time parse: Minute %ld\n", cd->min);)

        /* Get seconds (optional) */
        if (*dummy == ':')
         cd->sec = strtol(++dummy, &dummy, 10);
        else
         cd->sec = 0;

        /* Check seconds */
        if (cd->sec <= 59) {
         const struct Library *UtilityBase = purd->purd_Bases.urb_UtilityBase;

         DEBUGLOG(kprintf("Time parse: Seconds %ld\n", cd->sec);)

         /* Convert date/time to Amiga format */
         if (rc = CheckDate(cd)) {

          DEBUGLOG(kprintf("Time parse: Converted %lu\n", rc);)

          /* Convert to GMT (if time zone is specified) */
          if (count >= 5) {
           char ind, hour2, hour1, min2, min1;

           /* Pointer to time zone token */
           dummy = *arg;

           /* Check for correct <+/->HHMM format */
           if ((strlen(dummy) == 5)                          &&
               (((ind = *dummy++) == '+')  || (ind == '-'))  &&
               ((hour2 = *dummy++) >= '0') && (hour2 <= '9') &&
               ((hour1 = *dummy++) >= '0') && (hour1 <= '9') &&
               ((min2  = *dummy++) >= '0') && (min2  <= '9') &&
               ((min1  = *dummy)   >= '0') && (min1  <= '9'))

            /* Transform offset to seconds and substract it to the time */
            rc -= (((hour2 - '0') * 10 + hour1 - '0') * 60 +
                    (min2  - '0') * 10 + min1  - '0') * ((ind == '+') ?  60 :
                                                                        -60);
          }

          DEBUGLOG(kprintf("Time parse: GMT       %lu\n", rc);)

          /* Convert to local time */
          rc -= purd->purd_GMTOffset;

          DEBUGLOG(kprintf("Time parse: Local     %lu\n", rc);)
         }
        }
       }
      }
     }
    }
   }
  }
 }
 return(rc);
}
