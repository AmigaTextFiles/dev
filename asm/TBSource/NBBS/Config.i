		ds.l	0
;config stuff - a straight copy of the .config file and vice versa

CONFIG:
ConfName:	dc.b	"NBBS",0,0		;To separate config file from other
ConfVers:	dc.w	1			;Version number (.1!!!)
SerExtFlags:	dc.l	0			;Extended flags, Mark-Space etc.
SerFlags:	dc.b	0			;Parity, XON/XOFF etc
SerStopBits:	dc.b	1			;Stop bits
SerDataBits:	dc.b	8			;Data bits
SerDuplex:	dc.b	0			;Duplex, 0=Full, 1=Half, 2=Echo
SerBRKT:	dc.l	0			;Break time
SerBaud:	dc.l	0			;Baud (grr.. bps!)
SerUnit		dc.l	0			;Serial device unit number
SerName		dc.b	"serial.device",0	;32 bytes reserved for all texts
		ds.b	18			;filename etc. 30 + 1 for 0, 1 pad
SerUnitGadBuf:	dc.b	"0",0			;The buffers with texts,
		ds.b	10			;saves code, but increase
SerBRKTGadBuf:	dc.b	"250000",0		;In order: SerUnit, FontSize
		ds.b	5			;BreakTime
SerResetStr:	dc.b	"ATZ",0			;ResetString
		ds.b	28
SerInitStr:	dc.b	"AT E0 Q0 V1 X4",0	;InitString
		ds.b	17
SerDialPre:	dc.b	"ATDT"			;Dial prefix, no 0! String continues
		ds.b	28			;FUTURE APPLICATION
SerDialSuf:	dc.b	0,0			;Dial suffix (0=return)
		ds.b	30			;FUTURE APPLICATION
SerRingStr:	dc.b	"RING",0		;RingString
		ds.b	27
SerAnswerStr:	dc.b	"ATA",0			;Answer string
		ds.b	28
SerConn300:	dc.b	"CONNECT",0		;300 bps
		ds.b	24
SerConn1200:	dc.b	"CONNECT 1200",0
		ds.b	19
SerConn2400:	dc.b	"CONNECT 2400",0
		ds.b	19
SerConn4800:	dc.b	"CONNECT 4800",0
		ds.b	19
SerConn9600:	dc.b	"CONNECT 9600",0
		ds.b	19
SerConn19200:	dc.b	"CONNECT 19200",0
		ds.b	18
SerConn38400:	dc.b	"CONNECT 38400",0
		ds.b	18
SerConn57600:	dc.b	"CONNECT 57600",0
		ds.b	18
UserFont:	dc.b	"topaz.font",0		;User defined font
		ds.b	21
FontSizeGadBuf:	dc.b	"8",0			;the size of the config
		ds.b	10			;file. Wise? I don't know.
UserFontSize:	dc.l	8			;size of font = 8!!
UserKeyMap:	dc.b	"S",0			;User defined keymap
		ds.b	30
BBSLocat:	dc.b	"BBS:",0		;Location on HD
		ds.b	127			;PathLength = 130 + 2
SystemPW:	ds.b	32			;System PassWord
NewUserPW:	ds.b	32			;New user Password
RemotePW:	dc.b	"RemotePW",0		;Remote Shell Access PW
		ds.b	23
BBSName:	dc.b	"BBS-Name",0		;Name of BBS
		ds.b	23
SysOpName:	dc.b	"SysOp",0		;Name of SysOp
		ds.b	26
CoSys1:		dc.b	"CoSysOp #1",0		;Name CoSysOp #1
		ds.b	21
CoSys2:		dc.b	"CoSysOp #2",0		;Name CoSysOp #2
		ds.b	21
CoSys3:		dc.b	"CoSysOp #3",0		;Name CoSysOp #3
		ds.b	21
CoSys4:		dc.b	"CoSysOp #4",0		;Name CoSysOp #4
		ds.b	21
CoSys5:		dc.b	"CoSysOp #5",0		;Name CoSysOp #5
		ds.b	21
ResetOnError:	dc.w	0			;Reset if error occured 0=no,1=yes 

CONFIG_END:	ds.w	0			;The End.
;Needed hmm.. lotsa stuff.. I'll make a list.. File:needed_config.lst
