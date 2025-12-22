MODULE m2pascal;

(*   
                  MODULE-2  TRANSLATOR   ( m2 => pascal )        
                  by:     Greg Mumm
                  status: Public Domain. No version or derivative is to 
                          sold for ANY profit w/o my express written permission.
                          Please leave my name intact somewhere if you plan
                          to upgrade it.
*)

FROM SYSTEM       IMPORT ADR;

FROM process      IMPORT ProcessSymbol;

FROM options      IMPORT OptionsRec;

FROM System       IMPORT argc,            argv ;

FROM scan         IMPORT ReadSymbol,       ReadAheadSymbol, STRING,
                         ReadLine,         ReadAheadLine,   TooFar,
                         OpenInFile,       eof,             eoln,
                         CloseAllFiles,    OpenOutFile,
                         IndentArray,      DebugPrintLine,  SymbolType,
                         SPACE,            TAB,             NameString,
		         DebugOutputToggle,PrintLineNumber;
 
FROM errors       IMPORT CleanUp,         FatalError,      ErrorType;

FROM InOut        IMPORT WriteString,     WriteCard;

FROM Strings      IMPORT StringLength,    ConcatString,     DeleteSubString, 
                         LocateSubString, CompareStringCAP, Relation,
                         CopyString ;
FROM heap         IMPORT ALLOCATE;

FROM Tasks        IMPORT SetSignal, SignalSet;   (* all for BreadC procedure *)


CONST
         DEBUG   = FALSE;
         VERSION = "1.0";

VAR
        InName, OutName : NameString;
        indent          : IndentArray;
        BreakCSet       : BOOLEAN;


PROCEDURE  init;
BEGIN
   BreakCSet    :=   FALSE;
END init;


 (* Detect Control-C *)
PROCEDURE BreakC(): BOOLEAN;
CONST
  BreakCode = 12;
VAR ReturnCode : BOOLEAN;
BEGIN
  ReturnCode := BreakCode IN SetSignal(SignalSet{}, SignalSet{BreakCode});
  IF ReturnCode THEN
       BreakCSet := TRUE;
  END;
  RETURN ReturnCode;
END BreakC;



(*
   -----------------------------------------------------------------------
                   Process the CLI parameters.
     \/                        \/                                \/
*)




PROCEDURE same ( s1, s2  : NameString ) : BOOLEAN;
BEGIN
    RETURN   (  CompareStringCAP ( s1, s2 ) = equal );
END same;




PROCEDURE SetParameters ( VAR p1, p2, p3 : NameString );
 VAR  np1, np2, np3 :  POINTER TO NameString;   
BEGIN
     p1 := "\0";   p2 := "\0";   p3 := "\0";

    IF argc >= 2 THEN
         np1  :=  ADR ( argv^[1]^ ) ;
         CopyString ( p1, np1^ );
    END;

    IF argc >=3 THEN
         np2 := ADR ( argv^[2]^ );
         CopyString ( p2  , np2^ );
    END;

    IF argc >=4 THEN
         np3 := ADR ( argv^[3]^ );
         CopyString ( p3  , np3^ );
    END;
END SetParameters;



PROCEDURE OpenIn () : BOOLEAN;
 VAR good : BOOLEAN;
BEGIN
   OpenInFile ( InName, FALSE, good );
   RETURN good;
END OpenIn;



PROCEDURE OpenOut () : BOOLEAN;
 VAR good : BOOLEAN;
BEGIN
       OpenOutFile ( OutName, TRUE, good ); 
       RETURN good;    
END OpenOut;


PROCEDURE OpenUpFiles ( p1, p2 : NameString );
 VAR good : BOOLEAN;
BEGIN
   CopyString ( InName,  p1 ) ;
   CopyString ( OutName, p2 ) ;

   IF OpenIn () THEN
       IF NOT OpenOut () THEN
           FatalError ( CliHelp );          
       END;
   ELSE
       ConcatString ( InName, ".mod");
       IF OpenIn () THEN
            IF NOT OpenOut ()THEN
                FatalError ( CliHelp );
            END;
       ELSE
            FatalError ( CliHelp );
       END;
   END;
END OpenUpFiles;

 (* user is specifically requesting help or information.
 *)
PROCEDURE HelpRequested ();
BEGIN
     WriteString ("\nexample session:\n");
     WriteString ("         1> cp df1:prog.mod ram:\n");
     WriteString ("         1> m2pascal prog.mod\n");
     WriteString ("         1> more prog.p\n");
     WriteString ("              option \"-bd\" (begin down) puts 'begin' \n");
     WriteString ("              on following line. The default is to put\n");
     WriteString ("              it on the same line as the command\n\n");
END HelpRequested ;


PROCEDURE help( p1 : NameString ) : BOOLEAN;
BEGIN
    RETURN ( same( p1 , "-?")   OR 
             same( p1 , "-h")  ) ;

END help;


PROCEDURE InFileEnding () : BOOLEAN;
 VAR l : CARDINAL;
BEGIN
    l := StringLength ( InName );
    RETURN ( LocateSubString ( InName, ".mod", l-4, l-1  ) <> -1 );
END InFileEnding ;


PROCEDURE BeginNewLine ( p1 : NameString ) : BOOLEAN;
BEGIN
       RETURN  (  same( p1 , "-bn" )   OR
                  same( p1 , "-bd" )  )
