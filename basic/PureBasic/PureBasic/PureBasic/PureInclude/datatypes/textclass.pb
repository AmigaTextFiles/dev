; 
; **  $VER: textclass.h 39.3 (3.8.92)
; **  Includes Release 40.15
; **
; **  Interface definitions for DataType text objects.
; **
; **  (C) Copyright 1992-1993 Commodore-Amiga, Inc.
; ** All Rights Reserved
; 

IncludePath  "PureInclude:"
XIncludeFile "utility/tagitem\h"
XIncludeFile "datatypes/datatypesclass\h"
XIncludeFile "libraries/iffparse\h"

; ***************************************************************************

; #TEXTDTCLASS  = "text\datatype"

; ***************************************************************************

;  Text attributes 
; #TDTA_Buffer  = (#DTA_Dummy + 300)
; #TDTA_BufferLen  = (#DTA_Dummy + 301)
; #TDTA_LineList  = (#DTA_Dummy + 302)
; #TDTA_WordSelect  = (#DTA_Dummy + 303)
; #TDTA_WordDelim  = (#DTA_Dummy + 304)
; #TDTA_WordWrap  = (#DTA_Dummy + 305)
     ;  Boolean. Should the text be word wrapped.  Defaults to false. 

; ***************************************************************************

;  There is one Line structure for every line of text in our document. 
Structure Line

    ln_Link.MinNode  ;  to link the lines together 
    *ln_Text.b  ;  pointer to the text for this line 
    ln_TextLen.l  ;  the character length of the text for this line 
    ln_XOffset.w  ;  where in the line the text starts 
    ln_YOffset.w  ;  line the text is on 
    ln_Width.w  ;  Width of line in pixels 
    ln_Height.w  ;  Height of line in pixels 
    ln_Flags.w  ;  info on the line 
    ln_FgPen.b  ;  foreground pen 
    ln_BgPen.b  ;  background pen 
    ln_Style.l  ;  Font style 
    *ln_Data.l  ;  Link data... 
EndStructure

; ***************************************************************************

;  Line.ln_Flags 

;  Line Feed 
#LNF_LF  = (1L Lsl 0)

;  Segment is a link 
#LNF_LINK = (1L Lsl 1)

;  ln_Data is a pointer to an DataTypes object 
#LNF_OBJECT = (1L Lsl 2)

;  Object is selected 
#LNF_SELECTED = (1L Lsl 3)

; ***************************************************************************

;  IFF types that may be text 
#ID_FTXT  = MAKE_ID('F','T','X','T')
#ID_CHRS  = MAKE_ID('C','H','R','S')

; ***************************************************************************

