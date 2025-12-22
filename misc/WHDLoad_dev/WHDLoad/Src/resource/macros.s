************************************************************************
* $Id: macros.s 1.9 2004/10/21 11:25:33 wepl Exp wepl $
************************************************************************

	INCLUDE	Includes:exec/types.i

;Symbol Numbers
	ENUM	0
	EITEM	SN_Slave
	EITEM	SN_SlaveFlags
	EITEM	SN_Resload
	EITEM	SN_TermReason
	EITEM	SN_Tags
	EITEM	SN_SetCPUFlags
	EITEM	SN_Patch
	EITEM	SN_PatcherBase
	EITEM	SN_PatcherTags
	EITEM	SN_RawDICBase
	EITEM	SN_RawDICSlaveFlags
	EITEM	SN_RawDICDiskFlags
	EITEM	SN_RawDICErrors

;Macros numbers
	ENUM	40
	EITEM	MN_LoadWHDSymbols
	EITEM	MN_DisassembleSlave1
	EITEM	MN_DisassembleSlave4
	EITEM	MN_DisassembleSlave8
	EITEM	MN_DisassembleSlave10
	EITEM	MN_DisassembleSlave16
	EITEM	MN_DisassembleSlaveData
	EITEM	MN_DisassembleRawDICSlave
	EITEM	MN_DisassembleRawDICDisk
	EITEM	MN_DisassembleRawDICTrack
	EITEM	MN_DisassembleRawDICFile

;Load Symbol
LDSYM	MACRO
	dc.w	\1
	dc.w	(.e\@-.s\@)
.s\@	dc.b	'\2',0
	EVEN
.e\@
	ENDM

;Make String
MKSTR	MACRO
	dc.w	(.e\@-.s\@)
.s\@	dc.b	'\1',0
	EVEN
.e\@
	ENDM

************************************************************************
_LoadWHDSymbols
	dc.l	MN_LoadWHDSymbols
	dc.l	.macroend-.macrostart
	dc.b	'Load Symbols WHD/Pat/Raw'
.macrostart
	LDSYM	759+SN_Slave,<rs:mysyms/WHDLoadSlave>
	LDSYM	759+SN_SlaveFlags,<rs:mysyms/WHDLoadSlaveFlags>
	LDSYM	759+SN_Resload,<rs:mysyms/WHDLoadResload>
	LDSYM	759+SN_TermReason,<rs:mysyms/WHDLoadTermReason>
	LDSYM	759+SN_Tags,<rs:mysyms/WHDLoadTags>
	LDSYM	759+SN_SetCPUFlags,<rs:mysyms/WHDLoadSetCPUFlags>
	LDSYM	759+SN_Patch,<rs:mysyms/WHDLoadPatch>
	LDSYM	759+SN_PatcherBase,<rs:mysyms/PatcherBase>
	LDSYM	759+SN_PatcherTags,<rs:mysyms/PatcherTags>
	LDSYM	759+SN_RawDICBase,<rs:mysyms/RawDICBase>
	LDSYM	759+SN_RawDICSlaveFlags,<rs:mysyms/RawDICSlaveFlags>
	LDSYM	759+SN_RawDICDiskFlags,<rs:mysyms/RawDICDiskFlags>
	LDSYM	759+SN_RawDICErrors,<rs:mysyms/RawDICErrors>
	dc.w	0
.macroend
************************************************************************
_DisassembleSlave1
	dc.l	MN_DisassembleSlave1
	dc.l	.macroend-.macrostart
	dc.b	'Disassemble Slave 1-3   '
