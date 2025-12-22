PROC main()
DEF _fl1

WriteF('\n')
WriteF(' Welcome to \e[43m NoWBDoctor \e[40m !!!\n')
Delay(100)
WriteF('\n')

WriteF('Let''s see what''s wrong ...\n')
Delay(50)
WriteF('\n')

_fl1:=FileLength('sys:WBST')

IF _fl1<>-1 -> Exists ...
      exec('Rename sys:WBST sys:WBStartup')
      WriteF(' OK !! Problem located and solved ...\n')
      WriteF('Next time, *wait* for disk activity stop before reseting your great Amiga !\n\b')
ELSE
      WriteF('OOpps ! NoWb didn''t do nothing wrong ... It''s not its fault.\n')
      Delay(50)
      WriteF(' Anyway you may contact the author for help ...\n')
ENDIF

ENDPROC


PROC exec(argum)

	Execute(argum,0,stdout)

ENDPROC
