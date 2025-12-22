/*
    MRDates - AmigaDOS date support routines.
    07/03/88

    This package is a hybrid of code from Thad Floryan, Doug Merrit and
    myself.  I wanted a reliable set of AmigaDOS date conversion routines
    and this combination seems to work pretty well.  The star of the show
    here is Thad's algorithm for converting the "days elapsed" field of
    an AmigaDOS DateStamp, using an intermediate Julian date format.  I
    lifted/embellished some of the data structures from Doug's ShowDate
    package and wrote the DateToDS function.

    History:    (most recent change first)

    12/31/88 -MRR-
        StrToDS was not handling the null string properly.

    11/01/88 -MRR- Added Unix-style documentation.

    07/03/88 - Changed some names:
                  Str2DS => StrToDS
                  DS2Str => DSToStr
 */

#define MRDATES
#include "MRDates.h"
#include <exec/types.h>
#include <ctype.h>


char *index();

#define DATE_SEPARATORS     "/:-."
#define MINS_PER_HOUR       60
#define SECS_PER_MIN        60
#define SECS_PER_HOUR       (SECS_PER_MIN * MINS_PER_HOUR)
#define TICS_PER_SEC        50

#define YEARS_PER_CENTURY   100


/*
   definitions to calculate current date
 */
#define FEB             1   /* index of feb. in table (for leap years) */
#define DAYS_PER_WEEK   7
#define DAYS_PER_YEAR   365
#define YEARS_PER_LEAP  4
#define START_YEAR      1978
#define FIRST_LEAP_YEAR 1980
#define LEAP_ADJUST     (FIRST_LEAP_YEAR - START_YEAR)
#define LEAP_FEB_DAYS   29
#define NORM_FEB_DAYS   28
#define IsLeap(N)       (((N) % YEARS_PER_LEAP) ? 0 : 1)


/*  FUNCTION
        DSToDate - convert a DateStamp to an MRDate.

    SYNOPSIS
        int DSToDate(dateStamp, date)
            struct DateStamp *dateStamp;
            MRDate *date;

    DESCRIPTION
      Extracts the date components from an AmigaDOS datestamp.
      The calculations herein use the following assertions:

      146097 = number of days in 400 years per 400 * 365.2425 = 146097.00
       36524 = number of days in 100 years per 100 * 365.2425 =  36524.25
        1461 = number of days in   4 years per   4 * 365.2425 =   1460.97

    AUTHOR
      Thad Floryan, 12-NOV-85
      Mods by Mark Rinfret, 04-JUL-88

    SEE ALSO
        Include file MRDates.h.

 */

#define DDELTA 722449   /* days from Jan.1,0000 to Jan.1,1978 */

static int mthvec[] =
   {-1, -1, 30, 58, 89, 119, 150, 180, 211, 242, 272, 303, 333, 364};

int
DSToDate(ds, date)
    long *ds; MRDate *date;

{

    long jdate, day0, day1, day2, day3;
    long year, month, day, temp;

    jdate = ds[0] + DDELTA;      /* adjust internal date to Julian */

    year = (jdate / 146097) * 400;
    day0  = day1 = jdate %= 146097;
    year += (jdate / 36524) * 100;
    day2  = day1 %= 36524;
    year += (day2 / 1461) * 4;
    day3  = day1 %= 1461;
    year += day3 / 365;
    month = 1 + (day1 %= 365);
    day = month % 30;
    month /= 30;

    if ( ( day3 >= 59 && day0 < 59 ) ||
        ( day3 <  59 && (day2 >= 59 || day0 < 59) ) )
      ++day1;

    if (day1 > mthvec[1 + month]) ++month;
    day = day1 - mthvec[month];
    date->Dyear = year;
    date->Dmonth = month;
    date->Dday = day;
    date->Dweekday = ds[0] % DAYS_PER_WEEK;

    temp = ds[1];               /* get ds_Minute value */
    date->Dhour = temp / MINS_PER_HOUR;
    date->Dminute = temp % MINS_PER_HOUR;
    date->Dsecond = ds[2] / TICS_PER_SEC;
    return 0;
}

