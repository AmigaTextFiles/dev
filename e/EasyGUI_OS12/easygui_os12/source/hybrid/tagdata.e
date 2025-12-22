/* RST: hybrid "any kick" replacement for utility library GetTagData()

   Please do not redistribute modified versions of this code. If you have
   any ideas how to make things better contact me at metamonk@yahoo.com.

   Also, please do not distribute further 'hybrid/#?' modules since there
   is already a large amount of additional stuff in work. Contact me...

   This code is Copyright (c) 2000, Ralf 'hippie2000' Steines, and
   inherits the legal state from the original EasyGUI disctribution. */

-> shares utilitybase with caller

OPT MODULE
OPT EXPORT

MODULE 'utility',
       'utility/tagitem'

PROC getTagData(value,default,taglist:PTR TO LONG)
  DEF res,tag,data,found=FALSE
  IF utilitybase
    res:=GetTagData(value,default,taglist)
  ELSE
    IF taglist
      WHILE (tag:=taglist[]++) AND (found=FALSE)
        data:=taglist[]++
        IF tag=value THEN found:=TRUE
      ENDWHILE
    ENDIF
    res:=IF found THEN data ELSE default
  ENDIF
ENDPROC res
