->  options
->  *******
->  NOUSER, DELAY

OPT OSVERSION=37

    PROC main()
	DEF flag, template, r, args=NIL:PTR TO LONG, o, delay,
        waitstring[10]:STRING, temp

	flag:=0 ; template:='OPTIONS-> n = No UserStartup / d = DELAY/M' ; delay:='3' -> default
    r:=ReadArgs(template,{args},NIL)

->WriteF('\d\n',r)
         IF r
           IF args
             o:=0
             WHILE args[o]
               temp:=args[o]
               UpperStr(temp)

               IF StrCmp(temp,'N',6)
->           DisplayBeep(0)
                flag:=1
                ENDIF

                IF StrCmp(temp,'D')
                    o++
                    IF args[o]
                        delay:=args[o]
                      ELSE
                        WriteF('You forgot to specify the delay number !!!\n')
                        RETURN
                    ENDIF
                ENDIF

                o++
             ENDWHILE
           ENDIF
           FreeArgs(r)
         ENDIF
-> RETURN
    StrCopy(waitstring,'Wait ',5)
    StrAdd(waitstring,delay,ALL)

      exec('c:setpatch')
	exec('Rename sys:WBStartup sys:WBST')
	exec('Wait 1')
	exec('loadwb DELAY -DEBUG')

		IF FileLength('s:WB-startup')<>-1
			exec('execute s:WB-startup')
		ENDIF


	exec(waitstring)
	exec('Rename sys:WBST sys:WBStartup')
		
	IF flag=0

		IF FileLength('s:user-startup')<>-1 
			exec('execute s:user-startup')
		ENDIF

	ENDIF


ENDPROC



PROC exec(argum)

	Execute(argum,0,stdout)

ENDPROC

CHAR '$VER:1.0',0
