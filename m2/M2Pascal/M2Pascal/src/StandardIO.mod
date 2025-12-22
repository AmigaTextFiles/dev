IMPLEMENTATION MODULE StandardIO ;
 (* 
   These routines provide support for modula-2 procecedures intended
   for Standard I/O. ( For example the procedure "WriteString" from
   the module InOut ).

   Note: All modula-2 procedures with 'read' in them ( ReadString etc..)
   are not included here. These are translated automaticaly by simple
   substitution.
 *)


FROM InOut       IMPORT  WriteString;

FROM OutModule   IMPORT  output,            AddBlanks,          identical;

FROM Strings     IMPORT  ConcatString,      ExtractSubString,   InsertSubString;

FROM scan        IMPORT  STRING,            IndentArray,
                         ReadSymbol,        ReadAheadSymbol,    SymbolType,
                         HitABrickWall;
FROM errors      IMPORT  ErrorType,         ErrorMessage;


CONST 
        DEBUG           =   FALSE;
	SLASH           =   134C;

VAR
        indent          :   IndentArray;
        ObjectString    :   STRING;
        StringIndex     :   CARDINAL;
        InFileSymbol    :   STRING;
        SymbolClass     :   SymbolType;
        i               :   CARDINAL;
        ch              :   CHAR;


 (* Symbol read in from file starts with the chars "Write"
 *)
PROCEDURE StartsWithWRITE ( symbol : STRING ) : BOOLEAN;
 VAR FirstFiveChars : STRING;
BEGIN
    ObjectString     := "\0";
    ExtractSubString ( FirstFiveChars ,  symbol , 0 , 5 );
    RETURN identical ( "Write" , FirstFiveChars );
END StartsWithWRITE;


  (* Example:
           WriteInt ( a , 1 );
                     ^^^^
                        Read this.

    Sucks in the comma and ignores it.
  *)
PROCEDURE ReadUntilComma ();
BEGIN
    ReadSymbol   ( InFileSymbol,SymbolClass );

    WHILE ( NOT identical ( InFileSymbol,  "," ) ) DO
         ConcatString ( ObjectString, InFileSymbol );             
         ReadSymbol   ( InFileSymbol, SymbolClass );
    END;
END ReadUntilComma;



 (* Process supported statement beginning with "write" such as "WriteInt".
    This procedure should NOT be used with "WriteString".
    The following statements are supported:
          WriteInt,
          WriteOct,
          WriteWrd,
          WriteCard,
          WriteHex.
    Translation in this version is simple and mimics the following example:
           WriteInt ( number , 1 )   ==>    writeln ( number )
           
           ( The number after the comma is always ignored )
 *)
PROCEDURE ProcessGenericWrite ( symbol : STRING );
BEGIN
        ConcatString ( ObjectString, "writeln" );
        AddBlanks    ( ObjectString );
        ReadSymbol   ( InFileSymbol, SymbolClass );
        IF ( identical ( InFileSymbol , "("  )  )THEN
              ConcatString ( ObjectString , InFileSymbol );
              ReadUntilComma ();

                  (* ignore everything after the comma and send it to the
                     big black hole in the ram
                  *)
                 WHILE  ( NOT ( HitABrickWall () ) AND
                        ( NOT   identical     ( InFileSymbol, ")" ) )   )   DO
                       ReadSymbol ( InFileSymbol , SymbolClass );
                 END;
                 IF ( identical ( InFileSymbol , ")" )  ) THEN
                     ConcatString ( ObjectString, InFileSymbol );
                     output ( indent, ObjectString );
                     IF DEBUG THEN 
                          WriteString ("ProcessWRITE exited: ");
                          WriteString ( ObjectString ); WriteString("\n") ;
                     END;
                 ELSE
                    ErrorMessage ( WriteStatement );    
                END;
        ELSE
                    ErrorMessage ( WriteStatement );                  
        END;

END ProcessGenericWrite;




PROCEDURE quote () : BOOLEAN;
BEGIN
    RETURN (  ch = '"' ) OR
           (  ch = "'" ) ;
END quote;




PROCEDURE NextCh ();
BEGIN
        INC ( i , 1 );
        ch  :=  InFileSymbol [ i ];
END NextCh;




PROCEDURE AddCh ( OneLetter : CHAR );
 VAR symbol : STRING;
BEGIN
       symbol [ 0 ] := OneLetter;
       symbol [ 1 ] := "\0";
       ConcatString ( ObjectString , symbol );        
END AddCh;




PROCEDURE InsertWriteln ();
BEGIN
     InsertSubString ( ObjectString , "writeln" , 0 );
END InsertWriteln;




PROCEDURE InsertWrite ();
BEGIN
     InsertSubString ( ObjectString , "write" , 0 );
END InsertWrite;




 (* Do the actual translation of "\n" instances.
    Symbol is in string "InFileSymbol".
 *)
PROCEDURE ProcessWriteStringToEnd ();
 VAR   SingleNewLine, DataEnd : BOOLEAN ;
