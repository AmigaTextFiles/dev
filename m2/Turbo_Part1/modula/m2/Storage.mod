IMPLEMENTATION MODULE Storage ;

FROM SYSTEM IMPORT ADDRESS ;
IMPORT StdLib, M2Lib ;

PROCEDURE ALLOCATE( VAR adr : ADDRESS ; size : LONGINT ) ;
BEGIN
  adr := StdLib.calloc( 1 , size ) ;
  IF adr = NIL THEN
    M2Lib._ErrorReq("Storage.ALLOCATE","Could not allocate memory")
  END
END ALLOCATE ;

PROCEDURE DEALLOCATE( VAR adr : ADDRESS ; size : LONGINT ) ;
BEGIN
  IF adr = NIL THEN
    M2Lib._ErrorReq("Storage.DEALLOCATE","NIL pointer")
  END ;
  StdLib.free( adr ) ;
  adr := NIL
END DEALLOCATE ;

END Storage.
