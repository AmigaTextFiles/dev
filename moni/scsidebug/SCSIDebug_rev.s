VERSION = 1
REVISION = 1

.macro DATE
.ascii "9.8.2009"
.endm

.macro VERS
.ascii "SCSIDebug 1.1"
.endm

.macro VSTRING
.ascii "SCSIDebug 1.1 (9.8.2009)"
.byte 13,10,0
.endm

.macro VERSTAG
.byte 0
.ascii "$VER: SCSIDebug 1.1 (9.8.2009)"
.byte 0
.endm
