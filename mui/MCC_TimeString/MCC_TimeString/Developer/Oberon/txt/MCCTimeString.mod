MODULE MCCTimeString;

(*
**
** Copyright © 1996-1997 Kai Hofmann. All rights reserved.
** Registered MUI custom class!
**
** $VER: MCCTimeString.mod 12.5 (18.10.97)
**
*)

  IMPORT
    mb := MuiBasics,
    u  := Utility,
    y  := SYSTEM;


  CONST
    cTimeString			* = "TimeString.mcc";

    aTimeStringTimeFormat	* = 081EE008AH;


  PROCEDURE TimeStringObject *{"TimeString.TimeStringObjectA"} (tags{9}..: u.Tag);


  PROCEDURE TimeStringObjectA *(tags{9}: u.TagListPtr);

  BEGIN
    mb.NewObjectA(y.ADR(cTimeString),tags);
  END TimeStringObjectA;

END MCCTimeString.