.macrostart
	dc.w	21	; CURSOR/Absolute/Start of file
	dc.w	$001D	; LABELS/Create single/Label
	MKSTR	<ws>
	dc.w	86	; */Convert specific EA''s/Set base #1

	dc.w	$000E	; DISPLAY/Set data type/Code
	dc.w	$001E	; LABELS/Create single/End-of-line comment
	MKSTR	<ws_Security>
	dc.w	$820A	; CURSOR/Relative/Next line * 2

	dc.w	$0013	; DISPLAY/Set data type/Longs
	dc.w	$820A	; CURSOR/Relative/Next line * 2
	dc.w	$0014	; DISPLAY/Set data type/Words
	dc.w	$8209	; CURSOR/Relative/Previous line * 2
	dc.w	$000B	; DISPLAY/Set data type/ASCII
	dc.w	$001E	; LABELS/Create single/End-of-line comment
	MKSTR	<ws_ID>
	dc.w	$810A	; CURSOR/Relative/Next line * 1

	dc.w	$005C	; DISPLAY/Set Numeric base/Decimal
	dc.w	$001E	; LABELS/Create single/End-of-line comment
	MKSTR	<ws_Version>
	dc.w	$810A	; CURSOR/Relative/Next line * 1

	dc.w	732+SN_SlaveFlags	; SYMBOLS/User-defined symbols/#2
	dc.w	$001E	; LABELS/Create single/End-of-line comment
	MKSTR	<ws_Flags>
	dc.w	$810A	; CURSOR/Relative/Next line * 1

	dc.w	$0013	; DISPLAY/Set data type/Longs
	dc.w	$001E	; LABELS/Create single/End-of-line comment
	MKSTR	<ws_BaseMemSize>
	dc.w	$810A	; CURSOR/Relative/Next line * 1

	dc.w	$001E	; LABELS/Create single/End-of-line comment
	MKSTR	<ws_ExecInstall>
	dc.w	$810A	; CURSOR/Relative/Next line * 1

	dc.w	$0014	; DISPLAY/Set data type/Words
	dc.w	89	; */Convert specific EA''s/Cvert W/base 1
	dc.w	$001E	; LABELS/Create single/End-of-line comment
	MKSTR	<ws_GameLoader>
	dc.w	434	; CURSOR/Copy/Clip #1
	dc.w	$0040	; CURSOR/Absolute/Forward reference
	dc.w	$001D	; LABELS/Create single/Label
	MKSTR	<slv_GameLoader>
	dc.w	774	; PROJECT/Disassemble
	dc.w	437	; CURSOR/Paste/Clip #1
	dc.w	$810A	; CURSOR/Relative/Next line * 1

	dc.w	$001E	; LABELS/Create single/End-of-line comment
	MKSTR	<ws_CurrentDir>
	dc.w	$810A	; CURSOR/Relative/Next line * 1

	dc.w	$001E	; LABELS/Create single/End-of-line comment
	MKSTR	<ws_DontCache>
*	dc.w	$810A	; CURSOR/Relative/Next line * 1

	dc.w	21	; CURSOR/Absolute/Start of file
	dc.w	0
.macroend
************************************************************************
_DisassembleSlave4
	dc.l	MN_DisassembleSlave4
	dc.l	.macroend-.macrostart
	dc.b	'Disassemble Slave 4-7   '
.macrostart
	dc.w	$0328-40+MN_DisassembleSlave1	; MACROS/Execute/
	dc.w	21	; CURSOR/Absolute/Start of file
	dc.w	$8a0A	; CURSOR/Relative/Next line * 10

	dc.w	23	; DISPLAY/Set data type/Byte
	dc.w	$001E	; LABELS/Create single/End-of-line comment
	MKSTR	<ws_keydebug>
	dc.w	$810A	; CURSOR/Relative/Next line * 1

	dc.w	$001E	; LABELS/Create single/End-of-line comment
	MKSTR	<ws_keyexit>
*	dc.w	$810A	; CURSOR/Relative/Next line * 1

	dc.w	21	; CURSOR/Absolute/Start of file
	dc.w	0
.macroend
************************************************************************
_DisassembleSlave8
	dc.l	MN_DisassembleSlave8
	dc.l	.macroend-.macrostart
	dc.b	'Disassemble Slave 8-9   '
.macrostart
	dc.w	$0328-40+MN_DisassembleSlave4	; MACROS/Execute/
	dc.w	21	; CURSOR/Absolute/Start of file
	dc.w	$8c0A	; CURSOR/Relative/Next line * 12

	dc.w	$0013	; DISPLAY/Set data type/Longs
	dc.w	$001E	; LABELS/Create single/End-of-line comment
	MKSTR	<ws_ExpMem>
*	dc.w	$810A	; CURSOR/Relative/Next line * 1

	dc.w	21	; CURSOR/Absolute/Start of file
	dc.w	0
