	IFND LIBRARIES_ROS_I
LIBRARIES_ROS_I SET 1
**
**	$VER: ros.i 2.0 (01.11.96)
**	Includes Release 2.0
**
**	ros.library definitions
**
**	(C) Copyright 1995/96 by TIK/RETIRE
**	    All Rights Reserved
**


	IFND    EXEC_LIBRARIES_I
	include "exec/libraries.i"
	ENDC

	IFND    EXEC_EXECBASE_I
	include "exec/execbase.i"
	ENDC

	IFND    HARDWARE_DMABITS_I
	include	hardware/dmabits.i
	ENDC

	IFND    HARDWARE_INTBITS_I
	include	hardware/intbits.i
	ENDC


ROSNAME	MACRO
	dc.b	'ros.library',0
	ENDM



******* Useful defines ********************************************************

AllCaches	equ CACRF_EnableI!CACRF_IBE!CACRF_EnableD!CACRF_DBE!CACRF_WriteAllocate!CACRF_CopyBack



******* PRIVATE STRUCTURES - DON'T TOUCH THESE ********************************


 STRUCTURE ROSMemNode,0
	APTR	ROSMN_Next
	APTR	ROSMN_Addr
	ULONG	ROSMN_Size
	UBYTE	ROSMN_ID
	STRUCT	ROSMN_pad1,3
	LABEL	ROSMN_SIZEOF

ROSMNID_MemBlock	equ 0
ROSMNID_SegList		equ 1


 STRUCTURE ROSJoyPortData,0
	APTR	ROSJPD_Handler
	ULONG	ROSJPD_PortState	; for key creator
	UWORD	ROSJPD_PortData
	LABEL	ROSJPD_SIZEOF


; defines for ROS_JoyPortFlags
	BITDEF	ROSJP,INUSE,0		; joyport read semaphore
	BITDEF	ROSJP,GCREAD,1		; gamecontroller read semaphore
	BITDEF	ROSJP,GPDEV,2		; gameport.dev removed or not
	BITDEF	ROSJP,OWNPORT0,3	; port0 bits (potgo) allocated
	BITDEF	ROSJP,OWNPORT1,4	; port1 bits (potgo) allocated
	BITDEF	ROSJP,OWNPORT2,5	; port2 bits (misc) allocated
	BITDEF	ROSJP,OWNPORT3,6	; port3 bits (misc) allocated



******* PUBLIC LIBRARY BASE ***************************************************


 STRUCTURE ROSBase,LIB_SIZE
	UBYTE	ROS_Flags
	UBYTE	ROS_pad
	ULONG	ROS_SegList

	* PUBLIC FIELDS, READ IT IF YOU NEED IT *

	UBYTE	ROS_KillSysFlags
	UBYTE	ROS_pad2
	APTR	ROS_ExecBase
	APTR	ROS_DOSBase
	APTR	ROS_GfxBase
	APTR	ROS_IntuitionBase
	APTR	ROS_CallingTask		; pointer to the callers task
	ULONG	ROS_EClockFreq		; timebase for cia chips
	; typical values PAL=709379 NTSC=715909 Hertz (also valid on OS1.3)

	* PRIVATE FIELDS - DON'T TOUCH THESE!!! *

	APTR	ROS_UtilityBase
	APTR	ROS_CIAABase
	APTR	ROS_CIABBase
	APTR	ROS_PotgoBase
	APTR	ROS_MiscBase
	APTR	ROS_DiskBase

	ULONG	ROS_TaskWinPtr
	ULONG	ROS_ReqState		; user settings, req on/off (0/-1)
	ULONG	ROS_SysCacheBits
	APTR	ROS_MsgPort		; port for device communication
	APTR	ROS_InputIO		; IO request for input.device
	APTR	ROS_AudioIO		; IO request for audio.device
	APTR	ROS_ScreenPtr		; ptr to ROS screen
	APTR	ROS_OldGPServer		; 

	APTR	ROS_VBR			; ptr to 680x0 vectors
	APTR	ROS_Copper1
	APTR	ROS_Copper2

	APTR	ROS_MemList

	APTR	ROS_ExitHandler		; invoked by exit key condition
	ULONG	ROS_ExitKey		; exit condition: qualifiers & keycode

	UWORD	ROS_DMA
	UWORD	ROS_DMAMask
	UWORD	ROS_SysDMA

	UWORD	ROS_Int
	UWORD	ROS_IntMask
	UWORD	ROS_SysInt

	ULONG	ROS_DefCacheBits
	ULONG	ROS_DefCacheMask

	STRUCT	ROS_UserInt,16*4	; pointers to user interrupt routines

	STRUCT	ROS_JPort0,ROSJPD_SIZEOF
	STRUCT	ROS_JPort1,ROSJPD_SIZEOF
	STRUCT	ROS_JPort2,ROSJPD_SIZEOF
	STRUCT	ROS_JPort3,ROSJPD_SIZEOF

	WORD	ROS_SysCallCount

	UBYTE	ROS_CIAAInt		; pending cia interrupts
	UBYTE	ROS_CIAACRA		; system cra state
	UBYTE	ROS_CIAACRAMask		; $01/$00 - timer used by system/ROS
	UBYTE	ROS_CIAACRB		; system crb state
	UBYTE	ROS_CIAACRBMask		; $01/$00 - timer used by system/ROS
	UBYTE	ROS_CIAAICR		; current icr state
	UBYTE	ROS_CIAAICRMask		; bit set - int allocated by ROS
					; bits used: CIAICRB_TA/TB/SP
	UBYTE	ROS_CIABInt
	UBYTE	ROS_CIABCRA
	UBYTE	ROS_CIABCRAMask
	UBYTE	ROS_CIABCRB
	UBYTE	ROS_CIABCRBMask
	UBYTE	ROS_CIABICR
	UBYTE	ROS_CIABICRMask		; bits used: CIAICRB_TA/TB

	BOOL	ROS_DiskBreak		; values for "DiskState" call
	UWORD	ROS_DiskState

	UBYTE	ROS_JoyPortFlags
	UBYTE	ROS_JoyPortFlags2	; bits 0..3 used (keycreator bits)

	BYTE	ROS_InputTaskPri
	BYTE	ROS_OldTaskPri

	LABEL	ROSBase_SIZEOF



