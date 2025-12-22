/* RST: handy procedures to allow easy version sensitive coding

   Please do not redistribute modified versions of this code. If you have
   any ideas how to make things better contact me at metamonk@yahoo.com.

   Also, please do not distribute further 'hybrid/#?' modules since there
   is already a large amount of additional stuff in work. Contact me...

   This code is Copyright (c) 2000, Ralf 'hippie2000' Steines, and
   inherits the legal state from the original EasyGUI disctribution. */

-> shares gfxbase and intuitionbase with the caller.

OPT MODULE
OPT EXPORT

MODULE 'exec/libraries'

PROC libVersion(lib:PTR TO lib,minver) RETURN lib.version>=minver

PROC intuiVersion(minver) RETURN libVersion(intuitionbase,minver)

PROC gfxVersion(minver) RETURN libVersion(gfxbase,minver)
