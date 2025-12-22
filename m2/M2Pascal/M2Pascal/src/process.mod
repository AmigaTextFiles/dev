IMPLEMENTATION MODULE process;

FROM scan               IMPORT STRING,          write,
                               ReadSymbol,      SPACE,           TAB,
                               EolnAhead,       SymbolType,      IndentArray,
                               ReadAheadSymbol, ReadAheadLine,   ReadLine,
                               TooFar;
FROM InOut              IMPORT WriteString,     WriteInt;

FROM errors             IMPORT CleanUp,         ErrorMessage,    ErrorType,
                               internal,        FatalError;
FROM IdLookup           IMPORT SearchHash,      IdInfoType,      ProcessType;

FROM OutModule          IMPORT output,          identical,       PutBEGIN,
                               AddBlanks,       WriteIndent,     FirstOption,
                               SecondOption;
FROM Strings            IMPORT ConcatString;

FROM StandardIO         IMPORT StartsWithWRITE, ProcessWRITE;

FROM FunctionProcessing IMPORT IsAFunction,     PopFunctionName, FunctionName;

CONST
        DEBUG             =   FALSE;
        CommentCharOff    =   " }" ;
        CommentCharOn     =   "{ " ;
VAR
	InFileSymbol      : STRING;
        SymbolClass       : SymbolType;
        indent            : IndentArray;
        CommentMode       : BOOLEAN;
        CommentBeginCount : CARDINAL;   (*  how many nested commnts  *)
        ModuleUsed        : BOOLEAN;



PROCEDURE out ( symbol : STRING );        
BEGIN
  output ( indent , symbol );
END out;


 
(* Does this misc. character have anything to do with the start/stop of
    comments?
 *)
PROCEDURE CommentCharacter ( symbol : STRING ) : BOOLEAN;
BEGIN
  RETURN
       identical ( symbol , "(" ) OR
       identical ( symbol , "*" )
END CommentCharacter;



PROCEDURE CheckCommentMode ( symbol : STRING );
 VAR NextSymbol : STRING;  SymbolClass : SymbolType; dummy : BOOLEAN;
BEGIN
    ReadAheadSymbol ( NextSymbol, SymbolClass );

    IF ( ( identical( symbol     , "*"  ) ) AND 
         ( identical( NextSymbol , ")"  ) ) ) THEN
               
                DEC ( CommentBeginCount , 1 );
                IF ( CommentBeginCount <= 0 ) THEN    (* not nested *)
                        IF ( CommentBeginCount < 0 ) THEN 
                          CommentBeginCount  := 0;
                        END;
			CommentMode := FALSE;
                        IF DEBUG THEN
                          WriteString("CheckCommentMode.CommentMode is OFF\n");
                        END;
                END;
                ReadSymbol ( NextSymbol, SymbolClass );
                out ( CommentCharOff );

    ELSIF ( ( identical( symbol     , "("  ) ) AND 
            ( identical( NextSymbol , "*"  ) ) ) THEN

                IF DEBUG THEN 
                       WriteString("CheckCommentMode.CommentMode is ON\n");
                END;
                CommentMode := TRUE;
                INC ( CommentBeginCount , 1 );
                ReadSymbol ( NextSymbol, SymbolClass );
                out ( CommentCharOn );
   ELSE
                out ( symbol );
   END;

END CheckCommentMode;



PROCEDURE processable ( symbol       : STRING;
                        SymbolClass  : SymbolType ) : BOOLEAN;
BEGIN
        RETURN    (  ( SymbolClass = identifier )        OR
                   ( ( SymbolClass = other  ) AND 
                     ( NOT identical ( symbol , "(" ) ) )) AND 
                     ( NOT CommentMode            ) ;
END processable;



PROCEDURE ProcessPROCEDURE();
BEGIN
        IF DEBUG THEN
              WriteString ("PROCEDURE encountered\n");
        END;

	IF ( NOT IsAFunction () ) THEN
               out ( "procedure" );
        ELSE
               out ( "function" );
        END;
END ProcessPROCEDURE;






PROCEDURE ProcessRETURN;
 VAR name : STRING;
BEGIN
        IF DEBUG THEN
              WriteString ("RETURN encountered\n");
        END;

        FunctionName ( name );
        out ( name );   out ( " := " );
END ProcessRETURN;




PROCEDURE ProcessMODULE ();
 VAR    symbol : STRING;     SymbolClass : SymbolType;
BEGIN
      IF NOT ModuleUsed THEN
           ModuleUsed := TRUE;
           out ( "program" );
           ReadSymbol ( symbol, SymbolClass );
           IF ( SymbolClass = blanks ) THEN
                  out ( symbol );
                  ReadSymbol ( symbol, SymbolClass );
           END;
 
           IF ( SymbolClass = identifier ) THEN
                  out ( symbol );
                  out ( " ( input, output )" );
           ELSE
                  ErrorMessage ( NoProgramName );
           END;
      ELSE
           ErrorMessage ( MultipleModule );
           out ( "MODULE" );
      END;
END ProcessMODULE;



 (* "THEN" is changed automatically to "then begin"
    where the position of "begin" is determined by PutBEGIN. 	
 *)
