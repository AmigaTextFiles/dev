
/*
 *  DATETOS.C
 *
 *  datetos(date, str, ctl)
 */

#include <local/typedefs.h>
#include <stdio.h>
#ifdef LATTICE
#include <string.h>
#endif

static char dim[12] = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
static char *Month[12] = { "Jan","Feb","Mar","Apr","May","Jun","Jul",
			   "Aug","Sep","Oct","Nov","Dec" };

char *
datetos(date, str, ctl)
DATESTAMP *date;
char *str;
char *ctl;
{
    long days, years;
    short leap, month;

    if (ctl == NULL)
	ctl = "D M Y h:m:s";
    days = date->ds_Days + 731; 	    /*	1976 (ly)       */
    years = days / (366+365*3);             /*  #quad yrs       */
    days -= years * (366+365*3);            /*  days remaining  */
					    /*	0 = jan 1	*/
    leap = (days <= 365);                   /*  0-365, is a leap yr */
    years = 1976 + 4 * years;		    /*	base yr 	*/
    if (leap == 0) {                        /*  days >= 366     */
	days -= 366;			    /*	add a year	*/
	++years;
	years += days / 365;		    /*	non-lyrs left	*/
	days  %= 365;			    /*	0-364		*/
    }
    for (month = 0; (month==1) ? (days >= 28 + leap) : (days >= dim[month]); ++month)
	days -= (month==1) ? (28 + leap) : dim[month];
    {
	register short i = 0;
	for (; *ctl; ++ctl) {
	    switch(*ctl) {
	    case 'h':
		sprintf(str+i, "%02d", date->ds_Minute / 60);
		break;
	    case 'm':
		sprintf(str+i, "%02d", date->ds_Minute % 60);
		break;
	    case 's':
		sprintf(str+i, "%02d", date->ds_Tick / 50 % 60);
		break;
	    case 'Y':
		sprintf(str+i, "%ld", years);
		break;
	    case 'M':
		strcpy(str+i, Month[month]);
		break;
	    case 'D':
		sprintf(str+i,"%2ld", days+1);
		break;
	    default:
		str[i] = *ctl;
		str[i+1] = 0;
		break;
	    }
	    i += strlen(str+i);
	}
    }
    return(str);
}

