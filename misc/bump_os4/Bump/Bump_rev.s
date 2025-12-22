VERSION = 3
REVISION = 5

.macro DATE
.ascii "19.11.2007"
.endm

.macro VERS
.ascii "Bump 3.5"
.endm

.macro VSTRING
.ascii "Bump 3.5 (19.11.2007)"
.byte 13,10,0
.endm

.macro VERSTAG
.byte 0
.ascii "$VER: Bump 3.5 (19.11.2007)"
.byte 0
.endm
