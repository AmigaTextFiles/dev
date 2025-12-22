IMPLEMENTATION MODULE DosStdIO ;

FROM SYSTEM IMPORT ADDRESS, STRING ;
IMPORT Dos ;

PROCEDURE ReadChar( ) : LONGINT ;
BEGIN RETURN Dos.FGetC( Dos.Input( ) )
END ReadChar ;

PROCEDURE WriteChar( c : LONGINT ) : LONGINT ;
BEGIN RETURN Dos.FPutC( Dos.Output( ) , c )
END WriteChar ;

PROCEDURE UnReadChar( c : LONGINT ) : LONGINT ;
BEGIN RETURN Dos.UnGetC( Dos.Input( ) , c )
END UnReadChar ;

PROCEDURE ReadChars( buf : ADDRESS ; num : LONGINT ) : LONGINT ;
BEGIN RETURN Dos.FRead( Dos.Input( ) , buf , 1 , num )
END ReadChars ;

PROCEDURE ReadLn( buf : STRING ; len : LONGINT ) : STRING ;
BEGIN RETURN Dos.FGets( Dos.Input( ) , buf , len )
END ReadLn ;

PROCEDURE WriteStr( s : STRING ) : LONGINT ;
BEGIN RETURN Dos.FPuts( Dos.Output( ) , s )
END WriteStr ;

PROCEDURE VWritef( format : STRING ; argv : ADDRESS ) ;
BEGIN Dos.VFWritef( Dos.Output() , format , argv )
END VWritef ;

END DosStdIO.