PROCEDURE ProcessTHEN () ;
BEGIN
     IF DEBUG THEN
          WriteString ("THEN encountered\n");
     END;

     out ( "then" );
     PutBEGIN ( indent );
END ProcessTHEN;



 (* DO => do begin
    This is used for WITH, FOR, WHILE.
  *)
PROCEDURE ProcessDO ();
BEGIN
   out      ( "do" );
   PutBEGIN ( indent );
END ProcessDO;



 (* An END statement has been found, is it followed by an identifier?
    Is the identifier followed by an "." or ";" ?    This procedure
    deals with the above situations.
 *)
PROCEDURE ProcessEND ();
BEGIN
      IF DEBUG THEN
         WriteString ("An END has been encountered\n");
      END;

      out ( "end" );

      ReadSymbol ( InFileSymbol, SymbolClass );    
      IF ( SymbolClass = blanks ) THEN
          ReadSymbol   ( InFileSymbol, SymbolClass );    
      END;

       (* identifier after END if it's there *)
      IF ( SymbolClass = identifier ) THEN
          PopFunctionName ( InFileSymbol );   (* potential end of function *)
          ReadSymbol      ( InFileSymbol, SymbolClass );    	 
      END;      

      IF ( SymbolClass = blanks ) THEN
          out        ( InFileSymbol );
          ReadSymbol ( InFileSymbol, SymbolClass );    
      END;

       (*   ";' or "."  *)
      out ( InFileSymbol );
            
END ProcessEND;



 (* "ELSE" => "end\n else begin"                  ( the latter is true for a 
                                                    case statement )
 *)
PROCEDURE ProcessELSE ();
BEGIN
     out ( "end\n");
     WriteIndent ( indent );
     out ( "else" );
     PutBEGIN ( indent );
END ProcessELSE;



 (* Case statement not translated correctly ( at all ) in this version
 *)
PROCEDURE ProcessCASE ();
BEGIN
      WriteString (" Keyword CASE encountered. Warning: This version\n");
      WriteString ("    requires manual conversion of CASE statements\n");
      out ("\n     {*****************************************************\n");
      out ("      * DELETE THESE 6 LINES AFTER CONVERTING CASE        *\n");
      out ("      * STATEMENT BELOW MANUALY.                          *\n");
      out ("      *      - Erase end before final else ( if present ). *\n");
      out ("      *      - Place a 'begin' after each colon.           *\n");
      out ("      *****************************************************}\n");

      WriteIndent ( indent );
      out ( "case" );
END ProcessCASE;





 (* handles ALLOCATE/DEALLOCATE and converts to new/dispose
 *)
PROCEDURE ProcessAllocation ( symbol : STRING );
 VAR s : STRING;
BEGIN
   IF ( identical ( symbol , "ALLOCATE" ) ) THEN
        out ( "new" );
   ELSE
        out ( "dispose" );
   END;

    (* clone everything until we are after the left parenth *)
   ReadSymbol ( InFileSymbol, SymbolClass );    
   WHILE ( NOT identical ( InFileSymbol , "(" ) ) DO
        out        ( InFileSymbol );
        ReadSymbol ( InFileSymbol, SymbolClass );    
   END;
   out ( InFileSymbol );

   FirstOption  ( s );
   out          (  s  );
   out          ( ")" );
   SecondOption ( s );
END ProcessAllocation;


 (* handles INC/DEC.    Ex:   INC ( i , 1 )  =>  i := i + 1
 *)
PROCEDURE ProcessAutoInc ( symbol : STRING );
 VAR s1 , s2 : STRING;
BEGIN
   (* blanks between comnd and par? *)
  AddBlanks    ( InFileSymbol );  (* toss away *)

   (* left par *)
  ReadSymbol ( InFileSymbol, SymbolClass );    

   (* first option *)   
  FirstOption ( s1 );
  out ( s1 );
  out ( " := " );
  out ( s1 );

  IF ( identical ( symbol , "INC" ) ) THEN
       out ( " + " );      
  ELSE (* DEC *)
       out ( " - " );
  END;

  SecondOption ( s2 );  

  IF ( identical ( s2 , "" ) ) THEN
       out ( "1" );
  ELSE
       out ( s2 );
  END;

END ProcessAutoInc;


PROCEDURE ProcessPOINTER ();
BEGIN
      IF DEBUG THEN
         WriteString ("The keyword POINTER has been encountered\n");
      END;
      AddBlanks    ( InFileSymbol );  (* toss away *)
      ReadSymbol   ( InFileSymbol, SymbolClass );    
      AddBlanks    ( InFileSymbol );  (* toss away *)
      out ( "^" );
END ProcessPOINTER;



 (* Check for end of "FROM blah IMPORT blah, blah" block of lines
 *)
PROCEDURE StopSkipping () : BOOLEAN;
BEGIN
   RETURN ( identical ( InFileSymbol , "CONST" )       OR
            identical ( InFileSymbol , "VAR" )         OR
            identical ( InFileSymbol , "BEGIN"  )      OR
            identical ( InFileSymbol , "PROCEDURE"  )  OR 
            identical ( InFileSymbol , "TYPE"  )   
          );
END StopSkipping;



PROCEDURE SkipImportData ();
 VAR good : BOOLEAN;
BEGIN
      IF DEBUG THEN
         WriteString ("The keyword FROM has been encountered\n");
      END;

      good            := ReadAheadLine   ( indent );
      ReadAheadSymbol ( InFileSymbol, SymbolClass );

      WHILE ( NOT StopSkipping() ) DO
         IF EolnAhead () THEN
             good   := ReadLine        ( indent );
             good   := ReadAheadLine   ( indent );
         END;
         ReadAheadSymbol ( InFileSymbol, SymbolClass );         
      END;
END SkipImportData;



 (* The symbol has been identified as being "special" meaning that it needs
    special processing ( verses a simple "exchange" ).
 *)
PROCEDURE ProcessCodeIsSpecial ( symbol : STRING      );
BEGIN

    IF  identical ( symbol , "THEN" )  THEN
          ProcessTHEN ();
    ELSIF identical ( symbol , "END" )   THEN
         ProcessEND ();
    ELSIF identical ( symbol , "ELSE" ) THEN
         ProcessELSE ();
    ELSIF StartsWithWRITE ( symbol ) THEN
         ProcessWRITE ( indent, symbol );
    ELSIF identical ( symbol , "DO" )  THEN
         ProcessDO ();
    ELSIF identical ( symbol , "FROM" )  THEN
         SkipImportData ();
    ELSIF identical  ( symbol , "MODULE" )  THEN
         ProcessMODULE ();
    ELSIF identical ( symbol , "PROCEDURE" ) THEN
         ProcessPROCEDURE ();
    ELSIF identical ( symbol , "RETURN" ) THEN
         ProcessRETURN ();
    ELSIF identical ( symbol , "POINTER" ) THEN  
         ProcessPOINTER ();
    ELSIF identical ( symbol , "CASE" ) THEN
         ProcessCASE ();
    ELSIF identical ( symbol , "ALLOCATE" ) THEN
         ProcessAllocation ( symbol );
    ELSIF identical ( symbol , "DEALLOCATE" ) THEN
         ProcessAllocation ( symbol );
    ELSIF identical ( symbol , "INC" ) THEN
         ProcessAutoInc ( symbol );
    ELSIF identical ( symbol , "DEC" ) THEN
         ProcessAutoInc ( symbol );
    ELSIF identical ( symbol , "" ) THEN        (*    future ....   *)
    ELSIF identical ( symbol , "" ) THEN
    ELSIF identical ( symbol , "" ) THEN
    ELSE
          internal ( "process.Keyword listed as SPECIAL not found");
    END;

END ProcessCodeIsSpecial;




PROCEDURE ProcessCodeIsNoSupport ( symbol : STRING );
BEGIN
   ErrorMessage ( NoSupportGeneric );
   IF      identical ( symbol , "DEFINITION" )     THEN
                     FatalError ( NoSupportDEFINITION );
   ELSIF   identical ( symbol , "IMPLEMENTATION" ) THEN
                     FatalError ( NoSupportIMPLEMENTATION );
   ELSIF   identical ( symbol , "LOOP" )           THEN
                     WriteString ("LOOP keyword is unsupported\n");
   ELSE
           internal ( "process.mod:ProcessCodeIsNoSupport has unknown code" );
   END;
END ProcessCodeIsNoSupport;




(*
   Here's the meat of the whole program. This procedure will take one symbol
   and related information as input and then output one or more symbols. Sounds
   pretty simple, huh? If a simple substitute is not possible further
   processing will take place. If the algorithm does not recognize the string
   given to it then it just writes it to output, unchanged.
*)
PROCEDURE ProcessSymbol(    Indent      : IndentArray;
                            symbol      : STRING;
                            SymbolClass : SymbolType   );


 VAR    IdInfo  : IdInfoType;   
BEGIN
   indent := Indent;   (* global *)

    (* symbol is an identifier/other and we are not in comment mode *)
   IF processable ( symbol , SymbolClass ) THEN
       IF SearchHash ( IdInfo, symbol ) THEN
           IF ( IdInfo.ProcessCode = exchange ) THEN
                out ( IdInfo.ExchangeString );
           ELSIF ( IdInfo.ProcessCode = special ) THEN
                ProcessCodeIsSpecial ( symbol );              
           ELSIF ( IdInfo.ProcessCode = NoSupport ) THEN
                ProcessCodeIsNoSupport ( symbol );
           ELSE
                internal ( "Unknown process code sent from IdLookup");
           END;
       ELSE
           out ( symbol );
       END;

    (* word wasn't an identifier or we're in comment mode   *)
   ELSE
           IF NOT CommentCharacter ( symbol ) THEN
                out ( symbol );
           ELSE
                 (* Change into or out of comment mode if the need be *)
                CheckCommentMode ( symbol );
           END;

   END;
END ProcessSymbol;





BEGIN (* main *)
   CommentMode       :=   FALSE;
   CommentBeginCount :=   0;     (* nested comments *)
   ModuleUsed        :=   FALSE;
END process.
