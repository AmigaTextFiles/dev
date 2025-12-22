IMPLEMENTATION MODULE Memory;

(*
 * -------------------------------------------------------------------------
 *
 *	:Module.	Memory
 *	:Contents.	Modul zur kontrollierten Anforderung von Speicher
 *
 *	:Author.	Reiner Nix
 *	:Address.	Geranienhof 2, 5000 Köln 71 Seeberg
 *	:Address.	rbnix@pool.informatik.rwth-aachen.de
 *	:Copyright.	Public Domain
 *	:Language.	Modula-2
 *	:Translator.	M2Amiga A-L V4.2d
 *	:History.	V1.0	08.08.93
 *
 * -------------------------------------------------------------------------
 *)

FROM	SYSTEM		IMPORT	ADDRESS, ADR;
FROM	Arts		IMPORT	programName,
				Requester;
FROM	Conversions	IMPORT	ValToStr;
IMPORT Heap;


VAR	error		:BOOLEAN;
	t1		:ARRAY [0..10] OF CHAR;
	text		:ARRAY [0..50] OF CHAR;


PROCEDURE Allocate	(VAR adr		:ADDRESS;
			     size		:LONGINT);

VAR	wiederholen	:BOOLEAN;


  PROCEDURE CopyChars	(VAR source		:ARRAY OF CHAR;
  			     dest		:ARRAY OF CHAR;
  			     start, length	:CARDINAL);

  VAR	i	:CARDINAL;

  BEGIN
  i := 0;
  WHILE (0 < length) AND (dest[i] # 0C) DO
    source[start] := dest[i];
    INC (i);
    INC (start);
    DEC (length)
    END
  END CopyChars;


(* Allocate *)
BEGIN
ValToStr (size, TRUE, t1, 10, 8, " ", error);
CopyChars (text, t1, 24, 8);
  REPEAT
  Heap.Allocate (adr, size);

  IF adr=NIL THEN
    wiederholen := Requester (programName, ADR (text), ADR ("wiederholen"), ADR ("abbrechen"));
    END
  UNTIL (adr#NIL) OR ((adr=NIL) AND (NOT wiederholen))
END Allocate;


PROCEDURE Deallocate	(VAR adr		:ADDRESS;
			     size		:LONGINT);


BEGIN
Heap.Deallocate (adr)
END Deallocate;


BEGIN
text := "Speicheranforderung von 12345678 Bytes mißlungen";
END Memory.

