    include "exec/types.i"

    STRUCTURE MidiPortData,0
	FPTR	mpd_ActivateXmit
	LABEL	mpd_SIZE

    STRUCTURE MidiDeviceData,0
	ULONG	mdd_Magic
	APTR	mdd_Name
	APTR	mdd_IDString
	UWORD	mdd_Version
	UWORD	mdd_Revision
	FPTR	mdd_Init
	FPTR	mdd_Expunge
	FPTR	mdd_OpenPort
	FPTR	mdd_ClosePort
	UBYTE	mdd_NPorts
	UBYTE	mdd_Flags
	LABEL	mdd_SIZE

MDD_SegOffset	equ 8
MDD_Magic	equ 'MDEV'
