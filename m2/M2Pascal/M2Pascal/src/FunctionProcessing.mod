IMPLEMENTATION MODULE FunctionProcessing;

     (*
      * This module handles the processing for functions. The names
      * are stored in a stack so nested functions can be used. Actually,
      * nested functions aren't allowed so this module could be 
      * re-written to be much smaller.
      *
      *)

FROM  scan       IMPORT STRING,           ReadAheadLine,
                        ReadAheadSymbol,  TooFar,           SymbolType,
                        IndentArray,      EolnAhead;
FROM  errors     IMPORT FatalError,       ErrorMessage,     ErrorType,
                        internal;
FROM  InOut      IMPORT WriteString;

FROM  OutModule  IMPORT identical;

FROM  strings    IMPORT ConcatString;

FROM  Heap       IMPORT ALLOCATE,         DEALLOCATE ;

CONST
      DEBUG               = FALSE;
TYPE
      ProcedureStatusType = ( colon, SemiColon, NotFound );
      StackPtrType        = POINTER TO StackType;
      StackType           = RECORD
                             name  : STRING;
                             next  : StackPtrType;
                            END;
VAR
      indent          : IndentArray;
      symbol          : STRING; 
      SymbolClass     : SymbolType;

      top             : StackPtrType;


PROCEDURE push ( FunctionName : STRING );
 VAR node : StackPtrType;
BEGIN
 ALLOCATE ( node , SIZE ( StackType ) );
 IF ( node = NIL ) THEN
     FatalError ( OutOfMemory );
 END;

 node^ .   name   := FunctionName;
 node^ .   next   := top;
 top              := node;
END push;


PROCEDURE BufferFull () : BOOLEAN;
BEGIN
 RETURN TooFar ();
END BufferFull;



 (* Determine whether a colon is found after passed variables are
    declared. This indicates that that a keyword follows and the 
    procedure is a pascal function.
 *)
PROCEDURE GetStatus () : ProcedureStatusType;
 VAR good : BOOLEAN;   ReturnVal : ProcedureStatusType;
BEGIN
  ReturnVal  :=  NotFound;
  symbol     :=  "\0";
 
  WHILE (  ( NOT EolnAhead ()           ) AND 
           ( NOT identical ( ")" , symbol ))     ) DO
       ReadAheadSymbol ( symbol, SymbolClass );
  END;

  IF ( identical ( ")" , symbol ) ) THEN
       ReadAheadSymbol ( symbol, SymbolClass );
       IF ( SymbolClass = blanks ) THEN
            ReadAheadSymbol ( symbol, SymbolClass );
       END;
       IF ( identical ( ":" , symbol ) ) THEN
            ReturnVal := colon;
       END;
       IF ( identical ( ";" , symbol ) ) THEN
            ReturnVal := SemiColon;
       END;
  END;

  RETURN ReturnVal;
END GetStatus;



 (* Determine whether a colon is found after passed variables are
    declared. This indicates that that a keyword follows and the 
    procedure is a pascal function. No parenthesis are necessary
    in the declaration.
 *)
PROCEDURE GetInitStatus () : ProcedureStatusType;
 VAR good : BOOLEAN;   ReturnVal : ProcedureStatusType;
BEGIN
  ReturnVal  :=  NotFound;
  symbol     :=  "\0";
 
   (* Blanks after "procedure" *)
  ReadAheadSymbol ( symbol, SymbolClass );

   (* First non-blank symbol after keyword "procedure" *)
  IF ( SymbolClass = blanks ) THEN
       ReadAheadSymbol ( symbol, SymbolClass );
  END;

  IF ( identical ( ":" , symbol ) ) THEN
       ReturnVal := colon;
  END;
  IF ( identical ( ";" , symbol ) ) THEN
       ReturnVal := SemiColon;
  END;

  IF ( ReturnVal = NotFound ) THEN       (* search rest of line *)
       ReturnVal := GetStatus ();
  END;

  RETURN ReturnVal;
END GetInitStatus;




 (* If the modula-2 procedure we're checking returns a value then it is a 
    "function" in pascal.
  *)
PROCEDURE  IsAFunction () : BOOLEAN;
 VAR good            : BOOLEAN;           
     FunctionName    : STRING;            
     ProcedureStatus : ProcedureStatusType;
     ReturnVal       : BOOLEAN;
BEGIN
     FunctionName := "\0";
     good         := TRUE;

          (* blanks between "PROCEDURE" and it's name *)
     ReadAheadSymbol ( symbol, SymbolClass );

          (* procedure name *)
     ReadAheadSymbol ( symbol, SymbolClass );
     ConcatString    ( FunctionName, symbol );
     IF DEBUG THEN
	     WriteString (" -Procedure name : " );
             WriteString ( FunctionName ); WriteString("\n");
     END;
 
     ProcedureStatus := GetInitStatus ();
     WHILE ( ( ProcedureStatus = NotFound ) AND 
             ( NOT BufferFull() )           AND 
               good                            ) DO
                          good            := ReadAheadLine ( indent );
                          ProcedureStatus := GetStatus ();
     END;


      IF ( ( NOT good )  OR ( BufferFull() ) ) THEN
	     ErrorMessage ( UndeterminedProcedure );
      ELSE
           IF ( ProcedureStatus = colon ) THEN
                ReturnVal  := TRUE;
                push ( FunctionName );
           ELSE
                ReturnVal  :=  FALSE;
           END;
      END;

      RETURN ReturnVal;
END IsAFunction;


(* 
  We're through with reading in this function if "name" matches the
  name on the top of the stack. If they match then pop the name off.
*)
PROCEDURE  PopFunctionName ( name  : STRING    );
 VAR temp : StackPtrType;
BEGIN
   IF  ( top <> NIL ) THEN
        IF ( identical ( name , top^.name ) ) THEN
             temp   :=  top;
             top    :=  top^.next;
             DEALLOCATE ( temp , SIZE ( StackType ) );
        END;
   END;
END PopFunctionName;


PROCEDURE  FunctionName  ( VAR TheName : STRING );
BEGIN
    IF ( top <> NIL ) THEN
        TheName  := top^.name;
    ELSE
        internal ( "FunctionName-> bottom of stack reached" );
    END;
END FunctionName;



BEGIN
 top := NIL;
END FunctionProcessing.
