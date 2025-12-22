
-> Copyright © 1995, Guichard Damien.

-> Label generator
-> Mostly an integer generator!

OPT MODULE
OPT EXPORT

OBJECT label_server PRIVATE
  label:LONG
ENDOBJECT

-> Reset.
PROC reset() OF label_server
  self.label:=0
ENDPROC

-> Next label
PROC next() OF label_server
  self.label:=self.label+1
ENDPROC self.label

