;      class.library.l : rewritten in LITTEL
;      from class.library.e
; changes : the lists nodes and classes are allocated with memorypools
; limitations : max 256 methods / class, mid = 0-255
; change : added cl.namelen
; change : goin back to actual size in NewClass,
; its just better.
; TODO : make each object of a class use a shared mempool.
;        for now, AllocMem(size, MEMF_CLEAR) is used.
; HOWTO do with returnvalues ? for now the methods
; returnvalue is passed back from Cl_DoMethod().
; no way to know if the method really existed..
; USING real hook as cl_hook :) gaah.. well.. its for the best,
; somemore memory is wasted, but its more compatible.
; just went threw all functions carefully and discovered
; nearly a ton of errors or unsecure things...
; added alot new Obtain/Release semaphore calls
; here and there. ..now also around mempoolfunctions.
; got rid of more bugs ...:)
; hell it isnt even being tested in real life yet.
; Domethod got extremely optimised by using
; regs only in code, as a sideeffect, all regs are preserved too.
; made supercalls (when a method isnt redefined) a bit faster
; by back branching.
; changing hook again.. making it 16 bytes big, meaning
; we can shl instead of multiplying when fetching it.
; gotta remember adjustin for this in DoMethod.. DONE
; forgot to adjust for it in AddMethod, RemMethod.. DONE
; something is not working in NewClass..
; bacause of that I will make some functions return
; other values then NIL, so we can know what is going on..
; MADE IT .. didnt help much.. UNTIL...
; I discovered A5 has to be saved too, if used, and it is.
; when fiddling around with LITTEL only code, it wasnt
; necessary...!
; 000628 : heh!! forgot that _SysBase needs A4 too!
; in Cl_NewObject for example... it needs sysbase to
; call other libraryfunctions..
; CHANGE : NewObject now doesnt call CLM_NEW !
;          EndObject now doesnt call CLM_END !
; if this behaviour is desired, just make a macro for it.
; 000631 : FIXED some errors in argument to FreePooled.
; Gonna get rid of node and make class a node.
;DONE much better!
; getting rid of the mempool !... it isnt needed
; anymore as the nodes dissapeared. Also if the library
; gets closed (expunged), all classdata gets FreePooled()
; even if they wherent AddClass()ed, making them useless.
; AllocMem it is from now on.


#mode LIBRARY 37 1 "class.library" "class.library by LS 2000"

#link library.o
#link strlen.o

#incdir "ainc:lib/"
#include "exec.i"
#include littel:lc/examples/class_lib/class.i
#include "LITTEL:macrofunctions/exec_lib.mf"

#makefd class_lib.fd _ClassBase ; make .fd file for it
#makei  class_lib.i ; make .i file for it

#fdef Cl_NewClass  (name,size,maxmid,super,user)(a0/d0/d1/a1/a2)
#fdef Cl_EndClass  (class)(a0)
#fdef Cl_AddClass  (class)(a0)
#fdef Cl_FindClass (name)(a0)
#fdef Cl_RemClass  (class)(a0)
#fdef Cl_NewObject (class)(a0)
#fdef Cl_EndObject (object)(a0)
#fdef Cl_AddMethod (class,mid,entry,subentry,data)(a0/d0/a1/a2/d1)
#fdef Cl_RemMethod (class,mid)(a0/d0)
#fdef Cl_DoMethod  (object,mid,args)(a2/d1/a1)
#fdef Cl_DoSMethod (object,mid,args)(a2/d1/a1)
#fdef Cl_GetOCName (object)(a0)
#fdef Cl_GetOCData (object)(a0)
#fdef Cl_GetHData  (hook)(a0)
#endfdef

       #xref StrLen
 
#equ SIZEOF_SS  46
#equ MEMF_CLEAR  $10000

; our hook lookalike
#equ CLH_ENTRY  0
#equ CLH_SUBENTRY  4
#equ CLH_DATA  8
#equ CLH_PAD   12

#equ SIZEOF_CLHOOK  16

#equ CL_LN_NEXT 0       ; LONG ; not touched
#equ CL_LN_PREV 4       ; LONG ; not touched
#equ CL_LN_TYPE 8       ; BYTE ; not used
#equ CL_LN_PRI  9       ; BYTE ; not used
#equ CL_LN_NAME 10      ; PTR TO CHAR
#equ CL_PAD1    12      ; INT (WORD)
#equ CL_NAMELEN 16      ; LONG
#equ CL_SIZE    20      ; LONG
#equ CL_HOOKS   24      ; PTR TO CL_HOOK
#equ CL_MAXMETHODID 28  ; LONG
#equ CL_SUPERCLASS  32  ; LONG
#equ CL_USERDATA    36  ; LONG

#equ SIZEOF_CLASS  40

#equ OBJ_CLASS  0

#equ LIST_HEAD  0
#equ LIST_TAIL  4
#equ LIST_TAILPRED  8