END BeginNewLine;


PROCEDURE ProcessCommands ( p1, p2, p3 : NameString ) : BOOLEAN;
BEGIN
     IF  BeginNewLine ( p1 ) THEN
           
           CopyString ( InName,  p2 ) ;
           CopyString ( OutName, p3 ) ;
           OptionsRec.BeginNewLine := TRUE;
           RETURN TRUE;
     ELSE
           RETURN FALSE;
     END;
END ProcessCommands ;


PROCEDURE ProcessArgc2 ( VAR p1, p2, p3 : NameString );
 VAR l : CARDINAL;
BEGIN
        IF help ( p1 ) THEN
            HelpRequested ();
            CleanUp();
        ELSE
            CopyString ( InName, p1 );
        END;

        CopyString ( OutName, InName ) ;
        IF InFileEnding () THEN
            l         := StringLength ( OutName );
            DeleteSubString( OutName, l - 4, l );        
        END;

        ConcatString ( OutName, ".p");
        IF OpenIn () THEN
            IF NOT OpenOut () THEN
                 FatalError ( CliHelp );
            END;
        ELSE
            ConcatString ( InName, ".mod" );
            IF OpenIn () THEN
                IF NOT OpenOut () THEN
                     FatalError ( CliHelp );
                 END;
            ELSE
                 FatalError ( CliHelp );
            END;
        END;
END ProcessArgc2;


(*  IN:   CLI parameters.
    OUT:  InFile, OutFile ( properly opened )   OR    
          Errors/help information.
*)
PROCEDURE ProcessCli ();
 VAR   p1, p2, p3 : NameString;       l : CARDINAL;
BEGIN
  SetParameters ( p1, p2, p3 );
  IF DEBUG THEN
       WriteString("ProcessCli() enter [ after SetParameters ]\n");
       WriteString("CLI p1 = |");WriteString(p1);WriteString("|\n");
       WriteString("CLI p2 = |");WriteString(p2);WriteString("|\n");
       WriteString("CLI p3 = |");WriteString(p3);WriteString("|\n");
  END;
  IF    argc = 4 THEN
        IF ProcessCommands ( p1, p2, p3 ) THEN
            OpenUpFiles ( p2, p3 );
        ELSE
            FatalError ( CliHelp );
        END;
  ELSIF ( argc = 3 ) OR ( argc = 2 ) THEN
        IF ( argc = 3 ) THEN
             IF ( NOT BeginNewLine ( p1 ) ) THEN
                  OpenUpFiles ( p1, p2 );
             ELSE
                  argc := 2;
                  OptionsRec.BeginNewLine := TRUE;
                  p1 := "\0";
                  ConcatString ( p1, p2 );
             END;
        END;
        IF ( argc = 2 ) THEN
             ProcessArgc2 ( p1, p2, p3 );
        END;
  ELSIF argc = 1 THEN
        FatalError ( CliHelp );
  ELSIF argc = 0 THEN
        FatalError ( WorkBench );
  ELSE
        FatalError ( CliHelp );
  END;
END ProcessCli;


(*
     ^                          ^                                ^
                   Process the CLI parameters.
   -----------------------------------------------------------------------
*)



PROCEDURE AuthorVersion ();
BEGIN
   WriteString ("    M2PASCAL  by: Greg Mumm  ( VER ");
   WriteString (VERSION);
   WriteString (" BETA )\n");
   WriteString ("                  "); WriteString(InName);
   WriteString ("  ==>  "); WriteString(OutName); WriteString("\n");

END AuthorVersion;



PROCEDURE DebugPrintSymbol ( symbol : STRING;  SymbolClass : SymbolType );
BEGIN
   WriteString("-");
   IF ( ( symbol [ 0 ] = SPACE )  OR ( symbol [ 0 ] = TAB ) ) THEN
        WriteString("<blanks>");
   ELSE         
        WriteString( symbol );
   END;
   WriteString("       ");
   IF SymbolClass = number THEN
        WriteString("number\n");
   ELSIF SymbolClass = identifier THEN
        WriteString("identifier\n");
   ELSIF SymbolClass = end THEN
        WriteString("end\n");
   ELSIF SymbolClass = literal THEN
        WriteString("literal\n");
   ELSIF SymbolClass  = blanks  THEN
        WriteString("blanks or tabs\n");
   ELSIF SymbolClass = other   THEN
        WriteString("other\n");
   END;
END DebugPrintSymbol;




PROCEDURE DoMain ();
 VAR good : BOOLEAN;  symbol : STRING;   SymbolClass : SymbolType;
BEGIN

        good := ReadLine ( indent );

        WHILE ( NOT eof ()   AND ( good )  AND ( NOT BreakC()  ) ) DO
          PrintLineNumber();
          WHILE NOT eoln ()  DO
                ReadSymbol ( symbol, SymbolClass );
                ProcessSymbol ( indent, symbol, SymbolClass );
          END;
          good := ReadLine ( indent );
        END;

        IF NOT good  THEN FatalError ( FileError ); END;
        IF BreakCSet THEN FatalError ( UserHalt  ); END;
END DoMain;



BEGIN (* main *)
        ProcessCli ();
        AuthorVersion ();
        DoMain ();
        CleanUp;
        WriteString("\n");
END m2pascal.
