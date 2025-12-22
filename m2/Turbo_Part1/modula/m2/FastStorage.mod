IMPLEMENTATION MODULE FastStorage ;

FROM SYSTEM IMPORT ADDRESS ;
IMPORT Storage ;

CONST
  maxLen = 16384 ;

VAR
  block  : ADDRESS ;
  offset : LONGINT ;

PROCEDURE ALLOCATE( VAR pointer : ADDRESS ; size : LONGINT ) ;
BEGIN
  IF ODD( size ) THEN INC( size ) END ;
  IF size >= maxLen THEN
    Storage.ALLOCATE( pointer, size )
  ELSE
    IF size >= maxLen - offset THEN
      offset := 0 ;
      Storage.ALLOCATE( block, maxLen )
    END ;
    pointer := block  + offset ;
    offset  := offset + size
  END
END ALLOCATE ;

BEGIN offset := maxLen ; (* This forces an allocation on the first call *)
END FastStorage.