#equ NIL  0
#equ TRUE  -1
#equ FALSE  0


#regpreserve OFF
#libraryenv OFF

;---------------------

PROC init

; theese are actually global, but when in LIBRARY mode,
; they have to be here.
LBLK _list 3       ; the classlist (mlh)
BBLK _ss   SIZEOF_SS   ; the signalsemaphore
;

   dmf InitSemaphore(_ss) ; init it

ENDPROC 1

PROC open
ENDPROC 1

PROC close
ENDPROC 

PROC expunge
ENDPROC

;-----our library functions--------------

#regpreserve a2-a6/d2-d7
#libraryenv SHARED

PROC Cl_NewClass     ; wrapper
   dpr NewClass(a0, d0, d1, a1, a2)
ENDPROC

PROC Cl_EndClass   ; wrapper
   dpr EndClass(a0)
ENDPROC

PROC Cl_FindClass ; wrapper
   dpr FindClass(a0)
ENDPROC

PROC Cl_AddClass ; wrapper
   dpr AddClass(a0)
ENDPROC

PROC Cl_RemClass ; wrapper
   dpr RemClass(a0)
ENDPROC

#libraryenv SHARED
#regpreserve a2-a6/d2-d7

PROC Cl_NewObject ; wrapper
   dpr NewObject(a0)
ENDPROC

PROC Cl_EndObject ; wrapper
   dpr EndObject(a0)
ENDPROC

PROC Cl_AddMethod ; wrapper
   dpr AddMethod(a0, d0, a1, a2, d1)
ENDPROC

PROC Cl_RemMethod ; wrapper
   dpr RemMethod(a0, d0)
ENDPROC

#libraryenv OFF
#regpreserve a2-a6/d2-d7

PROC Cl_DoMethod ; wrapper
   copy a2[].OBJ_CLASS, a3
   dpr DoMethod
ENDPROC

PROC Cl_DoSMethod ; wrapper
   copy a2[].OBJ_CLASS, a3
   copy a3[].CL_SUPERCLASS, a3
   dpr DoMethod
ENDPROC

#regpreserve OFF
#libraryenv OFF

;/* does NOT work on the class, but the OBJECT */
PROC Cl_GetOCName
   copy a0[].OBJ_CLASS, a0
ENDPROC a0[].CL_LN_NAME

;/* get the _CLASS_ userdata from an OBJECT */
;/* this is NOT the hook-data ! */
PROC Cl_GetOCData
  copy a0[].OBJ_CLASS, a0
ENDPROC a0[].CL_USERDATA

; /* NEW 000712 */
PROC Cl_GetHData
   copy a0[].16, d0
ENDPROC

; /* internals from here ... (params on stack) */

#regpreserve OFF
#libraryenv OFF

PROC NewClass %name, %datasize, %maxmethodid, %superclass, %user
   VAR class
   VAR memsize
   VAR strlen
   CODESTART
   ;/* allocate the class structure */
   dmf AllocMem(SIZEOF_CLASS, MEMF_CLEAR)
   copy d0 class
   IF class = NIL \ ret -1 \ ENDIF
   ;/* allocate mem for classname string */
   dpr  StrLen(%name)
   copy d0      strlen
   inc  strlen
   dmf  AllocMem(strlen, MEMF_CLEAR)
   copy d0,      class[].CL_LN_NAME
   IF class[].CL_LN_NAME = NIL \ dpr EndClass(class) \ RET -2 \ ENDIF
   ;/* copy classname string */
   dmf  CopyMem(%name, class[].CL_LN_NAME, strlen)
   ; /* set class.namelen */
   copy strlen, class[L].CL_NAMELEN
   ;/* set class.superclass */
   copy %superclass     class[L].CL_SUPERCLASS
   ;/* set class.cl_size */
   copy %datasize      class[L].CL_SIZE
   ;/* set maxmethodid */
   copy %maxmethodid   class[L].CL_MAXMETHODID
   ; /* copy userdata */
   copy %user, class[L].CL_USERDATA
   ;/* allocate mem for the cl_hooks */
   inc %maxmethodid
   mul %maxmethodid SIZEOF_CLHOOK memsize
   dmf AllocMem(memsize, MEMF_CLEAR)
   copy d0 class[L].CL_HOOKS
   IF class[L].CL_HOOKS = NIL \ dpr EndClass(class) \ ret -3 \ ENDIF
ENDPROC class
; returns negative numbers for failure


PROC EndClass %class
   VAR size
   CODESTART
   IF %class = NIL \ RET NIL \ ENDIF
   IF %class[L].CL_LN_NAME <> NIL
      dmf FreeMem(%class[L].CL_LN_NAME, %class[L].CL_NAMELEN)
   ENDIF
   IF %class[L].CL_HOOKS <> NIL
      add %class[L].CL_MAXMETHODID, 1, size
      mul SIZEOF_CLHOOK, size
      dmf FreeMem(%class[L].CL_HOOKS, size)
   ENDIF
   dmf FreeMem(%class, SIZEOF_CLASS)
