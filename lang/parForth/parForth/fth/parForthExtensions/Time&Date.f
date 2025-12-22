include? parForthExt.f parForthExt.f		\ using parForth instead of pForth

ANEW Time&Date.f

:STRUCT DateStamp		\ from jforth dos/dos.j
   LONG ds_Days			\ days from January 1, 1978
   LONG ds_Minute		\ minutes elapsed in the day	
   LONG ds_Tick			\ ticks elapsed in the current minute
;STRUCT
50 CONSTANT TICKS_PER_SECOND

:STRUCT DateTime		\ from jforth dos/datetime.j
	STRUCT DateStamp dat_Stamp
	UBYTE dat_Format
	UBYTE dat_Flags
	APTR dat_StrDay
	APTR dat_StrDate
	APTR dat_StrTime
;STRUCT
16   constant LEN_DATSTRING

0   constant DTB_SUBST
1   constant DTF_SUBST		\ provide day of week instead of StrDate
1   constant DTB_FUTURE
2   constant DTF_FUTURE

0   constant FORMAT_DOS		\ dd-mmm-yy
1   constant FORMAT_INT		\ yy-mmm-dd
2   constant FORMAT_USA		\ mm-dd-yy
3   constant FORMAT_CDN		\ dd-mm-yy

CREATE Time&Date$ 24 ALLOT									\ holds date & time strings
CREATE MyDateTime DateTime ALLOT							\ my DateTime structure

: _DateStamp ( &DateStamp -- ) 32 EXEC_DOSBASE CALL1NR ;	\ fill in given DateStamp structure
: _DateToStr ( &DateTime -- 0|n ) 124 EXEC_DOSBASE CALL1 ;	\ fill in initialized DateTime structure; 0 means failure

: >SECONDS ( ticks -- secs ) 50 / ;							\ convert ticks elapsed in current minute to seconds
: >HOUR    ( mins -- mins hour ) 60 /MOD ;					\ convert minutes elapsed in day to hour and minutes
: >DATE    ( -- dd mm yy ) Time&Date$ DUP 0$>$ COUNT		\ convert 0-terminated string to counted string
	3 0 DO 2DUP 3 I * /STRING VAL -ROT LOOP 2DROP 2000 + ;	\ day month yy

: TIME&DATE ( -- secs, mins, hour, day, month, year )	\ ANS Forth word
	MyDateTime _DateStamp								\ fill in the DateStamp structure of the DateTime structure
	FORMAT_CDN MyDateTime S! dat_Format					\ want dd-mm-yy format
	0          MyDateTime S! dat_Flags					\ no flags
	0          MyDateTime S! dat_StrDay					\ don't provide day of the week
	Time&Date$ MyDateTime S! dat_StrDate				\ place date string in our variable
	0          MyDateTime S! dat_StrTime				\ don't provide time$, we'll derive it from the DateStamp
	MyDateTime _DateToStr 0= ABORT" Invalid DateStamp"	\ fill in Time&Date$ with dd-mm-yy
	MyDateTime S@ ds_Tick    >SECONDS					\ secs
	MyDateTime S@ ds_Minute  >HOUR						\ secs mins hour
	>DATE ;												\ secs mins hour day month year
