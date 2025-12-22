;
; Empty development file for PureBasic
;
;

 INCLUDE "PureBasic:Library SDK/PhxAss/MakeResident.asm"


; Init the library stuffs
; -----------------------
;
; In the Order:
;   * Name of the library
;   * Name of the help file in which are documented all the functions
;   * Name of the function which will be called automatically when the program end
;   * Priority of this call (small numbers = the faster it will be called)
;   * Version of the library
;   * Revision of the library (ie: 0.12 here)
;

 initlib "TagList", "TagList", "FreeTagList", 0, 0, 12

;
; The functions...
;

 name      "Name", "()"
 flags
 amigalibs
 params
 debugger  1

    ; Code Here

 endfunc   1


;
; And the common part
;

 base

 endlib


 startdebugger

;Error0: debugerror "InitXXXX() don't have been called before or can't correctly setup"

 enddebugger

