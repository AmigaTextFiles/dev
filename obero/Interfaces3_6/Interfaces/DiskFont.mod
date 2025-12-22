(*
(*
**  Amiga Oberon Interface Module:
**  $VER: DiskFont.mod 40.15 (28.12.93) Oberon 3.0
**
**   © 1993 by Fridtjof Siebert
**   updated for V39, V40 by hartmut Goebel
*)
*)

MODULE DiskFont;

IMPORT
  e * := Exec,
  g * := Graphics,
  I * := Intuition,
  u * := Utility;

CONST
  maxFontPath * = 256;    (* including null terminator *)
  diskfontName * = "diskfont.library";

TYPE
  FontContentsPtr * = UNTRACED POINTER TO FontContents;
  FontContents * = STRUCT
    fileName * : ARRAY maxFontPath OF CHAR;
    ySize * : INTEGER;
    style * : SHORTSET;
    flags * : SHORTSET;
  END;


  TFontContentsPtr * = UNTRACED POINTER TO TFontContents;
  TFontContents * = STRUCT
    fileName * : ARRAY maxFontPath-2 OF CHAR;
    tagCount * : INTEGER;
    (*
     *  if tfc_TagCount is non-zero, tfc_FileName is overlayed with
     *  Text Tags starting at:  (struct TagItem * )
     *      &tfc_FileName[MAXFONTPATH-(tfc_TagCount*sizeof(struct TagItem))]
     *)
    ySize * : INTEGER;
    style * : SHORTSET;
    flags * : SHORTSET;
  END;

CONST
  fchId     * = 00F00H;  (* FontContentsHeader, then FontContents *)
  tfchId    * = 00F02H;  (* FontContentsHeader, then TFontContents *)
  ofchID    * = 00F03H;  (* FontContentsHeader, then TFontContents,
                          * associated with outline font *)

TYPE
  FontContentsHeaderPtr * = UNTRACED POINTER TO FontContentsHeader;
  FontContentsHeader * = STRUCT
    fileID * : INTEGER;         (* FCH_ID *)
    numEntries * : INTEGER;     (* the number of FontContents elements *)
 (* fc  * : ARRAY numEntries OF FontContents or
    tfc * : ARRAY numEntries OF TFontContents    *)
  END;

CONST

  dfhId       * = 00F80H;
  maxFontName * = 32;     (* font name including ".font\0" *)

