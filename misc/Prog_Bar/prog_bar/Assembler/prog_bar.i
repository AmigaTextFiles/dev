   IFND PROG_BAR_I
PROG_BAR_I  SET   1

** $Filename: progbar.i $
** $Release: 1.01 $
** $Revision: 36.1 $
** $Date: 18/11/96 $
**
** Prog_Bar definitions, a progress bar system
**
** (C) Copyright 1996 by Allan Savage
** All Rights Reserved

   IFND  EXEC_TYPES_I
   INCLUDE "exec/types.i"
   ENDC

   IFND UTILITY_TAGITEM_I
   INCLUDE "utility/tagitem.i"
   ENDC

   IFND INTUITION_INTUITION_I
   INCLUDE "intuition/intuition.i"
   ENDC

;------------------------------------------------------------------------------

PB_Dummy             EQU   TAG_USER+$60000

; Tags for CreateProgBar() and SetProgBarAttrs()

PB_LeftEdge          EQU   PB_Dummy+1     ; X pos
PB_TopEdge           EQU   PB_Dummy+2     ; Y pos
PB_Width             EQU   PB_Dummy+3     ; Width
PB_Height            EQU   PB_Dummy+4     ; Height
PB_Direction         EQU   PB_Dummy+5     ; Direction of Expansion
PB_BarColour         EQU   PB_Dummy+6     ; Bar colour
PB_BarBackColour     EQU   PB_Dummy+7     ; Bar Background colour
PB_BarSize           EQU   PB_Dummy+8     ; Value of full Bar
PB_BarValue          EQU   PB_Dummy+9     ; Value of filled Bar
PB_BorderType        EQU   PB_Dummy+10    ; Type of Border

PB_TextMode          EQU   PB_Dummy+11    ; Actual Value or %age
PB_TextPosition      EQU   PB_Dummy+12    ; Position to display text
PB_TextColour        EQU   PB_Dummy+13    ; Text Colour
PB_TextBackColour    EQU   PB_Dummy+14    ; Text BackGround Colour
PB_TextFont          EQU   PB_Dummy+15    ; Font for text (*TextAttr)

; Options for PB_Direction

PBDE_RIGHT           EQU   0              ; From Left to Right  ( default )
PBDE_LEFT            EQU   1              ; From Right to Left
PBDE_UP              EQU   2              ; From Bottom to Top
PBDE_DOWN            EQU   3              ; From Top to Bottom

; Options for PB_BorderType

PBBT_NONE            EQU   10             ; No Border
PBBT_PLAIN           EQU   11             ; Plain Black Box  ( default )
PBBT_RECESSED        EQU   12             ; Recessed Box
PBBT_RAISED          EQU   13             ; Raised Box
PBBT_RIDGE           EQU   14             ; Raised Ridge

; Options for Text Mode

PBTM_NONE            EQU   20             ; No Text  ( default )
PBTM_PERCENT         EQU   21             ; Display Value as a %age
PBTM_VALUE           EQU   22             ; Display Value as "Value/Total"

; Options for Text Position

PBTP_BELOW           EQU   30             ; Text centred below Bar  ( default )
PBTP_ABOVE           EQU   31             ; Text centred above Bar
PBTP_LEFT            EQU   32             ; Text to left of Bar
PBTP_RIGHT           EQU   33             ; Text to right of Bar
PBTP_CENTRE          EQU   34             ; Text centred inside Bar

; Structure Definition

   STRUCTURE P_Bar, 0

   ; The following fields are set up when the Progress Bar is created.
   ; They are simply quick reference points for the information needed
   ; to display the Progress Bar.  DO NOT CHANGE THE VALUES STORED HERE.

   APTR     pbr_Wnd                       ; Window to render Bar in
   APTR     pbr_RPort                     ; RastPort used for rendering
   APTR     pbr_Vis_Info                  ; VisualInfo for Bar
   STRUCT   pbr_Bar_IText,it_SIZEOF       ; Used to display the Text
   STRUCT   pbr_Bar_Text,16               ; Used to store the Text

   ; The following fields are used to store the current settings for the
   ; Progress Bar.  They should not be changed directly, but can be altered
   ; using SetProgBarAttrs()

   UWORD    pbr_LeftEdge                  ; Column Number for Left Edge
   UWORD    pbr_TopEdge                   ; Row Number for Top Edge
   UWORD    pbr_Width                     ; Total Width  ( including Border )
   UWORD    pbr_Height                    ; Total Height ( including Border )

   UBYTE    pbr_Direction                 ; Direction for Bar Expansion

   UBYTE    pbr_Bar_Colour                ; Pen Number for rendering Bar
   UBYTE    pbr_Bar_Background            ; Pen Number for Bar Background
   UWORD    pbr_Bar_Size                  ; Value for full bar
   UWORD    pbr_Bar_Value                 ; Current Value for Bar

   UBYTE    pbr_Border_Type               ; Type of Border

   UBYTE    pbr_Text_Mode                 ; Mode for text display
   UBYTE    pbr_Text_Position             ; Placement for Text

   ; The following fields are working variables for the functions and
   ; should not be used or altered by your program.

   UWORD    pbr_B_LeftEdge                ; LeftEdge of Bar ( No Border )
   UWORD    pbr_B_RightEdge               ; RightEdge of Bar ( No Border )
   UWORD    pbr_B_TopEdge                 ; TopEdge of Bar ( No Border )
   UWORD    pbr_B_BottomEdge              ; BottomEdge of Bar ( No Border )
   UWORD    pbr_B_Length                  ; Bar Length in pixels ( No Border )
   UWORD    pbr_B_Value                   ; Number of pixels to fill
   UBYTE    pbr_B_Percent                 ; Percentage of Bar filled
   UWORD    pbr_T_Width                   ; Width of text in pixels
   UWORD    pbr_T_Height                  ; Height of text in pixels
   UWORD    pbr_MT_Width                  ; Max Text Width in Pixels
   UWORD    pbr_MT_Left                   ; Left coordinate of longest test
   UWORD    pbr_MT_Top                    ; Top coordinate of longest text

   LABEL PBar_SIZEOF

PBAR     MACRO                         ; P_Bar structure
\1     EQU     SOFFSET
SOFFSET     SET     SOFFSET+PBar_SIZEOF
       ENDM


; Function Prototypes

   IFND  PROG_BAR_A

   XREF  _CreateProgBarA
   XREF  _CreateProgBar
   XREF  _SetProgBarAttrsA
   XREF  _SetProgBarAttrs
   XREF  _FreeProgBar
   XREF  _RefreshProgBar
   XREF  _UpdateProgBar
   XREF  _ResetProgBar
   XREF  _ClearProgBar
   XREF  _ClearBar
   XREF  _ClearText

   ENDC  ; PROG_BAR_A

   ENDC  ; PROG_BAR_I
