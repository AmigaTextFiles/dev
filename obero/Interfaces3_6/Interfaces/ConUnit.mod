(*
(*
**  Amiga Oberon Interface Module:
**  $VER: ConUnit.mod 40.15 (28.12.93) Oberon 3.0
**
**   © 1993 by Fridtjof Siebert
*)
*)

MODULE ConUnit;   (* $Implementation- *)

IMPORT
  e  * := Exec,
  c  * := Console,
  km * := KeyMap,
  ie * := InputEvent,
  I  * := Intuition,
  g  * := Graphics;

CONST

(* ---- console unit numbers for OpenDevice() *)
  library   * = -1;      (* no unit, just fill in IO_DEVICE field *)
  standard  * = 0;       (* standard unmapped console *)

(* ---- New unit numbers for OpenDevice() - (V36) *)

  charMap   * = 1;       (* bind character map to console *)
  snipMap   * = 3;       (* bind character map w/ snip to console *)

(* ---- New flag defines for OpenDevice() - (V37) *)

  flagDefault         * = LONGSET{};
  flagNoDrawOnNewSize * = LONGSET{0};


  pmbAsm    * = c.mLNM+1;       (* internal storage bit for AS flag *)
  pmbAwm    * = pmbAsm+1;       (* internal storage bit for AW flag *)
  maxTabs   * = 80;

TYPE

  ConUnitPtr * = UNTRACED POINTER TO   ConUnit;
  ConUnit * = STRUCT (mp * : e.MsgPort)
      (* ---- read only variables *)
    window       - : I.WindowPtr; (* intuition window bound to this unit *)
    xCP          - : INTEGER;     (* character position *)
    yCP          - : INTEGER;
    xMax         - : INTEGER;     (* max character position *)
    yMax         - : INTEGER;
    xRSize       - : INTEGER;     (* character raster size *)
    yRSize       - : INTEGER;
    xROrigin     - : INTEGER;     (* raster origin *)
    yROrigin     - : INTEGER;
    xRExtant     - : INTEGER;     (* raster maxima *)
    yRExtant     - : INTEGER;
    xMinShrink   - : INTEGER;     (* smallest area intact from resize process *)
    yMinShrink   - : INTEGER;
    xcCP         - : INTEGER;     (* cursor position *)
    ycCP         - : INTEGER;

      (* ---- read/write variables (writes must must be protected) *)
      (* ---- storage for AskKeyMap and SetKeyMap *)
    keyMapStruct * : km.KeyMap;
      (* ---- tab stops *)
    tabStops     * : ARRAY maxTabs OF INTEGER; (* 0 at start, 0xffff at end of list *)

      (* ---- console rastport attributes *)
    mask         * : SHORTSET;
    fgPen        * : SHORTINT;
    bgPen        * : SHORTINT;
    aolPen       * : SHORTINT;
    drawMode     * : SHORTSET;
    obsolete1    * : e.BYTE;      (* was cu_AreaPtSz -- not used in V36 *)
    obsolete2    * : e.APTR;      (* was cu_AreaPtrn -- not used in V36 *)
    minterms     * : ARRAY 8 OF e.BYTE; (* console minterms *)
    font         * : g.TextFontPtr;
    algoStyle    * : e.BYTE;
    txFlags      * : SHORTSET;
    txHeight     * : INTEGER;
    txWidth      * : INTEGER;
    txBaseline   * : INTEGER;
    txSpacing    * : INTEGER;

    (* ---- console MODES and RAW EVENTS switches *)
    modes        * : ARRAY (pmbAwm + 7) DIV 8 OF SHORTSET;  (* one bit per mode *)
    rawEvents    * : ARRAY (ie.classMax + 7) DIV 8 OF SHORTSET;
  END;

END ConUnit.

