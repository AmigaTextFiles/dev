IMPLEMENTATION MODULE scan;

(* 

                      **********
                      ** SCAN **     ( BETA version )
                      **********

             by : Greg Mumm


      This lex. scanner reads multiple symbols one by one on a per line basis.

      The look-ahead buffer is organized like this: ( Each character
      represents one line of the source data )

                   ---                             <<     Never read again
                    *    <-- PermanentPtr          ---
                    B                                 \
                    U                                  >  Full of data
                    F    <-- AheadFrontPtr            /   to be read again
                    F                                /
                    E    <-- AheadRearPtr          --
                    R    
                    *
                    *
                    *    <-- BUFFERSIZE
                    ---   

                        All of the above data is used to set "BufferIndex"
                        which points to the correct line in the buffer.

*)


FROM FileSystem  IMPORT ReadChar,         File,             Response,
                        Lookup,           Close,            WriteChar;
FROM InOut       IMPORT WriteString,      WriteCard,        ReadString;
FROM Strings     IMPORT CompareString,    Relation,         CopyString;
FROM errors      IMPORT FatalError,       ErrorMessage,     ErrorType,
                        ErrorFileMessage, internal;
FROM heap        IMPORT ALLOCATE,         DEALLOCATE;

CONST 
      BUFFERSIZE = 8;      (* size of look-ahead buffer: Stores BUFFERSIZE - 1
                              lines for "look-ahead"  *)


TYPE
     AccessType    = ( normal  ,       ScanAhead                   );
     ReadStatusType= ( permanent,      AheadFront,    AheadRear    );
     LineArray     = ARRAY  [ 1..StringMax ] OF CHAR;
     LineRecType   = RECORD 
                       line          :  LineArray;
                       PermanentPtr  :  CARDINAL;
                       AheadFrontPtr :  CARDINAL;
                       AheadRearPtr  :  CARDINAL;
     END;
     LineBufferType = ARRAY [ 1..BUFFERSIZE ] OF  LineRecType;
(*
     ScanFileRec = RECORD
                       FileData      :  File;
                       LineBuffer    :  LineBufferType;
                       LineNumber    :  CARDINAL;
                       PermanentPtr  :  CARDINAL;
                       AheadFrontPtr :  CARDINAL;
                       AheadRearPtr  :  CARDINAL;
                       EndLine       :  BOOLEAN;
                       EndLineAhead  :  BOOLEAN;
                       EndFile       :  BOOLEAN;
                       EndFileAhead  :  BOOLEAN;
                       BufferFull    :  BOOLEAN;
                       LastAccess    :  AccessType;
                    END;
*)


