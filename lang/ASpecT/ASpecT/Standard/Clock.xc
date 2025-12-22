/* NO_RUSAGE_AVAIL should be defined iff getrusage is not available
   at your machine!
*/ 

#ifdef MAC
/* MacIntosh does not support getrusage ... */
#define NO_RUSAGE_AVAIL
#endif



#include <sys/types.h>
#include <sys/stat.h>
#include <sys/time.h>

#ifndef NO_RUSAGE_AVAIL

#include <sys/resource.h>
struct rusage STARTTIME,ENDTIME;

#endif

void
DEFUN(xx_Clocktime_0,(SysIn,Area,Ok,SysOut,Res),
      TERM  SysIn  AND
      TERM  Area   AND
      TERM *Ok     AND
      TERM *SysOut AND
      TERM *Res)
{
   time_t     * sys_time;
   struct tm  * time_struc;
   *SysOut = SysIn;
   *Ok = true;
   sys_time = (time_t *) time(NULL);
   if(OPN(Area)==_CDateTimelocal_0)
        time_struc = localtime(&sys_time);
   else time_struc = gmtime(&sys_time);
   *Res = co__DateTimetd_0(
	     Area,
	     co__Timetime_0((TERM)((*time_struc).tm_hour     ),
	                    (TERM)((*time_struc).tm_min      ),
	                    (TERM)((*time_struc).tm_sec      ) ),
	     co__Datedate_0((TERM)((*time_struc).tm_year+1900),
	                    (TERM)((*time_struc).tm_mon+1    ),
	                    (TERM)((*time_struc).tm_mday     ) ));
}


unsigned mode = 0;

#define sec(x) x.ru_utime.tv_sec
#define usec(x) x.ru_utime.tv_usec

TERM
DEFUN(xx_Clockstop_timer_0,(S),
      TERM S)
{ 
#ifndef NO_RUSAGE_AVAIL
  getrusage(RUSAGE_SELF,&ENDTIME);
  mode = 2; /* we are stopped */
#endif
  return S;
}

TERM
DEFUN(xx_Clockstart_timer_0,(S),
      TERM S)
{
#ifndef NO_RUSAGE_AVAIL
  getrusage(RUSAGE_SELF,&STARTTIME);
  mode = 1; /* we are running */
#endif
  return S;
}

void
DEFUN(xx_Clocklook_timer_0,(SI,SEC,HSEC,SO),
      TERM  SI   AND
      TERM *SEC  AND
      TERM *HSEC AND
      TERM *SO) 
{ *SO = SI;
#ifdef NO_RUSAGE_AVAIL
  *SEC = (TERM) 0;
  *HSEC = (TERM) 0;
#else
  if(mode==0) { *SEC = 0; *HSEC = 0; return; }
  if(mode==1) getrusage(RUSAGE_SELF,&ENDTIME);
  if(usec(ENDTIME)<usec(STARTTIME)) {
     *SEC = (TERM)(sec(ENDTIME)-sec(STARTTIME)-1);
     *HSEC = (TERM)((usec(ENDTIME)+1000000-usec(STARTTIME)) / 10000);
  } else {
     *SEC = (TERM)(sec(ENDTIME)-sec(STARTTIME));
     *HSEC = (TERM)((usec(ENDTIME)-usec(STARTTIME)) / 10000);
  }
#endif
}

void
DEFUN(xx_Clocktimer_available_0,(SI,ISIT,SO),
      TERM  SI   AND
      TERM *ISIT AND
      TERM *SO) 
{ *SO = SI;
#ifdef NO_RUSAGE_AVAIL
  *ISIT = false;
#else
  *ISIT = true;
#endif
}

void
DEFUN(xx_Clockmodify_time_0,(SysIn,Area,Name,Ok,SysOut,Res),
      TERM  SysIn  AND
      TERM  Area   AND
      TERM  Name   AND
      TERM *Ok     AND
      TERM *SysOut AND
      TERM *Res)
{
#ifndef MAC
   extern char * EXFUN(malloc,(unsigned));
#endif
   struct stat sys_time;
   struct tm   *time_struc;
   char        *FNC;
   int         ret;
   unsigned    LEN=(unsigned)Stringlength_0(CP(Name));
#ifdef NEED_STD_DECL
   extern void EXFUN(free,(char *));
#endif
   *SysOut = SysIn;
   *Ok = false;
   FNC = malloc(LEN+1);
   if (FNC == NULL) {
      free__RUNTIME_string(Name);
   } else {
      STRING_TERM_to_CHAR_ARRAY(Name,LEN,FNC);
      free__RUNTIME_string(Name);
      ret = stat(FNC,&sys_time);;
      free(FNC);
      if (ret==0)
             { *Ok = true;
               if(OPN(Area)==_CDateTimelocal_0)
                      time_struc = localtime(&sys_time.st_mtime);
               else   time_struc = gmtime(&sys_time.st_mtime);
	       *Res = co__DateTimetd_0(
	                Area,
	                co__Timetime_0((TERM)((*time_struc).tm_hour     ),
	                               (TERM)((*time_struc).tm_min      ),
	                               (TERM)((*time_struc).tm_sec      ) ),
	                co__Datedate_0((TERM)((*time_struc).tm_year+1900),
	                               (TERM)((*time_struc).tm_mon+1    ),
	                               (TERM)((*time_struc).tm_mday     ) ));
	     }
      else
        free_DateTime_time_area(Area);
   }
}


XINITIALIZE(Clock_Xinitialize,__XINIT_Clock)