/*  FUNCTION
        DateToDS(date, dateStamp)

    SYNOPSIS
        void DateToDS(date, dateStamp)
             MRDate *date;
             struct DateStamp *dateStamp;

    DESCRIPTION
        DateToDS converts the special MRDate format to a DateStamp.
 */

DateToDS(date, ds)
    MRDate *date; long *ds;
{
    long daysElapsed, yearsElapsed, leapYears, thisMonth, thisDay, thisYear;
    int month;

    /* Note the special handling for year < START_YEAR.  In this case,
     * the other fields are not even checked - the user just gets the
     * "start of time".
     */
    if ((thisYear = date->Dyear) < START_YEAR) {
        ds[0] = ds[1] = ds[2] = 0;
        return;
    }
    if (IsLeap(thisYear))
        calendar[FEB].Mdays = LEAP_FEB_DAYS;

    thisDay = date->Dday - 1;
    thisMonth = date->Dmonth -1;
    yearsElapsed = thisYear - START_YEAR;
    leapYears = (yearsElapsed + LEAP_ADJUST -1) / YEARS_PER_LEAP;
    daysElapsed = (yearsElapsed * DAYS_PER_YEAR) + leapYears;
    for (month = 0; month < thisMonth; ++month)
        daysElapsed += calendar[month].Mdays;
    daysElapsed += thisDay;
    calendar[FEB].Mdays = NORM_FEB_DAYS;
    ds[0] = daysElapsed;
    ds[1] = date->Dhour * MINS_PER_HOUR + date->Dminute;
    ds[2] = date->Dsecond * TICS_PER_SEC;
}
/*  FUNCTION
        CompareDS - compare two DateStamp values.

    SYNOPSIS
        int CompareDS(date1, date2)
            struct DateStamp *date1, *date2;

    DESCRIPTION
        CompareDS performs an ordered comparison between two DateStamp
        values, returning the following result codes:

            -1 => date1 < date2
             0 => date1 == date2
             1 => date1 > date2

    NOTE:
        This routine makes an assumption about the DateStamp structure,
        specifically that it can be viewed as an array of 3 long integers
        in days, minutes and ticks order.
 */

int
CompareDS(d1, d2)
    long *d1, *d2;
{
    USHORT i;
    long compare;

    for (i = 0; i < 3; ++i) {
        if (compare = (d1[i] - d2[i])) {
            if (compare < 0) return -1;
            return 1;
        }
    }
    return 0;                       /* dates match */
}

/*  FUNCTION
        DSToStr - convert a DateStamp to a formatted string.

    SYNOPSIS
        void DSToStr(str,fmt,d)
             char *str, *fmt;
             struct DateStamp *d;

    DESCRIPTION
        DSToStr works a little like sprintf.  It converts a DateStamp
        to an ascii formatted string.  The formatting style is dependent
        upon the contents of the format string, fmt, passed to this
        function.

        The content of the format string is very similar to that
        for printf, with the exception that the following letters
        have special significance:
            y => year minus 1900
            Y => full year value
            m => month value as integer
            M => month name
            d => day of month (1..31)
            D => day name ("Monday".."Sunday")
            h => hour in twenty-four hour notation
            H => hour in twelve hour notation
            i => 12 hour indicator for H notation (AM or PM)
            I => same as i
            n => minutes    (sorry...conflict with m = months)
            N => same as n
            s => seconds
            S => same as s

        All other characters are passed through as part of the normal
        formatting process.  The following are some examples with
        Saturday, July 18, 1987, 13:53 as an input date:

            "%y/%m/%d"          => 87/7/18
            "%02m/%02d/%2y"     => 07/18/87
            "%D, %M %d, %Y"     => Saturday, July 18, 1987
            "%02H:%02m i"       => 01:53 PM
            "Time now: %h%m"    => Time now: 13:53

 */
