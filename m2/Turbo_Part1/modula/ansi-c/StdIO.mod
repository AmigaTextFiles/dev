(* These are macros in DICE, and so are not implemented in c.lib *)
IMPLEMENTATION MODULE StdIO ; (* Entirely DICE specific *)

FROM SYSTEM IMPORT ADDRESS ;
IMPORT StdIO, Iob, SYSTEM ;

CONST
  SIF_EOF = BITSET( 00002 ) ;

PROCEDURE clearerr( fi : FILEPtr ) ;
BEGIN fi^.sd_Flags := fi^.sd_Flags-SIF_EOF ; fi^.sd_Error := 0 ;
END clearerr ;

PROCEDURE feof( fi : FILEPtr ) : BOOLEAN ;
BEGIN RETURN (fi^.sd_Flags*SIF_EOF) # {} ;
END feof ;

PROCEDURE ferror( fi : FILEPtr ) : LONGINT ;
BEGIN RETURN fi^.sd_Error
END ferror ;

PROCEDURE fileno( fi : FILEPtr ) : LONGINT ;
BEGIN RETURN fi^.sd_Fd
END fileno ;

PROCEDURE getc( fi : FILEPtr ) : LONGINT ;
BEGIN RETURN StdIO.fgetc( fi )
END getc ;

PROCEDURE putc( c : LONGINT ; fi : FILEPtr ) : LONGINT ;
BEGIN RETURN StdIO.fputc( c , fi )
END putc ;

PROCEDURE getchar( ) : LONGINT ;
BEGIN RETURN StdIO.fgetc( stdin )
END getchar ;

PROCEDURE putchar( c : LONGINT ) : LONGINT ;
BEGIN RETURN StdIO.fputc( c , stdout )
END putchar ;

BEGIN
  stdin  := SYSTEM.ADR( Iob._Iob ) ;
  stdout := FILEPtr( ADDRESS( stdin  ) + SIZE( FILE ) ) ;
  stderr := FILEPtr( ADDRESS( stdout ) + SIZE( FILE ) ) ;
END StdIO.


