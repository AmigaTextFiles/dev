MODULE '*patternStringF'

PROC main() HANDLE
DEF pd=NIL:PTR TO pattern_data,
    hstri[256]:STRING

  WriteF('Started\n')
  pd:=createPatternData('PatternStringF(): %TIME %YEAR (%6PERCENT%%)',"%",
                        [PARGS_Type_String,  'TIME',    0,
                         PARGS_Type_Decimal, 'YEAR',    0,
                         PARGS_Type_Float,   'PERCENT', 2,
                         PARGS_Type_END]:pattern_arg)

  WriteF('Ok\n')
  WriteF('NEW formatstring: "\s"\n',pd.newformatstr)

  WriteF('"\s"\n',patternStringF(hstri,pd,['15.06 Uhr',1997,15.26]))

EXCEPT DO
  freePatternData(pd)

  IF exception
    WriteF('Error: \s (\d)\n',[exception,0]:LONG,exceptioninfo)
  ENDIF

ENDPROC


