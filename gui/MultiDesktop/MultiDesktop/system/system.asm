 PMMU
 FPU

CALLSYS  macro \1
      jsr      _LVO\1(A6)
      endm

 xdef _GetCPUType
 xdef _GetMMUType
 xdef _GetFPUType
 xdef _GetCACR
 xdef _SetCACR
 xdef _GetCRP
 xdef _SetCRP
 xdef _GetSRP
 xdef _SetSRP
 xdef _GetTC
 xdef _SetTC
 xdef _GetTT0
 xdef _SetTT0
 xdef _GetTT1
 xdef _SetTT1

_LVOSupervisor   equ -30
_LVOFindTask     equ -294
_AbsExecBase     equ   $4

CIB_ENABLE     equ   0
CIB_FREEZE     equ   1
CIB_CLEAR      equ   3
CIB_BURST      equ   4

CDB_ENABLE     equ   8
CDB_FREEZE     equ   9
CDB_CLEAR      equ   11
CDB_BURST      equ   12

AFB_68881      equ   4
AFB_68030      equ   2
AFB_68020      equ   1
AFB_68010      equ   0

TC_TRAPCODE    equ   $0032
ATNFLGS        equ   $0129


 jmp _GetMMUType

 ;======================================================================
 ;
 ;  This function returns the type of the CPU in the system as a
 ;  longword: 68000, 68010, 68020, or 68030.  The testing must be done
 ;  in reverse order, in that any higher CPU also has the bits set for
 ;  a lower CPU.  Also, since 1.3 doesn't recognize the 68030, if I
 ;  find the 68020 bit set, I always check for the presence of a
 ;  68030.
 ;
 ;  This routine should be the first test routine called under 1.2
 ;  and 1.3.
 ;
 ;  ULONG GetCPUType();
 ;
 ;======================================================================

_GetCPUType:
   movem.l  a4/a5,-(sp)             ; Save this register
   move.l   _AbsExecBase,a6         ; Get ExecBase
   btst.b   #AFB_68030,ATNFLGS(a6)  ; Does the OS think an '030 is here?
   beq.s _GetCPUType_0
   move.l   #68030,d0               ; Sure does...
   movem.l  (sp)+,a4/a5
   rts

_GetCPUType_0:
   btst.b   #AFB_68020,ATNFLGS(a6)  ; Maybe a 68020
   bne.s _GetCPUType_2
   btst.b   #AFB_68010,ATNFLGS(a6)  ; Maybe a 68010?
   bne.s _GetCPUType_1
   move.l   #68000,d0               ; Just a measley '000
   movem.l  (sp)+,a4/a5
   rts

_GetCPUType_1:
   move.l   #68010,d0               ; Yup, we're an '010
   movem.l  (sp)+,a4/a5
   rts

_GetCPUType_2:
   move.l   #68020,d0               ; Assume we're an '020
   lea   _GetCPUType_3,a5           ; Get the start of the supervisor code
   CALLSYS Supervisor
   movem.l  (sp)+,a4/a5
   rts

   machine mc68020
_GetCPUType_3:
   movec cacr,d1                    ; Get the cache register
   move.l   d1,a4                   ; Save it for a minute
   bset.l   #CIB_BURST,d1           ; Set the inst burst bit
   bclr.l   #CIB_ENABLE,d1          ; Clear the inst cache bit
   movec d1,cacr                    ; Try to set the CACR
   movec cacr,d1
   btst.l   #CIB_BURST,d1           ; Do we have a set burst bit?
   beq.s _GetCPUType_4
   move.l   #68030,d0               ; It's a 68030
   bset.b   #AFB_68030,ATNFLGS(a6)

_GetCPUType_4:
   move.l   a4,d1                   ; Restore the original CACR
   movec d1,cacr
   rte
   machine mc68000

;======================================================================
;
;  This function returns the type of the FPU in the system as a
;  longword: 0 (no FPU), 68881, or 68882.
;
;  ULONG GetFPUType();
;
;======================================================================

