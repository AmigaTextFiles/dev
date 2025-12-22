;Gadget Engine shared library. (c) 2001 by Pablo Daniel Roldan

   SECTION   code

   NOLIST
   incdir  "sys:devpac/include/"
   INCLUDE "exec/exec_lib.i"
   INCLUDE "exec/types.i"
   INCLUDE "exec/initializers.i"
   INCLUDE "exec/libraries.i"
   INCLUDE "exec/lists.i"
   INCLUDE "exec/alerts.i"
   INCLUDE "exec/resident.i"
   INCLUDE "exec/memory.i"
   INCLUDE "exec/execbase.i"
   INCLUDE "libraries/dos.i"
   INCLUDE "math/mathffp_lib.i"
   INCLUDE "math/mathtrans_lib.i"
   INCLUDE "intuition/intuition_lib.i"
   INCLUDE "intuition/intuition.i"
   INCLUDE "graphics/graphics_lib.i"
   INCLUDE "graphics/gfx.i"
   INCLUDE "graphics/view.i"
   INCLUDE "graphics/rastport.i"

   incdir  "sys:devpac/gengine/"
   INCLUDE "asmsupp.i"
   INCLUDE "genginebase.i"
   INCLUDE "gengine_rev.i"
   INCLUDE "gengine.i"
   INCLUDE "graphicsp.i"
   INCLUDE "ge_avl.i"
   INCLUDE "ge_tagitem.i"


   XDEF   InitTable                    ;------ These don't have to be external but it helps
   XDEF   Open                         ;------ some debuggers to have them globally visible
   XDEF   Close
   XDEF   Expunge
   XDEF   Null
   XDEF   LibName
   XDEF   RGBtoHSL
   XDEF   GetFreePen
   XDEF   GetClosestPen
   XDEF   Look4Color
   XDEF   GetBestPen
   XDEF   AllocGRPort
   XDEF   FreeGRPort
   XDEF   GetPenInfo
   XDEF   FreePenInfo
   XDEF   CModulo
   XDEF   CAlpha

   XREF   _AbsExecBase
   XDEF   _MathBase
   XDEF   _DOSBase
   XDEF   _IntuitionBase
   XDEF   _GfxBase
   XDEF   _MathTransBase

   XDEF   _OSVERSION    ; ---version of Exec.library
   ; The first executable location.  This should return an error in case someone tried to
   ; run you as a program (instead of loading you as a library).
Start:
   MOVEQ   #-1,d0
   rts

