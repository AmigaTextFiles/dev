MODULE 'oomodules/datetime'

PROC main()
    DEF dtclass:PTR TO date_time,day,date,time
    NEW dtclass
    day,date,time:=dtclass.date_time()
    WriteF('\s \s \s\n',day,date,time)
    END dtclass
    ENDPROC