_GetFPUType:
   move.l   a5,-(sp)                ; Save this register
   move.l   _AbsExecBase,a6         ; Get ExecBase
   btst.b   #AFB_68881,ATNFLGS(a6)  ; Does the OS think an FPU is here?
   bne.s _GetFPUType_1
   moveq.l  #0,d0                   ; No FPU here, dude
   move.l   (sp)+,a5                ; Give back the register
   rts

_GetFPUType_1:
   lea   _GetFPUType_2,a5           ; Get the start of the supervisor code
   CALLSYS Supervisor
   move.l   (sp)+,a5                ; Give back registers
   rts

_GetFPUType_2:
   move.l   #68881,d0               ; Assume we're a 68881
   fsave -(sp)                      ; Test and check
   moveq.l  #0,d1
   move.b   1(sp),d1                ; Size of this frame
   cmpi  #$18,d1
   beq   _GetFPUType_3
   move.l   #68882,d0               ; It's a 68882

_GetFPUType_3:
   frestore (sp)+                   ; Restore the stack
   rte               

;======================================================================
;
;  This function returns 0L if the system contains no MMU, 
;  68851L if the system does contain an 68851, or 68030L if the
;  system contains a 68030.
;
;  This routine seems to lock up on at least some CSA 68020 
;  boards, though it runs just fine on those from Ronin and 
;  Commodore, as well as all 68030 boards it's been tested on.
;
;  ULONG GetMMUType()
;
;======================================================================

_GetMMUType:
   move.l   _AbsExecBase,a6         ; Get ExecBase
   movem.l  a3/a4/a5,-(sp)          ; Save this stuff
   moveq #0,d0
   move.l   d0,a1
   CALLSYS  FindTask                ; Call FindTask(0L)
   move.l   d0,a3                 
                                 
   move.l   TC_TRAPCODE(a3),a4      ; Change the exception vector
   lea      _GetMMUType_2,a0
   move.l   a0,TC_TRAPCODE(a3)
   
   subq.l   #4,sp                   ; Let's try an MMU instruction
   pmove tc,(sp)
   cmpi  #0,d0                      ; Any MMU here?
   beq.s _GetMMUType_1
   btst.b   #AFB_68030,ATNFLGS(a6)  ; Does the OS think an '030 is here?
   beq.s _GetMMUType_1
   move.l   #68030,d0

_GetMMUType_1:
   addq.l   #4,sp                   ; Return that local
   move.l   a4,TC_TRAPCODE(a3)      ; Reset exception stuff
   movem.l  (sp)+,a3/a4/a5          ; and return the registers
   rts

 ; This is the exception code.  No matter what machine we're on,
 ; we get an exception.  If the MMU's in place, we should get a
 ; privilige violation; if not, an F-Line emulation exception.

_GetMMUType_2:
   move.l   (sp)+,d0                ; Get Amiga supplied exception #
   cmpi  #11,d0                     ; Is it an F-Line?
   beq.s _GetMMUType_3              ; If so, go to the fail routine
   move.l   #68851,d0               ; We have MMU
   addq.l   #4,2(sp)                ; Skip the MMU instruction
   rte

_GetMMUType_3:
   moveq.l  #0,d0                   ; It dinna woik,
   addq.l   #4,2(sp)                ; Skip the MMU instruction
   rte

;======================================================================
;
;  This function returns the MMU CRP register.  It assumes a 68020
;  system with MMU, or a 68030 based system (eg, test for MMU before
;  you call this, or you wind up in The Guru Zone).  Note that the
;  CRP register is two longwords long.
;
;  void GetCRP(a4)
;
;======================================================================

_GetCRP:
   move.l   _AbsExecBase,a6         ; Get ExecBase
   move.l   a5,-(sp)
   lea   _GetCRP_2,a5               ; Get the start of the supervisor code
   CALLSYS  Supervisor
   move.l   (sp)+,a5
   rts

_GetCRP_2:
   pmove crp,(a0)
   rte

;======================================================================
;
;  This function sets the MMU CRP register.  It assumes a 68020 
;  system with MMU, or a 68030 based system (eg, test for MMU before
;  you call this, or you wind up in The Guru Zone).  Note that the
;  CRP register is two longwords long.
;
;  void SetCRP(a4)
;
;======================================================================

