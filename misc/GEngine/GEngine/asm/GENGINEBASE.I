* genginebase.i
*
********************************************************************************************
* definition of gengine.library base
*******************************************************************************************

   IFND  GENGINE_BASE_I
GENGINE_BASE_I SET 1


   IFND  EXEC_TYPES_I
   INCLUDE  "exec/types.i"
   ENDC   ; EXEC_TYPES_I

   IFND  EXEC_LIBRARIES_I
   INCLUDE  "exec/libraries.i"
   ENDC   ; EXEC_LIBRARIES_I

;--------------------------
; library data structures
;--------------------------
;  Note that the library base begins with a library node

   STRUCTURE GEngineBase,LIB_SIZE
   UBYTE   eb_Flags
   UBYTE   eb_pad
   ;We are now longword aligned
   ULONG   eb_SysLib
   ULONG   eb_DosLib
   ULONG   eb_MathLib
   ULONG   eb_GraphLib
   ULONG   eb_IntuiLib
   ULONG   eb_SegList
   ULONG   eb_Prefs
;---------------------
   ULONG   eb_Hook1   ;this two tmp
   ULONG   eb_Hook2
   ULONG   eb_ObjPool ;Object Memory pool
   ULONG   eb_ClassTree ;AVLTree of Public Classes
   STRUCT  eb_WinList, MLH_SIZE
;--------------------- Built-in Classes
   ULONG   eb_GERClass
   ULONG   eb_GEIClass
   LABEL   GEngineBase_SIZEOF

;-=-=-=-=-=-=-=-=-
; Preferences
;-=-=-=-=-=-=-=-=-

   STRUCTURE GPreferences,0
   ULONG   gp_Flags
   ULONG   gp_WnFont
   ULONG   gp_SmFont
   ULONG   gp_BgFont
   STRUCT  gp_BkgCol,12
   STRUCT  gp_TxtCol,12
   STRUCT  gp_ShiCol,12
   STRUCT  gp_HShCol,12
   STRUCT  gp_DrkCol,12
   STRUCT  gp_HDkCol,12
   STRUCT  gp_HglCol,12
   STRUCT  gp_SltCol,12
   UWORD   gp_BtStyle
   UWORD   gp_BtBackPen
   UWORD   gp_BtPresPen
   UWORD   gp_Reserved1   ;By now its only to
   ULONG   gp_BtTxtFont   ;make this long-word alligned
   UWORD   gp_SlStyle
   UWORD   gp_SlCStyle
   UWORD   gp_SlArrPosition
   UWORD   gp_Reserved2   ;Same gp_Reserved1
   ULONG   gp_SlTxtFont
   UWORD   gp_StStyle
   LABEL   GPrefs_SIZEOF

GENGINENAME   MACRO
      DC.B   'gengine.library',0
      ENDM

   ENDC  ;GENGINE_BASE_I

