	IFND SYSTEM_SYSOBJECT_I
SYSTEM_SYSOBJECT_I  SET  1

**
**	$VER: sysobject.i
**
**	(C) Copyright 1996-1998 DreamWorld Productions.
**	    All Rights Reserved
**

	IFND	DPKERNEL_I
	include	'dpkernel/dpkernel.i'
	ENDC

******************************************************************************
* The SysObject structure.

VER_SYSOBJECT  = 2
TAGS_SYSOBJECT = ((ID_SPCTAGS<<16)|ID_SYSOBJECT)

   STRUCTURE	SysObject,HEAD_SIZEOF
	APTR	SO_Prev          ;Previous object in the list.
	APTR	SO_Next          ;Next object in the list.
	WORD	SO_ObjectID      ;ID for the object (eg ID_PICTURE, ID_HIDDEN).
	WORD	SO_ClassID       ;ID for the class.
	APTR	SO_Name          ;String pointer to the name of this object.
	APTR	SO_CopyToUnv     ;> Copy to universe.
	APTR	SO_CopyFromUnv   ;> Copy from universe.
	APTR	SO_CheckFile     ;> Check for file recognition.
	APTR	SO_Load          ;> Load a file that belongs to this object.
	APTR	SO_Show          ;> Make an object visible to the user.
	APTR	SO_Get           ;> Get object.
	APTR	SO_Free          ;> Free object.
	APTR	SO_Init          ;> Initialise object.
	APTR	SO_Read          ;> Read some data from the object.
	APTR	SO_Write         ;> Write some data to the object.
	APTR	SO_Rename        ;> Rename an object.
	APTR	SO_Hide          ;> Hide/Remove the object from the display.
	APTR	SO_yy03          ;>
	APTR	SO_SaveToFile    ;> Save this entire object as a file.
	APTR	SO_Query         ;> Query the information held on this object.
	APTR	SO_Activate      ;> Perform the native action for this object.
	APTR	SO_Deactivate    ;> End the native action for this object.
	APTR	SO_Draw          ;> Draw an object inside its container.
	APTR	SO_Clear         ;> Clear an object from its container.
	APTR	SO_Reset         ;> Reset the object.
	APTR	SO_Flush         ;> Flush any buffered data in the object.
	APTR	SO_TagTrigger    ;> Special routine handled by TagInit().
	APTR	SO_Master        ;Reference to master if this is a child.
	APTR	SO_FieldArray    ;Array for field orientation support.
	APTR	SO_Unlock        ;> Unlock an object.
	APTR	SO_DetachParent  ;> Detach a parent from a child.
	APTR	SO_DetachChild   ;> Detach a child from a parent.
	APTR	SO_Unhook        ;> Unhook an object from a chain.
	APTR	SO_MoveToBack    ;> Move the position of an object to the back.
	APTR	SO_MoveToFront   ;> Move the position of an object to the back.
	APTR	SO_FileExtension ;Pointer to the file extension string.
	APTR	SO_FileDesc      ;Pointer to a description of the file type.
	APTR	SO_Copy          ;>
	APTR	SO_Lock          ;>
	APTR	SO_Seek          ;>
	APTR	SO_AttemptExclusive ;>
	APTR	SO_FieldSize     ;The size of each field entry in the array.
	APTR	SO_FreeExclusive ;>
	WORD	SO_FieldTotal    ;The total of listed fields in the array.
	WORD	SO_ClassVersion  ;The version of the object being represented.
	LONG	SO_ObjectSize    ;The byte size of the object structure.

