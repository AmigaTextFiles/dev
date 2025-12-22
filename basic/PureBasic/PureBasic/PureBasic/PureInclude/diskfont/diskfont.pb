;
;  $VER: diskfont.h 38.0 (18.6.92)
;  Includes Release 40.15
;
;  diskfont library definitions
;
;  (C) Copyright 1990 Robert R. Burns
;      All Rights Reserved
;  (C) Copyright 1985-1993 Commodore-AMIGA, Inc.
;      All Rights Reserved
;


IncludePath   "PureInclude:"
XIncludeFile "exec/nodes.pb"
XIncludeFile "exec/lists.pb"
XIncludeFile "graphics/text.pb"

#MAXFONTPATH = 256   ; including null terminator

Structure FontContents
    fc_FileName.b[#MAXFONTPATH]
    fc_YSize.w
    fc_Style.b
    fc_Flags.b
EndStructure


Structure TFontContents
    tfc_FileName.b[#MAXFONTPATH-2];
    tfc_TagCount.w; /* including the TAG_DONE tag */
    ;
    ; *  If tfc_TagCount is non-zero, tfc_FileName is overlayed with
    ; *  Text Tags starting at:  (struct TagItem *)
    ; *      &tfc_FileName[MAXFONTPATH-(tfc_TagCount*SizeOf(struct TagItem))]
    ; */
    tfc_YSize.w;
    tfc_Style.b;
    tfc_Flags.b;
EndStructure


#FCH_ID  = $0f00  ; FontContentsHeader, Then FontContents */
#TFCH_ID = $0f02  ; FontContentsHeader, Then TFontContents */
#OFCH_ID = $0f03  ; FontContentsHeader, Then TFontContents,
;         * associated with outline font */

Structure FontContentsHeader
    fch_FileID.w;   ; FCH_ID */
    fch_NumEntries.w; ; the number of FontContents elements */
    ; Newtype .FontContents fch_FC[], OR Newtype .TFontContents fch_TFC[]; */
EndStructure


#DFH_ID   = $0f80
#MAXFONTNAME = 32  ; font name including ".font\0" */

Structure DiskFontHeader
    ; the following 8 bytes are NOT actually considered a part of the  */
    ; DiskFontHeader, but immediately preceed it. The NextSegment is */
    ; supplied by the linker/loader, AND the ReturnCode is the code  */
    ; at the beginning of the font in Case someone runs it...    */
    ;   ULONG dfh_NextSegment;     \* actually a BPTR  */
    ;   ULONG dfh_ReturnCode;      \* MOVEQ #0,D0 : RTS  */
    ; here Then is the official start of the DiskFontHeader...   */
    dfh_DF.Node   ; node to link disk fonts */
    dfh_FileID.w   ; DFH_ID */
    dfh_Revision.w ; the font revision */
    dfh_Segment.l  ; the segment address when loaded */
    dfh_Name.b[#MAXFONTNAME]; ; the font name (null terminated) */
    dfh_TF.TextFont ; loaded TextFont structure */
EndStructure

; unfortunately, this needs To be explicitly typed */
; Used only If dfh_TF.tf_Style FSB_TAGGED bit is set */
;#dfh_TagList = #dfh_Segment ; destroyed during loading */


#AFB_MEMORY = 0
#AFF_MEMORY = $0001
#AFB_DISK   = 1
#AFF_DISK   = $0002
#AFB_SCALED = 2
#AFF_SCALED = $0004
#AFB_BITMAP = 3
#AFF_BITMAP = $0008

#AFB_TAGGED = 16  ; Return TAvailFonts */
#AFF_TAGGED = $10000

Structure AvailFonts
  af_Type.w         ; MEMORY, DISK, or SCALED */
  af_Attr.TextAttr  ; text attributes for font */
EndStructure


Structure TAvailFonts
  taf_Type.w          ; MEMORY, DISK, or SCALED */
  taf_Attr.TTextAttr  ; text attributes for font */
EndStructure

Structure AvailFontsHeader
  afh_NumEntries.w   ; number of AvailFonts elements */
  ; Newtype .AvailFonts afh_AF[], OR Newtype .TAvailFonts afh_TAF[]; */
EndStructure


