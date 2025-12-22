IMPLEMENTATION MODULE FileOut;

(*
 * -------------------------------------------------------------------------
 *
 *	:Module.	FileOut.mod
 *	:Contents.	Ausgaben wie mit InOut aber auf eine Datei.

 *	:Author.	Reiner Nix
 *	:Address.	Geranienhof 2, 5000 Köln 71 Seeberg
 *	:Address.	rbnix@pool.informatik.rwth-aachen.de
 *	:Copyright.	Public Domain
 *	:Language.	Modula-2
 *	:Translator.	M2Amiga A-L V4.2d
 *	:History.	V1.0	21.11.90	M2Amiga V3.3d
 *	:History.	V1.1	13.08.91	M2Amiga V4.0d
 *	:History.	V1.2	23.08.93	erweitert um WriteHex 
 *
 * -------------------------------------------------------------------------
 *)

FROM	SYSTEM		IMPORT	ADR;
FROM	ASCII		IMPORT	lf, cr, sp;
FROM	String		IMPORT	Length;
FROM	Conversions	IMPORT	ValToStr;
FROM	RealConversions	IMPORT	RealToStr;
FROM	FileSystem	IMPORT	File,
				WriteChar, WriteBytes;


PROCEDURE WriteLn	(VAR file	:File);

BEGIN
WriteChar (file, lf)
END WriteLn;


PROCEDURE Write		(VAR file	:File;
			 char		:CHAR);

BEGIN
WriteChar (file, char)
END Write;


PROCEDURE WriteString	(VAR file	:File;
			 string		:ARRAY OF CHAR);

VAR	actual	:LONGINT;

BEGIN
WriteBytes (file, ADR (string), Length (string), actual)
END WriteString;


PROCEDURE WriteCard	(VAR file	:File;
			 number		:LONGCARD; n	:CARDINAL);

VAR	string		:ARRAY[1..12] OF CHAR;
	error		:BOOLEAN;

BEGIN
ValToStr (number, FALSE, string, 10, n, sp, error);
IF NOT error THEN
  WriteString (file,string)
ELSE
  WriteString (file,"FEHLER")
  END
END WriteCard;


PROCEDURE WriteInt	(VAR file	:File;
			 number		:LONGINT; n	:CARDINAL);

VAR	string		:ARRAY[1..12] OF CHAR;
	error		:BOOLEAN;

BEGIN
ValToStr (number, TRUE, string, 10, n, sp, error);
IF NOT error THEN
  WriteString (file,string)
ELSE
  WriteString (file,"FEHLER")
  END
END WriteInt;


PROCEDURE WriteHex	(VAR file	:File;
			 number		:LONGINT; n	:CARDINAL);

VAR	string		:ARRAY[1..12] OF CHAR;
	error		:BOOLEAN;

BEGIN
ValToStr (number, TRUE, string, 16, n, " ", error);
IF NOT error THEN
  WriteString (file,string)
ELSE
  WriteString (file,"FEHLER")
  END
END WriteHex;


PROCEDURE WriteBool	(VAR file	:File;
			 boolean	:BOOLEAN);

BEGIN
IF boolean THEN
  WriteString (file, "TRUE")
ELSE
  WriteString (file, "FALSE")
  END
END WriteBool;


PROCEDURE WriteReal	(VAR file	:File;
			 number		:REAL; m, n	:CARDINAL);

VAR	string		:ARRAY[1..20] OF CHAR;
	error		:BOOLEAN;

BEGIN
IF m > 20 THEN
  m := 20;
  IF n > m THEN n := 18 END
  END;
RealToStr (number, string, m, n, FALSE, error);
IF NOT error THEN
  WriteString (file, string)
ELSE
  WriteString (file, "FEHLER")
  END
END WriteReal;


END FileOut.
