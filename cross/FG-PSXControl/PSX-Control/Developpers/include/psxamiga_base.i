
	   IFND  EXEC_TYPES_I
	   INCLUDE  "exec/types.i"
	   ENDC   ; EXEC_TYPES_I

	   IFND  EXEC_LIBRARIES_I
	   INCLUDE  "exec/libraries.i"
	   ENDC   ; EXEC_LIBRARIES_I


* This is the library base for the psxamiga.library
* All these values are READ ONLY. Do _NOT_ touch the fields
* marked "Private" or the seven plagues of Egypt will fall
* upon thee.

   STRUCTURE PSXAmigaBase,LIB_SIZE
	UBYTE   pa_Flags		; Private!
	UBYTE   pa_pad			; Private!
	ULONG   pa_SegList		; Private!
	ULONG   pa_ExecBase		; Private!

	UBYTE	pa_LinkStatus		; Status of the PSX Linkcable (1 = online, 0 = offline)
	UBYTE   pa_TerminalStatus	; Status of the PSX Terminal  (1 = online, 0 = offline)
	UBYTE	pa_Status		; General Status (1 = PSX-Control ready to perform actions / 0 = action in progress)
        ULONG   pa_System               ; Development system type
	LONG	pa_TaskLocked		; Pointer to task that owns the lock

   LABEL   pa_SIZEOF

