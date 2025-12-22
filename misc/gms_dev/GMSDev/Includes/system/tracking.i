	IFND SYSTEM_TRACKING_I
SYSTEM_TRACKING_I  SET  1

**
**  $VER: tracking.i V1.0
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved.
**

	IFND    DPKERNEL_I
	include 'dpkernel/dpkernel.i'
	ENDC

RES_EMPTY    =  0
RES_MEMORY   =  1      ;Memory allocation, lowest level resource type.
RES_COMPLEX  =  2      ;Complex allocation - (hardware and software).
RES_CUSTOM   =  3      ;Software allocation of a customised type.
RES_HARDWARE =  4      ;Hardware allocation.

   STRUCTURE	TRK,00
	APTR	trk_Next       ;Next in the chain.
	WORD	trk_ID         ;ID number of this resource (see above).
	LONG	trk_Key        ;Unique key for the resource.
	APTR	trk_Address    ;Address of object to free.
	APTR	trk_Routine    ;Routine that frees the object.
	LABEL	TRK_SIZEOF

  ENDC	;SYSTEM_TRACKING_I