VAR
      PermanentPtr,
      AheadFrontPtr,
      AheadRearPtr,
      PermanentStore,
      AheadFrontStore,
      AheadRearStore,
      BufferIndex    :  CARDINAL;
      LineBuffer     :  LineBufferType;  (* List of lines we're working on *)
      InFile         :  File;         (* The AmigaDos file we're working on *)
      OutFile        :  File;
      ch             :  CHAR;
      SymbolPtr      :  CARDINAL;
      CharPtr        :  CARDINAL;
      indent         :  IndentArray;  (* Margin information before 1'st symol *)
      InName         :  NameString;
      OutName        :  NameString;
      EndLine        ,
      EndFile        ,
      EndLineAhead   ,
      EndFileAhead   :  BOOLEAN;
      EndLineStore   ,
      EndFileStore   ,
      EndLineAheadStore ,
      EndFileAheadStore :  BOOLEAN;
      LineNumber     :  CARDINAL;
      BufferFull     :  BOOLEAN;
      LastAccess     :  AccessType;
      status         :  ReadStatusType;
      ahead          :  BOOLEAN;
      DebugOutput    :  BOOLEAN;
       
(*
 -------------------------------------------------------------------------
                       General file usage procedures.
*)


 (* 
   Store "new" to proper value. ( Store it to flag or FlagAhead ). "flag"
   represents EndLine or EndFile.
 *)
PROCEDURE SetVal ( VAR flag , FlagAhead : BOOLEAN;  new, ahead : BOOLEAN );
BEGIN
      IF ( NOT ahead ) THEN
            flag      := new;
      ELSE
            FlagAhead := new;
      END;
END SetVal;


PROCEDURE BlankOutBuffer ();
 VAR i,j : CARDINAL;
BEGIN
 FOR i := 1 TO BUFFERSIZE DO
     FOR j := 1 TO StringMax DO
          LineBuffer [ i ].line[ j ]         := 0C;
     END;
     LineBuffer [ i ].PermanentPtr           := 1;          
     LineBuffer [ i ].AheadFrontPtr          := 1;          
     LineBuffer [ i ].AheadRearPtr           := 1;          
 END;
END BlankOutBuffer ;


 (* This procedure determines where the data requested is to be read from.
    There are three possibities of output:    
    
                       PermanentData     ( Return this data and never come
                                           back. )
                       AheadFront        ( Return data to be re-read later.
                                           If read before, send it again. )
                       AheadRear         ( Return data to be re-read later.
                                           Use data that hasn't been 
                                           read before.)
    Input : ahead , LastAccess.
 *)

PROCEDURE ReadStatus () : ReadStatusType;
BEGIN
     IF ( NOT ahead ) THEN
                     RETURN permanent;
     ELSE
          IF ( LastAccess = normal ) THEN
                     RETURN AheadFront;
          ELSE
       	             RETURN AheadRear;
          END;
     END;
END ReadStatus;


PROCEDURE DataSet() : BOOLEAN;
BEGIN
    RETURN InName[0] <> 0C;
END DataSet;


PROCEDURE DetermineEof (ahead:BOOLEAN) : BOOLEAN;
 VAR ReturnVal : BOOLEAN;
BEGIN
    ReturnVal := FALSE;
    IF DataSet() THEN
        IF ( NOT ahead ) THEN
            ReturnVal := EndFileStore;
        ELSE
            ReturnVal := EndFileAheadStore;
        END;
    END;
    RETURN ReturnVal ;
END DetermineEof;


PROCEDURE DetermineEoln ( ahead : BOOLEAN ) : BOOLEAN;
 VAR ReturnVal : BOOLEAN;
BEGIN
    ReturnVal := FALSE;
    IF DataSet () THEN
        IF ( NOT ahead ) THEN
            ReturnVal := EndLineStore;
        ELSE
            ReturnVal := EndLineAheadStore;
        END;
    END;
    RETURN ReturnVal;
END DetermineEoln;



PROCEDURE eof () : BOOLEAN;
BEGIN
  RETURN DetermineEof ( FALSE );
END eof;


PROCEDURE EofAhead () : BOOLEAN;
BEGIN
  RETURN DetermineEof ( TRUE );
END EofAhead;


PROCEDURE eoln () : BOOLEAN;
BEGIN
  RETURN DetermineEoln ( FALSE );
END eoln;


PROCEDURE EolnAhead ( ) : BOOLEAN;
BEGIN
  RETURN DetermineEoln ( TRUE );
END EolnAhead;



PROCEDURE HitABrickWall ( ) :  BOOLEAN;
BEGIN
  RETURN ( eof () OR  eoln () );
END HitABrickWall;


 (* The two following procedured don't work! 
    An attempt was made to find a solution to
    the problem of ReadingAhead after a ReadAhead command. In the 
    second case we wish to read the same symbol as the first case.
*)
PROCEDURE rewind ();
BEGIN
    LastAccess    := normal ;
END rewind;


PROCEDURE FastForward ();
BEGIN
 LastAccess := ScanAhead ;
END FastForward;


(*
   Was look-ahead buffer full?
*)
PROCEDURE TooFar () : BOOLEAN;
BEGIN
    IF DataSet () THEN
         RETURN BufferFull;
    ELSE
         RETURN TRUE;
    END;
END TooFar;


PROCEDURE OpenFile (     name     : ARRAY OF CHAR;
                     VAR FileData : File; 
                       DeleteFile : BOOLEAN ) : BOOLEAN;
BEGIN
     Lookup ( FileData , name, DeleteFile ); 
     RETURN ( FileData.res = done );
END OpenFile;


PROCEDURE OpenInFile (    FileName   : NameString  ;
                          DeleteFile : BOOLEAN     ;
                      VAR opened     : BOOLEAN      ) ;
BEGIN
     opened := OpenFile(FileName,InFile,DeleteFile);
     IF opened THEN
              CopyString(InName,FileName);
              BlankOutBuffer ();
              LineNumber          := 0;          (* Just read this line *)
              PermanentPtr        := 1;
              AheadFrontPtr       := 1;
              AheadRearPtr        := 1;
              PermanentStore      := 1;
              AheadFrontStore     := 1;
              AheadRearStore      := 1;
              EndFile             := FALSE;
              EndFileAhead        := FALSE;
              EndLine             := FALSE;
              EndLineAhead        := FALSE;
              EndFileStore        := FALSE;
              EndFileAheadStore   := FALSE;
              EndLineStore        := FALSE;
              EndLineAheadStore   := FALSE;
              BufferFull          := FALSE;
              LastAccess          := normal;
      ELSE
              InName[0]:=0C;
      END;
END OpenInFile;


PROCEDURE OpenOutFile (    FileName   : NameString  ;
                          DeleteFile  : BOOLEAN     ;
                      VAR opened      : BOOLEAN      ) ;
BEGIN
     opened := OpenFile(FileName,OutFile,DeleteFile);
     IF opened THEN
              CopyString(OutName,FileName);
     ELSE
              OutName[0]:=0C;
     END;
END OpenOutFile;



PROCEDURE CloseAllFiles ();
 VAR successful:BOOLEAN;
BEGIN
     IF (InName[0]<>0C) THEN 
          Close ( InFile );
          successful := ( InFile.res = done ) OR  ( InFile.eof = TRUE );
          IF NOT successful THEN ErrorMessage ( FileClose );   END;
          InName[0]:=0C;
     END;
     IF (OutName[0]<>0C) THEN
          Close ( OutFile );
          successful := ( OutFile.res = done ) OR  ( OutFile.eof = TRUE );
          IF NOT successful THEN ErrorMessage ( FileClose );   END;
          OutName[0]:=0C;
     END;
END CloseAllFiles;


(*
 ---------------------------------------------------------------------------
       Read from file into one line of information.
\/     \/     \/    \/    \/    \/    \/    \/    \/    \/    \/    \/    \/
*)



(* 
  This procedure reads in another character from the InFile.
*)
PROCEDURE NextCh ( VAR ptr     : CARDINAL;    
                   VAR ch      : CHAR );
BEGIN
        LineBuffer [ BufferIndex ]. line [ ptr ] := ch;
        ReadChar ( InFile, ch );
        INC (ptr);
END NextCh;



(*
   Setup global values to be used by internal procedures and setup
   externally visible variables.
*)
PROCEDURE LineSetGlobal ();
BEGIN
    BufferFull           := FALSE;
    EndLine              := FALSE;
    EndFile              := FALSE;
    PermanentPtr         := PermanentStore;
    AheadFrontPtr        := AheadFrontStore;
    AheadRearPtr         := AheadRearStore;
    status               := ReadStatus ();
END LineSetGlobal;



(* 
   Determine which line in buffer we should be accessing next.
*)
PROCEDURE SetBufferIndex () : CARDINAL;
BEGIN
     IF     ( status = permanent )  THEN
          IF     ( PermanentPtr <> AheadRearPtr )  THEN
	       INC    ( PermanentPtr , 1 );
          ELSE
               PermanentPtr  := 1;
               AheadFrontPtr := 1;
               AheadRearPtr  := 1;
          END;
          RETURN        PermanentPtr;
     ELSIF ( status = AheadRear )  THEN
          INC    ( AheadRearPtr );
          IF     ( AheadRearPtr > BUFFERSIZE ) THEN
               BufferFull := TRUE;
	       RETURN 0;               
          END;
          RETURN AheadRearPtr;
     ELSE
          INC    ( AheadFrontPtr );
          RETURN AheadFrontPtr;
     END;
END SetBufferIndex;


 (* Print INPUT line
  *)
PROCEDURE DebugPrintLine ( indent : IndentArray );
 VAR    i : CARDINAL ; 
BEGIN
     (* 
        note: line numbers NOT accurate after a readAHEADline
     *)
        WriteString("\n--------");WriteString(InName);
        WriteCard ( LineNumber , 3 );
        WriteString("---");WriteString("\n");
        i := 1;
        REPEAT
           ch := LineBuffer [ BufferIndex ] . line [ i ] ;
           IF  ch = EOLN THEN
               WriteString("\n");
           ELSIF ch = 0C THEN
               WriteString("<eof> OR 0C\n");
           ELSE
               WriteString( ch );
           END;
           INC( i );
        UNTIL ( ch=EOLN )  OR ( ch = 0C );
        WriteString("----------------------------------------------------\n"); 
END DebugPrintLine;


 (* Print all data sent to OUTPUT (object) file. Set this and you're
    looking at the file as it is being written to disk.
  *)
PROCEDURE DebugOutputToggle ();
BEGIN
	IF DebugOutput THEN
		WriteString("DebugOutputToggle. Output to screen OFF.\n");
		DebugOutput := FALSE;
	ELSE
		WriteString("DebugOutputToggle executed. All data sent to \n");
		WriteString("a file is being printed to screen also.\n\n");
		DebugOutput := TRUE;
	END;
END DebugOutputToggle;

(*
   What line number are we processing. Add offset if we're looking ahead.
   ( internal use )
*)
PROCEDURE GetLineNumber ( ) : CARDINAL;
 VAR status : ReadStatusType;
BEGIN
     IF NOT ahead THEN 
          RETURN LineNumber;
     ELSE
          status :=  ReadStatus ();
          IF ( status = AheadFront ) THEN
                 RETURN ( LineNumber + 
                        ( AheadFrontPtr - PermanentPtr ) );
          ELSE
                 RETURN ( LineNumber + 
                        ( AheadFrontPtr - PermanentPtr ) );
          END;
     END;
END GetLineNumber;



PROCEDURE PrintLineNumber ();
BEGIN
     IF ( NOT DebugOutput ) THEN
	  WriteString("\n");
          WriteCard(LineNumber,1);	
     END;
END PrintLineNumber;




PROCEDURE ScanLine ( VAR indent : IndentArray;  VAR good : BOOLEAN  ;
                         ahead  : BOOLEAN );
 VAR i, ptr, IndentPtr : CARDINAL; ch : CHAR;
BEGIN
      i := 1; ptr := 1; IndentPtr := 1; ch := 0C;

      (* set 'indent' *)
     ReadChar ( InFile, ch );
     WHILE ( ((ch = SPACE) OR ( ch = TAB ))  AND (InFile.res = done)  )  DO
                indent [ IndentPtr ] := ch;
                INC    ( IndentPtr,  1 );
                NextCh ( ptr,        ch );
     END;


      (* Read in rest of line *)
     WHILE   ( (InFile.res = done) & 
               ( (( NOT InFile.eof) & (ch <> EOLN)) & (ptr < StringMax ) ) ) DO
                NextCh ( ptr, ch );
     END; 


     IF InFile.eof THEN
                EndFile                                   := TRUE;
                LineBuffer [ BufferIndex ] . line [ ptr ] := 0C;

     ELSIF  InFile.res <> done   THEN
                good  := FALSE;

      ELSIF ( ch = EOLN ) THEN
                LineBuffer [ BufferIndex ] . line [ ptr ]     := EOLN;
 

     ELSIF ( ptr >=  StringMax ) THEN  
                ErrorFileMessage ( Scan_DataPastEndOfLine , 
                                   InName,
                                   GetLineNumber () );
                LineBuffer [ BufferIndex ] . line [ ptr ]     := EOLN;
     END;
     
     indent [ IndentPtr ] := 0C;     

END ScanLine;



(*
   Save the global data to FileInfo after reading a line.
   (Return value of items).
*)
PROCEDURE LineReadGlobal ();
BEGIN
     SetVal ( EndFileStore , EndFileAheadStore, EndFile, ahead );
     SetVal ( EndLineStore , EndLineAheadStore, EndLine, ahead );
     AheadFrontStore :=    AheadFrontPtr;
     AheadRearStore  :=    AheadRearPtr;
     PermanentStore  :=    PermanentPtr;
     
     IF ( status = permanent ) THEN
          LastAccess    := normal;
     ELSE
          LastAccess    := ScanAhead;
     END;
     LineBuffer[ BufferIndex ] . PermanentPtr  :=    1;
     LineBuffer[ BufferIndex ] . AheadFrontPtr :=    1;
     LineBuffer[ BufferIndex ] . AheadRearPtr  :=    1;
END LineReadGlobal;




(* Read from the file or buffer?
*)
PROCEDURE ReadInFileData () : BOOLEAN;
BEGIN
     RETURN   ( BufferIndex = 1    )   OR
              ( status = AheadRear ) ;
END ReadInFileData;



(*
   Read in one line from input file.
*)
PROCEDURE ReadInLine (   ahead : BOOLEAN ;  
                      VAR good : BOOLEAN ;   VAR indent   : IndentArray );
BEGIN
 LineSetGlobal  ();
 BufferIndex    := SetBufferIndex ( );

 IF NOT BufferFull THEN
    IF ReadInFileData () THEN 
         LineBuffer [ BufferIndex ] . line [ StringMax ] := 0C;
         ScanLine   ( indent , good, ahead );
    END;
    IF good THEN LineReadGlobal (); END;
 END;
END ReadInLine;



PROCEDURE ReadLine ( VAR indent     : IndentArray  ) : BOOLEAN ;
 VAR     ptr : CARDINAL;     i : CARDINAL;    ch : CHAR;   IndentPtr : CARDINAL;
        good : BOOLEAN;
BEGIN
 good := TRUE;
 IF NOT DataSet () THEN 
        ErrorMessage( FileNotOpened );
        good := FALSE;
 END;

 ahead := FALSE;
 IF good THEN
    ReadInLine ( ahead, good, indent );
    INC ( LineNumber )
 END;
 RETURN good;
END ReadLine;



PROCEDURE ReadAheadLine ( VAR indent  : IndentArray  ) : BOOLEAN ;
 VAR     ptr : CARDINAL;     i : CARDINAL;    ch : CHAR;   IndentPtr : CARDINAL;
        good : BOOLEAN;
BEGIN
 good := TRUE;
 IF NOT DataSet () THEN 
        ErrorMessage( FileNotOpened );
        good := FALSE;
 END;

 ahead := TRUE;
 IF good AND ( NOT eof () ) THEN
      ReadInLine ( ahead, good, indent );
 END;
 RETURN ( good )  AND  ( NOT BufferFull )  ;
END ReadAheadLine;




(*
  --------------------------------------------------------------------------
                       Symbol processing procedures.
\/     \/     \/    \/    \/    \/    \/    \/    \/    \/    \/    \/    \/
*)




(*
   Add 'ch' to the symbol and get next 'ch'.
*)

PROCEDURE AddChar ( VAR symbol     : STRING );
BEGIN
        symbol [ SymbolPtr ] := ch;
        INC ( SymbolPtr , 1 );
        INC ( CharPtr   , 1 );
        ch := LineBuffer [ BufferIndex ] . line [ CharPtr ];
END AddChar;


(*
   Reads in a literal. ( Charcters between and including quotes )
*)
PROCEDURE ScanLiteral ( VAR symbol   :   STRING;  VAR correct    : BOOLEAN  );
 VAR   working        : BOOLEAN;
       i              : CARDINAL;
       quote          : CHAR;
       CharPtrStart   : CARDINAL;
       SymbolPtrStart : CARDINAL;
BEGIN
     working         := TRUE;
     ch              := LineBuffer [ BufferIndex ] . line [ CharPtr ];
     quote           := ch ;
     correct         := TRUE;

     AddChar ( symbol );

      (* Save location in case no end quote found *)
     CharPtrStart    := CharPtr;    
     SymbolPtrStart  := SymbolPtr;

     WHILE  (  working & ( CharPtr < StringMax )  &
            ( ( ch <> 0C ) OR ( ch <> EOLN ) ) )          DO

                IF  ( ch = quote ) THEN
                        working :=  
                              LineBuffer [ BufferIndex ] . 
                               line [ CharPtr + 1 ] = quote ;
                        IF  working THEN    (* double quote *)
                                AddChar ( symbol );
                        END;
                END;

                IF (( CharPtr < StringMax ) & 
                   ( ( ch <> 0C ) OR ( ch <> EOLN )))     THEN

                    AddChar ( symbol );
                END;
     END;

     IF working & ( CharPtr = StringMax  ) THEN
                (* second quote not detected *)
                correct   := FALSE;
                CharPtr   := CharPtrStart;
                SymbolPtr := SymbolPtrStart;
     END;

     symbol [ SymbolPtr ]  := 0C;     
END ScanLiteral;



PROCEDURE BLANKS ( ch : CHAR ) : BOOLEAN;
BEGIN
    RETURN  ( ch =  SPACE ) OR ( ch =  TAB )
END BLANKS;



PROCEDURE alphabetic ( ch : CHAR ) : BOOLEAN;
BEGIN
         (* It's confussing looking, but it's fast, and it works... *)
        RETURN  (  (( ch >= "a" ) &  ( ch <= "z" )) OR 
                   (( ch >= "A" ) &  ( ch <= "Z" )) OR
                    ( ch =  "_" )                    OR
                    ( ch =  "'" )                    OR
                    ( ch =  '"' )                     );
END alphabetic;


(*
   Extra characters are allowed after the first character is read
   in. ( For instance  the "_" character ) . This procedure excludes
   these characters.
 *)
PROCEDURE StartAlphabetic ( ch : CHAR ) : BOOLEAN;
BEGIN
        RETURN (  ( ( ch >= "a" ) &  ( ch <= "z" ) ) OR 
                  ( ( ch >= "A" ) &  ( ch <= "Z" ) ) );

END StartAlphabetic;




PROCEDURE numeric ( ch : CHAR ) : BOOLEAN;
BEGIN
      RETURN    ( (( ch >='0' ) & ( ch <= '9' ))  OR
                   ( ch = '.' )                   OR
                   ( ch = 'e' )                   OR
                   ( ch = 'E' )                   OR
                   ( ch = '+' )                   OR
                   ( ch = '-' ) );
END numeric;



 (* Test if character is a number while searching an identifier.
    Decimal points etc are NOT included
  *)
PROCEDURE digit ( ch : CHAR ) : BOOLEAN;
BEGIN
      RETURN    ( ( ch >='0' ) & ( ch <= '9' ) );
END digit;



(*
   Set output of SetPtr is based on  "ahead" and LastAccess.

   Each line looks like this:
       
           [ x x x x x x x x x x x x x x x x x x x x ...]
               ^             ^               ^
               PermanentPtr  AheadFrontPtr   AheadRearPtr

           where: Anything left of PermanentPtr has been read and is gone 
                   forever.
                  Anything between PermanentPtr & AheadRearPtr has been
                   read from the file already and is waiting to be processed.
                  AheadFrontPtr is used when scanning ahead when there is
                   scanned ahead data to read.
*)
PROCEDURE SetPtr () : CARDINAL;
BEGIN
     IF     ( status = permanent )  THEN
               RETURN PermanentPtr;
     ELSIF  ( status = AheadRear )  THEN
               RETURN AheadRearPtr;
     ELSE
               RETURN AheadFrontPtr;               
     END;
END SetPtr;


PROCEDURE SetBufferIndexForSymbol () : CARDINAL;
BEGIN
     IF     ( status = permanent )  THEN
               RETURN PermanentStore;
     ELSIF  ( status = AheadRear )  THEN
               RETURN AheadRearStore;
     ELSE
               RETURN AheadFrontStore;               
     END;
END SetBufferIndexForSymbol;


PROCEDURE SymbolSetGlobal (  VAR LiteralCorrect  : BOOLEAN );
BEGIN
        status               := ReadStatus ();
        BufferIndex          := SetBufferIndexForSymbol ();
        PermanentPtr         := LineBuffer [ BufferIndex ] . 
                                 PermanentPtr;
        AheadFrontPtr        := LineBuffer [ BufferIndex ] . 
                                 AheadFrontPtr;
        AheadRearPtr         := LineBuffer [ BufferIndex ] . 
                                 AheadRearPtr;
        SymbolPtr            := 0;
        LiteralCorrect       := FALSE;
        CharPtr              := SetPtr ();
        ch                   := LineBuffer [ BufferIndex ]. line  [ CharPtr ] ;
END SymbolSetGlobal;




PROCEDURE ReadInSymbol (  VAR symbol         : STRING; 
                          VAR SymbolClass    : SymbolType ;
                          VAR LiteralCorrect : BOOLEAN );
BEGIN
        IF BLANKS(ch) THEN
                WHILE ( BLANKS ( ch )  &  ( CharPtr < StringMax ) ) DO
                   AddChar ( symbol );
                END;
                SymbolClass          := blanks;      
                symbol [ SymbolPtr ] := 0C;
        ELSIF StartAlphabetic ( ch ) THEN       
                WHILE ( ( alphabetic ( ch ) OR digit ( ch ) &  
                      ( CharPtr < StringMax ) ) )   DO
                  AddChar ( symbol );
                END;
                        SymbolClass          := identifier;  
                        symbol [ SymbolPtr ] := 0C;
        ELSIF numeric ( ch ) THEN
                WHILE  ( numeric ( ch ) &  ( CharPtr < StringMax ) ) DO
                   AddChar ( symbol );
                END;
                        SymbolClass          := number;      
                        symbol [ SymbolPtr ] := 0C;
        ELSIF ( ( ch = "'" ) OR ( ch = '"') ) THEN
                ScanLiteral ( symbol , LiteralCorrect );
                IF LiteralCorrect THEN  SymbolClass  := literal;
                ELSE                    SymbolClass  := other  ;   END;
         (* eoln or eof *)
        ELSIF ( ( ch = EOLN ) OR ( ch = 0C ) ) THEN
                EndLine              := TRUE;
                SymbolClass          := end;
                symbol [ SymbolPtr ] := EOLN;
                IF SymbolPtr < StringMax THEN
                     INC    ( SymbolPtr );
                     symbol [ SymbolPtr ] := 0C;
                END;
        ELSE
                AddChar ( symbol );
                SymbolClass           := other;
                symbol  [ SymbolPtr ] := 0C;
        END;
END ReadInSymbol;


 (* Store the global data we modified when reading a symbol 
    back to FileInfo.
  *)
PROCEDURE SymbolReadGlobal ();
BEGIN
      IF    ( status = permanent ) THEN
              LastAccess := normal;
              LineBuffer [ BufferIndex ] . PermanentPtr  := CharPtr;
              IF    ( CharPtr > AheadFrontPtr ) THEN
                   LineBuffer [ BufferIndex ] . AheadFrontPtr  := CharPtr; 
              END;
              IF ( CharPtr > AheadRearPtr  ) THEN
                   LineBuffer [ BufferIndex ] . AheadRearPtr   := CharPtr; 
              END;
      ELSIF ( status = AheadRear ) THEN
              LastAccess := ScanAhead;
              LineBuffer [ BufferIndex ] . AheadRearPtr  := CharPtr;
      ELSE
              LastAccess := ScanAhead;
              LineBuffer [ BufferIndex ] . AheadFrontPtr  := CharPtr;
              IF    ( CharPtr > AheadRearPtr ) THEN
                   LineBuffer [ BufferIndex ] . AheadRearPtr  := CharPtr; 
              END;
     END;
     SetVal ( EndLineStore , EndLineAheadStore , EndLine, ahead );
END SymbolReadGlobal;



(*
  Input : one line.
  Output: One symbol and it's class.
*)
PROCEDURE ReadSymbol ( VAR  symbol        : STRING;
                       VAR  SymbolClass   : SymbolType );
 VAR     LiteralCorrect :  BOOLEAN;  
BEGIN
        ahead := FALSE;
        SymbolSetGlobal    ( LiteralCorrect );
        ReadInSymbol       ( symbol,  SymbolClass, LiteralCorrect );
        SymbolReadGlobal   ();
END ReadSymbol;





PROCEDURE ReadAheadSymbol ( VAR  symbol        : STRING;
                            VAR  SymbolClass   : SymbolType );
 VAR     LiteralCorrect :  BOOLEAN;  
BEGIN
        ahead := TRUE;
        SymbolSetGlobal  ( LiteralCorrect );
        ReadInSymbol     ( symbol, SymbolClass, LiteralCorrect ); 
        SymbolReadGlobal ();
END ReadAheadSymbol;



(*
  ---------------------------------------------------------------------------
                                    File Output.
*)
PROCEDURE write ( ch : CHAR ) ;
BEGIN
    IF OutName[0]<>0C THEN
         WriteChar ( OutFile, ch );
	 IF DebugOutput THEN WriteString ( ch ); END;
         IF OutFile.res <> done THEN
             IF OutFile.res = nomemory THEN
                   FatalError ( OutOfMemory  );
             ELSE
                   FatalError ( FileError );
             END;
         END;  
     END;
END write;

BEGIN
   InName[0]     :=  0C;
   OutName[0]    :=  0C;
   DebugOutput   :=  FALSE;
END scan.
