
MODULE 'exec/memory','dos/dos'

PROC main()

DEF n,m,a

IF arg[]
   IF (n:=Val(arg)) > 0
      a:=AvailMem(MEMF_LARGEST)
      IF n > a
         WriteF('number is to big\n')
         n:=a
      ENDIF
      IF (m:=AllocMem(n,MEMF_ANY))
         WriteF('allocating \d bytes\n'+
                'press CTRL-C to free memory\n',n)
         Wait(SIGBREAKF_CTRL_C)
         FreeMem(m,n)
      ENDIF
   ELSE
      WriteF('bad value\n')
   ENDIF
ELSE
   WriteF('USAGE: < size mem >\n')
ENDIF

ENDPROC