SOA_CopyToUnv        = TAPTR|SO_CopyToUnv
SOA_CopyFromUnv      = TAPTR|SO_CopyFromUnv
SOA_CheckFile        = TAPTR|SO_CheckFile
SOA_Load             = TAPTR|SO_Load
SOA_Show             = TAPTR|SO_Show
SOA_Get              = TAPTR|SO_Get
SOA_Free             = TAPTR|SO_Free
SOA_Init             = TAPTR|SO_Init
SOA_Read             = TAPTR|SO_Read
SOA_Write            = TAPTR|SO_Write
SOA_Rename           = TAPTR|SO_Rename
SOA_Hide             = TAPTR|SO_Hide
SOA_yy03             = TAPTR
SOA_SaveToFile       = TAPTR|SO_SaveToFile
SOA_Query            = TAPTR|SO_Query
SOA_Activate         = TAPTR|SO_Activate
SOA_Deactivate       = TAPTR|SO_Deactivate
SOA_Draw             = TAPTR|SO_Draw
SOA_Clear            = TAPTR|SO_Clear
SOA_Reset            = TAPTR|SO_Reset
SOA_Flush            = TAPTR|SO_Flush
SOA_TagTrigger       = TAPTR|SO_TagTrigger
SOA_Master           = TAPTR|SO_Master
SOA_FieldArray       = TAPTR|SO_FieldArray
SOA_Unlock	     = TAPTR|SO_Unlock
SOA_DetachParent     = TAPTR|SO_DetachParent
SOA_DetachChild      = TAPTR|SO_DetachChild
SOA_Unhook           = TAPTR|SO_Unhook
SOA_MoveToBack       = TAPTR|SO_MoveToBack
SOA_MoveToFront      = TAPTR|SO_MoveToFront
SOA_FileExtension    = TAPTR|SO_FileExtension
SOA_FileDesc         = TAPTR|SO_FileDesc
SOA_Copy             = TAPTR|SO_Copy
SOA_Lock             = TAPTR|SO_Lock
SOA_Seek             = TAPTR|SO_Seek
SOA_AttemptExclusive = TAPTR|SO_AttemptExclusive
SOA_FieldSize        = TLONG|SO_FieldSize
SOA_FreeExclusive    = TAPTR|SO_FreeExclusive
SOA_FieldTotal       = TWORD|SO_FieldTotal
SOA_ClassVersion     = TWORD|SO_ClassVersion
SOA_ObjectSize       = TLONG|SO_ObjectSize

****************************************************************************
* Structure for field orientation.

   STRUCTURE	FLD,0
	APTR	FLD_Name     ;The english name for the field, e.g. "Width".
	WORD	FLD_Offset   ;The field's position in the object structure.
	WORD	FLD_FieldID  ;Provides a fast way of finding fields, eg FID_WIDTH.
	LONG	FLD_Flags    ;Special flags that describe the field.
	LONG	FLD_MinRange ;Minimum value for this field (for debugging).
	LONG	FLD_MaxRange ;Maximum value for this field (for debugging).

FDF_BYTE      = $10000000    ;Field is byte sized.
FDF_WORD      = $20000000    ;Field is word sized.
FDF_LONG      = $40000000    ;Field is long sized.
FDF_QUAD      = $80000000    ;Field is 2xlong sized.

FD_OBJECT     = $00000001
FD_CHILD      = $00000002
FD_STRING     = $00000004
FD_POINTER    = $00000008
FD_BYTEARRAY  = $00000010
FD_WORDARRAY  = $00000020
FD_LONGARRAY  = $00000040
FD_SOURCE     = $00000800

FDF_OBJECT    = $40000009  ;Field refers to another object.
FDF_CHILD     = $4000000A  ;Field refers to a child object.
FDF_STRING    = $4000000C  ;Field points to a string.
FDF_POINTER   = $40000008  ;Field is an address pointer.
FDF_BYTEARRAY = $40000018  ;Points to an array of bytes.
FDF_WORDARRAY = $40000028  ;Points to an array of words.
FDF_LONGARRAY = $40000048  ;Points to an array of longs.
FDF_UNSIGNED  = $00000080  ;Field is unsigned (no negatives).
FDF_RANGE     = $00000100  ;Enforce range limitations.
FDF_FLAGS     = $00000200  ;Field contains flags.
FDF_HEX       = $00000400  ;Field is in hexadecimal.
FDF_SOURCE    = $40000808
FDF_LOOKUP    = $00001000  ;Lookup names for values in this field.

