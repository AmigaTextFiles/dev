IMPLEMENTATION MODULE IdLookup;


(*

     By: Greg Mumm

     This module allows the lookup of identifiers.  It's especially
     useful for the simple substitutions that occur when translating
     module-2 into pascal. For instance, looking up the symbol "MODULE"
     will result in the new symbol-to-exchange "program".
*)

FROM SYSTEM       IMPORT ADDRESS,        ADR;

FROM Strings      IMPORT CompareString,  Relation,   CopyString ;

FROM Heap         IMPORT ALLOCATE ;

FROM InOut        IMPORT WriteString,    WriteInt;

FROM errors       IMPORT FatalError,     ErrorType,     internal;

FROM scan         IMPORT STRING ;


CONST
        DEBUG     = FALSE;
        TableSize = 277;     


TYPE


        HashRecPtr   = POINTER TO HashRecType;

        HashRecType  = RECORD
	 	symbol         : STRING;
		ProcessCode    : ProcessType;
		ExchangeString : STRING;   (* only used if ProcessCode
					      is "exchange"  *)
	        next           : HashRecPtr;
	       END;


VAR     
        table        : ARRAY [ 0 .. TableSize -1 ] OF  HashRecPtr;
        i            : INTEGER;




PROCEDURE HashFunction ( KeyString  : STRING   ) : INTEGER;
 VAR i : INTEGER;  ch : CHAR;  sum : CARDINAL;
BEGIN
  sum  := 1;
  i    := 0;

  REPEAT
        ch  := KeyString [ i ];
        sum := sum +  ORD ( ch ) ;

        INC ( i );
  UNTIL ( ( i = 5 ) OR ( ch = 0C ) );

  RETURN sum MOD (TableSize -1);
END HashFunction;


(* This procedure will add your hash record to the table, currently
   this is not alphabetized                                          *)
PROCEDURE InsertRecordInTable ( index : INTEGER; VAR   ptr : HashRecPtr );
BEGIN
        ptr ^.next := table [ index ]; (* ptr to prev. first record in list *)

        table [ index ] := ptr;        (* new first ptr in list *)
END InsertRecordInTable;


                                                        
(* This procedure will set up the hash table one symbol at a time. This
   is run before the execution of the main line.
*)
PROCEDURE SetHash  (     KeyString : STRING;      ProcessCode : ProcessType; 
                     ReplaceString : STRING                              );
 VAR     index : INTEGER;                 ptr  : HashRecPtr;
