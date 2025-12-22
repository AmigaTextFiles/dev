
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
; a small example showing and testing the wla syntax
; written by ville helin <vhelin@cc.hut.fi> in 1998-2001
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

.INCLUDE "gb_memory.i"
.INCLUDE "defines.i"
.INCLUDE "cgb_hardware.i"


.DEFINE SIMON "old.gb"


.BACKGROUND SIMON

.BANK 0 SLOT 0
.ORG 0
.DB 10

.SECTION "zorbas" OVERWRITE

.DBCOS 0.2, 10, 3.2, 120, 1.3

.ENDS
