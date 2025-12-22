(*(***********************************************************************

:Program.    CNEIdentParser.mod
:Contents.   prints out all level 0 idents which are not exported
:Author.     hartmtut Goebel [hG]
:Address.    Aufseßplatz 5, D-90459 Nürnberg
:Address.    UseNet: hartmut@oberon.nbg.sub.org
:Address.    Z-Netz: hartmut@asn.zer   Fido: 2:246/81.1
:Copyright.  Copyright © 1993 by hartmtut Goebel
:Language.   Oberon-2
:Translator. Amiga Oberon 3.0
:Support.    based on a parser from Fridtjof Siebert
:Version.    $VER: CNEIdentParser.mod 1.4 (22.12.93) Copyright © 1993 by hartmtut Goebel

(* $StackChk- $NilChk- $RangeChk- $CaseChk- $OvflChk- $ReturnChk- $ClearVars- *)
(****i* CNEIdentParser/--history-- *****************************
*
*********************************************************************)*)*)

MODULE CNEIdentParser;

IMPORT
  avl := AVLTrees;

CONST
  versionString = "$VER: CNEIdentParser 1.4 (22.12.93) Copyright © 1993 by hartmtut Goebel";

TYPE
  PROC = PROCEDURE;
  ErrProc = PROCEDURE();

  String * = ARRAY 80 OF CHAR;
  StringPtr * = UNTRACED POINTER TO String;
  LongStr * = ARRAY 512 OF CHAR;

VAR
  Identifier *: String;
  Char* : CHAR;                      (* letztes Zeichen von ReadChar()        *)

(*--- start hG changes --*)

  AppendPreIdent *: PROC;
  ShortenPreIdent *: PROC;
  WriteNotExportedIdent *: PROC;

  moduleName *, PreIdent *: avl.String;
  procLevel *: INTEGER;

(*--- end hG changes --*)

(* Alle Oberon Symbole: *)

CONST

  plus           * =  0; minus    * =  1; times      * =  2; divide      * =  3;
  not            * =  4; and      * =  5; point      * =  6; comma       * =  7;
  semicolon      * =  8; slash    * =  9; lparen     * = 10; langle      * = 11;
  lbrace         * = 12; becomes  * = 13; power      * = 14; relation    * = 15;
  equal          * = 16; range    * = 21; colon      * = 22;
  rparen         * = 23;
  rangle         * = 24; rbrace   * = 25; array      * = 26; begin       * = 27;
  case           * = 28; close    * = 29; const      * = 30;
  div            * = 32; do       * = 33; else       * = 34; elsif       * = 35;
  end            * = 36; exit     * = 37; if         * = 38; module      * = 39;
  import         * = 40; in       * = 41; is         * = 42; loop        * = 43;
  mod            * = 44; of       * = 45; or         * = 46; pointer     * = 47;
  procedure      * = 48; record   * = 49; repeat     * = 50; return      * = 51;
  then           * = 52; to       * = 53; type       * = 54; var         * = 55;
  until          * = 56; with     * = 57; while      * = 58; identifier  * = 59;
  string         * = 60; cnumber  * = 61; cchar      * = 62; struct      * = 65;
  bpointer       * = 66; for      * = 67; by         * = 68; untraced    * = 69;
  eof            * = 80; none     * = 81; intstring  * = 82;
  intpoint       * = 83; intnum   * = 84; intcomp    * = 85;
  intid          * = 86; intparen * = 87; intcolon   * = 88;

(* none, intstring, intpoint, intnum, intcomp, intid, intparen und intcolon werden
   nur intern in diesem Modul verwendet! *)

(* Allgemeiner Stringtyp: *)


CONST
  OpSize = 61;

TYPE
  OpPtr = UNTRACED POINTER TO Opera;
  Opera = STRUCT
            name: ARRAY 10 OF CHAR;  (* Schlüsselwort *)
            sym: INTEGER;     (* sein Symbol   *)
            next: OpPtr;      (* nächstes mit gleichem Key *)
          END;