BEGIN
    index := HashFunction ( KeyString ) ;

    ALLOCATE ( ptr , SIZE ( HashRecType ) );


    IF ptr <> NIL THEN
            CopyString ( ptr^. symbol , KeyString );
            ptr^. next        := NIL;
            IF ProcessCode = exchange THEN
                CopyString ( ptr^ . ExchangeString, ReplaceString );
                ptr^ . ProcessCode    := exchange;
            ELSIF ProcessCode = special THEN
                ptr^ . ExchangeString := 0C;   (*  don't use this  *)
                ptr^ . ProcessCode    := special;               
            ELSIF ProcessCode = NoSupport THEN
                ptr^ . ExchangeString := 0C;   (*  don't use this  *)
                ptr^ . ProcessCode    := NoSupport;
            ELSE
                internal ( "Unknown ProcessCode in IdLookup" );
            END;
           
            InsertRecordInTable ( index, ptr );
    ELSE
            FatalError ( OutOfMemory );
    END;
END SetHash;



(* This function will search the hash table for the requested symbol
   and send back the appropriate record if found. If the symbol is not
   found in the table it will return a FALSE       *)

PROCEDURE SearchHash ( VAR IdInfo     : IdInfoType  ;  
                       SearchSymbol   : STRING )    : BOOLEAN;
 VAR index : INTEGER;   TempPtr : HashRecPtr;    WordFound : BOOLEAN;
BEGIN
        index                 := HashFunction ( SearchSymbol );
        TempPtr               := table [ index ];
        WordFound             := FALSE;
        
        WHILE ( TempPtr <> NIL) AND ( NOT WordFound ) DO
                IF  CompareString ( TempPtr^.symbol , SearchSymbol ) = equal
                THEN WordFound := TRUE;
                ELSE TempPtr := TempPtr^.next;
                END;
        END;

        IF WordFound THEN        
             IdInfo.ProcessCode    := TempPtr^.ProcessCode;
             CopyString (IdInfo.ExchangeString, TempPtr^.ExchangeString ) ;
        ELSE
             IdInfo.ProcessCode    := NotFound;
        END;

        RETURN WordFound;                
END SearchHash;



PROCEDURE DebugPrintTable ;
 VAR i : INTEGER;    ptr : HashRecPtr;
BEGIN
     FOR i := 0 TO TableSize -1 DO
        IF table [ i ] <>  NIL THEN
           ptr := table [ i ];
           WriteInt ( i, 4 ); WriteString(" ");
           WHILE ptr <> NIL DO
                WriteString(ptr^.symbol); WriteString(" ");
                IF ptr^.ProcessCode = exchange THEN
                        WriteString("exchange | ");
                        WriteString(ptr^.ExchangeString);
                ELSIF ptr^.ProcessCode = special THEN
                        WriteString("special");
                ELSIF ptr^.ProcessCode = NoSupport THEN
                        WriteString("NoSupport");
                ELSE
                        WriteString("NotFound");
                END;
                WriteString(" , ");
                ptr := ptr^.next;
           END;
           WriteString("\n");
        END;
     END;
END DebugPrintTable;


BEGIN (* main *)

   FOR i := 0 TO TableSize -1 DO
        table [ i ] := NIL;
   END;

   SetHash ( "MODULE" ,    special,   ""  );
   (*         ^^^^^^^
              key          ^^^^^
                           ProcessCode  
                                    ^^^^^^
                                    Replacement Symbol 
                                    if  of type "exchange"    *)
   



   SetHash (  "ABS" ,        exchange,     "abs"  );
   SetHash (  "AND" ,        exchange,     "and"  );
   SetHash (  "ARRAY" ,      exchange,     "array"  );
   SetHash (  "BEGIN" ,      exchange,     "begin"  );
   SetHash (  "BOOLEAN" ,    exchange,     "boolean"  );
   SetHash (  "CARDINAL" ,   exchange,     "integer"  );
   SetHash (  "CHAR" ,       exchange,     "char"  );
   SetHash (  "CONST" ,      exchange,     "const"  );
   SetHash (  "DIV" ,        exchange,     "div"  );
   SetHash (  "ELSIF" ,      exchange,     "else if"  );
   SetHash (  "FALSE" ,      exchange,     "false"  );
   SetHash (  "FOR" ,        exchange,     "for"  );
   SetHash (  "HALT" ,       exchange,     "halt"  );
   SetHash (  "IF" ,         exchange,     "if"  );
   SetHash (  "IN" ,         exchange,     "in"  );
   SetHash (  "INTEGER" ,    exchange,     "integer"  );
   SetHash (  "NIL" ,        exchange,     "nil"  );
   SetHash (  "NOT" ,        exchange,     "not"  );
   SetHash (  "ODD" ,        exchange,     "odd"  );
   SetHash (  "OF" ,         exchange,     "of"  );
   SetHash (  "OR" ,         exchange,     "or"  );
   SetHash (  "ORD" ,        exchange,     "ord"  );
   SetHash (  "Read" ,       exchange,     "read"  );
   SetHash (  "ReadString" , exchange,     "read"  );
   SetHash (  "ReadInt" ,    exchange,     "read"  );
   SetHash (  "ReadCard",    exchange,     "read"  );
   SetHash (  "ReadWrd" ,    exchange,     "read"  );
   SetHash (  "REAL" ,       exchange,     "real"  );
   SetHash (  "RECORD" ,     exchange,     "record"  );
   SetHash (  "REPEAT" ,     exchange,     "repeat"  );
   SetHash (  "TO" ,         exchange,     "to"  );
   SetHash (  "TRUE" ,       exchange,     "true"  );
   SetHash (  "TYPE" ,       exchange,     "type"  );
   SetHash (  "UNTIL" ,      exchange,     "until"  );
   SetHash (  "VAR" ,        exchange,     "var"  );
   SetHash (  "WHILE" ,      exchange,     "while"  );
   SetHash (  "WITH" ,       exchange,     "with"  );
   SetHash (  "WriteLn",     exchange,     "writeln"  );
   SetHash (  "#" ,          exchange,     "<>"  );
   SetHash (  "&" ,          exchange,     "AND"  );
   SetHash (  "{" ,          exchange,     "["  );
   SetHash (  "}" ,          exchange,     "]"  );
   SetHash (  "|" ,          exchange,     "end;"  );   (* CASE *)



   SetHash (  "ALLOCATE",    special,     ""  );
   SetHash (  "CASE"  ,      special,     ""  );
   SetHash (  "DEALLOCATE",  special,     ""  );
   SetHash (  "DEC"  ,       special,     ""  );
   SetHash (  "DO"  ,        special,     ""  );
   SetHash (  "ELSE"  ,      special,     ""  );
   SetHash (  "END"  ,       special,     ""  );
   SetHash (  "FROM" ,       special,     ""  );
   SetHash (  "INC"  ,       special,     ""  );
   SetHash (  "POINTER" ,    special,     ""  );
   SetHash (  "PROCEDURE" ,  special,     ""  );
   SetHash (  "RETURN" ,     special,     ""  );
   SetHash (  "THEN" ,       special,     ""  );
   SetHash (  "WriteString", special,     ""  );
   SetHash (  "WriteInt",    special,     ""  );
   SetHash (  "WriteOct",    special,     ""  );
   SetHash (  "WriteCard",   special,     ""  );
   SetHash (  "WriteHex",    special,     ""  );
   SetHash (  "WriteWrd",    special,     ""  );


   SetHash (  "DEFINITION"     ,       NoSupport,     ""  );
   SetHash (  "IMPLEMENTATION" ,       NoSupport,     ""  );  
   SetHash (  "LOOP"           ,       NoSupport,     ""  );


   IF DEBUG THEN DebugPrintTable   END;

END IdLookup.
