IMPLEMENTATION MODULE OutModule;
 (*
   This module is used primarily for the output ( object ) file. It consists
   of mostly internal text maintenance operations like word wrapping if
   the data is too long for the output line and indenting the line from
   the left side to match the original.
   
   This module also handles some string related procedures like comparing.

   BUGS: Tabs are not handled correctly.
 *)

FROM scan    IMPORT IndentArray,          STRING,              write,       
                    EOLN,                 ReadAheadSymbol,
                    ReadSymbol,           SymbolType,          SPACE,
                    TAB,                  rewind,              Q2;
FROM Strings IMPORT StringLength,         ConcatString,        CompareString,
                    Relation;
FROM errors  IMPORT CleanUp;

FROM InOut   IMPORT WriteString,  WriteCard;

FROM options IMPORT OptionsRec;

 (* All global data below is for a SINGLE output file.
 *)
CONST
        COLMAX   =   80;

VAR
        ColWrite      :    CARDINAL;  (*  col we're about to write to  *)
        InFileSymbol  :    STRING;
        SymbolClass   :    SymbolType;
        r_par         :    INTEGER;   (* paranth. matching *)


(* Determine if symbol is too long for current line and should be placed
   on next line.
*)
PROCEDURE WordWrap ( length : CARDINAL ) : BOOLEAN;
BEGIN
  RETURN  ( ( COLMAX - ColWrite + 1 ) < length );
END WordWrap;




 (* dump the data which produces the original margin.
 *)
PROCEDURE  WriteIndent ( indent : IndentArray );
 VAR i : CARDINAL;  ch : CHAR;   good : BOOLEAN;
BEGIN
   i    :=  1;
   ch   :=  indent [ i ];     (* Tab or Space character *)
   INC  ( i );
   good :=  TRUE;

   WHILE  (  ( ch <> 0C  ) AND good ) DO
         write ( ch );
         INC ( ColWrite , 1 );

         ch   := indent [ i ];
         INC ( i        , 1 );
   END;
END WriteIndent;


 (* A tab will merely increment ColWrite by 1. This in undesirable in
    some circumstances.
  *)
PROCEDURE output ( indent     : IndentArray  ;   
                   word       : STRING );
 VAR   i : INTEGER;    ch  : CHAR;      good : BOOLEAN;
BEGIN
        i    := 0;
        ch   := word [ i ];
        good := TRUE;


        IF ( (WordWrap ( StringLength ( word ) )) AND ( ch <> EOLN ) ) THEN
            write ( EOLN );
            ColWrite := 1;
            WriteIndent ( indent );
        END;

        WHILE  ( (  ch <> 0C  ) AND good ) DO
                write ( ch );

                INC ( i        , 1 );
                        
                  (* reset ColWrite if a line feed exists *)
                IF ( ch <> EOLN ) THEN
                        INC ( ColWrite , 1 );
                ELSE
                        ColWrite := 1;
                END;

                ch := word [ i ];
        END;

        IF NOT good THEN CleanUp (); END;        (* HALT *)

END output;


 (* Put the string "begin" in the output file either on the same line
    we've been using or on the next line according to the default 
    parameters. A space is inserted before "begin".
 *)
PROCEDURE PutBEGIN ( indent  : IndentArray );
 VAR good : BOOLEAN;  len  : CARDINAL;
BEGIN
 len := 6;   (* " begin"   note spc at begining   *)

  (* same line if possible *)
 IF ( ( OptionsRec.BeginNewLine = FALSE ) AND ( NOT WordWrap ( len )  ) ) THEN
	output ( indent, " begin" );
  (* next line *)
 ELSE
        write ( EOLN );
	ColWrite :=  1;  WriteIndent ( indent );
        output ( indent , "begin" ); 
 END;

END PutBEGIN;




(*****************String related support below********************************)


 (* If there blanks in the InFile that are about to be read then
    tack them onto the end of the string.
   BUG: This procedure is the reason why INC(i) doesn't work but INC ( i ) does

 *)
PROCEDURE AddBlanks ( VAR symbol   : STRING      );
BEGIN
    ReadAheadSymbol ( InFileSymbol, SymbolClass );
(*
    rewind          ( InFile ) ; (* Next read-ahead returns the abve line *)
*)
    IF ( SymbolClass = blanks ) THEN
        ReadSymbol ( InFileSymbol, SymbolClass );
        ConcatString ( symbol, InFileSymbol );
    END;
END AddBlanks;




  (* compare two strings. This probably doesn't belong in here...
  *)
PROCEDURE identical ( s1 , s2 : STRING ) : BOOLEAN;
BEGIN
 RETURN CompareString ( s1, s2 ) = equal;
END identical;


 (* Increase or decrease global variable "r_par" depending if s = ) or (
 *)
PROCEDURE SetParCount ( s : STRING );
BEGIN
     IF identical ( s , ")" ) THEN
          INC ( r_par );
     ELSIF identical ( s , "(" ) THEN
          DEC ( r_par );
     END;
END SetParCount;


PROCEDURE LastPar () : BOOLEAN;
BEGIN
     IF r_par = 1 THEN
          RETURN TRUE;
     ELSE
          RETURN FALSE;
     END;
END LastPar;

 (* Read first options of a one or two option command like so:
              INC ( i , 1 )   OR  INC ( i )
                   ^^^                 ^^^      -> returned value
                       |                  |     -> ptr to next char.

                  The comma is read and thrown out in the first case.
 *)

PROCEDURE FirstOption ( VAR  RetSymbol : STRING );
BEGIN
     RetSymbol := "\0";
     
      (* blanks between parenthesis and first option *)
     AddBlanks ( RetSymbol );

      (* Read first option ( until comma or right parenthesis )   *)
     ReadAheadSymbol ( InFileSymbol, SymbolClass );

     WHILE ( NOT identical ( InFileSymbol , "," ) AND
           ( NOT identical ( InFileSymbol , ")" )   ))  DO
          ConcatString    ( RetSymbol, InFileSymbol );          
          ReadSymbol      ( InFileSymbol, SymbolClass );
          ReadAheadSymbol ( InFileSymbol, SymbolClass );
     END;

     IF ( identical ( InFileSymbol , "," )  ) THEN
          ReadSymbol      ( InFileSymbol, SymbolClass );
     END;
     
     (*
    WriteString("FirstOption. |"); WriteString( RetSymbol ); WriteString("|\n");
     *)
END FirstOption; 



 (* Use to get retrieve a second option of a two option command. 
    This is used after a call to FirstOption(). 
    Here is a picture :
             INC ( i , 1 ) ;   OR   INC ( i ) ;
                      |                     |     -> start on entry
                          |                  |    -> finish on exit
 *)
PROCEDURE SecondOption ( VAR RetSymbol : STRING);
 VAR s : STRING;  
BEGIN
     RetSymbol := "\0";
     r_par     := 0   ;  (* number of right ")" paranthesis *)

     ReadSymbol (  s, SymbolClass );
     SetParCount ( s );
     WHILE  NOT LastPar()  DO
                ConcatString    ( RetSymbol, s );
                ReadSymbol      ( s, SymbolClass );
                SetParCount     ( s );
     END;
     
     (*
   WriteString("SecondOption. |"); WriteString( RetSymbol ); WriteString("|\n");
     *)
END SecondOption;



BEGIN
    ColWrite   := 1;
END OutModule.