***************************************************************************
* Field ID's.

FID_Flags      = 1
FID_Source     = 2
FID_ScrHeight  = 3
FID_ScrWidth   = 4
FID_ScrMode    = 5
FID_Width      = 6
FID_Height     = 7
FID_Size       = 8
FID_Data       = 9
FID_Array      = 10
FID_MaxSize    = 11
FID_Parent     = 12
FID_Child      = 13
FID_Restore    = 14
FID_MemType    = 15
FID_Planes     = 16
FID_AmtColours = 17
FID_Palette    = 18
FID_LineMod    = 19
FID_PlaneMod   = 20
FID_ByteWidth  = 21
FID_Type       = 22
FID_Buffers    = 23
FID_Owner      = 24
FID_Entries    = 25
FID_GfxCoords  = 26
FID_Frame      = 27
FID_ClipLX     = 28
FID_ClipRX     = 29
FID_ClipTY     = 30
FID_ClipBY     = 31
FID_FPlane     = 32
FID_PropWidth  = 33
FID_PropHeight = 34
FID_Attrib     = 35
FID_PlaneSize  = 36
;FID_SrcBitmap  = 37
;FID_DestBitmap = 38
;FID_MaskBitmap = 39
FID_MaskCoords = 40
FID_AmtFrames  = 41
FID_XCoord     = 42
FID_YCoord     = 43
FID_Frequency  = 44
FID_Pair       = 45
FID_Volume     = 46
FID_Priority   = 47
FID_Length     = 48
FID_Octave     = 49
FID_Bitmap     = 50
FID_Sound      = 51
FID_Name       = 52
FID_Colour     = 53
FID_Point      = 54
FID_Gutter     = 55
FID_Char       = 56
FID_Port       = 57
FID_XChange    = 58
FID_YChange    = 59
FID_ZChange    = 60
FID_Buttons    = 61
FID_ButtonTimeOut = 62
FID_MoveTimeOut   = 63
FID_NXLimit       = 64
FID_NYLimit       = 65
FID_PXLimit       = 66
FID_PYLimit       = 67
FID_Number        = 68
FID_Year          = 69
FID_Month         = 70
FID_Day           = 71
FID_Hour          = 72
FID_Minute        = 73
FID_Second        = 74
FID_Micro         = 75
FID_ModBase       = 76
FID_Segment       = 77
FID_Public        = 78
FID_MinVersion    = 79
FID_MinRevision   = 80
FID_Date          = 81
FID_Author        = 82
FID_Copyright     = 83
FID_Short         = 84
FID_Args          = 85
FID_GVBase        = 86
FID_Prev          = 87
FID_Next          = 88
FID_Task          = 89
FID_Address       = 90
FID_ClassID       = 91
FID_ClassName     = 92
FID_CPU           = 93
FID_ModName       = 94
FID_ModNumber     = 95
FID_Extension     = 96
FID_Module        = 97
FID_ConfigFile    = 98
FID_FileHead      = 99
FID_ChildDir      = 100
FID_ChildFile     = 101
FID_BytePos       = 102
FID_DataProcessor = 103
FID_MemPtr1       = 104
FID_MemPtr2       = 105
FID_MemPtr3       = 106
FID_Command       = 107
FID_Link          = 108
FID_Raster        = 109
FID_BmpXOffset    = 110
FID_BmpYOffset    = 111
FID_Switch        = 112
FID_Screen        = 113
FID_XOffset       = 114
FID_YOffset       = 115
FID_DirectGfx     = 116
FID_EntryList     = 117
FID_DirectMasks   = 118
FID_EntrySize     = 119
FID_Music         = 120
FID_Title         = 121
FID_Track         = 122
FID_Artist        = 123
FID_Tempo         = 124
FID_Position      = 125
FID_Routine       = 126

  ENDC	;SYSTEM_SYSOBJECT_I
