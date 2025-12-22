/* RST: hybrid "any kick" replacement for exec library
   CreateMsgPort() and DeleteMsgPort()

   Please do not redistribute modified versions of this code. If you have
   any ideas how to make things better contact me at metamonk@yahoo.com.

   Also, please do not distribute further 'hybrid/#?' modules since there
   is already a large amount of additional stuff in work. Contact me...

   This code is Copyright (c) 2000, Ralf 'hippie2000' Steines, and
   inherits the legal state from the original EasyGUI disctribution. */

OPT MODULE
OPT EXPORT

MODULE 'amigalib/ports'

PROC createMsgPort()
  DEF port
  IF KickVersion(36) THEN port:=CreateMsgPort() ELSE port:=createPort(0,0)
ENDPROC port

PROC deleteMsgPort(port)
  IF KickVersion(36) THEN DeleteMsgPort(port) ELSE deletePort(port)
ENDPROC