void
DSToStr(str,fmt,d)
    char *str, *fmt; long *d;
{
    MRDate date;
    char fc,*fs,*out;
    USHORT ivalue;
    char new_fmt[256];          /* make it big to be "safe" */
    USHORT new_fmt_lng;
    char *svalue;

    DSToDate(d, &date);         /* convert DateStamp to MRDate format */

    *str = '\0';                /* insure output is empty */
    out = str;
    fs = fmt;                   /* make copy of format string pointer */

    while (fc = *fs++) {        /* get format characters */
        if (fc == '%') {        /* formatting meta-character? */
            new_fmt_lng = 0;
            new_fmt[new_fmt_lng++] = fc;
            /* copy width information */
            while (isdigit(fc = *fs++) || fc == '-')
                new_fmt[new_fmt_lng++] = fc;

            switch (fc) {       /* what are we trying to do? */
            case 'y':           /* year - 1980 */
                ivalue = date.Dyear % 100;
write_int:
                new_fmt[new_fmt_lng++] = 'd';
                new_fmt[new_fmt_lng] = '\0';
                sprintf(out,new_fmt,ivalue);
                out = str + strlen(str);
                break;
            case 'Y':           /* full year value */
                ivalue = date.Dyear;
                goto write_int;

            case 'm':           /* month */
                ivalue = date.Dmonth;
                goto write_int;

            case 'M':           /* month name */
                svalue = calendar[date.Dmonth - 1].Mname;
write_str:
                new_fmt[new_fmt_lng++] = 's';
                new_fmt[new_fmt_lng] = '\0';
                sprintf(out,new_fmt,svalue);
                out = str + strlen(str);
                break;

            case 'd':           /* day */
                ivalue = date.Dday;
                goto write_int;

            case 'D':           /* day name */
                svalue = dayNames[d[0] % DAYS_PER_WEEK];
                goto write_str;

            case 'h':           /* hour */
                ivalue = date.Dhour;
                goto write_int;

            case 'H':           /* hour in 12 hour notation */
                ivalue = date.Dhour;
                if (ivalue >= 12) ivalue -= 12;
                goto write_int;

            case 'i':           /* AM/PM indicator */
            case 'I':
                if (date.Dhour >= 12)
                    svalue = "PM";
                else
                    svalue = "AM";
                goto write_str;

            case 'n':           /* minutes */
            case 'N':
                ivalue = date.Dminute;
                goto write_int;

            case 's':           /* seconds */
            case 'S':
                ivalue = date.Dsecond;
                goto write_int;

            default:
                /* We are in deep caca - don't know what to do with this
                 * format character.  Copy the raw format string to the
                 * output as debugging information.
                 */
                new_fmt[new_fmt_lng++] = fc;
                new_fmt[new_fmt_lng] = '\0';
                strcat(out, new_fmt);
                out = out + strlen(out);    /* advance string pointer */
                break;
            }
        }
        else
            *out++ = fc;        /* copy literal character */
    }
    *out = '\0';                /* terminating null */
}

/*  FUNCTION
        StrToDS - convert a string to a DateStamp.

    SYNOPSIS
        int StrToDS(string, date)
            char *string;
            struct DateStamp *date;

    DESCRIPTION
        StrToDS expects its string argument to contain a date in
        MM/DD/YY HH:MM:SS format.  The time portion is optional.
        StrToDS will attempt to convert the string to a DateStamp
        representation.  If successful, it will return 0.  On
        failure, a 1 is returned.

 */

