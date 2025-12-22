/* RST: opening and closing utility library

   Please do not redistribute modified versions of this code. If you have
   any ideas how to make things better contact me at metamonk@yahoo.com.

   Also, please do not distribute further 'hybrid/#?' modules since there
   is already a large amount of additional stuff in work. Contact me...

   This code is Copyright (c) 2000, Ralf 'hippie2000' Steines, and
   inherits the legal state from the original EasyGUI disctribution. */

-> exports utilitybase to caller/other modules

OPT MODULE
OPT EXPORT

MODULE 'utility'

PROC openUtility()
  utilitybase:=OpenLibrary('utility.library',36)
ENDPROC

PROC closeUtility()
  IF utilitybase THEN CloseLibrary(utilitybase)
ENDPROC
