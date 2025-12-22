MODULE demo;

IMPORT  Dos, Mui;

  PROCEDURE fail*( app : Mui.Object; str : ARRAY OF CHAR );
    BEGIN
      IF app # NIL THEN
        Mui.DisposeObject( app );
      END;
      IF str # "" THEN
        IF Dos.PutStr( str )= 0 THEN END;
        HALT( 20 );
      END;
      HALT( 0 );
    END fail;

END demo.