******* Bit defines for KillSysFlags ******************************************

	BITDEF	ROSKS,INUSE,0		; KillSystem called
	BITDEF	ROSKS,DEAD,1		; no multitasking
	BITDEF	ROSKS,DEFCACHE,2	; use default cache settings
	BITDEF	ROSKS,FRONTSCREEN,3	; ROS screen in front

; following flags are private, do not rely on this!!!
	BITDEF	ROSKS,NOAUDALLOC,5	; skip audio allocation
	BITDEF	ROSKS,BASHMODE,6	; hardware bashing mode
	BITDEF	ROSKS,VIEWCHANGED,7	; view changed



******* Bit defines for KillSystem call ***************************************

KILLF_SYSMODE	equ 0
	BITDEF	KILL,DEATHMODE,0	; non-multitasking mode
	BITDEF	KILL,OSFRIENDLY,1	; OS friendly mode



******* Bit defines for Read/Write calls **************************************

	BITDEF	ROSRW,DISKWAIT,0	; wait for disk



******* Defines for DiskState call ********************************************

DISK_NOP	equ 0
DISK_Init	equ 1
DISK_Busy	equ 2
DISK_Waiting	equ 3



******* Bit defines for ChipsetCheck call *************************************

	BITDEF	ROSCS,ECS,0		; at least rev4 agnus & ecs denise 
	BITDEF	ROSCS,AGA,1		; at least rev2 alice & aa lisa



******* Bit defines for SetTimerVec call **************************************

TIMF_ANY	equ 0
	BITDEF	TIM,LEV2,0		; allocate level 2 (cia a) timer
	BITDEF	TIM,LEV6,1		; allocate level 6 (cia b) timer



******* Bit defines for SetCopper call ****************************************

COPF_COPPER1	equ 0
	BITDEF	COP,COPPER2,0		; modify copper2 contents
	BITDEF	COP,STROBE,1		; immediate copper reload
	BITDEF	COP,LOF,2		; start coplist in along frame
	BITDEF	COP,SHF,3		; start coplist in a short frame



******* Further interrupt bit defines for interrupt manipulation calls ********

	BITDEF	INT,KEYB,1		; keyboard
	BITDEF	INT,CIAATIMA,2		; CIA A Timer A
	BITDEF	INT,CIAATIMB,3		; CIA A Timer B
	BITDEF	INT,CIABTIMA,12		; CIA B Timer A
	BITDEF	INT,CIABTIMB,13		; CIA B Timer B



******* Parameters for ROSSetJoyPortAttrs() ***********************************

ROSJPA_AUTOSENSE	equ 0
ROSJPA_GAMECTLR		equ 1
ROSJPA_MOUSE		equ 2
ROSJPA_JOYSTK		equ 3

ROSJPA_ADDKEYS		equ 4		; activate key creator for this port
ROSJPA_REMKEYS		equ 5		; deactivate key creator

ROSJPA_REINITIALIZE	equ -1		; free resources, reset to autosense,
					; remove key creation



	ENDC ; LIBRARIES_ROS_I
