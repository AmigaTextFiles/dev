
-> lexical tokens for compilers. Use connected with lexical analysers.

-> Copyright © Guichard Damien 01/04/1996

OPT MODULE
OPT EXPORT

MODULE 'fw/fastDictionary'

OBJECT token OF fastDictionary
  lexicalClass:LONG
ENDOBJECT

-> Creation method.
PROC newToken(name:PTR TO CHAR,class:LONG) OF token
  self.name:=name
  self.hashCode:=self.hash(name)
  self.lexicalClass:=class
ENDPROC