VAR
  Sym: INTEGER;                      (* letzes Symbol                         *)

  Operator: ARRAY OpSize OF OpPtr;   (* Hash-Tabelle der Schlüsselworte       *)
  Syms: ARRAY 128 OF INTEGER;        (* Symbole, am 1. Zeichen erkannt        *)

  StdId: ARRAY OpSize OF OpPtr;      (* Hash-Tabelle der Standardbezeichner   *)

  i: INTEGER;      (* zum leeren der Hashtabelle beim Initialisieren *)
  c: CHAR;

  ReadChar: PROC;
  Error: ErrProc;

(*-------------------------------------------------------------------------*)


PROCEDURE GetKey*(VAR str: ARRAY OF CHAR): INTEGER;

VAR i,j,key: INTEGER;

BEGIN
  i := 0; key := 0;
  WHILE str[i]#0X DO
    (* $OvflChk- *)
      key := key * 256;
      INC(key,ORD(str[i]));
    (* $OvflChk= *)
    INC(i);
  END;
  IF key<0 THEN IF key=MIN(INTEGER) THEN key := MAX(INTEGER) ELSE key := -key END END;
  RETURN key;
END GetKey;


PROCEDURE GetOp*(VAR s: String): OpPtr;
VAR
  op: OpPtr;