TYPE
  DiskFontHeaderPtr * = UNTRACED POINTER TO DiskFontHeader;
  DiskFontHeader * = STRUCT (df * : e.Node)  (* node to link disk fonts *)
    (* the following 8 bytes are not actually considered a part of the  *)
    (* DiskFontHeader, but immediately preceed it. The NextSegment is   *)
    (* supplied by the linker/loader, and the ReturnCode is the code    *)
    (* at the beginning of the font in case someone runs it...          *)
    (*   ULONG dfh_NextSegment;                 \* actually a BPTR      *)
    (*   ULONG dfh_ReturnCode;                  \* MOVEQ #0,D0 : RTS    *)
    (* here then is the official start of the DiskFontHeader...         *)
    fileID   * : INTEGER;        (* DFH_ID *)
    revision * : INTEGER;        (* the font revision *)
    segment  * : e.BPTR;         (* the segment address when loaded *)
    name     * : ARRAY maxFontName OF CHAR; (* the font name (null terminated) *)
    tf       * : g.TextFont;     (* loaded TextFont structure *)
  END;

(* unfortunately, this needs to be explicitly typed *)
(* used only if dfh_TF.tf_Style FSB_TAGGED bit is set *)
(*#define dfh_TagList     dfh_Segment     (* destroyed during loading *)*)


CONST
  memory  * = 0;
  disk    * = 1;
  scaled  * = 2;
  bitmap  * = 3;

  tagged  * = 16;  (* return TAvailFont *)

TYPE
  AvailFontPtr * = UNTRACED POINTER TO AvailFont;
  AvailFont * = STRUCT
    type * : SET;            (* MEMORY, DISK, or SCALED *)
    attr * : g.TextAttr;     (* text attributes for font *)
  END;

  TAvailFontPtr * = UNTRACED POINTER TO TAvailFont;
  TAvailFont * = STRUCT
    type * : SET;          (* MEMORY, DISK, or SCALED *)
    attr * : g.TTextAttr;  (* text attributes for font *)
  END;

  AvailFontsHeaderPtr * = UNTRACED POINTER TO AvailFontsHeader;
  AvailFontsHeader * = STRUCT
    numEntries * : INTEGER;      (* number of AvailFont elements *)
 (* af  * : ARRAY numEntries OF AvailFont or
    taf * : ARRAY numEntries OF TAvailFont   *)
  END;

(* ---------------------------------------------------------------- *)
CONST

(* Level 0 entries never appear in the .otag tag list, but appear in font
 * specifications *)
  level0 * =      u.user;
(* Level 1 entries are required to exist in the .otag tag list *)
  level1 * =      u.user + 1000H;
(* Level 2 entries are optional typeface metric tags *)
  level2 * =      u.user + 2000H;
(* Level 3 entries are required for some OT_Engines *)
  level3 * =      u.user + 3000H;
(* Indirect entries are at (tag address + data offset) *)
  indirect * =    08000H;


(********************************************************************)
(* font specification and inquiry tags *)

(* !  tags flagged with an exclaimation mark are valid for
 *    specification.
 *  ? tags flagged with a question mark are valid for inquiry
 *
 * fixed binary numbers are encoded as 16 bits of integer and
 * 16 bits of fraction.  Negative values are indicated by twos
 * complement of all 32 bits.
 *)

(* !  OT_DeviceDPI specifies the target device dots per inch -- X DPI is
 *    in the high word, Y DPI in the low word. *)
  deviceDPI * =   level0 + 001H;      (* == TA_DeviceDPI *)

(* !  OT_DotSize specifies the target device dot size as a percent of
 *    it's resolution-implied size -- X percent in high word, Y percent
 *    in low word. *)
  dotSize * =     level0 + 002H;

(* !  OT_PointHeight specifies the requested point height of a typeface,
 *    specifically, the height and nominal width of the em-square.
 *    The point referred to here is 1/72".  It is encoded as a fixed
 *    binary number. *)
  pointHeight * = level0 + 008H;

(* !  OT_SetFactor specifies the requested set width of a typeface.
 *    It distorts the width of the em-square from that specified by
 *    OT_PointHeight.  To compensate for a device with different
 *    horizontal and vertical resolutions, OT_DeviceDPI should be used
 *    instead.  For a normal aspect ratio, set to 1.0 (encoded as
 *    0x00010000.  This is the default value. *)
  setFactor * =   level0 + 009H;

(* !  OT_Shear... specifies the Sine and Cosine of the vertical stroke
 *    angle, as two fixed point binary fractions.  Both must be specified:
 *    first the Sine and then the Cosine.  Setting the sine component
 *    changes the Shear to an undefined value, setting the cosine
 *    component completes the Shear change to the new composite value.
 *    For no shear, set to 0.0, 1.0 (encoded as 000000000, 0x00010000).
 *    This is the default value. *)
  shearSin * =    level0 + 00AH;
  shearCos * =    level0 + 00BH;

(* !  OT_Rotate... specifies the Sine and Cosine of the baselin rotation
 *    angle, as two fixed point binary fractions.  Both must be specified:
 *    first the Sine and then the Cosine.  Setting the sine component
 *    changes the Shear to an undefined value, setting the cosine
 *    component completes the Shear change to the new composite value.
 *    For no shear, set to 0.0, 1.0 (encoded as 0x00000000, 0x00010000).
 *    This is the default value. *)
  rotateSin * =   level0 + 00CH;
  rotateCos * =   level0 + 00DH;

(* !  OT_Embolden... specifies values to algorithimically embolden -- or,
 *    when negative, lighten -- the glyph.  It is encoded as a fixed point
 *    binary fraction of the em-square.  The X and Y components can be
 *    changed indendently.  For normal characters, set to 0.0, 0.0
 *    (encoded as 0x00000000, 0x00000000).  This is the default value. *)
  emboldenX * =   level0 + 00EH;
  emboldenY * =   level0 + 00FH;

(* !  OT_PointSize is an old method of specifying the point size,
 *    encoded as (points * 16). *)
  pointSize * =   level0 + 010H;

(* !  OT_GlyphCode specifies the glyph (character) code to use with
 *    subsequent operations.  For example, this is the code for an
 *    OT_Glyph inquiry *)
  glyphCode * =   level0 + 011H;

(* !  OT_GlyphCode2 specifies the second glyph code.  For example,
 *    this is the right glyph of the two glyphs of an OT_KernPair
 *    inquiry *)
  glyphCode2 * =  level0 + 012H;

(* !  OT_GlyphWidth specifies a specific width for a glyph.
 *    It sets a specific escapement (advance) width for subsequent
 *    glyphs.  It is encoded as a fixed binary fraction of the em-square.
 *    To revert to using the font-defined escapement for each glyph, set
 *    to 0.0 (encoded as 0x00000000).  This is the default value. *)
  glyphWidth * =  level0 + 013H;

(* !  OT_OTagPath and
 * !  OT_OTagList specify the selected typeface.  Both must be specified:
 *    first the Path and then the List.  Setting the path name changes
 *    changes the typeface to an undefined value, providing the List
 *    completes the typeface selection to the new typeface.  OTagPath
 *    is the null terminated full file path of the .otag file associated
 *    with the typeface.  OTagList is a memory copy of the processed
 *    contents of that .otag file (i.e. with indirections resolved).
 *    There are no default values for the typeface. *)
  oTagPath * =    level0 + indirect + 014H;
  oTagList * =    level0 + indirect + 015H;

(*  ? OT_GlyphMap supplies a read-only struct GlyphMap pointer that
 *    describes a bitmap for a glyph with the current attributes. *)
  glyphMap * =    level0 + indirect + 020H;

(*  ? OT_WidthList supplies a read-only struct MinList of struct
 *    GlyphWidthEntry nodes for glyphs that are defined from GlyphCode
 *    to GlyphCode2, inclusive.  The widths are represented as fixed
 *    binary fractions of the em-square, ignoring any effect of
 *    SetFactor or GlyphWidth.  A width would need to be converted to
 *    a distance along the baseline in device units by the
 *    application. *)
  widthList * =   level0 + indirect + 021H;

(*  ? OT_...KernPair supplies the kern adjustment to be added to the
 *    current position after placement of the GlyphCode glyph and
 *    before placement of the GlyphCode2 glyph.  Text kern pairs are
 *    for rendering body text.  Display kern pairs are generally
 *    tighter values for display (e.g. headline) purposes.  The
 *    adjustment is represented as a fixed binary fraction of the
 *    em-square, ignoring any effect of SetFactor.  This number would
 *    need to be converted to a distance along the baseline in device
 *    units by the application. *)
  textKernPair   * = level0 + indirect + 022H;
  designKernPair * = level0 + indirect + 023H;

(*  ? OT_Underlined is an unsigned word which is used to request
 *    algorithimic underlining for the engine when rendering the glyph.
 *    Bullet.library currently does not support this tag, though it
 *    may be used by other engines in the future.  The default for
 *    any engine which supports this tag must be OTUL_None.  Engines which
 *    do not support this tag should return an appropriate OTERR value.
 *
 *    As of V39, diskfont.library will request underlining if specified
 *    in the TextAttr, or TTextAttr passed to OpenDiskFont().  Diskfont
 *    will first request Broken underlining (like the Text() function
 *    does when SetSoftStyle() is used), and then Solid underlining if
 *    the engine returns an error.  If the engine returns an error for
 *    both, then diskfont.library attempts to find, or create the best
 *    non-underlined font that it can. *)
  underLined * =          level0 + 024H;

  ulNone           * = 0;
  ulSolid          * = 1;
  ulBroken         * = 2;
  ulDoubleSolid    * = 3;
  outlDoubleBroken * = 4;

(*  ? OT_StrikeThrough is a boolean which is used to request
 *    algorithimic strike through when rendering the glyph.
 *    Bullet.library currently does not support this tag, though it
 *    may be used by other engines in the future.  The default for
 *    any engined which supports this tag must be FALSE.  Engines which
 *    do not support this tag should return an appropriate OTERR value. *)
  strikeThrough * =       level0 + 025H;


(********************************************************************)
(* .otag tags *)

(* suffix for files in FONTS: that contain these tags *)
  suffix  * = ".otag";

(* OT_FileIdent both identifies this file and verifies its size.
 * It is required to be the first tag in the file. *)
  fileIdent * =   level1 + 001H;

(* OT_Engine specifies the font engine this file is designed to use *)
  engine  * =     level1 + indirect + 002H;
  eBullet * =     "bullet";

(* OT_Family is the family name of this typeface *)
  family * =      level1 + indirect + 003H;

(* The name of this typeface is implicit in the name of the .otag file *)
(* OT_BName is used to find the bold variant of this typeface *)
  bName * =       level2 + indirect + 005H;
(* OT_IName is used to find the italic variant of this typeface *)
  iName * =       level2 + indirect + 006H;
(* OT_BIName is used to find the bold italic variant of this typeface *)
  biName * =      level2 + indirect + 007H;

(* OT_SymSet is used to select the symbol set that has the OT_YSizeFactor
 * described here.  Other symbol sets might have different extremes *)
  symbolSet * =   level1 + 010H;

(* OT_YSizeFactor is a ratio to assist in calculating the Point height
 * to BlackHeight relationship -- high word: Point height term, low
 * word: Black height term -- pointSize = ysize*<high>/<low> *)
  ySizeFactor * = level1 + 011H;

(* OT_SpaceWidth specifies the width of the space character relative
 * to the character height *)
  spaceWidth * =  level2 + 012H;

(* OT_IsFixed is a boolean indicating that all the characters in the
 * typeface are intended to have the same character advance *)
  isFixed * =     level2 + 013H;

(* OT_SerifFlag is a boolean indicating if the character has serifs *)
  serifFlag * =   level1 + 014H;

(* OT_StemWeight is an unsigned byte indicating the weight of the character *)
  stemWeight * =  level1 + 015H;

  sUltraThin  * = 8;   (*   0- 15 *)
  sExtraThin  * = 24;  (*  16- 31 *)
  sThin       * = 40;  (*  32- 47 *)
  sExtraLight * = 56;  (*  48- 63 *)
  sLight      * = 72;  (*  64- 79 *)
  sDemiLight  * = 88;  (*  80- 95 *)
  sSemiLight  * = 104; (*  96-111 *)
  sBook       * = 120; (* 112-127 *)
  sMedium     * = 136; (* 128-143 *)
  sSemiBold   * = 152; (* 144-159 *)
  sDemiBold   * = 168; (* 160-175 *)
  sBold       * = 184; (* 176-191 *)
  sExtraBold  * = 200; (* 192-207 *)
  sBlack      * = 216; (* 208-223 *)
  sExtraBlack * = 232; (* 224-239 *)
  sUltraBlack * = 248; (* 240-255 *)

(* OT_SlantStyle is an unsigned byte indicating the font posture *)
  slantStyle * =  level1 + 016H;
  sUpright    * = 0;
  sItalic     * = 1;       (* Oblique, Slanted, etc. *)
  sLeftItalic * = 2;       (* Reverse Slant *)

(* OT_HorizStyle is an unsigned byte indicating the appearance width *)
  horizStyle       * = level1 + 017H;
  hUltraCompressed * = 16;     (*   0- 31 *)
  hExtraCompressed * = 48;     (*  32- 63 *)
  hCompressed      * = 80;     (*  64- 95 *)
  hCondensed       * = 112;    (*  96-127 *)
  hNormal          * = 144;    (* 128-159 *)
  hSemiExpanded    * = 176;    (* 160-191 *)
  hExpanded        * = 208;    (* 192-223 *)
  hExtraExpanded   * = 240;    (* 224-255 *)

(* OT_SpaceFactor specifies the width of the space character relative
 * to the character height *)
  spaceFactor * = level2 + 018H;

(* OT_InhibitAlgoStyle indicates which ta_Style bits, if any, should
 * be ignored even if the font does not already have that quality.
 * For example, if FSF_BOLD is set and the typeface is not bold but
 * the user specifies bold, the application or diskfont library is
 * not to use OT_Embolden to achieve a bold result. *)
  inhibitAlgoStyle * = level2 + 019H;

(* OT_AvailSizes is an indirect pointer to sorted UWORDs, 0th is count *)
  availSizes    * =  level1 + indirect + 020H;
  maxAvailSizes * =  20;      (* no more than 20 sizes allowed *)

(* OT_SpecCount is the count number of parameters specified here *)
  specCount * =   level1 + 0100H;

(* Specs can be created as appropriate for the engine by ORing in the
 * parameter number (1 is first, 2 is second, ... up to 15th) *)
  spec * =        level1 + 0100H;
(* OT_Spec1 is the (first) parameter to the font engine to select
 * this particular typeface *)
  spec1 * =       level1 + 0101H;


(* ---------------------------------------------------------------- *)
TYPE
(*
 *      glyph.h -- structures for glyph libraries
 *)

(* A GlyphEngine must be acquired via OpenEngine and is read-only *)
  GlyphEnginePtr * = UNTRACED POINTER TO GlyphEngine;
  GlyphEngine * = STRUCT
    library   - : e.LibraryPtr; (* engine library *)
    name      - : e.LSTRPTR;    (* library basename: e.g. "bullet" *)
    (* private library data follows... *)
  END;

  FIXED * = LONGINT;          (* 32 bit signed w/ 16 bits of fraction *)

  GlyphMapPtr * = UNTRACED POINTER TO GlyphMap;
  GlyphMap  * = STRUCT
    bmModulo    * : INTEGER;  (* # of bytes in row: always multiple of 4 *)
    bmRows      * : INTEGER;  (* # of rows in bitmap *)
    blackLeft   * : INTEGER;  (* # of blank pixel columns at left *)
    blackTop    * : INTEGER;  (* # of blank rows at top *)
    blackWidth  * : INTEGER;  (* span of contiguous non-blank columns *)
    blackHeight * : INTEGER;  (* span of contiguous non-blank rows *)
    xOrigin     * : FIXED;    (* distance from upper left corner of bitmap *)
    yOrigin     * : FIXED;    (*   to initial CP, in fractional pixels *)
    x0          * : INTEGER;  (* approximation of XOrigin in whole pixels *)
    y0          * : INTEGER;  (* approximation of YOrigin in whole pixels *)
    x1          * : INTEGER;  (* approximation of XOrigin + Width *)
    y1          * : INTEGER;  (* approximation of YOrigin + Width *)
    width       * : FIXED;    (* character advance, as fraction of em width *)
    bitMap      * : e.APTR;   (* actual glyph bitmap *)
  END;

  GlyphWidthEntryPtr * = UNTRACED POINTER TO GlyphWidthEntry;
  GlyphWidthEntry * = STRUCT (node *: e.MinNode);
                              (* on list returned by OT_WidthList inquiry *)
    code  * : INTEGER;        (* entry's character code value *)
    width * : FIXED;          (* character advance, as fraction of em width *)
  END;

(* ---------------------------------------------------------------- *)
CONST
(*
 *      oterrors.h -- error results from outline libraries
 *)

(* PRELIMINARY *)
  errFailure * =          -1;      (* catch-all for error *)
  errSuccess * =          0;       (* no error *)
  errBadTag * =           1;       (* inappropriate tag for function *)
  errUnknownTag * =       2;       (* unknown tag for function *)
  errBadData * =          3;       (* catch-all for bad tag data *)
  errNoMemory * =         4;       (* insufficient memory for operation *)
  errNoFace * =           5;       (* no typeface currently specified *)
  errBadFace * =          6;       (* typeface specification problem *)
  errNoGlyph * =          7;       (* no glyph specified *)
  errBadGlyph * =         8;       (* bad glyph code or glyph range *)
  errNoShear * =          9;       (* shear only partially specified *)
  errNoRotate * =         10;      (* rotate only partially specified *)
  errTooSmall * =         11;      (* typeface metrics yield tiny glyphs *)
  errUnknownGlyph * =     12;      (* glyph not known by engine *)

(* ---------------------------------------------------------------- *)

VAR
  base * : e.LibraryPtr;

PROCEDURE OpenDiskFont       *{base,- 30}(VAR textAttr{8}     : g.TextAttr): g.TextFontPtr;
PROCEDURE AvailFonts         *{base,- 36}(VAR buffer{8}       : ARRAY OF e.BYTE;
                                          long{0}             : LONGINT;
                                          flags{1}            : LONGSET): LONGSET;

(* ---   functions in V34 or higher  (Release 1.3)   --- *)

PROCEDURE NewFontContents    *{base,- 42}(fontsLock{8}        : e.BPTR;
                                          fontName{9}         : ARRAY OF CHAR): FontContentsHeaderPtr;
PROCEDURE DisposeFontContents*{base,- 48}(fontConstentsHeader{9} : FontContentsHeaderPtr);

(* ---   functions in V36 or higher  (Release 2.0)   --- *)

PROCEDURE NewScaledDiskFont  *{base,- 54}(sourceFont{8}       : g.TextFontPtr;
                                          VAR destTextAttr{9} : g.TextAttr): DiskFontHeaderPtr;


(* $OvflChk- $RangeChk- $StackChk- $NilChk- $ReturnChk- $CaseChk- *)

BEGIN
  base :=  e.OpenLibrary(diskfontName,33);
  IF base=NIL THEN
    IF I.DisplayAlert(0,"\x00\x64\x14missing diskfont.library!\o\o",50) THEN END;
    HALT(20)
  END;

CLOSE
  IF base#NIL THEN e.CloseLibrary(base) END;

END DiskFont.