.macroend
************************************************************************
_DisassembleSlave10
	dc.l	MN_DisassembleSlave10
	dc.l	.macroend-.macrostart
	dc.b	'Disassemble Slave 10-15 '
.macrostart
	dc.w	$0328-40+MN_DisassembleSlave8	; MACROS/Execute/
	dc.w	21	; CURSOR/Absolute/Start of file
	dc.w	$8d0A	; CURSOR/Relative/Next line * 13

	dc.w	$0014	; DISPLAY/Set data type/Words
	dc.w	89	; */Convert specific EA''s/Cvert W/base 1
	dc.w	$001E	; LABELS/Create single/End-of-line comment
	MKSTR	<ws_name>
	dc.w	$0040	; CURSOR/Absolute/Forward reference
	dc.w	$001D	; LABELS/Create single/Label
	MKSTR	<slv_name>
	dc.w	$000B	; DISPLAY/Set data type/ASCII
	dc.w	$003F	; CURSOR/Absolute/Previous location
	dc.w	$810A	; CURSOR/Relative/Next line * 1

	dc.w	89	; */Convert specific EA''s/Cvert W/base 1
	dc.w	$001E	; LABELS/Create single/End-of-line comment
	MKSTR	<ws_copy>
	dc.w	$0040	; CURSOR/Absolute/Forward reference
	dc.w	$001D	; LABELS/Create single/Label
	MKSTR	<slv_copy>
	dc.w	$000B	; DISPLAY/Set data type/ASCII
	dc.w	$003F	; CURSOR/Absolute/Previous location
	dc.w	$810A	; CURSOR/Relative/Next line * 1

	dc.w	89	; */Convert specific EA''s/Cvert W/base 1
	dc.w	$001E	; LABELS/Create single/End-of-line comment
	MKSTR	<ws_info>
	dc.w	$0040	; CURSOR/Absolute/Forward reference
	dc.w	$001D	; LABELS/Create single/Label
	MKSTR	<slv_info>
	dc.w	$000B	; DISPLAY/Set data type/ASCII
	dc.w	$003F	; CURSOR/Absolute/Previous location
*	dc.w	$810A	; CURSOR/Relative/Next line * 1

	dc.w	21	; CURSOR/Absolute/Start of file
	dc.w	0
.macroend
************************************************************************
_DisassembleSlave16
	dc.l	MN_DisassembleSlave16
	dc.l	.macroend-.macrostart
	dc.b	'Disassemble Slave 16    '
.macrostart
	dc.w	$0328-40+MN_DisassembleSlave10	; MACROS/Execute/
	dc.w	21	; CURSOR/Absolute/Start of file
	dc.w	$900A	; CURSOR/Relative/Next line * 16

	dc.w	$0014	; DISPLAY/Set data type/Words
	dc.w	89	; */Convert specific EA''s/Cvert W/base 1
	dc.w	$001E	; LABELS/Create single/End-of-line comment
	MKSTR	<ws_kickname>
	dc.w	$0040	; CURSOR/Absolute/Forward reference
	dc.w	$001D	; LABELS/Create single/Label
	MKSTR	<slv_kickname>
	dc.w	$000B	; DISPLAY/Set data type/ASCII
	dc.w	$003F	; CURSOR/Absolute/Previous location
	dc.w	$810A	; CURSOR/Relative/Next line * 1

	dc.w	$0013	; DISPLAY/Set data type/Longs
	dc.w	$001E	; LABELS/Create single/End-of-line comment
	MKSTR	<ws_kicksize>
	dc.w	$810A	; CURSOR/Relative/Next line * 1

	dc.w	$0014	; DISPLAY/Set data type/Words
	dc.w	$001E	; LABELS/Create single/End-of-line comment
	MKSTR	<ws_kickcrc>
*	dc.w	$810A	; CURSOR/Relative/Next line * 1

	dc.w	21	; CURSOR/Absolute/Start of file
	dc.w	0
.macroend
************************************************************************
_DisassembleSlaveData
	dc.l	MN_DisassembleSlaveData
	dc.l	.macroend-.macrostart
	dc.b	'Disassemble Slave Data  '
