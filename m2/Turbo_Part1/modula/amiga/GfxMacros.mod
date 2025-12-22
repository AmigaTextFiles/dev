IMPLEMENTATION MODULE GfxMacros ;

IMPORT SYSTEM, M2Lib, Hardware, Graphics ;
FROM Graphics IMPORT BITSET, BITCLR, FRST_DOT, AREAOUTLINE,
		     RastPortPtr, UCopListPtr , CopListPtr , GfxBase ;

PROCEDURE ON_DISPLAY( ) ;
BEGIN Hardware.custom.dmacon := BITSET + Hardware.DMAF_RASTER
END ON_DISPLAY ;

PROCEDURE OFF_DISPLAY( ) ;
BEGIN Hardware.custom.dmacon := BITCLR + Hardware.DMAF_RASTER
END OFF_DISPLAY ;

PROCEDURE ON_SPRITE( ) ;
BEGIN Hardware.custom.dmacon := BITSET + Hardware.DMAF_SPRITE
END ON_SPRITE ;

PROCEDURE OFF_SPRITE( ) ;
BEGIN Hardware.custom.dmacon := BITCLR + Hardware.DMAF_SPRITE
END OFF_SPRITE ;

PROCEDURE ON_VBLANK( ) ;
BEGIN Hardware.custom.intena := BITSET + Hardware.INTF_VERTB
END ON_VBLANK ;

PROCEDURE OFF_VBLANK( ) ;
BEGIN Hardware.custom.intena := BITCLR + Hardware.INTF_VERTB
END OFF_VBLANK ;

PROCEDURE SetDrPt( w : RastPortPtr ; p : CARDINAL ) ;
BEGIN
  w^.LinePtrn := p ;
  w^.Flags := w^.Flags + FRST_DOT ;
  w^.linpatcnt := 15
END SetDrPt ;

PROCEDURE SetAfPt( w : RastPortPtr ; p : SYSTEM.ADDRESS ; n : SHORTINT ) ;
BEGIN w^.AreaPtrn := p ; w^.AreaPtSz := n
END SetAfPt ;

PROCEDURE SetOPen( w : RastPortPtr ; c : SHORTINT ) ;
BEGIN w^.AOlPen := c ; w^.Flags := w^.Flags + AREAOUTLINE
END SetOPen ;

PROCEDURE SetWrMsk( w : RastPortPtr ; m : SYSTEM.SHORTSET ) ;
BEGIN w^.Mask := m ;
END SetWrMsk ;

PROCEDURE SafeSetOutlinePen( w : RastPortPtr ; c : SHORTINT ) ;
BEGIN
  IF GfxBase^.LibNode.lib_Version < 39 THEN
    w^.AOlPen := c ; w^.Flags := w^.Flags + AREAOUTLINE
  ELSE c := Graphics.SetOutlinePen( w , c )
  END
END SafeSetOutlinePen ;

PROCEDURE SafeSetWriteMask( w : RastPortPtr ; m : SYSTEM.SHORTSET ) ;
  VAR x : LONGINT ;
BEGIN
  IF GfxBase^.LibNode.lib_Version < 39 THEN w^.Mask := m
  ELSE x := Graphics.SetWriteMask( w, m )
  END
END SafeSetWriteMask ;

PROCEDURE GetOPen( rp : RastPortPtr ) : LONGINT ;
BEGIN RETURN Graphics.GetOutlinePen( rp )
END GetOPen ;

PROCEDURE BNDRYOFF( w : RastPortPtr ) ;
BEGIN w^.Flags := w^.Flags - AREAOUTLINE
END BNDRYOFF ;

PROCEDURE CINIT( c : UCopListPtr ; n : LONGINT ) : UCopListPtr ;
BEGIN RETURN Graphics.UCopperListInit( c, n )
END CINIT ;

PROCEDURE CMOVE( c : UCopListPtr ; a : SYSTEM.ADDRESS ; b : LONGINT ) ;
BEGIN Graphics.CMove( c, a, b ) ; Graphics.CBump( c )
END CMOVE ;

PROCEDURE CWAIT( c : UCopListPtr ; a, b : LONGINT ) ;
BEGIN Graphics.CWait( c, a, b ) ; Graphics.CBump( c )
END CWAIT ;

PROCEDURE CEND( c : UCopListPtr ) ;
BEGIN Graphics.CWait( c, 10000, 255 ) ; Graphics.CBump( c )
END CEND ;

PROCEDURE DrawCircle( rp : RastPortPtr ; cx, cy, r : LONGINT ) ;
BEGIN Graphics.DrawEllipse( rp, cx, cy, r, r )
END DrawCircle ;

PROCEDURE AreaCircle( rp : RastPortPtr ; cx, cy, r : LONGINT ) : LONGINT ;
BEGIN RETURN Graphics.AreaEllipse( rp, cx, cy, r, r )
END AreaCircle ;

END GfxMacros.