_SetCRP:
   move.l   _AbsExecBase,a6      ; Get ExecBase
   move.l   a5,-(sp)
   lea   _SetCRP_2,a5            ; Get the start of the supervisor code
   CALLSYS  Supervisor
   move.l   (sp)+,a5             ; Give back registers
   rts

_SetCRP_2:
   pflusha                       ; explicitly flush the ATC for now
   pmove (a0),crp
   rte

;======================================================================
;
;  This function returns the MMU SRP register.  It assumes a 68020
;  system with MMU, or a 68030 based system (eg, test for MMU before
;  you call this, or you wind up in The Guru Zone).  Note that the
;  SRP register is two longwords long.
;
;  void GetSRP(a4)
;
;======================================================================

_GetSRP:
   move.l   _AbsExecBase,a6         ; Get ExecBase
   move.l   a5,-(sp)
   lea   _GetSRP_2,a5               ; Get the start of the supervisor code
   CALLSYS  Supervisor
   move.l   (sp)+,a5
   rts

_GetSRP_2:
   pmove srp,(a0)
   rte

;======================================================================
;
;  This function sets the MMU SRP register.  It assumes a 68020
;  system with MMU, or a 68030 based system (eg, test for MMU before
;  you call this, or you wind up in The Guru Zone).  Note that the
;  SRP register is two longwords long.
;
;  void SetSRP(a4)
;
;======================================================================

_SetSRP:
   move.l   _AbsExecBase,a6      ; Get ExecBase
   move.l   a5,-(sp)
   lea   _SetSRP_2,a5            ; Get the start of the supervisor code
   CALLSYS  Supervisor
   move.l   (sp)+,a5             ; Give back registers
   rts

_SetSRP_2:
   pflusha                       ; explicitly flush the ATC for now
   pmove (a0),srp
   rte

;======================================================================
;
;  This function returns the MMU TC register.  It assumes a 68020 
;  system with MMU, or a 68030 based system (eg, test for MMU before
;  you call this, or you wind up in The Guru Zone).  
;
;  ULONG GetTC()
;
;======================================================================

_GetTC:
   move.l   _AbsExecBase,a6      ; Get ExecBase
   move.l   a5,-(sp)
   subq.l   #4,sp                ; Make a place to dump TC
   move.l   sp,a0
   lea   _GetTC_2,a5             ; Get the start of the supervisor code
   CALLSYS  Supervisor
   move.l   (sp),d0              ; Here's the result
   addq.l   #4,sp          
   move.l   (sp)+,a5
   rts

_GetTC_2:
   pmove tc,(a0)
   rte

;======================================================================
;
;  This function sets the MMU TC register.  It assumes a 68020 
;  system with MMU, or a 68030 based system (eg, test for MMU before
;  you call this, or you wind up in The Guru Zone).
;
;  void SetTC(ULONG)
;
;======================================================================

_SetTC:
   lea   4(sp),a0                ; Get address of our new TC value
   move.l   _AbsExecBase,a6      ; Get ExecBase
   move.l   a5,-(sp)
   lea   _SetTC_2,a5             ; Get the start of the supervisor code
   CALLSYS  Supervisor
   move.l   (sp)+,a5
   rts

_SetTC_2:
   pflusha                       ; explicitly flush the ATC for now
   pmove (a0),tc
   rte

;======================================================================
;
;  This function returns the MMU TT0 register.  It assumes a 68020
;  system with MMU, or a 68030 based system (eg, test for MMU before
;  you call this, or you wind up in The Guru Zone).  
;
;  ULONG GetTT0()
;
;======================================================================

   machine mc68030
_GetTT0:
   move.l   _AbsExecBase,a6      ; Get ExecBase
   move.l   a5,-(sp)
   subq.l   #4,sp                ; Make a place to dump TT0
   move.l   sp,a0
   lea   _GetTT0_2,a5             ; Get the start of the supervisor code
   CALLSYS  Supervisor
   move.l   (sp),d0              ; Here's the result
   addq.l   #4,sp          
   move.l   (sp)+,a5
   rts

_GetTT0_2:
   pmove tt0,(a0)
   rte
   machine mc68000

