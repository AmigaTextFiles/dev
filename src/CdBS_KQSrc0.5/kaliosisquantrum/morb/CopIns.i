*
* Macros for copper instructions
* ©1997-1998, CdBS Software (MORB)
* $Id: CopIns.i 0.2 1997/08/22 18:30:51 MORB Exp MORB $
*

**** comove src,dest

comove   macro
         dc.w      \2,\1
         endm

**** cowait x,y

cowait   macro
         dc.b      \2,\1|1
         dc.w      $fffe
         endm

**** coskip x,y

coskip   macro
         dc.b      \2,\1|1
         dc.w      $ffff
         endm

**** cocol val,n

cocol    macro
         dc.w      color+\2*2,\1
         endm

**** conop
*** Puts 0 in dmacon, which does nothing but take two words
*** in the copperlist. Useful.

conop    macro
         dc.w      $96,0
         endm

**** coend

coend    macro
         dc.l      $fffffffe
         endm
