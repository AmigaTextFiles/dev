MODULE MCCDateText;

(*
**
** Copyright © 1997 Kai Hofmann. All rights reserved.
** Registered MUI custom class!
**
** $VER: MCCDateText.mod 12.0 (19.08.97)
**
*)

  IMPORT
    mb := MuiBasics,
    u  := Utility,
    y  := SYSTEM;


  CONST
    cDateText			*= "DateText.mcc";

    aDateTextDateFormat	*= 081EE0059H;


  PROCEDURE DateTextObject *{"DateText.DateTextObjectA"} (tags{9}..: u.Tag);


  PROCEDURE DateTextObjectA *(tags{9}: u.TagListPtr);

  BEGIN
    mb.NewObjectA(y.ADR(cDateText),tags);
  END DateTextObjectA;

END MCCDateText.
