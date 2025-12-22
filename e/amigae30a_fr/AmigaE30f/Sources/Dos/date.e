/* exemple d'utilisation des fonctions DateStamp() et DateToStr() */

MODULE 'dos/datetime', 'dos/dos'

DEF dt:datetime,ds:PTR TO datestamp

/* Ils vont être remplis par DateToStr() */
DEF day[50]:ARRAY,date[50]:ARRAY,time[50]:ARRAY

PROC main()

  /* reçoit le "stamp" de la structure datetime */
  ds:=DateStamp(dt.stamp)

  WriteF('jours=\d, minutes=\d, ticks=\d\n',ds.days,ds.minute,ds.tick)

  /* remplit la structure datetime */
  dt.format:=FORMAT_DOS
  dt.flags:=DTF_SUBST
  dt.strday:=day
  dt.strdate:=date
  dt.strtime:=time

  IF DateToStr(dt)
    WriteF('jour=\s, date=\s, heure=\s\n',day,date,time)
  ENDIF

ENDPROC
