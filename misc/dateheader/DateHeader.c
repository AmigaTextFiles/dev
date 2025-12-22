/********************************************************
    DateHeader.c

    A program to create the current date in a format
    needed by AmigaDOS Version

    Program by Russ Steffen

    E-Mail: STEFFENR@UWSTOUT.EDU

*********************************************************/

#include <date.h>
#include <time.h>
#include <stdio.h>

/***** Note because of this, it can't be compiled unless a copy of
       date.h is already present. ********************************/

const char * const verTag = "\0$VER: DateHeader 37.1 " __AMIGADATE__ ;

void
main()
{
  time_t     timeDate;
  struct tm *localTime;
  char	     dateString[80];

  puts("/********************************************");
  puts(" date.h");
  puts(" Automatic Date Header");
  puts(" Created by DateHeader, a program by");
  puts(" Russ Steffen.");
  puts("********************************************/\n");

  timeDate = time(NULL);                  /* Get current date */

  localTime = localtime( &timeDate );     /* convert to useable format */

  strftime( dateString, (size_t)80,
	    "#define __AMIGADATE__ \"(%d.%m.%y)\"\n", localTime );

  puts( dateString );

  strftime( dateString, (size_t)80,
	    "#define __CREATION_DATE__ \"%A, %d %B %Y\"\n", localTime );

  puts( dateString );

  /**** Feel free to add any other date symbols you need *********/
}
