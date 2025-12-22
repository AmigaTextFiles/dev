
-> Copyright © 1995, Guichard Damien.

-> Unnamer is an artefact whose special purpose is to invalid
-> old names of renamed features.
-> Unnamer is invisible at user level (over to class level)

OPT MODULE
OPT EXPORT

MODULE '*strings'
MODULE '*feature'

-> feature unnamer
OBJECT unnamer OF feature
ENDOBJECT

-> Make old_name invalid.
PROC old_name(name) OF unnamer
  self.int:=hash(name)
  self.name:=name
ENDPROC

-> Has feature this final name in the class?
PROC has_final_name() OF unnamer IS FALSE

