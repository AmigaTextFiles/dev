	IFND	MISC_CONFIG_H
MISC_CONFIG_H	SET  1

**
**  $VER: config.i V1.0
**
**  Configuration Object.
**
**  (C) Copyright 1998 DreamWorld Productions.
**      All Rights Reserved.
**

***************************************************************************
* Config Object.

VER_CONFIG  = 1
TAGS_CONFIG = ((ID_SPCTAGS<<16)|ID_CONFIG)

   STRUCTURE	CNF,HEAD_SIZEOF   ;[00] Standard header.
	APTR	CNF_Source        ;[12] Source of config data.
	APTR	CNF_Entries       ;[16] Pointer to config data.
	LONG	CNF_AmtEntries    ;[20] Amount of configuration entries.

  ENDC  ;MISC_CONFIG_H