;======================================================================
;
;  This function sets the MMU TT0 register.  It assumes a 68020
;  system with MMU, or a 68030 based system (eg, test for MMU before
;  you call this, or you wind up in The Guru Zone).
;
;  void SetTT0(ULONG)
;
;======================================================================

   machine mc68030
_SetTT0:
   lea   4(sp),a0                ; Get address of our new TT0 value
   move.l   _AbsExecBase,a6      ; Get ExecBase
   move.l   a5,-(sp)
   lea   _SetTT0_2,a5             ; Get the start of the supervisor code
   CALLSYS  Supervisor
   move.l   (sp)+,a5
   rts

_SetTT0_2:
   pflusha                       ; explicitly flush the ATC for now
   pmove (a0),tt0
   rte
   machine mc68000

;======================================================================
;
;  This function returns the MMU TT1 register.  It assumes a 68020
;  system with MMU, or a 68030 based system (eg, test for MMU before
;  you call this, or you wind up in The Guru Zone).  
;
;  ULONG GetTT1()
;
;======================================================================

   machine mc68030
_GetTT1:
   move.l   _AbsExecBase,a6      ; Get ExecBase
   move.l   a5,-(sp)
   subq.l   #4,sp                ; Make a place to dump TT1
   move.l   sp,a0
   lea   _GetTT1_2,a5             ; Get the start of the supervisor code
   CALLSYS  Supervisor
   move.l   (sp),d0              ; Here's the result
   addq.l   #4,sp          
   move.l   (sp)+,a5
   rts

_GetTT1_2:
   pmove tt1,(a0)
   rte
   machine mc68000

;======================================================================
;
;  This function sets the MMU TT1 register.  It assumes a 68020
;  system with MMU, or a 68030 based system (eg, test for MMU before
;  you call this, or you wind up in The Guru Zone).
;
;  void SetTT1(ULONG)
;
;======================================================================

   machine mc68030
_SetTT1:
   lea   4(sp),a0                ; Get address of our new TT1 value
   move.l   _AbsExecBase,a6      ; Get ExecBase
   move.l   a5,-(sp)
   lea   _SetTT1_2,a5             ; Get the start of the supervisor code
   CALLSYS  Supervisor
   move.l   (sp)+,a5
   rts

_SetTT1_2:
   pflusha                       ; explicitly flush the ATC for now
   pmove (a0),tt1
   rte
   machine mc68000

;======================================================================
;
;  This function returns the 68020/68030 CACR register.  It assumes
;  a 68020 or 68030 based system.
;
;  ULONG GetCACR()
;
;======================================================================

_GetCACR:
   move.l   _AbsExecBase,a6         ; Get ExecBase
   btst.b   #AFB_68020,ATNFLGS(a6)  ; Does the OS think an '020 is here?
   bne.s _GetCACR_1
   moveq #0,d0                      ; No CACR here, pal
   rts

   machine mc68020
_GetCACR_1:
   move.l   a5,-(sp)                ; Save this register
   lea   _GetCACR_2,a5              ; Get the start of the supervisor code
   CALLSYS  Supervisor
   move.l   (sp)+,a5                ; Give back registers
   rts

_GetCACR_2:
   movec cacr,d0                    ; Make CACR the return value
   rte
   machine mc68000

;======================================================================
;
;  This function sets the value of the 68020/68030 CACR register.  
;  It assumes a 68020 or 68030 based system.
;
;  void SetCACR(cacr)
;  ULONG cacr;
;
;======================================================================

_SetCACR:
   move.l   4(sp),d0                ; New CACR is on stack
   move.l   _AbsExecBase,a6         ; Get ExecBase
   btst.b   #AFB_68020,ATNFLGS(a6)  ; Does the OS think an '020 is here?
   bne.s _SetCACR_1
   rts                              ; No CACR here, pal

   machine mc68020
_SetCACR_1:
   move.l   a5,-(sp)                ; Save this register
   lea   _SetCACR_2,a5              ; Get the start of the supervisor code
   CALLSYS  Supervisor
   move.l   (sp)+,a5                ; Give back register
   rts

_SetCACR_2:
   movec d0,cacr                    ; Set the CACR
   rte
   machine mc68000
