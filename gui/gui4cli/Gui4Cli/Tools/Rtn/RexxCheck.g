G4C

; RexxCheck.g

; Routine to make sure that rexxmast has been launched and that
; RX and WaitForPort have been made resident.

; Only really needed if G4C is run from the WB directly (not through c:gui)

; Before calling it, check if variable $*REXXOK = 1. 
; If it is, it means that this routine has already been run successfuly.
; .. do something like this..

; if $*REXXOK != 1           ; check if rexxcheck.g has been run
;    guiload guis/tools/rtn/rexxcheck.g
;    if $*REXXOK != 1        ; quit if rexxcheck failed
;        stop
;    endif
; endif
; run 'rx MyFile'


xOnLoad

if $*REXXOK = 1			; rexxcheck.g has already been run
   guiquit rexxcheck.g
   stop
endif

ifexists file rexxmast          ; means that Gui4Cli knows default paths
   ifexists file rx             ; so no need for this
      *REXXOK = 1
      guiquit rexxcheck.g
      stop
   endif
endif

*REXXOK    = 0

; Check for RexxMast

ifexists port REXX
   ; ok - rexxmast already loaded
else
   ifexists file sys:system/rexxmast
       run 'sys:system/rexxmast'
   else
       ezreq "RexxMast not found\nplease start it manually\nand try again" OK ""
       guiquit rexxcheck.g
       stop
   endif
   wait port REXX 50
   if $$RETCODE > 0
       ezreq 'Could not run RexxMast!' ABORT ""
       guiquit rexxcheck.g
       stop
   endif
endif

; Make RX resident

ifexists file sys:rexxc/rx
   run 'resident sys:rexxc/rx pure add'
else
   ezreq 'Sys:rexxc/RX not found!\nI need it to run ARexx.' OK ''
   guiquit rexxcheck.g
   stop
endif

; Make WaitForPort resident

ifexists file sys:rexxc/waitforport
   run 'resident sys:rexxc/waitforport pure add'
else
   ezreq 'Sys:rexxc/WaitForport not found!\nI need it to run ARexx.' OK ''
   guiquit rexxcheck.g
   stop
endif

; Everything allright

*REXXOK = 1
guiquit rexxcheck.g