.macrostart
	dc.w	21	; CURSOR/Absolute/Start of file
	dc.w	$880A	; CURSOR/Relative/Next line * 8
	dc.w	89	; */Convert specific EA''s/Cvert W/base 1
	dc.w	$0040	; CURSOR/Absolute/Forward reference
	dc.w	$001D	; LABELS/Create single/Label
	MKSTR	<slv_CurrentDir>
	dc.w	$000B	; DISPLAY/Set data type/ASCII
	dc.w	21	; CURSOR/Absolute/Start of file
	dc.w	0
.macroend
************************************************************************
_DisassembleRawDICSlave
	dc.l	MN_DisassembleRawDICSlave
	dc.l	.macroend-.macrostart
	dc.b	'Disassemble RawDIC Slave'
.macrostart
	dc.w	21	; CURSOR/Absolute/Start of file

	dc.w	$000E	; DISPLAY/Set data type/Code
	dc.w	$001E	; LABELS/Create single/End-of-line comment
	MKSTR	<Security>
	dc.w	$820A	; CURSOR/Relative/Next line * 2

	dc.w	$0014	; DISPLAY/Set data type/Words
	dc.w	$830A	; CURSOR/Relative/Next line * 3
	dc.w	23	; DISPLAY/Set data type/Byte
	dc.w	$8309	; CURSOR/Relative/Previous line * 3
	dc.w	$000B	; DISPLAY/Set data type/ASCII
	dc.w	$001E	; LABELS/Create single/End-of-line comment
	MKSTR	<ID>
	dc.w	$810A	; CURSOR/Relative/Next line * 1

	dc.w	$005C	; DISPLAY/Set Numeric base/Decimal
	dc.w	$001E	; LABELS/Create single/End-of-line comment
	MKSTR	<slv_Version>
	dc.w	$810A	; CURSOR/Relative/Next line * 1

	dc.w	732+SN_RawDICSlaveFlags	; SYMBOLS/User-defined symbols
	dc.w	$001E	; LABELS/Create single/End-of-line comment
	MKSTR	<slv_Flags>
	dc.w	$810A	; CURSOR/Relative/Next line * 1

	dc.w	$0013	; DISPLAY/Set data type/Longs
	dc.w	$001E	; LABELS/Create single/End-of-line comment
	MKSTR	<slv_FirstDisk>
	dc.w	$0040	; CURSOR/Absolute/Forward reference
	dc.w	$001D	; LABELS/Create single/Label
	MKSTR	<_disk1>
	dc.w	$0328-40+MN_DisassembleRawDICDisk	; MACROS/Execute/
	dc.w	$003F	; CURSOR/Absolute/Previous location
	dc.w	$810A	; CURSOR/Relative/Next line * 1

	dc.w	$0013	; DISPLAY/Set data type/Longs
	dc.w	$001E	; LABELS/Create single/End-of-line comment
	MKSTR	<slv_Text>
	dc.w	$0040	; CURSOR/Absolute/Forward reference
	dc.w	$001D	; LABELS/Create single/Label
	MKSTR	<_Text>
	dc.w	$000B	; DISPLAY/Set data type/ASCII
	dc.w	$003F	; CURSOR/Absolute/Previous location
	dc.w	$810A	; CURSOR/Relative/Next line * 1
	dc.w	$000B	; DISPLAY/Set data type/ASCII

	dc.w	21	; CURSOR/Absolute/Start of file
	dc.w	0
.macroend
************************************************************************
_DisassembleRawDICDisk
	dc.l	MN_DisassembleRawDICDisk
	dc.l	.macroend-.macrostart
	dc.b	'Disassemble RawDIC Disk '
.macrostart
	dc.w	$0013	; DISPLAY/Set data type/Longs
	dc.w	$001E	; LABELS/Create single/End-of-line comment
	MKSTR	<dsk_NextDisk>
	dc.w	$810A	; CURSOR/Relative/Next line * 1

	dc.w	$0014	; DISPLAY/Set data type/Words
	dc.w	$001E	; LABELS/Create single/End-of-line comment
	MKSTR	<dsk_Version>
	dc.w	$810A	; CURSOR/Relative/Next line * 1

	dc.w	732+SN_RawDICDiskFlags	; SYMBOLS/User-defined symbols
	dc.w	$001E	; LABELS/Create single/End-of-line comment
	MKSTR	<dsk_Flags>
	dc.w	$810A	; CURSOR/Relative/Next line * 1

	dc.w	$0013	; DISPLAY/Set data type/Longs
	dc.w	$001E	; LABELS/Create single/End-of-line comment
	MKSTR	<dsk_TrackList>
	dc.w	$0040	; CURSOR/Absolute/Forward reference
