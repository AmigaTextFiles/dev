
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/Calendar_mcc.h>
#include <string.h>
#include <stdio.h>

/***********************************************************************/

int
main(int argc,char **argv)
{
    struct Library *CalendarBase;
    int            res;

    if (CalendarBase = OpenLibrary(CALENDARNAME,CALENDARVER))
    {
        ULONG greg, d, m, y;
        char  buf[128];

        greg = CALGetToday();
        printf("     Today: %ld\n",greg);

        CALGregToDate(greg,&d,&m,&y);
        printf("      Date: %ld %ld %ld\n",d,m,y);

        CALFormatDate(NULL,buf,sizeof(buf),FORMTDATEFMT_SYSTEM,greg);
        printf(" Long date: %s\n",buf);

        CALFormatDate(NULL,buf,sizeof(buf),FORMTDATEFMT_SYSTEMSHORT,greg);
        printf("Short date: %s\n",buf);

        printf("   Weekday: %ld\n",CALGregWeekday(greg));
        printf("    Julian: %ld\n",CALGetJulian(greg));
        printf("      Week: %ld\n",(CALGetJulian(greg)/7)+1);

        CALGetEaster(y,&d,&m);
        greg = CALDateToGreg(d,m,y);
        CALFormatDate(NULL,buf,sizeof(buf),FORMTDATEFMT_SYSTEM,greg);
        printf("    Easter: %s\n",buf);

        CloseLibrary(CalendarBase);
        res = RETURN_OK;
    }
    else
    {
        printf("%s: Can't open %s %ld+",argv[0],CALENDARNAME,CALENDARVER);
        res = RETURN_ERROR;
    }

    return res;
}

/***********************************************************************/