BEGIN
  op := Operator[GetKey(s) MOD OpSize];
  WHILE (op#NIL) AND (s#op.name) DO
    op := op.next;
  END;
  RETURN op;
END GetOp;

PROCEDURE GetStdId*(VAR s: String): OpPtr;
VAR
  op: OpPtr;
BEGIN
  op := StdId[GetKey(s) MOD OpSize];
  WHILE (op#NIL) AND (s#op.name) DO
    op := op.next;
  END;
  RETURN op;
END GetStdId;


(*-------------------------------------------------------------------------*)


PROCEDURE GetSym*;
(* Liest das nächste Symbol in die Variable Sym. *)
VAR
  c: CHAR;
  done: BOOLEAN;

 (*------  Number:  ------*)

  PROCEDURE GetNumber;
  (* wertet konstante Zahl aus. Bei Realzahlen wird der Bereich nicht geprüft! *)

  VAR hex: BOOLEAN;

  BEGIN
    Sym := cnumber; hex := FALSE;
    LOOP
      CASE Char OF
      "0".."9": |
      "A".."F": hex := TRUE |
      ELSE EXIT END;
      ReadChar;
    END;
    CASE Char OF
    "H","U": ReadChar; RETURN |
    "X"    : ReadChar; Sym := cchar; RETURN |
    ELSE END;
    IF hex THEN Error() END;
    CASE Char OF
    ".":
      ReadChar; IF Char="." THEN Char := CHR(127); RETURN END;
      WHILE (Char>="0") AND (Char<="9") DO ReadChar END;
      CASE Char OF
      "D","E":
        ReadChar;
        CASE Char OF "+","-": ReadChar ELSE END;
        WHILE (Char>="0") AND (Char<="9") DO ReadChar END;
      ELSE END;
    ELSE END;
  END GetNumber;

  (*------  Identifier:  ------*)

  PROCEDURE GetIdentifier;
  (* liest Bezeichner ein *)

  VAR
    cnt: INTEGER;   (* Anzahl Zeichen                *)
    cap: BOOLEAN;   (* nur Großbuchstaben?           *)
    cc: CHAR;
    op: OpPtr;

  BEGIN
    (* Identifier einlesen: *)
    cnt := 0; cap := TRUE;  cc := CAP(Char);
    REPEAT
      cap := cap AND (cc=Char);
      Identifier[cnt] := Char; ReadChar; cc := CAP(Char);
      IF cnt<79 THEN INC(cnt) END;
    UNTIL ((Char<"0") OR (Char>"9")) AND ((cc<"A") OR (cc>"Z"));
    Identifier[cnt] := 0X;

    (* Probe auf reserviertes Wort: *)
    IF cap THEN
      op := GetOp(Identifier);
      IF op#NIL THEN Sym := op.sym; RETURN END;
    END;

    (* kein Standardbezeichner: *)
    Sym := identifier;
  END GetIdentifier;

  (*------  Bemerkung:  ------*)

  PROCEDURE Remark;

  BEGIN
    ReadChar;
    REPEAT
      WHILE (Char#"*") AND (Char#0X) DO
        IF Char="(" THEN ReadChar;
          IF Char="*" THEN Remark() END
        ELSE ReadChar END;
      END;
      ReadChar;
    UNTIL (Char=")") OR (Char=0X);
    IF Char=0X THEN Error() ELSE ReadChar END;
  END Remark;

  PROCEDURE NoSpecialChar;
  BEGIN
    WHILE (Char<=" ") OR (Char>7FX) DO
      IF Char=0X THEN RETURN END;
      ReadChar;
    END;
  END NoSpecialChar;

BEGIN
  REPEAT
    NoSpecialChar;
    Sym := Syms[ORD(Char)]; IF Sym<none THEN ReadChar; RETURN END;
    CASE Sym OF
    intid:  GetIdentifier |
    intnum: GetNumber |
    intparen: ReadChar; IF Char="*" THEN Remark; Sym:=none      ELSE Sym:=lparen END |
    intpoint: ReadChar; IF Char="." THEN Sym:=range; ReadChar   ELSE Sym:=point  END |
    intcolon: ReadChar; IF Char="=" THEN Sym:=becomes; ReadChar ELSE Sym:=colon  END |
    intcomp:
      Sym := relation; ReadChar; IF Char="=" THEN ReadChar END |
    intstring:
      c := Char;
      done := FALSE;
      REPEAT     (* String einlesen *)
        IF Char="\\" THEN ReadChar END;
        ReadChar;
        IF Char=c THEN
          ReadChar;
          NoSpecialChar;
          IF Char=c THEN ReadChar ELSE done := TRUE END;
        END;
      UNTIL done OR (Char=0AX);
      CASE Char OF 0X,0AX: Error() ELSE END;
      Sym := string |
    none: Error(); ReadChar |
    END;
  UNTIL Sym#none;
END GetSym;


(*-------------------------------------------------------------------------*)


PROCEDURE Parse* (rc: PROC; err: ErrProc);
(*#   module  =  MODULE ident ";"  [ImportList] DeclarationSequence
  #      [BEGIN StatementSequence] [CLOSE StatementSequence] END ident "." .
  #  ImportList  =  IMPORT import {"," import} ";" .
  #  import  =  identdef [":" ident]. *)

  PROCEDURE Check(sym: INTEGER);
  BEGIN IF Sym#sym THEN Error() END; GetSym END Check;

  PROCEDURE CheckIdent;  BEGIN Check(identifier) END CheckIdent;
  PROCEDURE CheckSemi;   BEGIN Check(semicolon ) END CheckSemi;
  PROCEDURE CheckColon;  BEGIN Check(colon     ) END CheckColon;
  PROCEDURE CheckEnd;    BEGIN Check(end       ) END CheckEnd;
  PROCEDURE CheckOf;     BEGIN Check(of        ) END CheckOf;
  PROCEDURE CheckDo;     BEGIN Check(do        ) END CheckDo;
  PROCEDURE CheckEqual;  BEGIN Check(equal     ) END CheckEqual;
  PROCEDURE Checkrparen; BEGIN Check(rparen    ) END Checkrparen;
  PROCEDURE Checkrbrace; BEGIN Check(rbrace    ) END Checkrbrace;
  PROCEDURE Checkrangle; BEGIN Check(rangle    ) END Checkrangle;
  PROCEDURE CheckThen;   BEGIN Check(then      ) END CheckThen;
  PROCEDURE CheckTo;     BEGIN Check(to        ) END CheckTo;
  PROCEDURE Times;       BEGIN IF Sym=times THEN GetSym END END Times;
  PROCEDURE IdentDef;
  (*#  identdef = ident ["*"|"-"].*)
  BEGIN
    CheckIdent;
    CASE Sym OF times,minus: GetSym
    ELSE WriteNotExportedIdent; END;
  END IdentDef;
  PROCEDURE Qualident;
  (*#  qualident = [ident "."] ident.*)
  BEGIN CheckIdent; IF Sym=point THEN GetSym; CheckIdent END END Qualident;

  PROCEDURE Semicolon(): BOOLEAN; BEGIN IF Sym=semicolon THEN GetSym; RETURN TRUE ELSE RETURN FALSE END END Semicolon;
  PROCEDURE Comma():     BOOLEAN; BEGIN IF Sym=comma     THEN GetSym; RETURN TRUE ELSE RETURN FALSE END END Comma;

  PROCEDURE ^ Expression;

  PROCEDURE ExpList;
  (*#  ExpList  =  expression {"," expression}. *)
  BEGIN REPEAT Expression UNTIL NOT Comma() END ExpList;

  PROCEDURE Elements;
  (*# Elements = element {"," element}.
    # element = expression [".." expression]. *)
  BEGIN
    REPEAT
      Expression; IF Sym=range THEN GetSym; Expression END;
    UNTIL NOT Comma();
  END Elements;

  PROCEDURE Set;
  (*#  set  =  "{" [element {"," element}] "}".
    #  element  =  expression [".." expression]. *)
  BEGIN
    GetSym; (* { *)
    IF Sym#rbrace THEN Elements END;
    Checkrbrace;
  END Set;

  PROCEDURE Designator;
  (*#  designator  =  qualident ( {"." ident | "[" ExpList "]" | "(" qualident ")" |
                              "^" } | set ). !!! geändert für LONGSET{} etc. *)
  BEGIN
    Qualident;
    LOOP
      CASE Sym OF
      point:  GetSym; CheckIdent |
      langle: GetSym; ExpList; Checkrangle |
      lparen: GetSym; IF Sym#rparen THEN ExpList END; Checkrparen |
      power:  GetSym |
      lbrace: Set |
      ELSE EXIT END;
    END;
  END Designator;

  PROCEDURE Expression;
  (*#  expression  =  SimpleExpression [relation SimpleExpression].
    #  relation  =  "=" | "#" | "<" | "<=" | ">" | ">=" | IN | IS. *)

    PROCEDURE SimpleExpression;
    (*#  SimpleExpression  =  ["+"|"-"] term {AddOperator term}.
      #  AddOperator  =  "+" | "-" | OR . *)

      PROCEDURE Term;
      (*#  term  =  factor {MulOperator factor}.
        #  MulOperator  =  "*" | "/" | DIV | MOD | "&" . *)

        PROCEDURE Factor;
        (*#  factor  =  number | CharConstant | string | NIL | set |
          #    designator [ActualParameters] | "(" expression ")" | "~" factor. *)
        BEGIN
          CASE Sym OF
          cnumber,cchar,string: GetSym |
          identifier:           Designator |
          lparen:               GetSym; Expression; Checkrparen |
          not:                  GetSym; Factor |
          lbrace:               Set |
          ELSE Error() END;
        END Factor;

      BEGIN
        LOOP
          Factor;
          CASE Sym OF times,divide,div,mod,and: GetSym | ELSE EXIT END;
        END;
      END Term;

    BEGIN
      CASE Sym OF plus,minus: GetSym | ELSE END;
      LOOP
        Term;
        CASE Sym OF plus,minus,or: GetSym | ELSE EXIT END;
      END;
    END SimpleExpression;

  BEGIN
    SimpleExpression;
    CASE Sym OF equal,relation,in,is: GetSym; SimpleExpression ELSE END;
  END Expression;

  PROCEDURE ^ StatementSequence;

  PROCEDURE StatSeqEnd; BEGIN StatementSequence; CheckEnd END StatSeqEnd;

  PROCEDURE ^ FormalParameters;

  PROCEDURE Type;
  (*#  type  =  qualident | ArrayType | RecordType | PointerType | ProcedureType.
    #  ArrayType  =  ARRAY [length {"," length}] OF type.
    #  length  =  ConstExpression.
    #  RecordType  =  RECORD ["(" BaseType ")"] FieldListSequence END.
    #  BaseType  =  qualident.
    #  FieldListSequence  =  FieldList {";" FieldList}.
    #  FieldList  =  [IdentList ":" type].
    #  PointerType  =  (BPOINTER | [UNTRACED] POINTER) TO type.
    #  ProcedureType = PROCEDURE [FormalParameters]. *)
  BEGIN
    CASE Sym OF
    identifier: Qualident |
    array:      GetSym;
                IF Sym#of THEN
                  Expression;
                  WHILE Sym=comma DO
                    GetSym;
                    Expression
                  END;
                END;
                CheckOf;
                Type |
    record,struct:
                IF Sym=record THEN
                  GetSym;
                  IF Sym=lparen THEN GetSym; Qualident; Checkrparen END;
                ELSE
                  GetSym;
                  IF Sym=lparen THEN
                    GetSym;
                    IdentDef;
                    CheckColon;
                    Qualident;
                    Checkrparen
                  END;
                END;
                REPEAT
                  IF Sym=identifier THEN
                    REPEAT IdentDef; UNTIL NOT Comma();
                    CheckColon; Type
                  END;
                UNTIL NOT Semicolon();
                CheckEnd |
    untraced,pointer,bpointer:
                IF Sym=untraced THEN
                  GetSym; Check(pointer);
                ELSE
                  GetSym
                END;
                CheckTo; Type |
    procedure:  GetSym; FormalParameters;
    ELSE Error() END;
  END Type;

  PROCEDURE FormalParameters;
  (*#  FormalParameters  =  "(" [FPSection {";" FPSection}] ")" [":" qualident].
    #  FPSection  =  [VAR] ident ["{" Expression "}" [".."]] {"," ident} ":" Type. *)
  BEGIN
    IF Sym=lparen THEN
      GetSym;
      IF Sym#rparen THEN
        IF Sym#lparen THEN
          REPEAT
            IF Sym=var THEN GetSym END;
            REPEAT
              CheckIdent;
              IF Sym=lbrace THEN
                GetSym;
                Expression;
                Checkrbrace;
                IF Sym=range THEN GetSym END;
              END;
            UNTIL NOT Comma();
            CheckColon; Type;
          UNTIL NOT Semicolon();
        END;
      END;
      Checkrparen;
      IF Sym=colon THEN GetSym; Qualident END;
    END;
  END FormalParameters;

  PROCEDURE StatementSequence;
  (*#  StatementSequence  =  statement {";" statement}. *)

    PROCEDURE Statement;
    (*#  statement  =  [assignment | ProcedureCall |
      #    IfStatement | CaseStatement | WhileStatement | RepeatStatement |
      #    LoopStatement | WithStatement | ForStatement | EXIT | RETURN [expression] ].
      #  assignment  =  designator ":=" expression.
      #  ProcedureCall  =  designator [ActualParameters].
      #  IfStatement  =  IF expression THEN StatementSequence
      #    {ELSIF expression THEN StatementSequence}
      #    [ELSE StatementSequence]
      #    END.
      #  CaseStatement  =  CASE expression OF case {"|" case} [ELSE StatementSequence] END.
      #  case  =  [CaseLabelList ":" StatementSequence].
      #  CaseLabelList  =  CaseLabels {"," CaseLabels}.
      #  CaseLabels  =  ConstExpression [".." ConstExpression].
      #  WhileStatement  =  WHILE expression DO StatementSequence END.
      #  RepeatStatement  =   REPEAT StatementSequence UNTIL expression.
      #  LoopStatement  =  LOOP StatementSequence END.
      #  WithStatement  =  WITH qualident ":" qualident DO StatementSequence END .
      #  ForStatement = FOR ident ":=" Expression TO Expression [BY ConstExpression]
      #                 DO StatementSequence END. *)

      PROCEDURE ElseEnd;
      BEGIN
        IF Sym=else THEN GetSym; StatementSequence END;
        CheckEnd;
      END ElseEnd;

    BEGIN
      CASE Sym OF
      identifier: Designator; IF Sym=becomes THEN GetSym; Expression END |
      if:         REPEAT
                    GetSym; Expression; CheckThen; StatementSequence;
                  UNTIL Sym#elsif;
                  ElseEnd |
      case:       GetSym; Expression; CheckOf;
                  LOOP
                    WHILE Sym=slash DO GetSym END;
                    CASE Sym OF else,end: EXIT ELSE END;
                    Elements; CheckColon; StatementSequence;
                    IF Sym#slash THEN EXIT END;
                  END;
                  ElseEnd |
      while:      GetSym; Expression; CheckDo; StatSeqEnd |
      repeat:     GetSym; StatementSequence; Check(until); Expression |
      loop:       GetSym; StatSeqEnd |
      with:       REPEAT
                    GetSym; Qualident; CheckColon; Qualident; CheckDo; StatementSequence;
                  UNTIL Sym#slash;
                  ElseEnd |
      for:        GetSym; CheckIdent; Check(becomes); Expression;
                  CheckTo; Expression;
                  IF Sym=by THEN GetSym; Expression END;
                  CheckDo; StatSeqEnd |
      exit:       GetSym |
      return:     GetSym;
                  CASE Sym OF semicolon,end,else,elsif,slash,until: |
                  ELSE Expression END |
      ELSE END;
    END Statement;

  BEGIN
    REPEAT
      Statement;
    UNTIL NOT Semicolon();
  END StatementSequence;

  PROCEDURE DeclarationSequence;
  (*#  DeclarationSequence  =  {CONST {ConstantDeclaration ";"} |
    #      TYPE {TypeDeclaration ";"} | VAR {VariableDeclaration ";"}}
    #      {ProcedureDeclaration ";" | ForwardDeclaration ";" |
    #       ExternProcDeclaration ";"}.
    #  ConstantDeclaration  =  identdef "=" ConstExpression.
    #  ConstExpression  =  expression.
    #  TypeDeclaration  =  identdef "=" type.
    #  VariableDeclaration  =  IdentList ":" type.
    #  ProcedureDeclaration  =  ProcedureHeading ";" ProcedureBody ident.
    #  ProcedureHeading  =  PROCEDURE ["*"] [Receiver] identdef [FormalParameters].
    #  ProcedureBody  =  DeclarationSequence [BEGIN StatementSequence] END.
    #  ForwardDeclaration  =  PROCEDURE "^" [Receiver] identdef [FormalParameters].
    #  Receiver = "(" [VAR] ident ":" ident ")".
    #  ExternProcDeclaration = PROCEDURE identdef "[" expression ["," expression] "]" . *)

  VAR forward: BOOLEAN;

  BEGIN
    LOOP
      CASE Sym OF
      | const: GetSym; WHILE Sym=identifier DO IdentDef; CheckEqual; Expression; CheckSemi END;
      | type:  GetSym; WHILE Sym=identifier DO IdentDef; AppendPreIdent; CheckEqual; Type; CheckSemi; ShortenPreIdent; END;
      | var:
          GetSym;
          WHILE Sym=identifier DO
            REPEAT
              IdentDef;
              IF Sym=langle THEN GetSym; Expression; Checkrangle END;
            UNTIL NOT Comma();
            CheckColon; Type; CheckSemi;
          END;
      | procedure:
          GetSym; forward := FALSE;
          IF Sym=power THEN GetSym; forward := TRUE ELSE IF Sym=times THEN GetSym END END;
          IF Sym=lparen THEN
            GetSym;
            IF Sym=var THEN GetSym END;
            CheckIdent;
            CheckColon;
            CheckIdent;
            Checkrparen;
          END;
          IdentDef;
          INC(procLevel);
          IF Sym=lbrace THEN
            forward := TRUE;
            GetSym;
            Expression;
            IF Sym=comma THEN GetSym; Expression END;
            Checkrbrace;
          END;
          FormalParameters; CheckSemi;
          IF NOT forward THEN
            DeclarationSequence;
            IF Sym=begin THEN GetSym; StatementSequence END;
            CheckEnd; CheckIdent; CheckSemi;
          END;
          DEC(procLevel);
      ELSE EXIT END;
      ShortenPreIdent();
    END;
  END DeclarationSequence;

BEGIN
  ReadChar := rc; Error := err; Char := " ";
  GetSym;
  REPEAT
    Check(module); CheckIdent; COPY(Identifier,moduleName); CheckSemi;
    IF Sym=import THEN
      PreIdent := "IMPORT: ";
      GetSym;
      REPEAT
        IdentDef; IF (Sym=colon) OR (Sym=becomes) THEN GetSym; CheckIdent END;
      UNTIL NOT Comma();
      CheckSemi;
      PreIdent := "";
    END;
    DeclarationSequence;
    IF Sym=begin THEN GetSym; StatementSequence END;
    IF Sym=close THEN GetSym; StatementSequence END;
    CheckEnd; CheckIdent; Check(point);
  UNTIL Sym=eof;
END Parse;


(*-------------------------------------------------------------------------*)


PROCEDURE AddOp(sym: INTEGER (* Symbol *); op: ARRAY OF CHAR);
(* Operator zur Operatorenliste hinzufügen: *)

VAR
  o: OpPtr;
  i: INTEGER;

BEGIN
  NEW(o);
  COPY(op,o.name);
  o.sym  := sym;
  i := GetKey(op) MOD OpSize;
  o.next := Operator[i]; Operator[i] := o;
END AddOp;


PROCEDURE AddStd(op: ARRAY OF CHAR);
(* Operator zur Operatorenliste hinzufügen: *)

VAR
  o: OpPtr;
  i: INTEGER;

BEGIN
  NEW(o);
  COPY(op,o.name);
  o.sym  := identifier;
  i := GetKey(op) MOD OpSize;
  o.next := StdId[i]; StdId[i] := o;
END AddStd;

BEGIN

(* Standardoperatoren: *)

  i := 0; WHILE i<OpSize DO Operator[i] := NIL; INC(i) END;
  AddOp(and,      "AND"      ); AddOp(array,    "ARRAY"    );
  AddOp(begin,    "BEGIN"    ); AddOp(bpointer, "BPOINTER" );
  AddOp(by,       "BY"       ); AddOp(case,     "CASE"     );
  AddOp(close,    "CLOSE"    ); AddOp(const,    "CONST"    );
  AddOp(div,      "DIV"      ); AddOp(do,       "DO"       );
  AddOp(else,     "ELSE"     ); AddOp(elsif,    "ELSIF"    );
  AddOp(end,      "END"      ); AddOp(exit,     "EXIT"     );
  AddOp(for,      "FOR"      ); AddOp(if,       "IF"       );
  AddOp(import,   "IMPORT"   ); AddOp(in,       "IN"       );
  AddOp(is,       "IS"       ); AddOp(loop,     "LOOP"     );
  AddOp(mod,      "MOD"      ); AddOp(module,   "MODULE"   );
  AddOp(not,      "NOT"      ); AddOp(of,       "OF"       );
  AddOp(or,       "OR"       ); AddOp(pointer,  "POINTER"  );
  AddOp(procedure,"PROCEDURE"); AddOp(record,   "RECORD"   );
  AddOp(repeat,   "REPEAT"   ); AddOp(return,   "RETURN"   );
  AddOp(struct,   "STRUCT"   ); AddOp(then,     "THEN"     );
  AddOp(to,       "TO"       ); AddOp(type,     "TYPE"     );
  AddOp(until,    "UNTIL"    ); AddOp(untraced, "UNTRACED" );
  AddOp(var,      "VAR"      ); AddOp(while,    "WHILE"    );
  AddOp(with,     "WITH"     );

  AddStd("BOOLEAN" );
  AddStd("CHAR"    );
  AddStd("BYTE"    );
  AddStd("SHORTINT");
  AddStd("INTEGER" );
  AddStd("LONGINT" );
  AddStd("REAL"    );
  AddStd("LONGREAL");
  AddStd("SHORTSET");
  AddStd("LONGSET" );
  AddStd("SET"     );

  AddStd("FALSE"   );
  AddStd("TRUE"    );
  AddStd("NIL"     );

  AddStd("ABS"     );
  AddStd("ASH"     );
  AddStd("CAP"     );
  AddStd("CHR"     );
  AddStd("COPY"    );
  AddStd("DEC"     );
  AddStd("DISPOSE" );
  AddStd("ENTIER"  );
  AddStd("EXCL"    );
  AddStd("HALT"    );
  AddStd("INC"     );
  AddStd("INCL"    );
  AddStd("LEN"     );
  AddStd("LONG"    );
  AddStd("MAX"     );
  AddStd("MIN"     );
  AddStd("NEW"     );
  AddStd("ODD"     );
  AddStd("ORD"     );
  AddStd("SHORT"   );
  AddStd("SIZE"    );

  AddStd("SYSTEM"  );
  AddStd("ADR"     );
  AddStd("LSH"     );
  AddStd("ROT"     );
(*AddStd("SIZE"    ); s.o. *)
  AddStd("INIT"    );
  AddStd("INLINE"  );
  AddStd("REG"     );
  AddStd("SETREG"  );
  AddStd("VAL"     );
  AddStd("ADDRESS" );
  AddStd("TYPEDESC");

  Syms[ORD("!")]:=none;     Syms[ORD('"')]:=intstring; Syms[ORD("#")]:=relation;
  Syms[ORD("$")]:=none;     Syms[ORD("%")]:=none;      Syms[ORD("&")]:=and;
  Syms[ORD("'")]:=intstring;Syms[ORD("(")]:=intparen;  Syms[ORD(")")]:=rparen;
  Syms[ORD("*")]:=times;    Syms[ORD("+")]:=plus;      Syms[ORD(",")]:=comma;
  Syms[ORD("-")]:=minus;    Syms[ORD(".")]:=intpoint;  Syms[ORD("/")]:=divide;
  Syms[ORD(":")]:=intcolon; Syms[ORD(";")]:=semicolon; Syms[ORD("<")]:=intcomp;
  Syms[ORD("=")]:=equal;    Syms[ORD(">")]:=intcomp;   Syms[ORD("?")]:=none;
  Syms[ORD("@")]:=none;     Syms[ORD("[")]:=langle;    Syms[ORD("\\")]:=none;
  Syms[ORD("]")]:=rangle;   Syms[ORD("^")]:=power;     Syms[ORD("_")]:=none;
  Syms[ORD("`")]:=none;     Syms[ORD("{")]:=lbrace;    Syms[ORD("|")]:=slash;
  Syms[ORD("}")]:=rbrace;   Syms[ORD("~")]:=not;       Syms[127     ]:=range;
  Syms[0       ]:=eof;

  c := "0"; REPEAT Syms[ORD(c)] := intnum; INC(c) UNTIL c>"9";
  c := "A"; REPEAT Syms[ORD(c)] := intid;  INC(c) UNTIL c>"Z";
  c := "a"; REPEAT Syms[ORD(c)] := intid;  INC(c) UNTIL c>"z";
END CNEIdentParser.

