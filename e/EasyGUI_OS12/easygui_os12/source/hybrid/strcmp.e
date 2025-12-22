/* RST: hybrid "any kick" replacement for
   utility library Stricmp() and Strnicmp()

   Please do not redistribute modified versions of this code. If you have
   any ideas how to make things better contact me at metamonk@yahoo.com.

   Also, please do not distribute further 'hybrid/#?' modules since there
   is already a large amount of additional stuff in work. Contact me...

   This code is Copyright (c) 2000, Ralf 'hippie2000' Steines, and
   inherits the legal state from the original EasyGUI disctribution. */

-> shares utilitybase with caller

OPT MODULE
OPT EXPORT

MODULE 'utility'

PROC stricmp(str1,str2)
  DEF res
  IF utilitybase
    res:=Stricmp(str1,str2)
  ELSE
    res:=-OstrCmp(str1,str2)
  ENDIF
ENDPROC res

PROC strnicmp(str1,str2,len)
  DEF s1[256]:STRING,s2[256]:STRING,res
  IF utilitybase
    res:=Strnicmp(str1,str2,len)
  ELSE
    StrCopy(s1,str1)
    LowerStr(s1)
    StrCopy(s2,str2)
    LowerStr(s2)
    res:=-OstrCmp(s1,s2,len)
  ENDIF
ENDPROC res