int
StrToDS(str, d)
    char *str; long *d;
{
    register char c;
    int count;
    int i, item;
    MRDate date;              /* unpacked DateStamp */
    char *s;

    int values[3];
    int value;

    s = str;
    for (item = 0; item < 2; ++item) {  /* item = date, then time */
        for (i = 0; i < 3; ++i) values[i] = 0;
        count = 0;
        while (c = *s++) {          /* get date value */
            if (c <= ' ')
                break;

            if (isdigit(c)) {
                value = 0;
                do {
                    value = value*10 + c - '0';
                    c = *s++;
                } while (isdigit(c));
                if (count == 3) {
    bad_value:
#ifdef DEBUG
                    puts("Error in date-time format.\n");
                    printf("at %s: values(%d) = %d, %d, %d\n",
                        s, count, values[0], values[1], values[2]);
#endif
                    return 1;
                }
                values[count++] = value;
                if (c <= ' ')
                    break;
            }
            else if (! index(DATE_SEPARATORS, c) )
                goto bad_value;     /* Illegal character - quit. */
        }                           /* end while */
        if (item) {                 /* Getting time? */
            date.Dhour = values[0];
            date.Dminute = values[1];
            date.Dsecond = values[2];
        }
        else {                      /* Getting date? */

/* It's OK to have a null date string, but it's not OK to specify only
   1 or 2 of the date components.
 */
            if (count && count != 3)
                goto bad_value;
            date.Dmonth = values[0];
            date.Dday = values[1];
            date.Dyear = values[2];
            if (date.Dyear == 0) {
                date.Dyear = START_YEAR;
                date.Dday = 1;
            }
            else {
                if (date.Dyear < (START_YEAR - 1900) )
                    date.Dyear += 100;
                date.Dyear += 1900;
            }
        }
    }                               /* end for */
    DateToDS(&date, d);
    return 0;
}                                   /* StrToDS */


#ifdef DEBUG
#include "stdio.h"
main(ac, av)
    int ac;
    char    **av;
{
    long    datestamp[3];           /* A little dangerous with Aztec */
    long    datestamp2[3];
    MRDate    date, oldDate;
    long    day, lastDay;
    int     errors = 0;

    /*
     * display results from DateStamp() (hours:minutes:seconds)
     */
    DateStamp(datestamp);

    /*
     * display results from DSToDate() (e.g. "03-May-88")
     */
    DSToDate(datestamp, &date);
    printf("Current date: %02d-%s-%02d\n",
        date.Dday, calendar[ date.Dmonth - 1].Mname,
        (date.Dyear % YEARS_PER_CENTURY));

    printf("Current time: %02d:%02d:%02d\n",
        date.Dhour, date.Dminute, date.Dsecond);

    printf("\nDoing sanity check through year 2000...\n\t");
    lastDay = (2000L - START_YEAR) * 365L;
    lastDay += (2000L - START_YEAR) / YEARS_PER_LEAP;
    for (day = 0; day <= lastDay; ++day) {
        if (day % 1000 == 0) {
            printf(" %ld", day);
            fflush(stdout);
        }
        datestamp[0] = day;
        datestamp[1] = MINS_PER_HOUR - 1;
        datestamp[2] = TICS_PER_SEC * (SECS_PER_MIN - 1);
        DSToDate(datestamp, &date);
        if (day && date == oldDate) {
            printf("Got same date for days %d, %d: %02d-%s-%02d\n",
                    day - 1, day,
                    date.Dday,
                    calendar[ date.Dmonth - 1 ].Mname,
                    (date.Dyear % YEARS_PER_CENTURY));

            if (++errors == 10)
                exit(1);
        }
        DateToDS(&date, datestamp2);
        if (day != datestamp2[0]) {
            printf("\nConversion mismatch at day %ld!\n", day);
            printf("\tBad value = %ld", datestamp2[0]);
            printf("\tDate: %02d-%s-%02d\n",
                    date.Dday,
                    calendar[ date.Dmonth  -1 ].Mname,
                    (date.Dyear % YEARS_PER_CENTURY));
            if (++errors == 10)
                exit(1);
        }
        oldDate = date;
    }
    printf("\nSanity check passed.\n");
} /* main() */
#endif