ENDPROC NIL

PROC FindClass %name
   VAR class
   CODESTART
   dmf ObtainSemaphore(_ss)
   dmf FindName(_list, %name)
   copy d0, class
   dmf ReleaseSemaphore(_ss)
ENDPROC class


; /* add a class to internal list. */
PROC AddClass %class
   CODESTART
   dpr FindClass(%class[].CL_LN_NAME) ; is ss protected internally
   IF d0 <> NIL \ RET NIL \ ENDIF ; return NIL if it already existed..
   ; /* add class to list */
   dmf ObtainSemaphore(_ss)
   dmf AddTail         (_list, %class)
   dmf ReleaseSemaphore(_ss)
ENDPROC %class

;/*remove class from internal list. */
PROC RemClass %class
   CODESTART
   dmf ObtainSemaphore(_ss)
   dmf Remove(%class)
   dmf FreeMem(%class, SIZEOF_CLASS)
   dmf ReleaseSemaphore(_ss)
ENDPROC

#libraryenv OFF

PROC NewObject %class
   VAR object
   CODESTART

   dmf AllocMem(%class[].CL_SIZE, MEMF_CLEAR)
   IF d0 = NIL \ RET \ ENDIF
   copy d0, object

   ; stuff classptr in object
   copy %class, object[].OBJ_CLASS

ENDPROC object
; returns NIL for allocmem failure

PROC EndObject %object
   CODESTART

   ; free object
   copy %object[].OBJ_CLASS, a0
   dmf FreeMem(%object, a0[].CL_SIZE)
ENDPROC

PROC AddMethod %class, %mid, %entry, %subentry, %data
   VAR cl_hook
   CODESTART
   IF %mid > %class[].CL_MAXMETHODID \ RET NIL \ ENDIF
   ;/* get right hook */
   shl 4, %mid, d0
   add d0, %class[].CL_HOOKS, cl_hook
   ;/* copy values to hook */
   copy %entry,    cl_hook[].CLH_ENTRY
   copy %subentry, cl_hook[].CLH_SUBENTRY
   copy %data,     cl_hook[].CLH_DATA
ENDPROC %class


PROC RemMethod %class, %mid
   CODESTART
   IF %mid > %class[].CL_MAXMETHODID \ RET NIL \ ENDIF
      ;/* get right hook */
   shl 4, %mid d0
   add d0, %class[].CL_HOOKS, a0
      ; /* remove (NIL) the hook */
   copy NIL, a0[].CLH_ENTRY
ENDPROC TRUE

PROC DoMethod ; a2=obj, a3=class, d1=mid, a1=args
   ; a0=cl_hook

   shl 4, d1, a0     ; a0 is offset in CL_HOOKS

lab again

   add a3[].CL_HOOKS, a0    ; a0 points to current cl_hook

   ; try super if entry is NIL
   bic a0[].CLH_ENTRY = NIL, ifsuper

   ; try super if methodid is to big
   bic d1 > a3[].CL_MAXMETHODID, ifsuper

   copy a0[].CLH_ENTRY, a6 ; copy entry to a6
   dec a0, 8               ; a0 points to real fake hook
   call a6                 ; call entry
   ret                     ; and return

lab ifsuper
   ; return if superclass isnt available
   bic a3[].CL_SUPERCLASS = NIL, end
   ; class = superclass
   copy a3[].CL_SUPERCLASS, a3
   ; super call ourselves by back branching
   bal again

lab end
ENDPROC

; returns NIL if method wasnt available,
; else it returns the methods returnvalue
; (which of cource can be NIL)


; *********************************************************************
; * The assembly language stub for "vanilla" C parameter conventions
; * could be:  (snipped from includes/hooks.h)
; *
; * _hookEntry:
; *      move.l  a1,-(sp)                ; push message packet pointer
; *      move.l  a2,-(sp)                ; push object pointer
; *      move.l  a0,-(sp)                ; push hook ptr
; *      move.l  h_SubEntry(a0),a0       ; fetch C entry point ...
; *      jsr     (a0)                    ; ... and call it
; *      lea     12(sp),sp               ; fix stack
; *      rts
; *********************************************************************
; ** another example entry                     **
; ***********************************************
; * entry:                                      *
; *   move.l a1, -(a7)          ; push arglist  *
; *   move.l a2, -(a7)          ; push object   *
; *   move.l h_SubEntry(a0), a3 ; get subentry  *
; *   jsr (a3)                  ; call subentry *
; *   addq.l #8, a7             ; fix stack     *
; *   rts                       ; return        *
; *                                             *
; *   hook.data can now be reach from within    *
; *   your method with Cl_GetHData()            *
; *   (if needed)                               *
; ***********************************************

END

