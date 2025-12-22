IMPLEMENTATION MODULE Graphics ;

IMPORT SYSTEM, M2Lib, Hardware, Graphics ;

TYPE
  AdrPtr = POINTER TO SYSTEM.ADDRESS ;

PROCEDURE InitAnimate( animKey : AdrPtr ) ;
BEGIN animKey^ := NIL
END InitAnimate ;

PROCEDURE RASSIZE( w , h : CARDINAL ) : CARDINAL ;
BEGIN RETURN h*CARDINAL( SYSTEM.BITSET((w+15)/8) * {1..15})
END RASSIZE ;

PROCEDURE RemBob( b : BobPtr ) ;
BEGIN b^.Flags := b^.Flags+BOBSAWAY ;
END RemBob ;

BEGIN GfxBase := M2Lib.OpenLib( GRAPHICSNAME, VERSION )
END Graphics.