; the follwing will fail if there are multiple disk structures
;	dc.w	$001D	; LABELS/Create single/Label
;	MKSTR	<_tracks1>
	dc.w	$0328-40+MN_DisassembleRawDICTrack	; MACROS/Execute/
	dc.w	$003F	; CURSOR/Absolute/Previous location
	dc.w	$810A	; CURSOR/Relative/Next line * 1

	dc.w	$001E	; LABELS/Create single/End-of-line comment
	MKSTR	<dsk_TLExtension>
	dc.w	$810A	; CURSOR/Relative/Next line * 1

	dc.w	$001E	; LABELS/Create single/End-of-line comment
	MKSTR	<dsk_FileList>
	dc.w	$810A	; CURSOR/Relative/Next line * 1

	dc.w	$001E	; LABELS/Create single/End-of-line comment
	MKSTR	<dsk_CRCList>
	dc.w	$810A	; CURSOR/Relative/Next line * 1

	dc.w	$001E	; LABELS/Create single/End-of-line comment
	MKSTR	<dsk_AltDisk>
	dc.w	$810A	; CURSOR/Relative/Next line * 1

	dc.w	$001E	; LABELS/Create single/End-of-line comment
	MKSTR	<dsk_InitCode>
	dc.w	$810A	; CURSOR/Relative/Next line * 1

	dc.w	$001E	; LABELS/Create single/End-of-line comment
	MKSTR	<dsk_DiskCode>

	dc.w	0
.macroend
************************************************************************
_DisassembleRawDICTrack
	dc.l	MN_DisassembleRawDICTrack
	dc.l	.macroend-.macrostart
	dc.b	'Disassemble RawDIC Track'
.macrostart
	dc.w	$0014	; DISPLAY/Set data type/Words
	dc.w	$005C	; DISPLAY/Set Numeric base/Decimal
	dc.w	$001E	; LABELS/Create single/End-of-line comment
	MKSTR	<tle_FirstTrack>
	dc.w	$810A	; CURSOR/Relative/Next line * 1

	dc.w	$005C	; DISPLAY/Set Numeric base/Decimal
	dc.w	$001E	; LABELS/Create single/End-of-line comment
	MKSTR	<tle_LastTrack>
	dc.w	$810A	; CURSOR/Relative/Next line * 1

	dc.w	$001E	; LABELS/Create single/End-of-line comment
	MKSTR	<tle_BlockLength>
	dc.w	$810A	; CURSOR/Relative/Next line * 1

	dc.w	$001E	; LABELS/Create single/End-of-line comment
	MKSTR	<tle_Sync>
	dc.w	$810A	; CURSOR/Relative/Next line * 1

	dc.w	$0013	; DISPLAY/Set data type/Longs
	dc.w	$001E	; LABELS/Create single/End-of-line comment
	MKSTR	<tle_Decoder>
	dc.w	$810A	; CURSOR/Relative/Next line * 1

	dc.w	$001F	; LABELS/Create single/Full-line comment
	MKSTR	<next entry>

	dc.w	$0014	; DISPLAY/Set data type/Words
	; next track list entry

	dc.w	0
.macroend
************************************************************************
_DisassembleRawDICFile
	dc.l	MN_DisassembleRawDICFile
	dc.l	.macroend-.macrostart
	dc.b	'Disassemble RawDIC File '
.macrostart
	dc.w	$0013	; DISPLAY/Set data type/Longs
	dc.w	$001E	; LABELS/Create single/End-of-line comment
	MKSTR	<fle_Name>
	dc.w	$810A	; CURSOR/Relative/Next line * 1

	dc.w	$001E	; LABELS/Create single/End-of-line comment
	MKSTR	<fle_Offset>
	dc.w	$810A	; CURSOR/Relative/Next line * 1

	dc.w	$001E	; LABELS/Create single/End-of-line comment
	MKSTR	<fle_Length>

	; next file list entry

	dc.w	0
	CNOP	0,4	; !!! Last Macro must be LONGWORD ALIGEND !!!
