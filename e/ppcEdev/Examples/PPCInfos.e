
OPT PREPROCESS

MODULE  'exec/types','exec/libraries',
        'utility/tagitem','ppc','libraries/ppc'

DEF mytags:PTR TO tagitem,i,
    cpu:PTR TO LONG,
    cpustring:PTR TO LONG,
    cpucount:PTR TO LONG,
    cpuclock:PTR TO LONG,
    cpupll:PTR TO LONG,
    cpurev:PTR TO LONG

PROC main()
   IF (ppclibbase:=OpenLibrary('ppc.library',0))
      mytags[0].tag:=PPCINFOTAG_CPUCOUNT
      mytags[1].tag:=TAG_END
      cpucount:=PpCGetAttrs(mytags)
      FOR i:=0 TO cpucount
         mytags[0].tag:=PPCINFOTAG_CPU
         mytags[0].data:=i
         mytags[1].tag:=TAG_END
         cpu:=PpCGetAttrs(mytags)
         IF (cpu AND CPU_603)
            cpustring:='PPC603'
         ELSEIF (cpu AND CPU_604)
            cpustring:='PPC603'
         ELSEIF (cpu AND CPU_602)
            cpustring:='PPC603'
         ELSEIF (cpu AND CPU_603e)
            cpustring:='PPC603e'
         ELSEIF (cpu AND CPU_603p)
            cpustring:='PPC603p'
         ELSEIF (cpu AND CPU_604e)
            cpustring:='PPC604e'
         ELSE
            cpustring:='Unknown'
         ENDIF
      ENDFOR

      mytags[0].tag:=PPCINFOTAG_CPUCOUNT
      mytags[0].data:=i
      mytags[1].tag:=TAG_END
      cpucount:=PpCGetAttrs(mytags)

      mytags[0].tag:=PPCINFOTAG_CPUCLOCK
      mytags[0].data:=i
      mytags[1].tag:=TAG_END
      cpuclock:=PpCGetAttrs(mytags)

      mytags[0].tag:=PPCINFOTAG_CPUPLL
      mytags[0].data:=i
      mytags[1].tag:=TAG_END
      cpupll:=PpCGetAttrs(mytags)

      mytags[0].tag:=PPCINFOTAG_CPUREV
      mytags[0].data:=i
      mytags[1].tag:=TAG_END
      cpurev:=PpCGetAttrs(mytags)

      WriteF('CPU\d \s = \s, CPURev \s, CPUClock \s MHz, CPUPLL \s\s',i,cpu,cpustring,cpurev,cpuclock,cpupll)
   ELSE
      WriteF('Keine ppc.library zu öffnen !\n')
   ENDIF
ENDPROC
