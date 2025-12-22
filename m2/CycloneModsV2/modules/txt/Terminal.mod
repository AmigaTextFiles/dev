IMPLEMENTATION MODULE Terminal;

(* (C) Copyright 1994 Marcel Timmermans. All rights reserved. *)

IMPORT io:InOut;

PROCEDURE Read( VAR ch :CHAR );
(*
    read a character
*)
BEGIN
  io.Read(ch);
END Read;


PROCEDURE ReadString( VAR s :ARRAY OF CHAR );
BEGIN
 io.ReadString(s);
END ReadString;


PROCEDURE ReadLongInt( VAR x :LONGINT );
BEGIN
 io.ReadLongInt(x);
END ReadLongInt;


PROCEDURE ReadInt( VAR x :INTEGER );
BEGIN
  io.ReadInt(x);
END ReadInt;


PROCEDURE Write( ch :CHAR );
(*
    write the character
*)
BEGIN
 io.Write(ch);
END Write;


PROCEDURE WriteLn;
(*
    same as: Write( ASCII.EOL )
*)
BEGIN
 Write(12C);
END WriteLn;


PROCEDURE WriteString( s :ARRAY OF CHAR );
(*$ CopyDyn- *)
(*
    write the string out
*)
BEGIN
 io.WriteString(s);
END WriteString;


PROCEDURE WriteLine( s :ARRAY OF CHAR );
(*$ CopyDyn- *)
BEGIN
 io.WriteLine(s);
END WriteLine;


PROCEDURE WriteInt( x : LONGINT; n :CARDINAL );
(*
    write the LONGINT right justified in a field of at least n characters.
*)
BEGIN
 io.WriteInt(x,n);
END WriteInt;


PROCEDURE WriteCard( x : LONGCARD; n : CARDINAL);
(*
    write the CARDINAL right justified in a field of at least n characters.
*)
BEGIN
 io.WriteCard(x,n);
END WriteCard;


PROCEDURE WriteOct( x, n :CARDINAL );
(*
    write x in octal format in a right justified field of at least n characters.
*)
BEGIN
 io.WriteOct(x,n);
END WriteOct;


PROCEDURE WriteHex( x : LONGINT; n :CARDINAL );
(*
    write x in hexadecimal in a right justified field of at least n characters.
    IF (n <= 2) AND (x < 100H) THEN 2 digits are written
    ELSE 4 digits are written
*)
BEGIN
 io.WriteHex(x,n);
END WriteHex;

END Terminal.mod