.macroend
************************************************************************
* Execute Macro Table
	IFEQ 1
	dc.w	$002F	; MACROS 1/Execute/(#1)
	dc.w	$0031	; MACROS 1/Execute/(#2)
	dc.w	$0033	; MACROS 1/Execute/(#3)
	dc.w	$0158	; MACROS 1/Execute/(#4)
	dc.w	$015A	; MACROS 1/Execute/(#5)
	dc.w	$015C	; MACROS 1/Execute/(#6)
	dc.w	$015E	; MACROS 1/Execute/(#7)
	dc.w	$0160	; MACROS 1/Execute/(#8)
	dc.w	$0162	; MACROS 1/Execute/(#9)
	dc.w	$0164	; MACROS 1/Execute/(#10)
	dc.w	$0166	; MACROS 1/Execute/(#11)
	dc.w	$0168	; MACROS 1/Execute/(#12)
	dc.w	$01E4	; MACROS 1/Execute/(#13)
	dc.w	$01E5	; MACROS 1/Execute/(#14)
	dc.w	$01E6	; MACROS 1/Execute/(#15)
	dc.w	$01E7	; MACROS 1/Execute/(#16)
	dc.w	$01E8	; MACROS 1/Execute/(#17)
	dc.w	$01E9	; MACROS 1/Execute/(#18)
	dc.w	$01EA	; MACROS 1/Execute/(#19)
	dc.w	$01EB	; MACROS 2/Execute/(#1)
	dc.w	$01EC	; MACROS 2/Execute/(#2)
	dc.w	$01ED	; MACROS 2/Execute/(#3)
	dc.w	$01EE	; MACROS 2/Execute/(#4)
	dc.w	$01EF	; MACROS 2/Execute/(#5)
	dc.w	$01F0	; MACROS 2/Execute/(#6)
	dc.w	$01F1	; MACROS 2/Execute/(#7)
	dc.w	$01F2	; MACROS 2/Execute/(#8)
	dc.w	$01F3	; MACROS 2/Execute/(#9)
	dc.w	$01F4	; MACROS 2/Execute/(#10)
	dc.w	$01F5	; MACROS 2/Execute/(#11)
	dc.w	$01F6	; MACROS 2/Execute/(#12)
	dc.w	$01F7	; MACROS 2/Execute/(#13)
	dc.w	$01F8	; MACROS 2/Execute/(#14)
	dc.w	$01F9	; MACROS 2/Execute/(#15)
	dc.w	$01FA	; MACROS 2/Execute/(#16)
	dc.w	$01FB	; MACROS 2/Execute/(#17)
	dc.w	$01FC	; MACROS 2/Execute/(#18)
	dc.w	$01FD	; MACROS 2/Execute/(#19)
	dc.w	$0323	; MACROS 3/Execute/(#39)
	dc.w	$0328	; MACROS 3/Execute/(#2)
	dc.w	$0329	; MACROS 3/Execute/(#3)
	dc.w	$032A	; MACROS 3/Execute/(#4)
	dc.w	$032B	; MACROS 3/Execute/(#5)
	dc.w	$032C	; MACROS 3/Execute/(#6)
	dc.w	$032D	; MACROS 3/Execute/(#7)
	dc.w	$032E	; MACROS 3/Execute/(#8)
	dc.w	$032F	; MACROS 3/Execute/(#9)
	dc.w	$0330	; MACROS 3/Execute/(#10)
	dc.w	$0331	; MACROS 3/Execute/(#11)
	dc.w	$0332	; MACROS 3/Execute/(#12)
	dc.w	$0333	; MACROS 3/Execute/(#13)
	dc.w	$0334	; MACROS 3/Execute/(#14)
	dc.w	$0335	; MACROS 3/Execute/(#15)
	dc.w	$0336	; MACROS 3/Execute/(#16)
	dc.w	$0337	; MACROS 3/Execute/(#17)
	dc.w	$0338	; MACROS 3/Execute/(#18)
	dc.w	$0339	; MACROS 3/Execute/(#19)
	ENDC
