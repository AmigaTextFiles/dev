OPT MODULE

MODULE 'dos/datetime','dos/dos'

EXPORT OBJECT date_time
    PRIVATE
    day[50]:ARRAY
    date[50]:ARRAY
    time[50]:ARRAY
    ENDOBJECT

PROC date_time() OF date_time
    DEF dt:datetime,ds:PTR TO datestamp
    ds:=DateStamp(dt.stamp)
    dt.format:=FORMAT_DOS
    dt.flags:=DTF_FUTURE
    dt.strday:=self.day
    dt.strdate:=self.date
    dt.strtime:=self.time
    DateToStr(dt)
    ENDPROC self.day,self.date,self.time

PROC date() OF date_time
    self.date_time()
    ENDPROC self.date

PROC day() OF date_time
    self.date_time()
    ENDPROC self.day

PROC time() OF date_time
    self.date_time()
    ENDPROC self.time

PROC end() OF date_time
    Dispose(self.day)
    Dispose(self.date)
    Dispose(self.time)
    ENDPROC

