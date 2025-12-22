#ifndef EXEC_ALERTS_H
#define EXEC_ALERTS_H



#define	ACPU_BusErr	$80000002	
#define	ACPU_AddressErr	$80000003	
#define	ACPU_InstErr	$80000004	
#define	ACPU_DivZero	$80000005	
#define	ACPU_CHK	$80000006	
#define	ACPU_TRAPV	$80000007	
#define	ACPU_PrivErr	$80000008	
#define	ACPU_Trace	$80000009	
#define	ACPU_LineA	$8000000A	
#define	ACPU_LineF	$8000000B	
#define	ACPU_Format	$8000000E	
#define	ACPU_Spurious	$80000018	
#define	ACPU_AutoVec1	$80000019	
#define	ACPU_AutoVec2	$8000001A	
#define	ACPU_AutoVec3	$8000001B	
#define	ACPU_AutoVec4	$8000001C	
#define	ACPU_AutoVec5	$8000001D	
#define	ACPU_AutoVec6	$8000001E	
#define	ACPU_AutoVec7	$8000001F	


#define AT_DeadEnd	$80000000
#define AT_Recovery	$00000000

#define AG_NoMemory	$00010000
#define AG_MakeLib	$00020000
#define AG_OpenLib	$00030000
#define AG_OpenDev	$00040000
#define AG_OpenRes	$00050000
#define AG_IOError	$00060000
#define AG_NoSignal	$00070000
#define AG_BadParm	$00080000
#define AG_CloseLib	$00090000	
#define AG_CloseDev	$000A0000	
#define AG_ProcCreate	$000B0000	

#define AO_ExecLib	$00008001
#define AO_GraphicsLib	$00008002
#define AO_LayersLib	$00008003
#define AO_Intuition	$00008004
#define AO_MathLib	$00008005
#define AO_DOSLib	$00008007
#define AO_RAMLib	$00008008
#define AO_IconLib	$00008009
#define AO_ExpansionLib $0000800A
#define AO_DiskfontLib	$0000800B
#define AO_UtilityLib	$0000800C
#define	AO_KeyMapLib	$0000800D
#define AO_AudioDev	$00008010
#define AO_ConsoleDev	$00008011
#define AO_GamePortDev	$00008012
#define AO_KeyboardDev	$00008013
#define AO_TrackDiskDev $00008014
#define AO_TimerDev	$00008015
#define AO_CIARsrc	$00008020
#define AO_DiskRsrc	$00008021
#define AO_MiscRsrc	$00008022
#define AO_BootStrap	$00008030
#define AO_Workbench	$00008031
#define AO_DiskCopy	$00008032
#define AO_GadTools	$00008033
#define AO_Unknown	$00008035


#define AN_ExecLib	$01000000
#define AN_ExcptVect	$01000001 
#define AN_BaseChkSum	$01000002 
#define AN_LibChkSum	$01000003 
#define AN_MemCorrupt	$81000005 
#define AN_IntrMem	$81000006 
#define AN_InitAPtr	$01000007 
#define AN_SemCorrupt	$01000008 
#define AN_FreeTwice	$01000009 
#define AN_BogusExcpt	$8100000A 
#define AN_IOUsedTwice	$0100000B 
#define AN_MemoryInsane $0100000C 
#define AN_IOAfterClose $0100000D 
#define AN_StackProbe	$0100000E 
#define AN_BadFreeAddr	$0100000F 
#define	AN_BadSemaphore	$01000010 

#define AN_GraphicsLib	$02000000
#define AN_GfxNoMem	$82010000	
#define AN_GfxNoMemMspc $82010001	
#define AN_LongFrame	$82010006	
#define AN_ShortFrame	$82010007	
#define AN_TextTmpRas	$02010009	
#define AN_BltBitMap	$8201000A	
#define AN_RegionMemory $8201000B	
#define AN_MakeVPort	$82010030	
#define AN_GfxNewError	$0200000C
#define AN_GfxFreeError $0200000D
#define AN_GfxNoLCM	$82011234	
#define AN_ObsoleteFont $02000401	

#define AN_LayersLib	$03000000
#define AN_LayersNoMem	$83010000	

#define AN_Intuition	$04000000
#define AN_GadgetType	$84000001	
#define AN_BadGadget	$04000001	
#define AN_CreatePort	$84010002	
#define AN_ItemAlloc	$04010003	
#define AN_SubAlloc	$04010004	
#define AN_PlaneAlloc	$84010005	
#define AN_ItemBoxTop	$84000006	
#define AN_OpenScreen	$84010007	
#define AN_OpenScrnRast $84010008	
#define AN_SysScrnType	$84000009	
#define AN_AddSWGadget	$8401000A	
#define AN_OpenWindow	$8401000B	
#define AN_BadState	$8400000C	
#define AN_BadMessage	$8400000D	
#define AN_WeirdEcho	$8400000E	
#define AN_NoConsole	$8400000F	
#define	AN_NoISem	$04000010	
#define	AN_ISemOrder	$04000011	

#define AN_MathLib	$05000000

#define AN_DOSLib	$07000000
#define AN_StartMem	$07010001 
#define AN_EndTask	$07000002 
#define AN_QPktFail	$07000003 
#define AN_AsyncPkt	$07000004 
#define AN_FreeVec	$07000005 
#define AN_DiskBlkSeq	$07000006 
#define AN_BitMap	$07000007 
#define AN_KeyFree	$07000008 
#define AN_BadChkSum	$07000009 
#define AN_DiskError	$0700000A 
#define AN_KeyRange	$0700000B 
#define AN_BadOverlay	$0700000C 
#define AN_BadInitFunc	$0700000D 
#define AN_FileReclosed $0700000E 

#define AN_RAMLib	$08000000
#define AN_BadSegList	$08000001	

#define AN_IconLib	$09000000

#define AN_ExpansionLib $0A000000
#define AN_BadExpansionFree	$0A000001 

#define AN_DiskfontLib	$0B000000

#define AN_AudioDev	$10000000

#define AN_ConsoleDev	$11000000
#define AN_NoWindow	$11000001	

#define AN_GamePortDev	$12000000

#define AN_KeyboardDev	$13000000

#define AN_TrackDiskDev $14000000
#define AN_TDCalibSeek	$14000001	
#define AN_TDDelay	$14000002	

#define AN_TimerDev	$15000000
#define AN_TMBadReq	$15000001 
#define AN_TMBadSupply	$15000002 

#define AN_CIARsrc	$20000000

#define AN_DiskRsrc	$21000000
#define AN_DRHasDisk	$21000001	
#define AN_DRIntNoAct	$21000002	

#define AN_MiscRsrc	$22000000

#define AN_BootStrap	$30000000
#define AN_BootError	$30000001	

#define AN_Workbench			$31000000
#define AN_NoFonts			$B1000001
#define AN_WBBadStartupMsg1		$31000001
#define AN_WBBadStartupMsg2		$31000002
#define AN_WBBadIOMsg			$31000003	
#define AN_WBReLayoutToolMenu		$B1010009	

#define AN_DiskCopy	$32000000

#define AN_GadTools	$33000000

#define AN_UtilityLib	$34000000

#define AN_Unknown	$35000000
#endif 
