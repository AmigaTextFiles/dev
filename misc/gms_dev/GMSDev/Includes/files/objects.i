	IFND FILES_OBJECTS_I
FILES_OBJECTS_I  SET  1

**
**  $VER: objects.i
**
**  Object definitions.
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved.
**
**

	IFND    DPKERNEL_I
	include 'dpkernel/dpkernel.i'
	ENDC

******************************************************************************
* Entry stucture for GetObjectList().

    STRUCTURE	ObjectEntry,0
	APTR	OE_Name           ;Pointer to the name, may be NULL.
	APTR	OE_Object         ;Object is returned here.
	LABEL	OE_SIZEOF

    STRUCTURE	DataHeader,0      ;Data header for each object.
	LONG	DH_Type           ;Type of object, eg STRC, CODE, DATA.
	LONG	DH_Next           ;Offset towards next object.
	LABEL	DH_Name           ;The name of the object.

******************************************************************************
* Object-File.

VER_OBJECTFILE  = 2
TAGS_OBJECTFILE = ((ID_SPCTAGS<<16)|ID_OBJECTFILE)

    STRUCTURE	OBJ,HEAD_SIZEOF
	APTR	OBJ_Source
	APTR	OBJ_Config

OBJA_Source = (TAPTR|OBJ_Source)
OBJA_Config = (TAPTR|OBJ_Config)

  ENDC ;FILES_OBJECTS_I
