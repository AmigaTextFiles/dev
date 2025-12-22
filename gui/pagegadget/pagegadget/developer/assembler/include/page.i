
**
** $VER: page.i 1.0 (09.09.96)
**
** Definitions for the page BOOPSI class
**
** (C) Copyright 1996 by Jens Tröger
** All Rights Reserved
**
** done with genious DevPac 3...  
** set tabstops to 11
**

IFND GADGETS_PAGE_I
GADGETS_PAGE_I  SET     1

; -------------------------------------------------------------------------

IFND UTILITY_TAGITEM_I
 INCLUDE "utility/tagitem.i"
ENDC

IFND UTILITY_HOOKS_I
 INCLUDE "utility/hooks.i"

IFND EXEC_LIBRARIES_I
 INCLUDE "exec/libraries.i"
ENDC

; -------------------------------------------------------------------------
; defs of the bevelbox 

 STRUCTURE BevelBox,0
  ULONG NextBBox
  WORD  Left
  WORD  Top
  WORD  Width
  WORD  Height
  ULONG Flags
  WORD  PtrnAPen
  WORD  PtrnBPen
  WORD  BoxShin
  WORD  BoxShadow
 LABEL BevelBox_SIZEOF

; -------------------------------------------------------------------------
; this is the most important structure

 STRUCTURE Page,0
  ULONG NextPage
  ULONG Name
  ULONG  NameFlags
  ULONG FirstGadget
  ULONG FirstIText
  ULONG FirstBBox
  ULONG  FirstImage
  ULONG  ThisPageHook
 LABEL Page_SIZEOF

; -------------------------------------------------------------------------
; the page-library base returned by OpenLibrary()
   
 STRUCTURE      PageBase,LIB_SIZE
  UBYTE page_Flags
  UBYTE page_PadByte
  ULONG page_SegList
  ULONG page_SysBase
  ULONG page_DOSBase
  ULONG page_IntuitionBase
  ULONG page_GfxBase
  ULONG page_GadtoolsBase
  ULONG page_UtilityBase
  ULONG page_DiskfontBase
  ULONG page_Class
 LABEL  PageBase_SIZEOF

; --------------------------------------------------------------------------
; this will get your hook function as a thrid argument

 STRUCTURE PageHookObject,0
  ULONG pho_GInfo
  ULONG pho_ActivaPage
 LABEL PageHookObject_SIZEOF

; --------------------------------------------------------------------------
; the tags of the page.gadget

PAGE_Pages              (TAG_USER + 0)  ; ti_Data holds pointer to the first Page-structure
PAGE_Layout     (TAG_USER + 1)  ; defines the look of the pages (see PGLYT_* flags)
PAGE_Underscore         (TAG_USER + 2)  ; not implemented yet
PAGE_Active     (TAG_USER + 3)  ; the active page (starts with 0 !!)
PAGE_TextFont   (TAG_USER + 4)  ; ptr to TextFont of the page-gadget
PAGE_TextAttr   (TAG_USER + 5)  ; ptr to TextAttr of the page-gadget
PAGE_ActiveStyle        (TAG_USER + 6)  ; defines the look of the selected page (see PGAST_* flags)

; --------------------------------------------------------------------------
; flags etc....   (see tags)

BBFLG_BACKFILL  1               ; fill bevel-box with BackPen color
BBFLG_PATTERNFILL       2               ; if BBFLG_BACKFILL then draw pattern
BBFLG_RECESSED  4               ; recessed-look of bevel-box
BBFLG_FRAMENONE 8               ; bevel-box without any borders
BBFLG_FRAMEBUTTON       16              ; simple button-look
BBFLG_FRAMERIDGE        32              ; looks like a string-gadget

PGLYT_SIMPLE    0               ; PAGE_Layout
PGLYT_MUISTYLE  1
PGLYT_GADTOOLS  2

PGAST_NORMAL    0               ; PAGE_ActiveStyle
PGAST_HILIGHT   1
PGAST_SHADOW    2

; --------------------------------------------------------------------------

ENDC    ; GADGETS_PAGE_I


