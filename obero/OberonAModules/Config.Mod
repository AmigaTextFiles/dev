(*
** $VER: Config.Mod 1.0 (12.4.98)
**
** Oberon-A module for config.library
**
** Copyright (C) 1998, Morten Bjergstrøm.
**
** EMail: mbjergstroem@hotmail.com
**
** config.library is (C) 1996, Adam Dawes.
*)

<*STANDARD-*>
MODULE [2] Config;

IMPORT
  e:=Exec,
  Kernel;

CONST
  CONFIGNAME*="config.library";


  CFG_WRITE_SUCCESS* = -1;
  CFG_WRITE_FAIL*    =  0;

  CFG_READ_SUCCESS*  = -1;
  CFG_READ_FAIL*     =  0;


VAR
  base-:e.LibraryPtr;




PROCEDURE WriteConfig* [base,-30]
  (filename [0]:ARRAY OF CHAR;
   section  [1]:ARRAY OF CHAR;
   item     [2]:ARRAY OF CHAR;
   data     [3]:ARRAY OF CHAR)
  :INTEGER;

PROCEDURE WriteConfigNumber* [base,-36]
  (filename [0]:ARRAY OF CHAR;
   section  [1]:ARRAY OF CHAR;
   item     [2]:ARRAY OF CHAR;
   data     [3]:LONGINT)
  :INTEGER;

PROCEDURE ReadConfig* [base,-42]
  (filename     [0]:ARRAY OF CHAR;
   section      [1]:ARRAY OF CHAR;
   item         [2]:ARRAY OF CHAR;
   VAR buffer   [3]:ARRAY OF CHAR;
   bufsize      [4]:INTEGER;
   def          [5]:ARRAY OF CHAR)
  :INTEGER;

PROCEDURE ReadConfigNumber* [base,-48]
  (filename [0]:ARRAY OF CHAR;
   section  [1]:ARRAY OF CHAR;
   item     [2]:ARRAY OF CHAR;
   def      [3]:LONGINT)
  :LONGINT;


PROCEDURE* [0] CloseLib (VAR rc : LONGINT);

BEGIN (* CloseLib *)

  IF base # NIL THEN e.CloseLibrary (base) END

END CloseLib;


BEGIN

  base:=e.OpenLibrary(CONFIGNAME,0);
  IF base # NIL THEN Kernel.SetCleanup(CloseLib) END;

END Config.
