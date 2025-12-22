OPT TURBO

CONST FLOAT_MAX_AFT=8,
      FLOAT_MAX_STRING_LENGTH=9

PROC floatToString(string, float, maxAft)
  DEF fore, aft, aftString[FLOAT_MAX_AFT]:STRING
  fore:=SpFix(float)
  aft:=SpFix(SpMul(SpSub(SpFlt(SpFix(float)), float), 10000000.0))
  StringF(string, '\d.', fore)
  StringF(aftString, '\z\d[7]', aft)
  maxAft:=IF maxAft>FLOAT_MAX_AFT THEN FLOAT_MAX_AFT ELSE maxAft
  SetStr(aftString, maxAft)
  StrAdd(string, aftString, ALL)
ENDPROC string


