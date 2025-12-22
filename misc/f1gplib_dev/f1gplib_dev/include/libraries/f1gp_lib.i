	IFND LIBRARIES_F1GP_LIB_I
LIBRARIES_F1GP_LIB_I SET 1
**
**	$VER: f1gp_lib.i 36.1 (10.11.99)
**
**	(C) Copyright 1995-1999 Oliver Roberts
**	All Rights Reserved
**

   IFND    EXEC_TYPES_I
   include 'exec/types.i'
   ENDC

   LIBINIT

   LIBDEF _LVOf1gpDetect
   LIBDEF _LVOf1gpCalcChecksum
   LIBDEF _LVOf1gpRequestNotification
   LIBDEF _LVOf1gpStopNotification
   LIBDEF _LVOf1gpGetDisplayInfo

** OBSOLETE -- Please use the new notification functions instead

   LIBDEF _LVOf1gpAllocQuitNotify
   LIBDEF _LVOf1gpFreeQuitNotify

   ENDC		; LIBRARIES_F1GP_LIB_I
