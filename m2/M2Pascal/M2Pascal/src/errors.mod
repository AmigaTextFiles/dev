IMPLEMENTATION  MODULE errors;




(*
   by : Greg Mumm

*)

FROM InOut      IMPORT WriteString, WriteCard;

FROM Heap       IMPORT FreeHeap;

FROM scan       IMPORT CloseAllFiles,  STRING, NameString;

FROM FileSystem IMPORT File, Close;


PROCEDURE PrintMessage ( message : ErrorType );
BEGIN
     CASE message OF 
            FileError               :   
                       WriteString("File Error");
                                    |
            Scan_DataPastEndOfLine  :
                       WriteString("Data encountered past the last column"); 
                                    |
            FileClose               :
                       WriteString("Error while attempting to close file");
                                    |
            FileNotOpened           :
                       WriteString("File not opened");
                                    |
            OutOfMemory             :
                       WriteString("Out of memory");
                                    |
            MultipleModule          :
                       WriteString("Sorry, modules within source code not");
                       WriteString(" allowed in this version");
                                    |
            UserHalt                :
                       WriteString("^C -> user halted execution");
                                    |
            CliHelp                 :
                       WriteString("m2pascal  source[.mod] [object[.p]]");
                                    |
            WorkBench               :
                       WriteString("Sorry, this version of m2pascal cannot");
                       WriteString(" be executed from workbench.");
                                    |
            NoProgramName           :
                       WriteString("There's no program name!");
                                    |
            NoSupportDEFINITION     :
                       WriteString("Can't translate definition module");
                                    |
            NoSupportIMPLEMENTATION :
                       WriteString("Can't translate implementation module");
                                    |
            NoSupportFiles          :
                       WriteString("File manipulation unsupported ");
                       WriteString("in this version");
                                    |
            NoSupportGeneric        :
                       WriteString("Unsupported feature detected");
                                    |
            WriteStatement          :
                       WriteString("Error in a Write statement");
                                    |
            UndeterminedProcedure   :
                       WriteString("Unsure if this is a procedure or ");
                       WriteString("function. Not enough look-ahead spc");
                                    | 
     ELSE
            WriteString("ErrorMessage not documented yet");
     END;
     WriteString("\n");
END PrintMessage;




PROCEDURE ErrorMessage ( message : ErrorType );
BEGIN
   WriteString(" ");    (* keep away from line numbers on left *)
   PrintMessage ( message );
END ErrorMessage;

 (* Line number are ALREADY on the screen at the left ( don't
    re-print them here. ( update for new version )
  *)
PROCEDURE ErrorFileMessage ( message : ErrorType;
                             name    : NameString;
                             line    : CARDINAL   );
BEGIN
   WriteString ("Error in FILE : "); WriteString ( name ); WriteString ("  ->");
   PrintMessage ( message );
END ErrorFileMessage;




PROCEDURE FatalError   ( message : ErrorType );
BEGIN
   WriteString("\n\n");
   PrintMessage ( message );
   WriteString("\n\n");

   CloseAllFiles;

   FreeHeap;   (* free up ALL memory allocated *)
 
   HALT;
END FatalError;



PROCEDURE internal ( AlertString : STRING );
BEGIN
    WriteString(" * INTERNAL ERROR! *   =>");
    WriteString( AlertString ); WriteString("\n");
    CleanUp();
    HALT;
END internal;


PROCEDURE CleanUp ();
BEGIN
    CloseAllFiles;    (* Close Any Files That Are Left Opened *)
    FreeHeap;
END CleanUp;

BEGIN
END errors.