BEGIN
    i             := 1;
    DataEnd       := FALSE;  (* Checks indirectly for an empty string ""   *)
    SingleNewLine := TRUE;  (* Flags that output should be 'writeln'      *)
    AddCh ( "'" );    (* change ' to "  *)


    ch := InFileSymbol [ 1 ];

    WHILE  ( NOT ( quote ()  )  ) DO
        IF ( ch = SLASH  ) THEN
           NextCh ();
           IF ( ch =  SLASH  )  THEN    (* 2 slashes in a row *)
                SingleNewLine   :=  FALSE;
                AddCh ( ch );
           ELSIF ( ch = 'n' ) THEN
                IF ( NOT SingleNewLine ) THEN
                    (* Close off statmnt *)
                   ConcatString ( ObjectString , "'); " ); 
                ELSE
                   ObjectString := "\0";
                   AddCh ( ";" );
                END;
                 
                SingleNewLine := TRUE;
                InsertWriteln ();
                output ( indent , ObjectString );
                ObjectString := "\0" ;                  (* Setup new string *)
                ConcatString ( ObjectString , "('" );

                NextCh ();  DEC ( i , 1 );  (* look ahead *)
                IF ( ( ch =   '"'  ) OR 
                     ( ch =   "'"  ) )   THEN
                           DataEnd  := TRUE;
                END;
           END;
        ELSE
           (* ch <> slash *)
           AddCh ( ch );
           SingleNewLine  := FALSE;	   
        END;

        NextCh ();
    END;

    IF ( NOT DataEnd ) THEN
         AddCh ( "'" );     (* second quote *)
         AddBlanks    (  ObjectString );
         ReadSymbol   ( InFileSymbol , SymbolClass );
         IF ( identical (  InFileSymbol, ")" )  )THEN
                     AddCh ( ")" );
         ELSE
                     ErrorMessage ( WriteStatement );
         END;     
    
         InsertWrite ();
         output ( indent , ObjectString );
    ELSE
         (* The statement has an empty string-> DON'T output it *)
         AddBlanks ( ObjectString );
         ReadSymbol   ( InFileSymbol , SymbolClass );
         IF ( identical ( InFileSymbol, ")" ) ) THEN 
                     AddBlanks ( ObjectString );
                     ReadSymbol   ( InFileSymbol , SymbolClass );
                     IF ( NOT identical ( InFileSymbol , ";" )  ) THEN
                         ErrorMessage ( WriteStatement );           
                     END;
         ELSE
                     ErrorMessage ( WriteStatement );
         END;
    END;

END ProcessWriteStringToEnd;



 (* This is used to process a WriteString that has an identifier-type string
    contained between the paranthesis. ( vs a quoted phrase ) This option
    is not part of standard ISO pascal and the compiler will barf it up
    if it's a bare-bones system.
 *)
PROCEDURE ProcessWriteStringIdentifier ();
BEGIN
     InsertWrite ();
     ConcatString ( ObjectString , InFileSymbol );          (* identifier *)
     AddBlanks (  ObjectString );
     ReadSymbol (  InFileSymbol, SymbolClass );
     IF ( identical ( InFileSymbol , ")" )  ) THEN
              ConcatString ( ObjectString , ")" );
              AddBlanks  ( ObjectString );
              ReadSymbol ( InFileSymbol, SymbolClass );
              IF ( identical ( InFileSymbol, ";" ) ) THEN
                  ConcatString ( ObjectString , ";" );
                  output ( indent, ObjectString  );
              ELSE
                  ErrorMessage ( WriteStatement );
              END;
     ELSE
                  ErrorMessage ( WriteStatement );
     END;
END  ProcessWriteStringIdentifier ;






 (* Process the statement "WriteString". Convert all instances of "\n" 
    to writeln statements. ( Otherwise they are "write" statements ).
    All data after the actual WriteString statement is read into the
    ObjectString first. Then if a '\n' is detected the string "writeln"
    is inserted in front of the ObjectString data. If no '\n' is detected
    then the string "write" is inserted in front.
 *)
PROCEDURE ProcessWriteString ();
BEGIN
      AddBlanks  ( ObjectString );
      ReadSymbol ( InFileSymbol , SymbolClass );
      IF (  identical ( InFileSymbol ,  "("  )  ) THEN
          AddCh ( "(" );
          AddBlanks ( ObjectString );
          ReadSymbol ( InFileSymbol, SymbolClass );

          IF    ( SymbolClass = literal ) THEN
                  ProcessWriteStringToEnd ();
          ELSIF ( SymbolClass = identifier ) THEN
                  ProcessWriteStringIdentifier ();
          ELSE
                  ErrorMessage ( WriteStatement );
          END;
      ELSE
	          ErrorMessage ( WriteStatement );
      END;
END ProcessWriteString;





 (* Symbol started with the characters "write"
 *)
PROCEDURE ProcessWRITE ( Indent  : IndentArray;
                          symbol : STRING );
BEGIN
    IF DEBUG THEN 
             WriteString("ProcessWRITE entered. Symbol is : ");
             WriteString( symbol ); WriteString("\n");
    END;

    indent := Indent;    (* global *)
    ObjectString := "\0";

    IF identical ( "WriteString" , symbol ) THEN
        ProcessWriteString ();
    ELSE
        ProcessGenericWrite ( symbol );
    END;

END ProcessWRITE;


BEGIN
    StringIndex    :=  0;
END StandardIO.
