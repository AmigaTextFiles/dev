/* example of usage for DateStamp() and DateToStr() functions */
MODULE 'dos/datetime', 'dos/dos'

DEF dt:datetime,ds:PTR TO datestamp

/* these are filled by DateToStr() */
DEF day[50]:ARRAY,date[50]:ARRAY,time[50]:ARRAY

PROC main()

  /* get stamp in part of datetime structure */
  ds:=DateStamp(dt.stamp)

  WriteF('days=\d, minutes=\d, ticks=\d\n',ds.days,ds.minute,ds.tick)

  /* fill datetime structure */
  dt.format:=FORMAT_DOS
  dt.flags:=DTF_SUBST
  dt.strday:=day
  dt.strdate:=date
  dt.strtime:=time

  IF DateToStr(dt)
    WriteF('day=\s, date=\s, time=\s\n',day,date,time)
  ENDIF

ENDPROC
