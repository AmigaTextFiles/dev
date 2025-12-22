;,//      LITTEL v0.17b - lets make a little library

#mode LIBRARY 37 1 "test.library" "test.library by me 2000"

#link library.o  ; must do this.

#incdir "ainc:lib/"
#include "dos.i"

#makefd test_lib.fd _TestBase ; make .fd file for it
#makei test_lib.i
;#makelvo test_lib.lvo


#fdef Inc10 (val)(d0)  ;// make our functions public, starting at -30
#fdef Inc100 (val)(d0)
#fdef Inc10p (val)()
#fdef Delay100 ()()
#fdef Bla ()()
#endfdef

GVAR _nisse  ; shared global


#LibraryEnv OFF   ; we will not use any globals

#regpreserve OFF  ; for now, no regs needs to be preserved

; as of v18 we need to declare theese functions too..
; no regs does _ever_ need to be preserved, but
; be sure to return <> NIL on success or NIL for
; failure in init and open !
; global blocks of data (strings, etc) MUST be declared
; in init !!! This may seem odd, and it is, but its the
; only way...

PROC init
   STRING _musse "hejhej"  ; MUST be declared in init !!
ENDPROC 1

PROC open
ENDPROC 1

PROC close
ENDPROC 

PROC expunge
ENDPROC 

;-----our library functions--------------

PROC Inc10
   inc D0 10
ENDPROC   ;// just a silly example //

PROC Inc100
   inc D0 100
ENDPROC

#regpreserve d6/d7 ; d6 and or d7 is used 

PROC Inc10p %param
   CODESTART ;needs to be here if using params or locals
   inc %param 10
ENDPROC %param

#regpreserve OFF

;following function can only be called from LITTEL code !
PROC Delay100
   copy 100 D0
   copy 100 D1
   call _DOSBase Delay  ; using callers _startup_ global !
ENDPROC

#LibraryEnv SHARED  ; we want to use librarys shared globals
                    ; no startupglobals is allowed now!
#regpreserve a4   ; we save a4 as library uses its own.

;the global nisse is the same to all tasks using the lib.
PROC Bla
   INC _nisse      ; using the shared global..
ENDPROC _nisse

END

