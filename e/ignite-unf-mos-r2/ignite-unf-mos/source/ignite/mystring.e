OPT MODULE, EXPORT, PREPROCESS

MODULE 'utility/tagitem'
MODULE 'utility/hooks'
MODULE 'intuition/intuition'
MODULE 'intuition/intuitionbase'
MODULE 'libraries/mui'
MODULE 'libraries/muip'
MODULE 'muimaster'

PROC floatStringObject(content:DOUBLE, oid=NIL)
   DEF so, str[50]:STRING
   RealF(str, content, 6)
   so := StringObject,StringFrame,
      MUIA_String_MaxLen, 32,
      MUIA_String_Contents, str,
      IF oid THEN MUIA_ObjectID ELSE TAG_IGNORE, oid,
      MUIA_String_Accept, '0123456789.-',
      End
ENDPROC so

PROC getStringFloat(strobj) (DOUBLE)
   DEF t, d:DOUBLE
   get(strobj, MUIA_String_Contents, {t})
   d := RealVal(t)
ENDPROC d

PROC setStringFloat(strobj, d:DOUBLE)
   DEF str[50]:STRING
   RealF(str, d, 9)
   nnset(strobj, MUIA_String_Contents, str)
ENDPROC

PROC setTextFloat(strobj, d:DOUBLE)
   DEF str[50]:STRING
   RealF(str, d, 9)
   nnset(strobj, MUIA_Text_Contents, str)
ENDPROC