;------------------------------------------------------------------------------------------
; A romtag structure.  Both "exec" and "ramlib" look for this structure to discover magic
; constants about you (such as where to start running you from...).  The include file
; sample_rev.i (created by hand or preferable with the developer tool ``bumprev''
; resolves the VERSION, REVISION, and VSTRING.
;------------------------------------------------------------------------------------------
   ; Few people will need a priority and should leave it at zero.  The RT_PRI field is used
   ; in configuring the ROMs.  Use "mods" from wack to look at other romtags in the system.
MYPRI   EQU   0

RomTag:
               ;STRUCTURE RT,0
     DC.W    RTC_MATCHWORD      ; UWORD RT_MATCHWORD
     DC.L    RomTag             ; APTR  RT_MATCHTAG
     DC.L    EndCode            ; APTR  RT_ENDSKIP
     DC.B    RTF_AUTOINIT       ; UBYTE RT_FLAGS
     DC.B    VERSION            ; UBYTE RT_VERSION  (defined in sample_rev.i)
     DC.B    NT_LIBRARY         ; UBYTE RT_TYPE
     DC.B    MYPRI              ; BYTE  RT_PRI
     DC.L    LibName            ; APTR  RT_NAME
     DC.L    IDString           ; APTR  RT_IDSTRING
     DC.L    InitTable          ; APTR  RT_INIT  table for InitResident()

   ; this is the name that the library will have
LibName:   GENGINENAME
   ; standard name/version/date ID string from bumprev-created sample_rev.i
IDString:  VSTRING

dosName:   DOSNAME
mathName:  FFPNAME
intName:   INTNAME
gfxName:   GRAFNAME
mattName:  MATHTRANSNAME
   ; force word alignment
   ds.w   0

*Some Globals constants here
_DOSBase  dc.l  0
_MathBase dc.l  0
_IntuitionBase  dc.l  0
_GfxBase  dc.l  0
_MathTransBase dc.l  0

_OSVERSION dc.w 0

_MYLIB  dc.l 0   ;Pointer to this lib base (used by root class dispatcher)

_P1       dc.w  $DDD  ;Shine
_P2       dc.w  $BBB  ;HShine
_P3       dc.w  $000     ;Text
_P4       dc.w  $AAA  ;Back
_P5       dc.w  $444     ;Dark
_P6       dc.w  $777     ;HDark
_P7       dc.w  $08A    ;Highlight
_P8       dc.w  $BB0    ;Select


; Default values for preferences

_DefaultPref:
   dc.l   0,0,0,0 ; flags & fonts
   dc.l   $AA000000,$AA000000,$AA000000 ; Background color
   dc.l   0,0,0 ; Text color
   dc.l   $E0000000,$E0000000,$E0000000 ; Shine Color
   dc.l   $C0000000,$C0000000,$C0000000 ; Half Shine color
   dc.l   $50000000,$50000000,$50000000 ; Dark color
   dc.l   $70000000,$70000000,$70000000 ; Half Dark color
   dc.l   $D0000000,$B0000000,0         ; Highlight color
   dc.l   $FFFFFFFF,$40000000,$40000000 ; Select color
   dc.w   0,0,0,0
   dc.l   0
   dc.w   0,0,0,0
   dc.l   0
   dc.w   0

   ; this files contains constants
   INCLUDE "ge_mempools.i"
   INCLUDE "ge_classes.i"

   ; The romtag specified that we were "RTF_AUTOINIT".  This means that the RT_INIT
   ; structure member points to one of these tables below.  If the AUTOINIT bit was not
   ; set then RT_INIT would point to a routine to run.

InitTable:
   DC.L   GEngineBase_SIZEOF ; size of library base data space
   DC.L   funcTable         ; pointer to function initializers
   DC.L   dataTable         ; pointer to data initializers
   DC.L   initRoutine       ; routine to run


funcTable:

   ;------ standard system routines
   dc.l   Open
   dc.l   Close
   dc.l   Expunge
   dc.l   Null

   ;------ Color related functions
   dc.l   RGBtoHSL
   dc.l   GetFreePen
   dc.l   GetClosestPen
   dc.l   Look4Color
   dc.l   GetBestPen
   dc.l   AllocGRPort
   dc.l   FreeGRPort
   dc.l   GetPenInfo
   dc.l   FreePenInfo

   ;------ Two fields that will be (probably) private
   dc.l   CModulo
   dc.l   CAlpha

   ;------ AVL Trees functions (defined in GE_AVL.i)
   dc.l   GE_AVLMax
   dc.l   GE_AVLMin
   dc.l   GE_AVLFind
   dc.l   GE_AVLRLeft
   dc.l   GE_AVLRRight
   dc.l   GE_AVLRLeftR
   dc.l   GE_AVLRRightL
   dc.l   GE_AVLInsert
   dc.l   GE_AVLRemove
   dc.l   0            ;---Reserved

   ;------ MemPool Functions (defined in ge_mempools.i)
   dc.l   GE_NewMemPool
   dc.l   GE_PoolAlloc
   dc.l   GE_PoolDealloc
   dc.l   GE_FreeMemPool
   dc.l   0           ;---Reserved (Some kind of mem defrag?)

   ;------ Class Creation Function (defined in ge_classes.i)
   dc.l   GE_MakeClass
   dc.l   GE_FreeClass
   dc.l   GE_AddClass
   dc.l   GE_RemoveClass
   dc.l   GE_IsObject

   ;------ TagItem functions
   dc.l   GE_NextTagItem
   dc.l   GE_GetTagData
   ;------ function table end marker
   dc.l   -1


   ; The data table initializes static data structures.  The format is specified in
   ; exec/InitStruct routine's manual pages.  The INITBYTE/INITWORD/INITLONG routines are
   ; in the file "exec/initializers.i".  The first argument is the offset from the library
   ; base for this byte/word/long.  The second argument is the value to put in that cell.
   ; The table is null terminated.
   ; NOTE - LN_TYPE below is a correction - old example had LH_TYPE.

dataTable:
        INITBYTE        LN_TYPE,NT_LIBRARY
        INITLONG        LN_NAME,LibName
        INITBYTE        LIB_FLAGS,LIBF_SUMUSED!LIBF_CHANGED
        INITWORD        LIB_VERSION,VERSION
        INITWORD        LIB_REVISION,REVISION
        INITLONG        LIB_IDSTRING,IDString
        DC.L   0

   ; This routine gets called after the library has been allocated.  The library pointer is
   ; in D0.  The segment list is in A0.  If it returns non-zero then the library will be
   ; linked into the library list.

initRoutine:

   ;------ get the library pointer into a convenient A register
   move.l   a5,-(sp)
   move.l   d0,a5
   move.l   d0,_MYLIB

   ;------ save a pointer to exec
   move.l   a6,eb_SysLib(a5)
   move.w   LIB_VERSION(a6),_OSVERSION ; save os version number

   ;------ save a pointer to our loaded code
   move.l   a0,eb_SegList(a5)

   ;------ open the dos library
   lea   dosName(pc),a1
   CLEAR   d0
   CALLSYS   OpenLibrary

   move.l   d0,eb_DosLib(a5)
   beq.s   .1$
   move.l   d0,_DOSBase
   ;------ open the mathffp library
   lea   mathName(pc),a1
   CLEAR   d0
   CALLSYS   OpenLibrary
   move.l   d0,eb_MathLib(a5)
   move.l   d0,_MathBase
   beq.s   .2$
   lea   intName(pc),a1
   CLEAR   d0
   CALLSYS   OpenLibrary
   move.l   d0,eb_IntuiLib(a5)
   move.l   d0,_IntuitionBase
   beq.s    .3$
   lea   gfxName(pc),a1
   CLEAR   d0
   CALLSYS   OpenLibrary
   move.l   d0,eb_GraphLib(a5)
   move.l   d0,_GfxBase
   beq.s    .4$
   CLEAR   d0
   lea   mattName(pc),a1
   CALLSYS   OpenLibrary
   move.l   d0,_MathTransBase
   beq.s    .5$
   ;------ now build the static data that we need
   ;
   ; put your initialization here...
   ;

   move.l   #GPrefs_SIZEOF,d0
   move.l   #MEMF_CLEAR|MEMF_PUBLIC,d1
   CALLSYS   AllocMem
   tst.l    d0
   beq      .6$
   move.l   d0,eb_Prefs(a5)
   move.l   d0,a1
   lea      _DefaultPref(pc),a0
   move.l   #GPrefs_SIZEOF,d0
   CALLSYS   CopyMem
   lea      geshook1(pc),a0
   move.l   a0,eb_Hook1(a5)
   lea      geshook2(pc),a0
   move.l   a0,eb_Hook2(a5)
   move     #0,eb_ClassTree(a5)

;---Init WinList
   lea      eb_WinList(a5),a0
   NEWLIST  a0

;---Init object MemPool
   move.l   d2,-(sp)
   move.l   #4096,d0
   move.l   #MEMF_CLEAR|MEMF_PUBLIC,d1
   moveq    #2,d2
   bsr.s    GE_NewMemPool
   move.l   (sp)+,d2
   tst.l    d0
   beq.s    .nopool
   move.l   d0,eb_ObjPool(a5)

;--- Add Root Class
   movem.l  a2,-(sp)
   lea      GEROOTNAME(pc),a0
   move.l   #0,a1
   move.l   #0,a2
   move.l   #_gobject_SIZEOF,d0
   clr      d1
   bsr.s    GE_MakeClass
   move.l   (sp)+,a2
   tst.l    d0
   beq.s    .noroot
   move.l   d0,eb_GERClass(a5)
   move.l   d0,a0
   lea      _GRoot(pc),a1
   move.l   a1,h_Entry(a0)
   move.l   a6,-(sp)
   move.l   a5,a6
   bsr.s    GE_AddClass
   move.l   (sp)+,a6

   move.l   a5,d0
   bra.s    .1$

.noroot
   ;------ free mempool
   move.l  eb_ObjPool(a5),a0
   bsr.s   GE_FreeMemPool
.nopool
   ;------ free preferences
   move.l   eb_Prefs(a5),a1
   move.l   #GPrefs_SIZEOF,d0
   CALLSYS  FreeMem
.6$
   move.l  _MathTransBase,a1
   CALLSYS   CloseLibrary
.5$
   move.l  _GfxBase,a1
   CALLSYS   CloseLibrary
.4$
   move.l  _IntuitionBase,a1
   CALLSYS   CloseLibrary
.3$
   move.l  _MathBase,a1
   CALLSYS   CloseLibrary
.2$
   move.l  _DOSBase,a1
   CALLSYS   CloseLibrary
   CLEAR   d0
.1$
   move.l   (sp)+,a5
   rts

;------------------------------------------------------------------------------------------
; here begins the system interface commands.  When the user calls OpenLibrary/CloseLibrary/
; RemoveLibrary, this eventually gets translated into a call to the following routines
; (Open/Close/Expunge).  Exec has already put our library pointer in A6 for us.  Exec has
; turned off task switching while in these routines (via Forbid/Permit), so we should not
; take too long in them.
;------------------------------------------------------------------------------------------

   ; Open returns the library pointer in d0 if the open was successful.  If the open failed
   ; then null is returned.  It might fail if we allocated memory on each open, or if only
   ; open application could have the library open at a time...

Open:      ; ( libptr:a6, version:d0 )

   ;------ mark us as having another opener
   addq.w   #1,LIB_OPENCNT(a6)

   ;------ prevent delayed expunges
   bclr   #LIBB_DELEXP,eb_Flags(a6)

   move.l   a6,d0
   rts

   ; There are two different things that might be returned from the Close routine.  If the
   ; library is no longer open and there is a delayed expunge then Close should return the
   ; segment list (as given to Init).  Otherwise close should return NULL.

Close:      ; ( libptr:a6 )

   ;------ set the return value
   CLEAR   d0

   ;------ mark us as having one fewer openers
   subq.w   #1,LIB_OPENCNT(a6)

   ;------ see if there is anyone left with us open
   bne.s   1$

   ;------ see if we have a delayed expunge pending
   btst   #LIBB_DELEXP,eb_Flags(a6)
   beq.s   1$

   ;------ do the expunge
   bsr   Expunge
1$
   rts

   ; There are two different things that might be returned from the Expunge routine.  If
   ; the library is no longer open then Expunge should return the segment list (as given
   ; to Init).  Otherwise Expunge should set the delayed expunge flag and return NULL.
   ;
   ; One other important note: because Expunge is called from the memory allocator, it may
   ; NEVER Wait() or otherwise take long time to complete.

Expunge:   ; ( libptr: a6 )

   movem.l   d2/a5/a6,-(sp)
   move.l   a6,a5
   move.l   eb_SysLib(a5),a6

   ;------ see if anyone has us open
   tst.w   LIB_OPENCNT(a5)
   beq   1$

   ;------ it is still open.  set the delayed expunge flag
   bset   #LIBB_DELEXP,eb_Flags(a5)
   CLEAR   d0
   bra.s   Expunge_End

1$
   ;------ go ahead and get rid of us.  Store our seglist in d2
   move.l   eb_SegList(a5),d2

   ;------ unlink from library list
   move.l   a5,a1
   CALLSYS   Remove

   ;
   ; device specific closings here...
   ;
   ;------ Clear WinList
clearl:
   lea     eb_WinList(a5),a1
   IFEMPTY a1,clearldone
   move.l  (a1),a1
   move.l  #wl_SIZEOF,d0
   CALLSYS FreeMem
   lea     eb_WinList(a5),a0
   REMHEAD
   bra.s   clearl
clearldone:
   ;------ Remove Root class
   move.l  eb_GERClass(a5),a0
   move.l  a6,-(sp)
   bsr.s   GE_RemoveClass
   move.l  (sp)+,a6
   move.l  #0,gc_SubclassCount(a0) ;<-----!!!!!
   bsr.s   GE_FreeClass

   ;------ free mempool
   move.l  eb_ObjPool(a5),a0
   bsr.s   GE_FreeMemPool

   ;------ free preferences
   move.l   eb_Prefs(a5),a1
   move.l   #GPrefs_SIZEOF,d0
   CALLSYS  FreeMem

   ;------ close the dos library
   move.l   _DOSBase,a1
   CALLSYS   CloseLibrary
   move.l   _MathBase,a1
   CALLSYS   CloseLibrary
   move.l   _IntuitionBase,a1
   CALLSYS   CloseLibrary
   move.l   _GfxBase,a1
   CALLSYS   CloseLibrary
   move.l   _MathTransBase,a1
   CALLSYS   CloseLibrary

   ;------ free our memory
   CLEAR   d0
   move.l   a5,a1
   move.w   LIB_NEGSIZE(a5),d0

   sub.l   d0,a1
   add.w   LIB_POSSIZE(a5),d0

   CALLSYS   FreeMem

   ;------ set up our return value
   move.l   d2,d0

Expunge_End:
   movem.l   (sp)+,d2/a5/a6
   rts

Null:
   CLEAR   d0
   rts

;------------------------------------------------------------------------------------------
; Here begins the library specific functions.  Both of these simple functions are entirely
; in assembler, but you can write your functions in C if you wish and interface to them
; here.  If, for instance, the bulk of the AddThese function was written in C, you could
; interface to it as follows:
;
;   - write a C function  addTheseC(n1,n2) and compile it
;   - XDEF _addThese C  in this library code
;   - change the AddThese function code below to:
;       move.l d1,-(sp)     ;push rightmost C arg first
;       move.l d0,-(sp)     ;push other C arg(s), right to left
;       jsr    _addTheseC   ;call the C code
;       addq   #8,sp        ;fix stack
;       rts                 ;return with result in d0
;------------------------------------------------------------------------------------------

*----- RGBtoHSL(d0,d1,d2,a0,a1,a2)
RGBtoHSL:
   movem.l d3-d7/a6,-(sp)
   clr.l   d3
   clr.l   d4
   clr.l   d5
   clr.l   d6
   clr.l   d7


   moveq   #12,d3
   rol.l   d3,D0     ;calculate d0=rwork
   andi.l  #$FFF,D0

   rol.l   d3,d1     ;calculate d1=gwork
   andi.l  #$FFF,d1

   rol.l   d3,d2
   andi.l  #$FFF,d2    ;calculate d2=bwork

*calculate min
   cmp.w   d0,d1     ;rwork<gwork?
   bls.s   .01
   move.w  d0,d3     ;yes d3=min=rwork
   bra.s   .02
.01
   move    d1,d3     ;no  d3=gwork
.02
   cmp.w   d2,d3     ;bwork<min?
   bls.s   .10
   move.w  d2,d3     ;yes d3=bwork

*calculate max
.10
   cmp.w   d0,d1     ;rwork>gwork?
   bhi.s   .11
   move.w  d0,d4     ;yes d4=max=rwork
   bra.s   .12
.11
   move    d1,d4     ;no  d4=gwork
.12
   cmp.w   d2,d4     ;bwork>max?
   bhi.s   .20
   move.w  d2,d4     ;yes d4=bwork

.20
   move.w  d4,d7
   lsl.w   #4,d7
   move.w  d7,(a2)   ;lum is done
   move.w  d4,d7
   sub.w   d3,d7     ;diff=max-min
   move.w  d7,d3     ;now d3 is diff
   tst.w   d4
   beq.s   .22
   moveq   #16,d6
   lsl.l   d6,d7
   movem.l d0/d1,-(sp) ; save rwork and gwork
   move.l  d7,d0     ;d0=diff shl 16
   CALLFFP SPFlt     ;convert d0 to float
   move.l  d0,d7
   move.l  d4,d0
   CALLFFP SPFlt     ;convert max to float
   move.l  d0,d1     ;d1=float(max)
   move.l  d7,d0
   CALLFFP SPDiv     ;divide d0 by d1(max)
   CALLFFP SPFix
   move.l  #$FFFF,d1
   cmp.l   d1,d0
   bls.s   .21
   move.l  d1,d0
.21
   move.w  d0,(a1)   ;sat is done
   movem.l  (sp)+,d0/d1 ;restore rwork and gwork
   bra.s   .23
.22
   move.w  #0,(a1)   ;sat is done (again?)
.23
   moveq   #0,d7
   move.w  (a1),d7
   tst.w   d7        ;sat=0?
   bne.s   .30
   move.w  #0,(a0)   ; yes -> hue=0
   bra.s   .tend
.30
   move.w  d4,d7
   sub.w   d1,d7     ; max-gwork
   moveq   #16,d6
   lsl.l   d6,d7
   movem.l d0/d1,-(sp) ; save rwork and gwork
   move.l  d7,d0
   CALLFFP SPFlt     ;convert d0 to float
   move.l  d0,d7
   move.l  d3,d0
   CALLFFP SPFlt     ;convert diff to float
   move.l  d0,d1     ;d1=float(diff)
   move.l  d1,d6     ;d6 saves diff from being currupted by SPFix
   move.l  d7,d0
   CALLFFP SPDiv     ;divide d0 by d1(diff)
   CALLFFP SPFix
   tst.l   d0
   beq.s   .1
   subq.l  #1,d0
   lsr     #4,d0
.1
   move.w  d0,d5     ;d5=gpart

   move.w  d4,d0
   sub.w   d2,d0     ; max-bwork
   moveq   #16,d7
   lsl.l   d7,d0
   CALLFFP SPFlt     ;convert d0 to float
   move.l  d6,d1     ;recover diff
   CALLFFP SPDiv     ;divide d0 by d1(diff)
   CALLFFP SPFix
   tst.l   d0
   beq.s   .2
   subq.l  #1,d0
   lsr     #4,d0
.2
   move.l  d0,d6     ;d6=bpart
   movem.l (sp)+,d0/d1 ;restore rwork and gwork
   cmp.w   d0,d4     ;rwork=max?
   bne.s   .31
   move.w  d6,d0     ; yes
   sub.l   d5,d0     ; d0=hue=bpart-gpart
   bra.s   .40
.31
   move.w  d4,d7
   sub.w   d0,d7     ;max-rwork
   moveq   #16,d0
   lsl.l   d0,d7
   movem.l d1,-(sp)  ;save gwork
   move.l  d7,d0
   CALLFFP SPFlt     ;convert d0 to float
   move.l  d0,d7
   move.l  d3,d0
   CALLFFP SPFlt     ;convert diff to float
   move.l  d0,d1     ;d1=float(diff)
   move.l  d7,d0
   CALLFFP SPDiv     ;divide d0 by d1(diff)
   CALLFFP SPFix
   tst.l   d0
   beq.s   .3
   subq.l  #1,d0
   lsr     #4,d0     ;d0=rpart
.3
   movem.l (sp)+,d1  ;restore gwork
   cmp.w   d1,d4     ;gwork=max?
   bne.s   .32
   addi.l  #$2000,d0 ; yes -> hue=$2000+rpart...
   sub.l   d6,d0     ; -bpart
   bra.s   .40
.32
   cmp.l   d2,d4     ;bwork=max
   bne     .40
   addi.l  #$4000,d5 ; yes -> hue=$4000+gpart...
   sub.l   d0,d5     ; -rpart
   move.l  d5,d0     ; d0=hue

.40
   tst.l   d0
   bgt.s   .41
   addi.l  #$6000,d0
.41
   CALLFFP SPFlt     ; convert hue to float
   move.l  d0,d7
   move.l  #2667,d0
   CALLFFP SPFlt
   move.l  d0,d1
   move.l  d7,d0
   CALLFFP SPMul     ; hue x 2667...
   move.l  d0,d7
   move.l  #1000,d0
   CALLFFP SPFlt
   move.l  d0,d1
   move.l  d7,d0
   CALLFFP SPDiv     ; .../1000
   CALLFFP SPFix
   move.w  d0,(a0)   ; hue done

.tend
   movem.l (sp)+,d3-d7/a6
   rts

*----- GetFreePen(a0)
GetFreePen:
   movem.l a1-a2/d1,-(sp)
   moveq.l #0,d1
   move.l  vp_RasInfo(a0),a1
   move.l  ri_BitMap(a1),a2
   move.b  bm_Depth(a2),d1
   moveq.l #1,d0
   lsl.w   d1,d0
   subq.w  #1,d0
   mulu.w  #2,d0 ;d0= max pen
   move.l  vp_ColorMap(a0),a1
   move.l  cm_ColorTable(a1),a2
   movea.l  a2,a1
.1$
   cmp.w   #$FFFF,(a1,d0.w) ;its the pen d0 free?
   beq.s   .2$              ;yes
   subi.w  #2,d0            ;no, d0=previous pen
   bpl.s   .1$
   move.w  #-1,d0
   bra.s   .3$
.2$
   divu.w  #2,d0
.3$
   movem.l (sp)+,a1-a2/d1
   rts

*----- GetClosestPen(a0,d0/d2)
GetClosestPen:
   link    a5,#-38   ;Make space for variables
                    ;-2(a5) Ph
                    ;-4(a5) Ps
                    ;-6(a5) Pl
                    ;-8(a5) Wh
                    ;-10(a5) Ws
                    ;-12(a5) Wl
                    ;-14(a5) Py
      ;-16(a5) BRGB
      ;-18(a5) Best
                    ;-20(a5) BP
      ;-22(a5) r
                    ;-24(a5) g
                    ;-26(a5) b
                    ;-30(a5) r32
                    ;-34(a5) g32
                    ;-38(a5) b32

   movem.l a1-a2/d3-d7,-(sp)
   move.w   _OSVERSION(pc),d3
   cmp.w    #39,d3
   blt.s    .old$
   move.l  a3,-(sp)
   move.l  d2,d3
   move.l  d1,d2
   move.l  d0,d1
   move.l  #-1,d4
   move.l  vp_ColorMap(a0),a3
   CALLGRAF  FindColor
   move.l  (sp)+,a3
   movem.l (sp)+,a1-a2/d3-d7
   unlk    a5
   rts


.old$
   move.l  d0,d3
   move.l  d0,-30(a5) ;r32
   rol.l   #4,d3
   andi.l  #$F,d3
   move.w  d3,-22(a5) ;r
   lsl.w   #8,d3
   move.l  d1,d4
   move.l  d1,-34(a5) ;g32
   rol.l   #4,d4
   andi.l  #$F,d4
   move.w  d4,-24(a5) ;g
   lsl.w   #4,d4
   move.l  d2,d5
   move.l  d2,-38(a5) ;b32
   rol.l   #4,d5
   andi.l  #$F,d5
   move.w  d5,-26(a5) ;b
   or.w    d3,d4
   or.w    d4,d5    ;d5=prgb

   movem.l  a0/d0,-(sp) ;save a0 & d0
   lea     -2(a5),a0    ;Ph
   lea     -4(a5),a1    ;Ps
   lea     -6(a5),a2    ;Pl
   jsr     RGBtoHSL
   movem.l (sp)+,a0/d0  ;restore a0 & d0

   move.l  d1,-(sp)
   CALLFFP SPFlt
   move.l  #-1717986753,d1 ; d1=0.30
   jsr     _LVOSPMul(a6)
   move.l  d0,d3
   move.l  (sp)+,d1
   move.l  d1,d0
   jsr     _LVOSPFlt(a6)
   move.l  #-1760936640,d1 ; d1=0.59
   jsr     _LVOSPMul(a6)
   move.l  d3,d1
   jsr     _LVOSPAdd(a6)
   move.l  d0,d3
   move.l  d2,d0
   jsr     _LVOSPFlt(a6)
   move.l  #-515396035,d1  ; d1=0.11
   jsr     _LVOSPMul(a6)
   move.l  d3,d1
   jsr     _LVOSPAdd(a6)
   jsr     _LVOSPFix(a6)
   move.w  d0,-14(a5)       ;PY done
; d0:r, d1:g, d2:b not needed anymore
   moveq.l #1,d3
   move.l  vp_RasInfo(a0),a1
   move.l  ri_BitMap(a1),a2
   moveq.l #0,d4
   move.b  bm_Depth(a2),d4
   lsl.w   d4,d3
   subi.w  #1,d3    ;d3=#colors-1
   move.l  vp_ColorMap(a0),a1
   move.l  a0,-(sp)
   move.l  a1,a0
   move.w  #$FFFF,-18(a5)
   move.w  #$FFFF,-16(a5)
   move.w  #0,-20(a5)

.loop0
   move.l  d3,d0
   CALLGRAF GetRGB4
   andi.l  #$FFF,d0
   move.l  d0,d1
   move.l  d0,d2
   move.l  d0,d7
   lsr.w   #8,d0
   andi.w  #15,d0  ;d0=Wr
   lsr.w   #4,d1
   andi.w  #15,d1  ;d1=Wg
   andi.w  #15,d2  ;d2=Wb
   cmp.w   #0,d5
   beq.s   .ext
   cmp.w   #$FFF,d5
   bne.s   .mid
.ext
   move.l  d1,d7
   CALLFFP SPFlt
   move.l  #-1717986753,d1 ; d1=0.30
   jsr     _LVOSPMul(a6)
   move.l  d0,d6
   move.l  d7,d1
   move.l  d1,d0
   jsr     _LVOSPFlt(a6)
   move.l  #-1760936640,d1 ; d1=0.59
   jsr     _LVOSPMul(a6)
   move.l  d6,d1
   jsr     _LVOSPAdd(a6)
   move.l  d0,d6
   move.l  d2,d0
   jsr     _LVOSPFlt(a6)
   move.l  #-515396035,d1  ; d1=0.11
   jsr     _LVOSPMul(a6)
   move.l  d6,d1
   jsr     _LVOSPAdd(a6)
   jsr     _LVOSPFix(a6)
   sub.w   -14(a5),d0
   bpl.s   .b1
   neg.w   d0
.b1
   moveq.l #0,d6
   move.w  -18(a5),d6
   cmp.l   d6,d0
   bpl.s   .doloop
   move.w  d0,-18(a5)      ;d0=Best
   move.w  d3,-20(a5)      ;d3=BP
   bra.s   .doloop
.mid
   movem.l d0-d2,-(sp)
   move.l  -30(a5),d0 ;r32
   move.l  -34(a5),d1 ;g32
   move.l  -38(a5),d2 ;b32
   lea     -8(a5),a0       ;Wh
   lea     -10(a5),a1      ;Ws
   lea     -12(a5),a2      ;Wl
   jsr     RGBtoHSL

   movem.l (sp)+,d0-d2
   move.w  -8(a5),d4
   sub.w   -2(a5),d4
   bpl.s   .1$
   neg.w   d4
.1$
   andi.l  #$FFFF,d4
   divu.w  #2,d4
   move.w  -10(a5),d6
   sub.w   -4(a5),d6
   bpl.s   .2$
   neg.w   d6
.2$
   andi.l  #$FFFF,d6
   divu.w  #2,d6
   add.w   d6,d4
   move.w  -12(a5),d6
   sub.w   -6(a5),d6
   bpl.s   .3$
   neg.w   d6
.3$
   andi.l  #$FFFF,d6
   divu.w  #2,d6
   add.w   d6,d4
   andi.l  #$FFFF,d4
   divu.w  #3,d4      ;d4=Actual
   andi.l  #$FFFF,d4

   moveq.l #0,d6
   move.w  -18(a6),d6
   cmp.l   d6,d4
   bpl.s   .doloop
   sub.w   -22(a5),d0
   bpl.s   .4$
   neg.w   d0
.4$
   sub.w   -24(a5),d1
   bpl.s   .5$
   neg.w   d1
.5$
   add.w   d1,d0
   sub.w   -26(a5),d2
   bpl.s   .6$
   neg.w   d2
.6$
   add.w   d2,d0     ;d0=argb

   moveq.l #0,d6
   move.w  -16(a5),d6
   cmp.l   d6,d0
   bpl.s   .doloop
   move.w  d4,-18(a5)
   move.w  d0,-16(a5)
   move.w  d3,-20(a5)

.doloop
   move.l  (sp),a0
   move.l  vp_ColorMap(a0),a0
   subi.w  #1,d3
   bpl.s   .loop0

.end
   move.w  -20(a5),d0
   move.l  (sp)+,a0
   movem.l (sp)+,a1-a2/d3-d7
   unlk    a5
   rts


;----- Look4Color(a0,d0/d1/d2)

Look4Color:


   movem.l  a0-a1/d3-d6,-(sp)
   move.w   _OSVERSION(pc),d3
   cmp.w    #39,d3
   blt.s    .v34$
   link     a5,#-12 ;Allocate Buffer
   move.l   d0,d3
   move.l   d1,d4
   move.l   d2,d5
   move.l   vp_RasInfo(a0),a1
   move.l   ri_BitMap(a1),a1
   move.b   bm_Depth(a1),d2
   moveq    #1,d6
   lsl.w    d2,d6 ;d6=max colors
   move.l   vp_ColorMap(a0),a0
   move.l   a0,-(sp)
   move.l   _GfxBase,a6
   moveq    #0,d2
.l2$
   move.l   d2,d0
   lea      -12(a5),a1
   moveq    #1,d1
   jsr      _LVOGetRGB32(a6)
   move.l   (sp),a0
   cmp.l    -12(a5),d3
   bne.s    .nxt$
   cmp.l    -8(a5),d4
   bne.s    .nxt$
   cmp.l    -4(a5),d5
   bne.s    .nxt$
   move.l   d2,d0
   move.l   (sp)+,a0
   unlk     a5
   bra.s    .e3$
.nxt$
   addi.w   #1,d2
   cmp.w    d2,d6
   bne.s    .l2$
   move.w   #-1,d0
   move.l   (sp)+,a0
   unlk     a5
   bra.s    .e3$

.v34$
   moveq    #12,d3
   rol.l    d3,d0
   andi.l   #$F00,d0
   rol.l    #8,d1
   andi.l   #$F0,d1
   rol.l    #4,d2
   andi.l   #$F,d2
   or.w     d2,d1
   or.w     d1,d0
   moveq    #0,d2
   move.w   d0,d1
   moveq    #1,d3
   move.l   vp_RasInfo(a0),a1
   move.l   ri_BitMap(a1),a1
   move.b   bm_Depth(a1),d2
   lsl.w    d2,d3           ;d3=max colors
   move.l   vp_ColorMap(a0),a0
   move.l   a0,-(sp)
   move.l   _GfxBase,a6
   moveq    #0,d2
.lup$
   move.w   d2,d0
   jsr      _LVOGetRGB4(a6)
   move.l   (sp),a0
   cmp.w    d0,d1
   beq.s    .end$
   addi.w   #1,d2
   cmp.b    d2,d3
   bne.s    .lup$
   move.w   #-1,d0
   bra.s    .e2$
.end$
   move.w   d2,d0
.e2$
   move.l   (sp)+,a0
.e3$
   movem.l  (sp)+,a0-a1/d3-d6
   rts

;-----GetBestPen(a0,d0/d1/d2)

GetBestPen:

   movem.l  a0-a1/d3,-(sp)
   movem.l  d0-d2,-(sp)
   jsr      Look4Color
   cmpi.w   #-1,d0
   bne.s    .d1$
   move.w   _OSVERSION,d3
   cmpi.w   #39,d3
   blt.s    .os$
   ;movem.l  (sp)+,d1-d3
   ;movem.l  d4/a0,-(sp)
   ;move.l   vp_ColorMap(a0),a0
   ;move.l   #-1,d0
   ;moveq    #1,d4
   ;CALLGRAF ObtainPen
   ;movem.l  (sp)+,d4/a0
   ;cmpi.l    #-1,d0
   ;bne.s    .do$
   bra.s    .nip$

.os$
   jsr      GetFreePen
   cmpi.w   #-1,d0
   beq.s    .nip$
   movem.l  (sp)+,d1-d3 ;ACA!!!
   movem.l  d0/d4,-(sp)
   moveq    #12,d4
   rol.l    d4,d1
   andi.l   #$F00,d1
   rol.l    #8,d2
   andi.l   #$F0,d2
   rol.l    #4,d3
   andi.l   #$F,d3
   CALLGRAF SetRGB4
   movem.w  (sp)+,d0/d4
   bra.s    .do$

.nip$
   movem.l  (sp)+,d0-d2
   jsr      GetClosestPen
   bra.s    .do$

.d1$
   move.w   d0,d3
   movem.l  (sp)+,d0-d2
   move.w   d3,d0
.do$
   movem.l  (sp)+,a0-a1/d3
   rts


;-----AllocGRPort (d0-d2)

AllocGRPort:
   link    a5,#-16
 ; -4 : RASSIZE
 ; -8 : Raster
 ; -12: BitMap
 ; -16: Buf size
   movem.l a0-a2/d3-d4,-(sp)
   move.w  d0,d3
   addi.w  #15,d3
   lsr.w   #3,d3
   andi.w  #$FFFE,d3
   mulu.w  d1,d3
   move.l  d3,-4(a5)
   mulu.w  d2,d3             ;d3= RASSIZE*depth
   move.l  d3,-16(a5)
   move.l  d0,d4
   move.l  d3,d0
   move.w  d1,-(sp)
   move.l  #MEMF_CLEAR|MEMF_PUBLIC|MEMF_CHIP,d1
   CALLEXEC AllocMem
   move.w  (sp)+,d1
   tst.l   d0
   beq.s   .nil1$

   move.l  d0,-8(a5)
   move.l  d1,-(sp)
   move.l  #bm_SIZEOF,d0
   move.l  #MEMF_CLEAR|MEMF_PUBLIC,d1
   jsr     _LVOAllocMem(a6)
   move.l  (sp)+,d1
   tst.l   d0
   beq.s   .nil2$

   move.l  d0,a0
   move.l  d0,-12(a5)
   move.w  d2,d0
   move.w  d1,d2
   move.w  d4,d1
   move.w  d0,-(sp)
   CALLGRAF InitBitMap
   move.w  (sp)+,d0
   move.l  -4(a5),d2      ;d2= RASSIZE
   move.l  -8(a5),d1
   move.l  -12(a5),a0
   adda.l  #bm_Planes,a0

   moveq   #0,d4
.for$
   move.l  d1,(a0)   ;Set Plane pointers

   addq    #1,d4
   add.l   d2,d1
   adda.l  #4,a0
   cmp.w   d0,d4
   bne.s   .for$

   move.w  d2,d3
   mulu.w  d0,d3
   move.l  #rp_SIZEOF,d0

   move.l  #MEMF_CLEAR|MEMF_PUBLIC,d1
   CALLEXEC AllocMem    ;Allocate RastPort
   tst.l   d0
   beq     .nil3$

   move.l  d0,a1
   move.l  a1,-(sp)
   CALLGRAF InitRastPort
   move.l  (sp)+,a1
   move.l  -12(a5),rp_BitMap(a1)
   moveq   #0,d0
   move.l  a1,-(sp)
   jsr     _LVOSetRast(a6)
   move.l  (sp)+,d0
   bra.s   .ok1$


.nil3$
   move.l  -12(a5),a1
   move.l  #bm_SIZEOF,d0
   CALLEXEC FreeMem

.nil2$
   move.l  -16(a5),d0
   move.l  -8(a5),a1
   CALLEXEC FreeMem
   moveq   #0,d0

.ok1$
.nil1$
   movem.l (sp)+,a0-a2/d3/d4
   unlk    a5
   rts


;FreeGRPort(a0)

FreeGRPort:

   cmpa.l  #0,a0
   beq.s   .end$
   movem.l d0/d1/a1,-(sp)
   move.l  rp_BitMap(a0),a1
   cmpa.l  #0,a1
   beq.s   .nobm$
   move.w  bm_BytesPerRow(a1),d0
   mulu.w  bm_Rows(a1),d0
   moveq   #0,d1
   move.b  bm_Depth(a1),d1
   mulu.w  d1,d0
   movem.l  a0-a1,-(sp)
   move.l  bm_Planes(a1),a1
   CALLEXEC FreeMem      ; Free Planes Memory
   movem.l (sp)+,a0/a1
   move.l  #bm_SIZEOF,d0
   move.l  a0,-(sp)
   jsr     _LVOFreeMem(a6)
   move.l  (sp)+,a0

.nobm$
   move.l  a0,a1
   move.l  #rp_SIZEOF,d0
   CALLEXEC FreeMem
   movem.l (sp)+,d0/d1/a1

.end$
   rts

; GetPenInfo(a0):d0

GetPenInfo:

   link    a5,#-16 ;Space for variables
      ; -4 viewport
      ; -8 peninfo
      ; -12 buffer
      ; -16 gengine base
   move.l  a6,-16(a5)
   movem.l a0-a2/d1-d3,-(sp)
   move.l  a0,d0
   tst.l   d0
   beq.s   .no$
   lea.l   sc_ViewPort(a0),a0
   move.l  a0,-4(a5) ;viewport
   move.l  #PenInfo_SIZEOF,d0
   move.l  #MEMF_CLEAR+MEMF_PUBLIC,d1
   CALLEXEC  AllocMem  ;Alloc PenInfo
   tst.l   d0
   beq.s   .no$
   move.l  d0,-8(a5) ; PenInfo
   move.l  #16,d0
   move.l  #MEMF_CLEAR+MEMF_PUBLIC,d1
   jsr    _LVOAllocMem(a6)
   tst.l   d0
   beq.s   .n1$
   move.l  d0,-12(a5)  ;Buffer
   move.l  d0,a2
   move.l  -8(a5),a1
   move.w  #1,PI_Version(a1)
   move.w  #8,PI_NumPens(a1)
   move.l  -16(a5),a0
   move.l  eb_Prefs(a0),a0
   lea     gp_BkgCol(a0),a1
   move.l  -4(a5),a0
   moveq   #0,d3
   move.w  #0,(a2)+
   lea     12(a1),a1

.lo$   ;start loop
   move.l  (a1)+,d0
   move.l  (a1)+,d1
   move.l  (a1)+,d2
   jsr     GetBestPen
   move.w  d0,(a2)+
   add.w   #1,d3
   cmp.w   #7,d3
   bne.s   .lo$    ;end loop

   move.l  -8(a5),a0
   move.l  -12(a5),PI_PenArray(a0) ; PenArray=Buffer
   move.l  -4(a5),a1
   move.l  vp_ColorMap(a1),a1
   CLEAR   d0
   move.w  cm_Count(a1),d0
   CALLGRAF  GetColorMap
   tst.l   d0
   beq.s   .n2$   ;No colormap allocated ->
   move.l  -8(a5),a0
   move.l  d0,PI_ColorMap(a0)
   move.w  _OSVERSION,d0
   cmpi.w  #39,d0
   bra.s   .lv34$
   CLEAR   d0
   CLEAR   d1
   movea.l a0,a1
   move.l  -4(a5),a0
   move.l  vp_ColorMap(a0),a0
   move.w  cm_Count(a0),d1
   move.l  PI_ColorMap(a1),a1
   move.l  cm_ColorTable(a1),a1
   CALLGRAF GetRGB32
   move.l  -8(a5),d0
   bra.s   .don$

.lv34$
   CLEAR   d2
   move.l  PI_ColorMap(a0),a2
   move.w  cm_Count(a2),d2
   move.l  -4(a5),a0
   move.l  vp_ColorMap(a0),-(sp)
   CLEAR   d3

.lo2$
   move.l  (sp),a0
   move.w  d3,d0
   CALLGRAF GetRGB4
   movem.l d2-d3,-(sp)
   move.l  d0,d1
   move.l  d0,d2
   exg     d0,d3
   movea.l a2,a0
   CALLGRAF SetRGB4CM
   movem.l (sp)+,d2-d3
   addq    #1,d3
   cmp.w   d3,d2
   bne.s   .lo2$
   move.l  -8(a5),d0
   lea     4(sp),sp
   bra.s   .don$


.n2$
   move.l  -12(a5),a1
   moveq   #16,d0
   CALLEXEC  FreeMem

.n1$
   move.l  -8(a5),a1
   move.l  #PenInfo_SIZEOF,d0
   CALLEXEC FreeMem

.no$
   moveq   #0,d0

.don$
   movem.l (sp)+,a0-a2/d1-d3
   unlk    a5
   rts

; FreePenInfo(a0);

FreePenInfo:

   movem.l a1/d0,-(sp)
   move.l  a0,d0
   tst.l   d0
   beq.s   .fin$
   move.l  PI_PenArray(a0),a1
   move.l  a1,d0
   tst.l   d0
   beq.s   .npen$
   move.l  a0,-(sp)
   moveq   #16,d0
   CALLEXEC  FreeMem
   move.l  (sp)+,a0

.npen$
   move.l  PI_ColorMap(a0),a1
   move.l  a1,d0
   tst.l   d0
   beq.s   .f1$
   move.l  a0,-(sp)
   movea.l a1,a0
   CALLGRAF  FreeColorMap
   move.l  (sp)+,a0

.f1$
   move.l  a0,a1
   move.l  #PenInfo_SIZEOF,d0
   CALLEXEC  FreeMem

.fin$
   movem.l  (sp)+,a1/d0
   rts


; d0 = CModulo(d0,d1) Retorna SQRT(X^2+Y^2)

CModulo:

   movem.l   d2-d3,-(sp)
   move.l    d1,d3
   move.l    d0,d1
   CALLFFP   SPMul
   move.l    d0,d2
   move.l    d3,d0
   move.l    d0,d1
   jsr       _LVOSPMul(a6)
   move.l    d2,d1
   jsr       _LVOSPAdd(a6)
   CALLMATHTRANS SPSqrt
   movem.l   (sp)+,d2-d3
   rts


; d0 = CAlpha(d0,d1)
; #-921707583 = -2PI/4
; #-921707711 = 2PI/4
; #-921707710 = 2PI/2
; #-921707709 = 2PI


CAlpha:

   movem.l   d4-d6,-(sp)
   move.l    d0,d4
   move.l    d1,d5
   tst.l     d0
   beq.s     .nox$
   tst.l     d1
   bne.s     .siy$
   move.l    d0,d1
   moveq     #0,d0
   CALLFFP   SPCmp
   bgt.s     .nex$
   move.l    #-921707583,d6
   bra.s     .cuad$
.nex$
   move.l    #-921707711,d6
   bra.s     .cuad$
.siy$
   CALLFFP   SPAbs
   move.l    d0,d6
   move.l    d1,d0
   jsr       _LVOSPAbs(a6)
   move.l    d6,d1
   exg       d0,d1
   jsr       _LVOSPDiv(a6)
   CALLMATHTRANS SPAtan
   move.l    d0,d6
   bra.s     .cuad$
.nox$
   move.l    d5,d1
   moveq     #0,d0
   CALLFFP   SPCmp
   bgt.s     .mix$
   moveq     #0,d6
   bra.s     .cuad$
.mix$
   move.l    #-921707710,d6

; check in which cuadrant we are
.cuad$
   move.l    d4,d1
   moveq     #0,d0
   CALLFFP   SPCmp
   bgt.s     .Q1$
   move.l    d5,d1
   moveq     #0,d0
   jsr       _LVOSPCmp(a6)
   blt.s     .Q1$
   move.l    #-921707709,d0
   move.l    d6,d1
   jsr       _LVOSPSub(a6)
   bra.s     .alend$
.Q1$
   move.l    d4,d1
   moveq     #0,d0
   jsr       _LVOSPCmp(a6)
   bgt.s     .Q2$
   move.l    d5,d1
   moveq     #0,d0
   jsr       _LVOSPCmp(a6)
   bgt.s     .Q2$
   move.l    #-921707710,d0
   move.l    d6,d1
   jsr       _LVOSPAdd(a6)
   bra.s     .alend$
.Q2$
   move.l    d4,d1
   moveq     #0,d0
   jsr       _LVOSPCmp(a6)
   blt.s     .nend$
   move.l    d5,d1
   moveq     #0,d0
   jsr       _LVOSPCmp(a6)
   bgt.s     .nend$
   move.l    #-921707710,d0
   move.l    d6,d1
   jsr       _LVOSPSub(a6)
   bra.s     .alend$
.nend$
   move.l    d6,d0
.alend$
   movem.l   (sp)+,d4-d6
   rts

   ; EndCode is a marker that show the end of your code.  Make sure it does not span
   ; sections nor is before the rom tag in memory!  It is ok to put it right after the ROM
   ; tag--that way you are always safe.  I put it here because it happens to be the "right"
   ; thing to do, and I know that it is safe in this case.

EndCode:

   END

