/* MRDates.h - Declarations for types and variables used by MRDates. */

#ifndef _MRDATES_H
#define _MRDATES_H
typedef struct {
	int	Dyear;		/* year AD (e.g. 1987)	*/
	int	Dmonth;		/* month of year (0-11)	*/
	int	Dday;		/* day in month (1-31)	*/
	int Dhour;		/* 0-23                 */
	int Dminute;    /* 0-59                 */
	int Dsecond;    /* 0-59                 */
	int	Dweekday;	/* day of week (Sun=0)	*/
} MRDate;

typedef struct {
        char    *Mname;
        int     Mdays;
		} CalEntry;

#ifdef MRDATES
CalEntry calendar[12] = {
        { "Jan", 31 },   { "Feb", 28 },  { "Mar", 31 }, { "Apr", 30 },
        { "May", 31 },   { "Jun", 30 },  { "Jul", 31 }, { "Aug", 31 },
        { "Sep", 30 },   { "Oct", 31 },  { "Nov", 30 }, { "Dec", 31 }
	};
#else
extern CalEntry calendar[12];
#endif

#ifdef MRDATES
char *dayNames[7] = {
	"Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"
	};
#else
extern char *dayNames[7];
#endif

#endif
