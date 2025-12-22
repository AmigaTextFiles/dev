#ifndef LIBRARIES_CALENDAR_MCC_H
#define LIBRARIES_CALENDAR_MCC_H

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

/*
**  $VER: Calendar_mcc.h 18.3 (27.7.2005)
**  Includes Release 18.3
**
**  Calendar_mcc.h
**  Calendar shared library
**
**  Written by Alfonso Ranieri <alforan@tin.it>.
**  All Rights Reserved
*/

/***********************************************************************/
/*
** Library
*/

#define CALENDARNAME "MUI/Calendar.mcc"
#define CALENDARVER  18

/***********************************************************************/

#define MINGREG  2353660
#define MAXGREG  2597988
#define MINYEAR  1732
#define MAXYEAR  2400
#define TODAYOFS 2443510

/***********************************************************************/

#define FORMTDATEFMT_SYSTEM         ((char *)(0))
#define FORMTDATEFMT_SYSTEMSHORT    ((char *)(1))

/***********************************************************************/

#endif /* LIBRARIES_CALENDAR_MCC_H */
