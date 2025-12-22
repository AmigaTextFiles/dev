MODULE MCCDateString;

(*
**
** Copyright © 1996-1997 Kai Hofmann. All rights reserved.
** Registered MUI custom class!
**
** $VER: MCCDateString.mod 12.3 (04.04.97)
**
*)

  IMPORT
    mb := MuiBasics,
    u  := Utility,
    y  := SYSTEM;


  CONST
    cDateString			*= "DateString.mcc";

    aDateStringDateFormat	*= 081EE0047H;


  PROCEDURE DateStringObject *{"DateString.DateStringObjectA"} (tags{9}..: u.Tag);


  PROCEDURE DateStringObjectA *(tags{9}: u.TagListPtr);

  BEGIN
    mb.NewObjectA(y.ADR(cDateString),tags);
  END DateStringObjectA;

END MCCDateString.
